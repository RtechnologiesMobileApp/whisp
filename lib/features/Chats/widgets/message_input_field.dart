import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/features/Chats/controllers/chat_controller.dart';
 

class MessageInputField extends StatelessWidget {
   final ChatController controller;
  
  const MessageInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
   

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                decoration: InputDecoration(
                  hintText: "Write a message",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xffF1F2F5),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: controller.sendMessage,
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
