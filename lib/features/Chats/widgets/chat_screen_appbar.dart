import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/features/home/view/home_screen.dart';
import 'package:whisp/features/premium/view/screens/premium_screen.dart';
import 'chat_bottom_sheet.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String userName;
  final String userAvatar;
  final String partnerId;
  final bool isFriend;

  const ChatAppBar({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.partnerId,
    this.isFriend = false,
  });

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _ChatAppBarState extends State<ChatAppBar> {
  final socketService = Get.find<SocketService>();
  final RxBool isRequestSent = false.obs;
  bool get isPremium => SessionController().user?.premium == true;

  @override
  void initState() {
    super.initState();
    debugPrint("🟢 ChatAppBar initialized — isFriend: ${widget.isFriend}");
    debugPrint("💎 Premium status: $isPremium");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      "📌 ChatScreen partnerId: ${widget.partnerId}, isFriend: ${widget.isFriend}",
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 1).withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 🔙 Back button
              InkWell(
                onTap: () {
                  socketService.endSession();
                  // Get.back();
                  if (Navigator.canPop(context)) {
    // Navigator.pop(context);                // Random chat → just pop
      Navigator.of(context).pushAndRemoveUntil(
                     MaterialPageRoute(builder: (context) => MainHomeScreen(index: 1)),
                      (route) => false,
                     );
  } else
                  Navigator.of(context).pushAndRemoveUntil(
                     MaterialPageRoute(builder: (context) => MainHomeScreen(index: 1)),
                      (route) => false,
                     );
                },
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 🧑 Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: widget.userAvatar.isNotEmpty ? NetworkImage(widget.userAvatar) : null,
                  backgroundColor: Colors.grey[200],
                  child: widget.userAvatar.isNotEmpty ? null : Icon(Icons.person, color: Colors.grey[400]),
                ),
              ),
              const SizedBox(width: 12),

              // 🟢 Name + Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: -0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    Obx(() {
                      final isOnline =
                          SocketService.to.onlineStatus[widget.partnerId] ??
                          false;
                      debugPrint(
                        "Online status for ${widget.partnerId}: $isOnline",
                      );
                      return isOnline
                          ? Text(
                              "Online",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xff771F98),
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : SizedBox.shrink();
                    }),
                  ],
                ),
              ),

              // 🤝 Friend Request Button (Reactive)
              // 🤝 Friend Request Button (Reactive)
              if (!widget.isFriend)
                Obx(() {
                  return InkWell(
                    onTap: () {
                      if (!isPremium) {
                        Get.to(() => PremiumScreen());
                        return;
                      }

                      if (isRequestSent.value) {
                        socketService.cancelFriendRequest(widget.partnerId, (
                          ack,
                        ) {
                          print(
                            "[socket] Cancel friend request response: $ack",
                          );
                          isRequestSent.value = false;
                        });
                      } else {
                        socketService.sendFriendRequest(widget.partnerId, (
                          ack,
                        ) {
                          print("[socket] Friend request sent response: $ack");
                          isRequestSent.value = true;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isRequestSent.value
                            ? Colors.red.withOpacity(0.1)
                            : const Color(0xff771F98).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isRequestSent.value
                              ? Colors.redAccent
                              : const Color(0xff771F98),
                        ),
                      ),
                      child: Text(
                        isRequestSent.value ? "Cancel" : "Add Friend",
                        style: TextStyle(
                          color: isRequestSent.value
                              ? Colors.redAccent
                              : const Color(0xff771F98),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }),

              const SizedBox(width: 10),

              // ⋮ More options
              InkWell(
                onTap: () => showChatBottomSheet(context),
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.more_vert, color: Colors.black87, size: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
