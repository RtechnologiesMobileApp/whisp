import 'package:get/get.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/features/friends/model/friend_model.dart';
import 'package:whisp/core/services/socket_service.dart';

class FriendsController extends GetxController {
  // --------------------
  // Friends tab
  // --------------------
  var friendsList = <FriendModel>[].obs;
  var searchQuery = ''.obs;
 var currentTabIndex = 0.obs; 
  // --------------------
  // Requests tab
  // --------------------
  var friendRequests = <FriendModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyFriends();

    // Listen for real-time friend requests
    listenForFriendRequests();
  }

  // --------------------
  // Friends methods
  // --------------------
  void loadDummyFriends() {
    friendsList.assignAll([
      FriendModel(name: "Ivan", imageUrl: AppImages.daim, isVerified: true, id: ''),
      FriendModel(name: "Daim", imageUrl: AppImages.daim, id: ''),
      FriendModel(name: "Ali", imageUrl: AppImages.daim, id: ''),
      FriendModel(name: "Malik", imageUrl: AppImages.daim, id: ''),
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

  // --------------------
  // Requests methods
  // --------------------

  void listenForFriendRequests() {
    final socket = SocketService.to;

    // Incoming request from other user
    socket.onFriendRequestIncoming((data) {
      final req = FriendModel.fromJson(Map<String, dynamic>.from(data));
      friendRequests.add(req);
    });

    // Request accepted by other user
    socket.onFriendRequestAccepted((data) {
      final acceptedUser = FriendModel.fromJson(Map<String, dynamic>.from(data));
      // Remove from requests if present
      friendRequests.removeWhere((r) => r.id == acceptedUser.id);
      // Add to friends list
      friendsList.add(acceptedUser);
    });

    // Request rejected by other user
    socket.onFriendRequestRejected((data) {
      final rejectedUser = FriendModel.fromJson(Map<String, dynamic>.from(data));
      friendRequests.removeWhere((r) => r.id == rejectedUser.id);
    });

    // Request canceled by sender
    socket.onFriendRequestCanceled((data) {
      final canceledUser = FriendModel.fromJson(data['from']);
      friendRequests.removeWhere((r) => r.id == canceledUser.id);
    });

    // Friend added (directly, e.g., after acceptance)
    socket.onFriendAdded((data) {
      final newFriend = FriendModel.fromJson(data['user']);
      friendsList.add(newFriend);
      friendRequests.removeWhere((r) => r.id == newFriend.id);
    });
  }

  void acceptRequest(String requestId) {
    SocketService.to.acceptFriend(requestId, (ack) {
      if (ack['ok'] == true) {
        friendRequests.removeWhere((r) => r.id == requestId);
        // Optional: refresh friends list from server
      } else {
        Get.snackbar("Error", ack['code'] ?? "Failed to accept request");
      }
    });
  }

  void rejectRequest(String requestId) {
    SocketService.to.rejectFriend(requestId, (ack) {
      if (ack['ok'] == true) {
        friendRequests.removeWhere((r) => r.id == requestId);
      } else {
        Get.snackbar("Error", ack['code'] ?? "Failed to reject request");
      }
    });
  }
}
