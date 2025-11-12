import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/features/Chats/controllers/chat_list_controller.dart';
import 'package:whisp/features/Chats/view/chat_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  final ChatListController controller = Get.put(ChatListController());

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
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.inbox_outlined,
                        color: Colors.black, size: 24),
                  ),
                ],
              ),
            ),

            // ===== Chat List =====
            Expanded(
              child: Obx(
                (){
                    if(controller.chats.length==0){
                      return Center(child: Text("No Chats"),);
                    
                    }
                  return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.chats.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.grey),
                  itemBuilder: (context, index) {
                  
                    final chat = controller.chats[index];
                    return Slidable(
                      endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => debugPrint('Disconnect ${chat['name']}'),
                  backgroundColor: Colors.grey.shade700,
                  foregroundColor: Colors.white,
                  label: 'Disconnect',
                ),
                SlidableAction(
                  onPressed: (_) => debugPrint('Block ${chat['name']}'),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  label: 'Block',
                ),
                SlidableAction(
                  onPressed: (_) => debugPrint('Report ${chat['name']}'),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  label: 'Report',
                ),
              ],
            ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        leading: Stack(
                          children: [
                           CircleAvatar(
                        radius: 26,
                        backgroundImage: chat['image'] != null && chat['image'] != ''
                            ? NetworkImage(chat['image'])
                            : AssetImage('assets/images/place_holder_pic.jpg') as ImageProvider,
                      ),
                      
                            if (chat['isOnline'] == true)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1.5),
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
                          ),
                        ),
                        subtitle: chat['isTyping'] == true
                            ? const Text(
                                'typing...',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              )
                            : Text(
                                chat['lastMessage'] ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                        trailing: Text(
                          chat['time'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {
                          // 👉 Navigate to friend ChatScreen
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
                }
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
