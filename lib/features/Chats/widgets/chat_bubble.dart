import 'package:flutter/material.dart';
import 'package:whisp/config/constants/colors.dart';

class ChatBubble extends StatelessWidget {
  final bool fromMe;
  final String message;

  const ChatBubble({super.key, required this.fromMe, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: fromMe ? AppColors.primary : Colors.white,
          border: fromMe ? null : Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: fromMe
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: fromMe
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: fromMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}
