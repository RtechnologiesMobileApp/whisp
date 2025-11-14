
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/features/Chats/repo/chat_repo.dart';
import 'package:whisp/features/friends/controller/friend_controller.dart';
 

class ChatListController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();

  var chats = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs; // Start as true
  bool _messageListenerSetup = false; // Prevent duplicate listener setup

  final FriendsController friendController = Get.find<FriendsController>();

  @override
  void onInit() {
    super.onInit();
    loadChatList();
    _setupMessageListener();
  }

  void _setupMessageListener() {
    // Only set up listener once to avoid duplicates
    if (_messageListenerSetup) return;
    _messageListenerSetup = true;
    
    // Set up a single message listener to avoid duplicates
    SocketService.to.onMessage((data) {
      final msgText = data['message'] ?? data['body'] ?? '';
      if (msgText.trim().isEmpty) return;

      // Get the actual sender ID from the message data
      final senderId = data['fromUserId'] ?? data['from'] ?? '';
      
      if (senderId.isNotEmpty) {
        updateLastMessage(senderId, msgText, senderId);
      }
    });
  }
 

  Future<void> loadChatList() async {
      isLoading.value = true;
    try {
      isLoading.value = true;

      final data = await _chatRepository.getChatList();
       debugPrint('🟢 Chat list raw response: $data');

      chats.assignAll(
        data.map<Map<String, dynamic>>((chat) {
          return {
            'id': chat['_id'] ?? chat['id'],
            'name': chat['fullName'] ?? '',
            'avatar': chat['avatar'] ?? '',
            'country': chat['country'] ?? '',
            'premium': chat['premium'] ?? false,
            'lastMessage': chat['lastMessage'] ?? '',
            'lastMessageUserId': chat['lastMessageUserId'] ?? '',
            'lastMessageTime': chat['lastMessageTime'] ?? '',
            'lastMessageRead':chat['lastMessageRead']??false
          };
        }).toList(),
      );
    } catch (e) {
      print("❌ Error loading chat list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateLastMessage(String chatId, String lastMessage, String lastUserId) {
    // Check if chat already exists to prevent duplicates
    final index = chats.indexWhere((c) => c['id'] == chatId);
    if (index != -1) {
      // Get current user ID to determine if message is from me or from other user
      final currentUserId = SessionController().user?.id;
      final isFromMe = lastUserId == currentUserId;
      
      // Update existing chat
      chats[index]['lastMessage'] = lastMessage;
      chats[index]['lastMessageUserId'] = lastUserId;
      chats[index]['lastMessageTime'] = DateTime.now().toString();
      // Set read status: if message is from me, it's read; if from other user, it's unread
      chats[index]['lastMessageRead'] = isFromMe;

      // Move chat to top of list
      final updatedChat = chats.removeAt(index);
      chats.insert(0, updatedChat);

      chats.refresh(); // 🔥 notify UI instantly
    } else {
      // Chat not found - check if we're already loading or if this is a duplicate call
      // Prevent creating multiple "Unknown" chats by checking if one already exists
      final existingUnknown = chats.any((c) => 
        c['id'] == chatId || 
        (c['name'] == 'Unknown' && c['lastMessage'] == lastMessage && c['lastMessageUserId'] == lastUserId)
      );
      
      if (!existingUnknown && !isLoading.value) {
        // Only reload if we're not already loading and no duplicate exists
        debugPrint('⚠️ Chat $chatId not found in list, reloading chat list...');
        loadChatList();
      }
    }
  }

}

 