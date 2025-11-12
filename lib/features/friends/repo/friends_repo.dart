import 'package:flutter/material.dart';
import 'package:whisp/core/network/api_client.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/core/services/session_manager.dart';
 
import 'package:whisp/features/friends/model/friend_model.dart';
import 'package:whisp/features/friends/model/friend_request_model.dart';

class FriendRepo {
  final ApiClient _api = ApiClient();

Future<List<FriendModel>> getFriendsList() async {
  try {
    debugPrint("Fetching friends list...");

    // ✅ Add token from session
    final res = await _api.get(
      ApiEndpoints.getFriends,
      requireAuth: true, // This will send token in header
    );

    debugPrint("Friends API response: $res");

    if (res["friends"] == null) {
      debugPrint("No friends found in response.");
      return [];
    }

    final friends = (res["friends"] as List)
        .map((e) => FriendModel.fromJson(e))
        .toList();

    debugPrint("Parsed friends count: ${friends.length}");
    return friends;
  } catch (e) {
    debugPrint("Error fetching friends: $e");
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> getFriendChatHistory(String friendId) async {
  try {
    final res = await _api.get("${ApiEndpoints.getFriendChatHistory}$friendId", requireAuth: true);
    if (res["messages"] == null) return [];

    return (res["messages"] as List)
        .map((msg) => {
              "fromMe": msg["from"] == SessionController().user!.id,
              "message": msg["body"] ?? '',
              "from": msg["from"],
              "to": msg["to"],
            })
        .toList();
  } catch (e) {
    debugPrint("Error fetching chat history: $e");
    return [];
  }
}

 


Future<List<FriendRequestModel>> getIncomingRequestsList() async {
  final res = await _api.get(ApiEndpoints.getFriendRequests, requireAuth: true); // ✅ token added
  final List<dynamic> incoming = res["incoming"] ?? [];

  return incoming.map((req) {
    final from = req["from"] ?? {};
    return FriendRequestModel(
      id: req["requestId"] ?? "",
      userId: from["id"] ?? "",
      name: from["fullName"] ?? "",
      imageUrl: from["avatar"] ?? "",
    );
  }).toList();
}


Future<bool> unfriend(String userId) async {
  try {
    final endpoint = "${ApiEndpoints.unfriend}/$userId";
    debugPrint("Unfriending user: $endpoint");

    final res = await _api.put(
      endpoint,
      requireAuth: true, // ✅ send token
    );

    debugPrint("Unfriend response: ${res.data}");

    if (res.statusCode == 200) {
      debugPrint("✅ User unfriended successfully!");
      return true;
    } else {
      debugPrint("⚠️ Failed to unfriend user: ${res.statusMessage}");
      return false;
    }
  } catch (e) {
    debugPrint("❌ Error while unfriending: $e");
    return false;
  }
}


}