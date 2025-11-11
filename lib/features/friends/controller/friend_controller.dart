import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/features/friends/model/friend_model.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/features/friends/model/friend_request_model.dart';
import 'package:whisp/features/friends/repo/friends_repo.dart';

class FriendsController extends GetxController {
  final FriendRepo repo = FriendRepo();

  // Friends tab
  var friendsList = <FriendModel>[].obs;
  var searchQuery = ''.obs;

  // Requests tab
  var friendRequests = <FriendRequestModel>[].obs;

  final RxBool isLoadingFriends = false.obs;
  final RxBool isLoadingRequests = false.obs;

  @override
  void onInit() {
    super.onInit();

    // ✅ Load friends from API
    fetchFriends();

    // ✅ Load friend requests from API
    fetchIncomingRequests();

  
  }
 
// Fetch Friends List from API
 
  Future<void> fetchFriends() async {
    try {
      isLoadingFriends.value = true;

      final res = await repo.getFriendsList();
      friendsList.assignAll(res);
    } catch (e) {
      log("Error fetching friends: $e");
    } finally {
      isLoadingFriends.value = false;
    }
  }

 
  //   Fetch Incoming Friend Requests from API
 
 Future<void> fetchIncomingRequests() async {
    try {
      isLoadingRequests.value = true;

      // ✅ Repo now returns List<FriendRequestModel>
      final List<FriendRequestModel> requests = await repo.getIncomingRequestsList();

      friendRequests.assignAll(requests);
    } catch (e) {
      log("Error fetching incoming requests: $e");
    } finally {
      isLoadingRequests.value = false;
    }
  }

 
  
  void toggleFriendStatus(FriendModel friend) {
    friend.isFriend = !friend.isFriend;
    friendsList.refresh();
  }

 
  List<FriendModel> get filteredFriends {
    if (searchQuery.value.isEmpty) return friendsList;

    return friendsList
        .where((f) =>
            f.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
void acceptRequest(String requestId) {
  SocketService.to.acceptFriend(requestId, (ack) {
    print("⚡ accept ack: $ack"); // debug log
    if (ack['ok'] == true) {
      final index = friendRequests.indexWhere((r) => r.id == requestId);
      if (index != -1) {
        friendRequests.removeAt(index);
        friendRequests.refresh();
      }
      fetchFriends();
      Get.snackbar("Success", "Friend request accepted");
    } else {
      Get.snackbar("Error", ack['code'] ?? "Failed to accept request");
    }
  });
}

void rejectRequest(String requestId) {
  try {
    SocketService.to.rejectFriend(requestId, (ack) {
      if (ack['ok'] == true) {
        final index = friendRequests.indexWhere((r) => r.id == requestId);
        if (index != -1) {
          friendRequests.removeAt(index);
          friendRequests.refresh();
        }
        Get.snackbar("Success", "Friend request rejected",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white);
      } else {
        Get.snackbar("Error", ack['code'] ?? "Failed to reject request",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white);
      }
    });
  } catch (e) {
    Get.snackbar("Error", "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white);
  }
}

  // //  Accept Request using Socket
 
  // void acceptRequest(String requestId) {
  //   SocketService.to.acceptFriend(requestId, (ack) {
  //     if (ack['ok'] == true) {
  //       friendRequests.removeWhere((r) => r.id == requestId);

  //       // optionally refresh after accepting
  //       fetchFriends();
  //     } else {
  //       Get.snackbar("Error", ack['code'] ?? "Failed to accept request");
  //     }
  //   });
  // }
 
  // //   Reject Request using Socket
  
  // void rejectRequest(String requestId) {
  //   SocketService.to.rejectFriend(requestId, (ack) {
  //     if (ack['ok'] == true) {
  //       friendRequests.removeWhere((r) => r.id == requestId);
  //     } else {
  //       Get.snackbar("Error", ack['code'] ?? "Failed to reject request");
  //     }
  //   });
  // }
}

 