import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/features/Chats/controllers/chat_list_controller.dart';
import 'package:whisp/features/friends/repo/friends_repo.dart';

class ChatController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final TextEditingController messageController = TextEditingController();
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  String? friendId; // 👈 optional: null means random chat
  bool isFriend;
  RxBool isLoading = false.obs;
  RxBool partnerTyping = false.obs;
  ChatController({this.friendId, this.isFriend = false}) {
    // ✅ Agar friend chat screen hai aur friendId available hai
    if (isFriend && friendId != null) {
      loadFriendChatHistory();
    }
  }
  String? get currentUserId => SessionController().user!.id;

  @override
  void onInit() {
    super.onInit();

    // 🔹 Listen for typing event
    SocketService.to.onTyping((data) {
      if (data["userId"] == friendId) {
        partnerTyping.value = data["isTyping"];
        debugPrint("Partner typing value ${partnerTyping.value}");
      }
    });
    
    // 🔹 Listen for messages only for this specific chat
    // Note: ChatListController handles updating the chat list globally
    SocketService.to.onMessage((data) {
      final msgText = data['message'] ?? data['body'] ?? '';
      if (msgText.trim().isEmpty) return;

      // Get the actual sender ID from the message data
      final senderId = data['fromUserId'] ?? data['from'] ?? '';
      
      // Only add message to current chat if it's from the current partner
      if (friendId != null && senderId == friendId) {
        messages.add({'fromMe': false, 'message': msgText});
      }
      // Chat list update is handled by ChatListController's listener
    });
  }
//   void sendTyping(bool isTyping) {
//   SocketService.to.typing(isTyping);
// }
void sendTyping(bool isTyping) {
  if (isFriend && friendId != null) {
    SocketService.to.typing(isTyping, toUserId: friendId!);
  } else {
    SocketService.to.typing(isTyping); // random chat
  }
}



  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    print("💡 Sending message, friendId: $friendId, isFriend: $isFriend");

    // ✅ Use isFriend flag instead of null check
    if (isFriend) {
      socketService.sendMessageToFriend(friendId!, text);
      debugPrint('[chat] Message sent to friend $friendId');
    } else {
      socketService.sendMessage(text);
      debugPrint('[chat] Message sent in random session');
    }

    messages.add({"fromMe": true, "message": text});
    final chatListController = Get.find<ChatListController>();
    final myUserId = SessionController().user!.id;
    // Only update chat list if we have a friendId (friend chat, not random)
    if (friendId != null && myUserId != null) {
      chatListController.updateLastMessage(friendId!, text, myUserId);
    }

    messageController.clear();
  }
  void markAsRead(String partnerId){
    socketService.markAsRead(partnerId);
  }

  void loadFriendChatHistory() async {
    if (isFriend && friendId != null) {
      try {
        isLoading.value = true;

        // ✅ Repo already returns List<Map<String, dynamic>>
        final history = await FriendRepo().getFriendChatHistory(friendId!);

        // Debug print to verify messages
        for (var msg in history) {
         
          print("from: ${msg['from']}, to: ${msg['to']}, body: ${msg['body']}");
        }

        // Assign messages to observable list
        messages.assignAll(
          history.map(
            (msg) => {
              "fromMe":
                  msg["from"]?.toString().trim() ==
                  currentUserId?.toString().trim(),
              "message":
                  msg["message"] ??
                  '', // Repo is already mapping 'body' to 'message'
            },
          ),
        );

        print("💬 Loaded ${messages.length} messages for friend $friendId");
      } catch (e) {
        print("❌ Failed to load chat history: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
