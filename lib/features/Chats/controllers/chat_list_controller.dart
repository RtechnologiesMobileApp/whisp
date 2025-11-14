
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/features/Chats/repo/chat_repo.dart';
import 'package:whisp/features/friends/controller/friend_controller.dart';
 

class ChatListController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();

  var chats = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs; // Start as true

  final FriendsController friendController = Get.find<FriendsController>();

  @override
  void onInit() {
    super.onInit();
    loadChatList();
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
  final index = chats.indexWhere((c) => c['id'] == chatId);
  if (index != -1) {
    chats[index]['lastMessage'] = lastMessage;
    chats[index]['lastMessageUserId'] = lastUserId;
    chats[index]['lastMessageTime'] = DateTime.now().toString();

    // Move chat to top of list
    final updatedChat = chats.removeAt(index);
    chats.insert(0, updatedChat);

    chats.refresh(); // 🔥 notify UI instantly
  } else {
    // Optional: If it's a new chat not in list, you can insert it
    chats.insert(0, {
      'id': chatId,
      'name': 'Unknown',
      'avatar': '',
      'lastMessage': lastMessage,
      'lastMessageUserId': lastUserId,
      'lastMessageTime': DateTime.now().toString(),
    });
  }
}

}

 