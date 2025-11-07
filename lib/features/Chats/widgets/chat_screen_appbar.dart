import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'chat_bottom_sheet.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userAvatar;

  const ChatAppBar({
    super.key,
    required this.userName,
    required this.userAvatar,
  });

  @override
  Widget build(BuildContext context) {
     final socketService = Get.find<SocketService>(); 
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () {
                socketService.endSession();
                Get.back();
              },
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(userAvatar),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Online", style: TextStyle(fontSize: 13, color: Colors.green)),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () => showChatBottomSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
