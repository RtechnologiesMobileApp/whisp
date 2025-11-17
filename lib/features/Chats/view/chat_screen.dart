import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/global.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/features/Chats/controllers/chat_controller.dart';
import 'package:whisp/features/Chats/widgets/chat_screen_appbar.dart';
import 'package:whisp/features/Chats/widgets/typing_bubble.dart';
import 'package:whisp/features/friends/controller/friend_controller.dart';
import 'package:whisp/features/home/view/home_screen.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input_field.dart';

class ChatScreen extends StatefulWidget {
  final String partnerId;
  final String partnerName;
  final String partnerAvatar;
  final bool isFriend;

  const ChatScreen({
    super.key,
    required this.partnerId,
    required this.partnerName,
    required this.partnerAvatar,
    this.isFriend = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ScrollController _scrollController;
  late ChatController controller;
  late FriendsController friendController;
  final socketService = Get.find<SocketService>();
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    // Initialize ChatController once
    controller = Get.isRegistered<ChatController>(
            tag: widget.isFriend ? widget.partnerId : 'random')
        ? Get.find<ChatController>(
            tag: widget.isFriend ? widget.partnerId : 'random')
        : Get.put(
            ChatController(friendId: widget.partnerId, isFriend: widget.isFriend),
            tag: widget.isFriend ? widget.partnerId : 'random',
          );

    // Initialize FriendsController
    friendController = Get.isRegistered<FriendsController>()
        ? Get.find<FriendsController>()
        : Get.put(FriendsController());

    friendController.getBlockedUsers();

    // Scroll to bottom whenever messages change
     ever(controller.messages, (_) => _scrollToBottom());
    ever(controller.partnerTyping, (_) {
  // only scroll when typing becomes visible (optional)
  if (controller.partnerTyping.value) {
    _scrollToBottom();
  } else {
    // if you want to always ensure bottom when it disappears, remove the if-check
    //_scrollToBottom();
  }
});
    // Optional: scroll to bottom on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notificationUserId = widget.partnerId;
    controller.markAsRead(widget.partnerId);
    return WillPopScope(
      onWillPop: () async {
         socketService.endSession();
          Navigator.of(context).pushAndRemoveUntil(
                     MaterialPageRoute(builder: (context) => MainHomeScreen(index: 1)),
                      (route) => false,
                     );
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF7F8FA),
        appBar: ChatAppBar(
          partnerId: widget.partnerId,
          userName: widget.partnerName,
          userAvatar: widget.partnerAvatar,
          isFriend: widget.isFriend,
        ),
        body: Column(
          children: [
            // Messages List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
      
                return Obx(() {
                  final msgCount = controller.messages.length;
                  final showTyping = controller.partnerTyping.value;
                  
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 12),
                    itemCount: msgCount + (showTyping ? 1 : 0),
                    itemBuilder: (context, index) {
      
                      if (showTyping && index == msgCount) {
                        return const TypingBubble();
                      }
      
                      final msg = controller.messages[index];
                      
                      return ChatBubble(
                        fromMe: msg['fromMe'] ?? false,
                        message: msg['body'] ?? '',
                        isRead: msg['isRead'] ?? false,
                        isVoice: msg["type"] == "voice-note",
                      voiceUrl: (msg["voiceUrl"] ?? msg["localPath"])?.toString(),

                        isSending: msg["sending"] ?? false,
                      );
                    },
                  );
                });
              }),
            ),
      
            // Blocked user or input field
            Obx(() {
              final isBlocked = friendController.blockedUsersList
                  .any((user) => user.id == widget.partnerId);
      
              if (isBlocked) {
                return InkWell(
                  onTap: () {
                    friendController.unblockUser(widget.partnerId);
                    friendController.fetchFriends();
                    friendController.update();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "You blocked this user",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else {
                return MessageInputField(controller: controller);
              }
            }),
          ],
        ),
      ),
    );
  }
}
 