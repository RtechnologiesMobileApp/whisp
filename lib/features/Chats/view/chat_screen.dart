import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/features/Chats/controllers/chat_controller.dart';
import 'package:whisp/features/Chats/widgets/chat_screen_appbar.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input_field.dart';

class ChatScreen extends StatelessWidget {
 final String partnerId;
  final String partnerName;
  final String partnerAvatar;

  const ChatScreen({super.key, required this.partnerId, required this.partnerName, required this.partnerAvatar});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: ChatAppBar(userName: partnerName, userAvatar: partnerAvatar),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.only(top: 12),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return ChatBubble(fromMe: msg['fromMe'], message: msg['message']);
                },
              ),
            ),
          ),
          const MessageInputField(),
        ],
      ),
    );
  }
}
