import 'package:get/get.dart';

class ChatListController extends GetxController {
  var chats = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Dummy data (replace later with backend/socket)
    chats.value = [
      {
        'name': 'Sam',
        'lastMessage': 'You: Hey just saw you sitting at the bar. Cute dog :)',
        'time': '9:25 pm',
        'image': 'assets/images/user1.png',
        'isOnline': false,
        'isTyping': false,
      },
      {
        'name': 'Daniella',
        'lastMessage': '',
        'time': '',
        'image': 'assets/images/user2.png',
        'isOnline': true,
        'isTyping': true,
      },
      {
        'name': 'Karen',
        'lastMessage': 'Sure, meet me at the bar in 5?',
        'time': '9:25 pm',
        'image': 'assets/images/user3.png',
        'isOnline': false,
        'isTyping': false,
      },
      {
        'name': 'James',
        'lastMessage': 'Just going to the bar to get a drink.',
        'time': '9:25 pm',
        'image': 'assets/images/user4.png',
        'isOnline': false,
        'isTyping': false,
      },
      {
        'name': 'Melissa',
        'lastMessage': 'Sure, meet me at the bar in 5?',
        'time': '9:25 pm',
        'image': 'assets/images/user5.png',
        'isOnline': false,
        'isTyping': false,
      },
    ];
  }
}
