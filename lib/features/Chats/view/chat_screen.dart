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
  final bool isFriend;

  const ChatScreen({super.key, required this.partnerId, required this.partnerName, required this.partnerAvatar,this.isFriend = false});

  @override
  Widget build(BuildContext context) {
   // final ChatController controller = Get.put(ChatController(friendId: partnerId,isFriend: isFriend));
   
final ChatController controller = Get.isRegistered<ChatController>(tag: isFriend ? partnerId : 'random')
    ? Get.find<ChatController>(tag: isFriend ? partnerId : 'random')
    : Get.put(
        ChatController(friendId: partnerId, isFriend: isFriend),
        tag: isFriend ? partnerId : 'random',
      );

     

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: ChatAppBar(partnerId: partnerId, userName: partnerName, userAvatar: partnerAvatar, isFriend: isFriend,),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.only(top: 12),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final bool isFromMe = msg['fromMe'] ?? false;
                  final String message = msg['body'] ?? msg['message'] ?? '';
                  return ChatBubble(fromMe: isFromMe, message: message);
                },
              ),
            ),
          ),
            MessageInputField(  controller: controller  ),
        ],
      ),
    );
  }
}
