import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/services/socket_service.dart';

class ChatController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final TextEditingController messageController = TextEditingController();
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

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
    socketService.sendMessage(text);
    messages.add({"fromMe": true, "message": text});
    messageController.clear();
  }
}
