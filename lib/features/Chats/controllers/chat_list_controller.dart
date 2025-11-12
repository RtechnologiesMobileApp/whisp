import 'package:get/get.dart';
import 'package:whisp/features/friends/controller/friend_controller.dart';
 

class ChatListController extends GetxController {
  var chats = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFriendsForChatList();
  }

  void loadFriendsForChatList() {
    final friendController = Get.find<FriendsController>();
    
    // Wait for friends to load if not already
    friendController.fetchFriends().then((_) {
      chats.assignAll(friendController.friendsList.map((f) => {
        'id': f.id,
        'name': f.name,
        'image': f.imageUrl,
        'lastMessage': '', // optional, ya fir backend se le sakte ho
      }).toList());
    });
  }
}
