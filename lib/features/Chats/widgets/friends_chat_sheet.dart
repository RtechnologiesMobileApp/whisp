import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/features/Chats/view/chat_screen.dart';
import 'package:whisp/features/friends/controller/friend_controller.dart';

class FriendsChatSheet extends StatelessWidget {
  final FriendsController friendController = Get.find<FriendsController>();

  FriendsChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final friends = friendController.friendsList;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: friends.isEmpty
            ? Center(
                child: Text(
                  "No friends found",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: friends.length,
                separatorBuilder: (_, __) => Divider(
                  color: Colors.grey.shade200,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: friend.imageUrl != null && friend.imageUrl != ''
                          ? NetworkImage(friend.imageUrl!)
                          : const AssetImage('assets/images/place_holder_pic.jpg')
                              as ImageProvider,
                    ),
                    title: Text(
                      friend.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: const Text(
                      "💬 Tap to start chat",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Get.back(); // close the sheet
                      Get.to(() => ChatScreen(
                            partnerId: friend.id,
                            partnerName: friend.name,
                            partnerAvatar: friend.imageUrl ?? '',
                            isFriend: true,
                          ));
                    },
                  );
                },
              ),
      );
    });
  }
}

