import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/global.dart';
import 'package:whisp/features/Chats/controllers/chat_controller.dart';
import 'package:whisp/features/Chats/widgets/chat_screen_appbar.dart';
import 'package:whisp/features/friends/controller/friend_controller.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input_field.dart';

class ChatScreen extends StatefulWidget {
 final String partnerId;
  final String partnerName;
  final String partnerAvatar;
  final bool isFriend;

  const ChatScreen({super.key, required this.partnerId, required this.partnerName, required this.partnerAvatar,this.isFriend = false});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  
  @override
  Widget build(BuildContext context) {
    notificationUserId=widget.partnerId;
   
   final FriendsController friendController =Get.isRegistered<FriendsController>()? Get.find<FriendsController>() : Get.put(FriendsController());
final ChatController controller = Get.isRegistered<ChatController>(tag: widget.isFriend ? widget.partnerId : 'random')
    ? Get.find<ChatController>(tag: widget.isFriend ? widget.partnerId : 'random')
    : Get.put(
        ChatController(friendId: widget.partnerId, isFriend: widget.isFriend),
        tag: widget.isFriend ? widget.partnerId : 'random',
      );
   friendController.getBlockedUsers();
     

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: ChatAppBar(partnerId: widget.partnerId, userName: widget.partnerName, userAvatar: widget.partnerAvatar, isFriend: widget.isFriend,),
      body: Column(
        children: [
          Expanded(
  child: Obx(
    () {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        padding: const EdgeInsets.only(top: 12),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final msg = controller.messages[index];
          final bool isFromMe = msg['fromMe'] ?? false;
          final String message = msg['message'] ?? '';
          return ChatBubble(fromMe: isFromMe, message: message);
        },
      );
    },
  ),
),

 Obx(() {
      return controller.partnerTyping.value
          ? Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    "${widget.partnerName} is typing...",
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : SizedBox.shrink();
    }),


Obx((){
  return
      friendController.blockedUsersList.any((user) => user.id == widget.partnerId)
    ? InkWell(
      onTap: () {
        friendController.unblockUser(widget.partnerId);
        friendController.fetchFriends();
        friendController.update();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          
          ),
        
        child: Text("You block this user",style: TextStyle(color: Colors.white),)),
    )
    : 


             MessageInputField(  controller: controller  );
             })
        ],
      ),
    );
  }
}
