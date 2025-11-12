import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/features/friends/repo/friends_repo.dart';

class ChatController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final TextEditingController messageController = TextEditingController();
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  String? friendId; // 👈 optional: null means random chat
  bool isFriend;
   RxBool isLoading = false.obs;
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
   SocketService.to.onMessage((Map data) {
  final message = Map<String, dynamic>.from(data);
  messages.add(message);
});

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
  messageController.clear();
}
void loadFriendChatHistory() async {
  if (isFriend && friendId != null) {
    try {
      isLoading.value = true;
      final history = await FriendRepo().getFriendChatHistory(friendId!);
 history.forEach((msg) {
        print("from: ${msg['from']}, to: ${msg['to']}, body: ${msg['body']}");
      });

      messages.assignAll(
        
        history.map((msg) => {
          "fromMe": msg["from"].toString().trim() == currentUserId!.toString().trim(),
          "message": msg["body"],
        }),
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
