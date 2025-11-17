import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/features/Chats/controllers/chat_list_controller.dart';
import 'package:whisp/features/Chats/repo/chat_repo.dart';
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
  debugPrint("📥 Incoming SOCKET message:");
  debugPrint("RAW → $data");

  final senderId = data['from'] ?? data['fromUserId'];

  if (senderId != friendId) return;

  // ----------- FIX START -----------
  final type = (data['type'] ?? 'text').toString();
  final isVoice = type == 'voice-note';

  final body = data['body']?.toString() ?? '';

  if (body.isEmpty) {
    debugPrint("⚠ Ignored empty socket message");
    return;
  }
  // ----------- FIX END -----------
  
  messages.add({
    'fromMe': senderId == currentUserId,
    'body': isVoice ? '' : body,
    'isVoice': isVoice,
    'voiceUrl': isVoice ? body : null,
    'type': type,
  });

  debugPrint("✅ Added → ${messages.last}");
});

 
  }
 
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
    debugPrint("💡 Sending message, friendId: $friendId, isFriend: $isFriend");

    // ✅ Use isFriend flag instead of null check
    if (isFriend) {
      socketService.sendMessageToFriend(friendId!, text);
      debugPrint('[chat] Message sent to friend $friendId');
    } else {
      socketService.sendMessage(text);
      debugPrint('[chat] Message sent in random session');
    }

    messages.add({"fromMe": true, "body": text});
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

      final history = await FriendRepo().getFriendChatHistory(friendId!);

      debugPrint("------- RAW HISTORY FROM API -------");
      for (var msg in history) {
        debugPrint("this is raw response msg: $msg");
      }

      messages.assignAll(
        history.map((msg) {
          final type = msg["type"]?.toString() ?? "text";
          final isVoice = type == "voice-note";

          return {
            "fromMe": msg["from"].toString() == currentUserId.toString(),
            "body": isVoice ? "" : (msg["body"] ?? ''),
            "isVoice": isVoice,
            "voiceUrl": isVoice ? msg["body"] : null,
            "type": type,
          };
        }).toList(),
      );

      debugPrint("🎯 HISTORY →   | body: ${messages.last["body"]}");
      debugPrint("💬 Loaded ${messages.length} messages for friend $friendId");
    } catch (e) {
      debugPrint("❌ Failed to load chat history: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

void sendVoice(File file) async {
  final tempMessage = {
    "fromMe": true,
    "body": "",
    "isVoice": true,
    "type": "voice-note",
    "voiceUrl": null,
    "localPath": file.path,
    "sending": true
  };

  messages.add(tempMessage);
  messages.refresh();

  try {
    final repo = ChatRepository();
    final voiceUrl = await repo.sendVoiceMessage(
      friendId: friendId!,
      audioFile: file,
    );

    final index = messages.indexOf(tempMessage);
    if (index != -1) {
      // Only update the needed fields
      messages[index]["voiceUrl"] = voiceUrl;
      messages[index]["sending"] = false;
      messages.refresh();
    }
  } catch (e) {
    Get.snackbar("Error", e.toString());
    messages.remove(tempMessage);
    messages.refresh();
  }
}

// void sendVoice(File file) async {
//   final tempMessage = {
//     "fromMe": true,
//     "body": "",
//     "isVoice": true,
//     "type": "voice-note",
//     "voiceUrl": null,
//     "localPath": file.path,
//     "sending": true
//   };

//   messages.add(tempMessage); // add temporary UI
//   messages.refresh();

//   try {
//     final repo = ChatRepository();

//     final voiceUrl = await repo.sendVoiceMessage(
//       friendId: friendId!,
//       audioFile: file,
//     );

//     // update temporary message with real voiceUrl
//     final index = messages.indexOf(tempMessage);
//     if (index != -1) {
//       messages[index] = {
//         ...Map<String, dynamic>.from(messages[index]),
//         "voiceUrl": voiceUrl,
//         "sending": false,
//       };
//     }

//     // backend will emit socket event as well
//   } catch (e) {
//     Get.snackbar("Error", e.toString());
//     messages.remove(tempMessage);
//     messages.refresh();
//   }
// }

 
}
