import 'package:get/get.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/features/friends/model/friend_model.dart';

class FriendsController extends GetxController {
  var friendsList = <FriendModel>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFriends();
  }

  void loadFriends() {
    friendsList.assignAll([
      FriendModel(name: "Ivan", imageUrl: AppImages.daim, isVerified: true),
      FriendModel(name: "Daim", imageUrl: AppImages.daim),
      FriendModel(name: "Ali", imageUrl: AppImages.daim),
      FriendModel(name: "Malik", imageUrl: AppImages.daim),
    ]);
  }

  void toggleFriendStatus(FriendModel friend) {
    friend.isFriend = !friend.isFriend;
    friendsList.refresh();
  }

  List<FriendModel> get filteredFriends {
    if (searchQuery.value.isEmpty) return friendsList;
    return friendsList
        .where(
          (f) => f.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }
}
