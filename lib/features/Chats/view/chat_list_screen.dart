import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/config/global/global.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/features/Chats/controllers/chat_list_controller.dart';
import 'package:whisp/features/Chats/view/chat_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:whisp/features/Chats/widgets/friends_chat_sheet.dart';
import 'package:whisp/features/Chats/widgets/report_bottom_sheet.dart';
import 'package:whisp/features/friends/controller/friend_controller.dart';
import 'package:whisp/features/friends/view/widgets/unfriend_dialog.dart';
import 'package:intl/intl.dart';
import 'package:whisp/features/home/view/home_screen.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  final ChatListController controller = Get.put(ChatListController());
  final FriendsController friendController = Get.find<FriendsController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadChatList();
      notificationUserId = null;
    });

    String trimMessage(String msg, {int max = 30}) {
      if (msg.length <= max) return msg;
      return msg.substring(0, max) + "...";
    }

    String formatTime(String isoString) {
      try {
        final dateTime = DateTime.parse(
          isoString,
        ).toLocal(); // convert to local timezone
        final formatter = DateFormat('h:mm a'); // e.g., 12:05 PM
        return formatter.format(dateTime);
      } catch (e) {
        return ''; // fallback
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainHomeScreen(index: 0)),
          (route) => false,
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== AppBar Section =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
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
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: FriendsChatSheet(),
                          ),
                        );
                      },
                      child: Image.asset(
                        AppImages.add_message,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== Chat List =====
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    // Show loader while fetching chat list
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.chats.isEmpty) {
                    // Show "No Chats" if API returns empty
                    return const Center(child: Text("No Chats"));
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
                              onPressed: (_) => showUnfriendDialog(
                                chat['name'],
                                "Disconnect",
                                () {
                                  log("💡 Disconnecting from ${chat['id']}");
                                  friendController.unfriendUser(chat['id']);
                                  Get.back();
                                },
                              ),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              label: 'Disconnect',
                              flex: 3,
                            ),
                            SlidableAction(
                              onPressed: (_) =>
                                  showUnfriendDialog(chat['name'], "Block", () {
                                    log("💡 Blocking ${chat['id']}");
                                    friendController.blockUser(chat['id']);
                                    friendController.getBlockedUsers();
                                    Get.back();
                                  }),
                              backgroundColor: AppColors.brownOrange,
                              foregroundColor: Colors.white,
                              label: 'Block',
                              flex: 2,
                            ),
                            SlidableAction(
                              spacing: 6,
                              onPressed: (_) {
                                log("💡 Reporting ${chat['id']}");
                                showReportBottomSheet(context, (String reason) {
                                  print(reason);
                                  friendController.reportUser(
                                    chat['id'],
                                    reason,
                                  );
                                });
                              },
                              backgroundColor: AppColors.brown,
                              foregroundColor: Colors.white,
                              label: 'Report',
                              flex: 2,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage:
                                    chat['avatar'] != null &&
                                        chat['avatar'] != ''
                                    ? NetworkImage(chat['avatar'])
                                    : const AssetImage(
                                            'assets/images/place_holder_pic.jpg',
                                          )
                                          as ImageProvider,
                              ),
                              Obx(() {
                                final isOnline =
                                    SocketService.to.onlineStatus[chat['id']] ??
                                    false;
                                return isOnline
                                    ? Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          height: 12,
                                          width: 12,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                chat['isTyping'] == true
                                    ? const Text(
                                        'typing...',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : Builder(
                                        builder: (_) {
                                          final currentUserId =
                                              SessionController().user!.id;
                                          final lastUserId =
                                              chat['lastMessageUserId'];
                                          final isFromMe =
                                              lastUserId == currentUserId;
                                          // final messageText =
                                          //     chat['lastMessage'] ?? '';
                                          final originalText =
                                              chat['lastMessage'] ?? '';
                                          final messageText = trimMessage(
                                            originalText,
                                          );

                                          final isRead =
                                              chat['lastMessageRead'] ?? false;
                                          return RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                              children: [
                                                if (isFromMe)
                                                  TextSpan(
                                                    text: 'You: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                TextSpan(
                                                  text: messageText,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        isRead || isFromMe
                                                        ? FontWeight.w600
                                                        : FontWeight.bold,
                                                    color: isRead || isFromMe
                                                        ? Colors.grey.shade600
                                                        : AppColors.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ],
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatTime(chat['lastMessageTime'] ?? ''),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            log("🧠 Chat item tapped:");
                            log("id: ${chat['id']}");
                            log("name: ${chat['name']}");
                            log("image: ${chat['avatar']}");
                            // 🔥 Wait if friends are still loading
                            if (friendController.isLoadingFriends.value) {
                              await friendController.fetchFriends();
                            }

                            final isStillFriend = friendController.isUserFriend(
                              chat['id'],
                            );

                            Get.to(
                              () => ChatScreen(
                                partnerId: chat['id'],
                                partnerName: chat['name'],
                                partnerAvatar: chat['avatar'],
                                isFriend: isStillFriend,
                              ),
                            );
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
      ),
    );
  }
}
