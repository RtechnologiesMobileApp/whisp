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

  final RxBool isLoadingFriends = true.obs;
final RxBool isLoadingRequests = true.obs;

  @override
  void onReady() {
  super.onReady();
  fetchFriends();
  fetchIncomingRequests();
}

  // @override
  // void onInit() {
  //   super.onInit();

    

  
  // }
 
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

  Future<void> unfriendUser(String userId) async {
  try {
    debugPrint("Attempting to unfriend user: $userId");
    final success = await repo.unfriend(userId);

    if (success) {
      Get.snackbar("Success", "User removed from friends list");
      // Optionally update your UI list:
      friendsList.removeWhere((f) => f.id == userId);
      update();
    } else {
      Get.snackbar("Failed", "Could not unfriend this user");
    }
  } catch (e) {
    debugPrint("❌ Error in controller while unfriending: $e");
    Get.snackbar("Error", e.toString());
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

 
}

 