import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/services/socket_service.dart';

class ChatController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final TextEditingController messageController = TextEditingController();
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  String? friendId; // 👈 optional: null means random chat
  bool isFriend;
  ChatController({this.friendId,this.isFriend = false});

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

}
