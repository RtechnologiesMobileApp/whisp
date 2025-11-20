import 'dart:async';
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
  RxBool isProcessingAudio = false.obs;

  /// pagiantion variables
  int limit = 10;
  int offset = 0;
  bool hasMore = true;
  String? nextCursor;
  bool isLoadingMore = false;

  ChatController({this.friendId, this.isFriend = false}) {
    // ✅ Agar friend chat screen hai aur friendId available hai
    if (friendId != null) {
      // loadFriendChatHistory();
      loadInitialChat();
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

  Timer? _typingTimer;
  bool _isTyping = false;

  void sendTyping() {
    if (!isFriend && friendId == null) return;

    // Emit typing start immediately only once
    if (!_isTyping) {
      _isTyping = true;
      SocketService.to.typing(true, toUserId: friendId!);
    }

    // Cancel previous timer
    _typingTimer?.cancel();

    // Start a 2-second timer to emit stop typing
    _typingTimer = Timer(const Duration(seconds: 2), () {
      _isTyping = false;
      SocketService.to.typing(false, toUserId: friendId!);
    });
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

  void markAsRead(String partnerId) {
    socketService.markAsRead(partnerId);
  }

  void sendVoice(File file) async {
    final tempMessage = {
      "fromMe": true,
      "body": "",
      "isVoice": true,
      "type": "voice-note",
      "voiceUrl": null,
      "localPath": file.path,
      "sending": true,
    };

    messages.add(tempMessage);
    messages.refresh();

    try {
      final repo = ChatRepository();
      final response = await repo.sendVoiceMessage(
        friendId: friendId!,
        audioFile: file,
      );

      final index = messages.indexOf(tempMessage);
      if (index != -1) {
        // Only update the needed fields
        final realUrl = response["url"];
        debugPrint("this is $realUrl");
        messages[index]["voiceUrl"] = realUrl;
        messages[index]["sending"] = false;
        messages[index].remove("localPath");
        messages.refresh();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      messages.remove(tempMessage);
      messages.refresh();
    }
  }

  //load initial chat with new variable
  Future<void> loadInitialChat() async {
    isLoading.value = true;
    hasMore = true;
    nextCursor = null;
    messages.clear();

    final res = await FriendRepo().getFriendChatHistory(
      friendId!,
      limit: limit,
      beforeId: null,
    );

    final fetched = _parseMessages(res['messages']);

    if (fetched.isNotEmpty) {
      // API already newest → oldest
      messages.assignAll(fetched);
      nextCursor = res["nextCursor"]; // 👈 correct cursor

      // nextCursor = fetched.last["createdAt"]; // oldest → cursor ✔
    }

    hasMore = res["hasMore"] ?? false;
    isLoading.value = false;
  }

  Future<void> loadMoreMessages(ScrollController scroll) async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;

    final oldMax = scroll.position.maxScrollExtent;

    final res = await FriendRepo().getFriendChatHistory(
      friendId!,
      limit: limit,
      beforeId: nextCursor, // Use correct cursor ✔
    );

    final olderMsgs = _parseMessages(res['messages']);

   if (olderMsgs.isNotEmpty) {
  messages.insertAll(0, olderMsgs);

  // 🔥 Update cursor from backend
  nextCursor = res["nextCursor"];
  debugPrint("🔄 Updated nextCursor(loadMore): $nextCursor");

  hasMore = res["hasMore"] ?? false;
} else {
  hasMore = false;
}

    await Future.delayed(const Duration(milliseconds: 20));

    final newMax = scroll.position.maxScrollExtent;
    final offset = newMax - oldMax;
    scroll.jumpTo(offset); // keeps scroll position ✔

    isLoadingMore = false;
  }

  List<Map<String, dynamic>> _parseMessages(List raw) {
    return raw.map((msg) {
      final type = msg["type"]?.toString() ?? "text";
      final isVoice = type == "voice-note";

      return {
        "id": msg["id"],
        "fromMe": msg["from"] == currentUserId,
        "body": isVoice ? "" : msg["body"],
        "isVoice": isVoice,
        "voiceUrl": isVoice ? msg["body"] : null,
        "type": type,
        "createdAt": msg["createdAt"],
      };
    }).toList();
  }
}
