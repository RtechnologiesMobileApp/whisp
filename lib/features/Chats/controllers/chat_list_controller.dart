
import 'package:get/get.dart';
import 'package:whisp/features/Chats/repo/chat_repo.dart';
 

class ChatListController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();

  var chats = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadChatList();
  }

  Future<void> loadChatList() async {
    try {
      isLoading.value = true;

      final data = await _chatRepository.getChatList();

      chats.assignAll(
        data.map<Map<String, dynamic>>((chat) {
          return {
            'id': chat['_id'] ?? chat['id'],
            'name': chat['fullName'] ?? '',
            'avatar': chat['avatar'] ?? '',
            'country': chat['country'] ?? '',
            'premium': chat['premium'] ?? false,
            'lastMessage': chat['lastMessage'] ?? '',
            'lastMessageUserId': chat['lastMessageUserId'] ?? '',
            'lastMessageTime': chat['lastMessageTime'] ?? '',
          };
        }).toList(),
      );
    } catch (e) {
      print("❌ Error loading chat list: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

// import 'package:get/get.dart';
// import 'package:whisp/features/friends/controller/friend_controller.dart';
 

// class ChatListController extends GetxController {
//   var chats = <Map<String, dynamic>>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadFriendsForChatList();
//   }

//   void loadFriendsForChatList() {
//     final friendController = Get.find<FriendsController>();
    
//     // Wait for friends to load if not already
//     friendController.fetchFriends().then((_) {
//       chats.assignAll(friendController.friendsList.map((f) => {
//         'id': f.id,
//         'name': f.name,
//         'image': f.imageUrl,
//         'lastMessage': '', // optional, ya fir backend se le sakte ho
//       }).toList());
//     });
//   }
// }
