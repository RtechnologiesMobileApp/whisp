import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/features/Chats/controllers/chat_list_controller.dart';
import 'package:whisp/features/Chats/view/chat_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:whisp/features/friends/controller/friend_controller.dart';
import 'package:whisp/features/friends/view/widgets/unfriend_dialog.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  final ChatListController controller = Get.put(ChatListController());
  final FriendsController friendController = Get.find<FriendsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== AppBar Section =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Messages",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      AppImages.add_message,
                      height: 24,
                      width: 24,
                    ),
                  )
                ],
              ),
            ),

            // ===== Chat List =====
            Expanded(
              child: Obx(() {
                if (controller.chats.length == 0) {
                  return Center(
                    child: Text("No Chats"),
                  );
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.chats.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) {
                    final chat = controller.chats[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) =>
                                showUnfriendDialog(chat['name'], "Disconnect", (){
                                  log("💡 Disconnecting from ${chat['id']}");
                                   friendController.unfriendUser(chat['id']);
               Get.back();
              }),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            label: 'Disconnect',
                            flex: 3,
                          ),
                          SlidableAction(
                            onPressed: (_) =>  showUnfriendDialog(chat['name'], "Block", (){
               Get.back();
              }),
                            backgroundColor: AppColors.brownOrange,
                            foregroundColor: Colors.white,
                            label: 'Block',
                            flex: 2,
                          ),
                          SlidableAction(
                            spacing: 6,
                            onPressed: (_) =>showUnfriendDialog(chat['name'], "Report", (){
               Get.back();
              }),
                            backgroundColor: AppColors.brown,
                            foregroundColor: Colors.white,
                            label: 'Report',
                            flex: 2,
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: chat['image'] != null &&
                                      chat['image'] != ''
                                  ? NetworkImage(chat['image'])
                                  : AssetImage(
                                          'assets/images/place_holder_pic.jpg')
                                      as ImageProvider,
                            ),
                            if (chat['isOnline'] == true)
                              Positioned(
                                right: 2,
                                bottom: 2,
                                child: Container(
                                  height: 12,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          chat['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: chat['isTyping'] == true
                              ? const Text(
                                  'typing...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                )
                              : Text(
                                  chat['lastMessage'] ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              chat['time'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navigate to ChatScreen
                          Get.to(() => ChatScreen(
                                partnerId: chat['id'],
                                partnerName: chat['name'],
                                partnerAvatar: chat['image'],
                                isFriend: true,
                              ));
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
} 