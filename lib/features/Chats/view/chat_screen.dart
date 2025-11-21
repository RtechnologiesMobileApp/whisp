import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/global/global.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/features/Chats/controllers/chat_controller.dart';
import 'package:whisp/features/Chats/widgets/chat_screen_appbar.dart';
import 'package:whisp/features/Chats/widgets/recording_bubble.dart';
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
  int fromIndex;

  ChatScreen({
    super.key,
    required this.partnerId,
    required this.partnerName,
    required this.partnerAvatar,
    this.isFriend = false,
    required this.fromIndex,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isActive = false;
  late ScrollController _scrollController;
  late ChatController controller;
  late FriendsController friendController;
  final socketService = Get.find<SocketService>();
  bool isLoadingMore = false;

  void _scrollListener() {
    // make sure controller attached
    if (!_scrollController.hasClients) return;

    try {
      final pos = _scrollController.position;
      // When user scrolls near top (<= 100 px from top) -> load older messages
      if (pos.pixels <= pos.minScrollExtent + 100) {
        // avoid rapid multiple calls — your controller also checks isLoadingMore
        debugPrint("Reached TOP → loading more...");
        controller.loadMoreMessages(_scrollController);
      }
    } catch (e) {
      // sometimes position access may throw if controller lost attachment briefly
      debugPrint("scrollListener error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    socketService.onRecording((data) {
      final isRecording = data['isRecording'];
      final userId = data['userId'];

      if (userId == widget.partnerId) {
        controller.partnerRecording.value = isRecording;
        debugPrint("🎧 Friend recording: $isRecording");

        // scroll bottom if visible
        if (_scrollController.hasClients &&
            _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 50) {
          _scrollToBottom();
        }
      }
    });

    _isActive = true;

    _scrollController = ScrollController();
    // attach our safe listener
    _scrollController.addListener(_scrollListener);

    // Initialize ChatController once
    controller =
        Get.isRegistered<ChatController>(
          tag: widget.isFriend ? widget.partnerId : 'random',
        )
        ? Get.find<ChatController>(
            tag: widget.isFriend ? widget.partnerId : 'random',
          )
        : Get.put(
            ChatController(
              friendId: widget.partnerId,
              isFriend: widget.isFriend,
            ),
            tag: widget.isFriend ? widget.partnerId : 'random',
          );

    // ... rest of your initState (FriendsController init, ever listeners, etc.)
    friendController = Get.isRegistered<FriendsController>()
        ? Get.find<FriendsController>()
        : Get.put(FriendsController());

    friendController.getBlockedUsers();

    // Scroll to bottom whenever messages change
    ever(controller.messages, (messages) {
      if (_isActive) {
        controller.markAsRead(widget.partnerId);
      }

      // Only scroll down if last message is from me (sent message)
      if (messages.isNotEmpty && messages.last["fromMe"] == true) {
        _scrollToBottom();
      }
    });

    // typing bubble ho to scroll only if already at bottom
    ever(controller.partnerTyping, (_) {
      if (_scrollController.hasClients &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 50) {
        _scrollToBottom();
      }
    });

    // Optional: scroll to bottom on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _isActive = false;
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    if (bottomInset > 0) {
      _scrollToBottom();
    }
    notificationUserId = widget.partnerId;
    controller.markAsRead(widget.partnerId);
    return WillPopScope(
      onWillPop: () async {
        socketService.endSession();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainHomeScreen(index: widget.fromIndex),
          ),
          (route) => false,
        );
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffF7F8FA),
        appBar: ChatAppBar(
          partnerId: widget.partnerId,
          userName: widget.partnerName,
          userAvatar: widget.partnerAvatar,
          isFriend: widget.isFriend,
          fromIndex: widget.fromIndex,
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
                  final showRecording = controller.partnerRecording.value;
                  int extra = showRecording ? 1 : (showTyping ? 1 : 0);
                  return ListView.builder(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 12),
                    //  itemCount: msgCount + (showTyping ? 1 : 0),
                    itemCount: msgCount + extra,
                    itemBuilder: (context, index) {
                      // if (showTyping && index == msgCount) {
                      //   return const TypingBubble();
                      // }

                      // if (controller.partnerRecording.value) {
                      //   return const RecordingBubble(); // 🎤
                      // }
                      if (index == msgCount) {
                        if (showRecording) return const RecordingBubble();
                        if (showTyping) return const TypingBubble();
                      }
                      final msg = controller.messages[index];

                      return ChatBubble(
                        fromMe: msg['fromMe'] ?? false,
                        message: msg['body'] ?? '',
                        isRead: msg['isRead'] ?? false,
                        isVoice: msg["type"] == "voice-note",
                        voiceUrl: (msg["voiceUrl"] ?? msg["localPath"])
                            ?.toString(),

                        isSending: msg["sending"] ?? false,
                      );
                    },
                  );
                });
              }),
            ),

            // Blocked user or input field
            Obx(() {
              final isBlocked = friendController.blockedUsersList.any(
                (user) => user.id == widget.partnerId,
              );

              if (isBlocked) {
                return InkWell(
                  onTap: () {
                    friendController.unblockUser(widget.partnerId);
                    friendController.fetchFriends();
                    friendController.update();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
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
                return MessageInputField(
                  controller: controller,
                  isFriend: widget.isFriend,
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
