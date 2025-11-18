import 'dart:developer';

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

Future<List<Map<String, dynamic>>> getFriendChatHistory(
  String friendId, {
  int limit = 10,
  int offset = 0,
}) async {
  try {
    final res = await _api.get(
      "${ApiEndpoints.getFriendChatHistory}$friendId?limit=$limit&offset=$offset",
      requireAuth: true,
    );

    if (res["messages"] == null) return [];

    return (res["messages"] as List).map((msg) {
      return {
        "fromMe": msg["from"] == SessionController().user!.id,
        "body": msg["body"] ?? '',
        "from": msg["from"],
        "to": msg["to"],
        "isRead": msg["isRead"],
        "type": msg["type"] ?? "text",
      };
    }).toList();
  } catch (e) {
    debugPrint("Error fetching chat history: $e");
    return [];
  }
}

  // Future<List<Map<String, dynamic>>> getFriendChatHistory(
  //   String friendId,
  // ) async {
  //   try {
  //     final res = await _api.get(
  //       "${ApiEndpoints.getFriendChatHistory}$friendId",
  //       requireAuth: true,
  //     );
  //     if (res["messages"] == null) return [];
  //     log("messages ${res["messages"]}");
  //     return (res["messages"] as List)
  //         .map(
  //           (msg) => {
  //             "fromMe": msg["from"] == SessionController().user!.id,
  //             "body": msg["body"] ?? '',
  //             "from": msg["from"],
  //             "to": msg["to"],
  //             "isRead": msg["isRead"],
  //             "type": msg["type"] ?? "text",
  //           },
  //         )
  //         .toList();
  //   } catch (e) {
  //     debugPrint("Error fetching chat history: $e");
  //     return [];
  //   }
  // }

  Future<List<FriendRequestModel>> getIncomingRequestsList() async {
    final res = await _api.get(
      ApiEndpoints.getFriendRequests,
      requireAuth: true,
    ); // ✅ token added
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

  Future<bool> reportUser(String userId, String reason) async {
    try {
      final endpoint = "${ApiEndpoints.reportUser}";
      debugPrint("Reporting user: $endpoint");

      final res = await _api.post(
        endpoint,

        {"targetUserId": userId, 'reason': reason},
        requireAuth: true, // ✅ send token
      );

      debugPrint("Report response: ${res.data}");

      if (res.statusCode == 200) {
        debugPrint("✅ User reported successfully!");
        return true;
      } else {
        debugPrint("⚠️ Failed to report user: ${res.statusMessage}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Error while reporting user: $e");
      return false;
    }
  }

  Future<bool> blockUser(String userId) async {
    try {
      final endpoint = "${ApiEndpoints.blockUser}";
      debugPrint("Blocking user: $endpoint");

      final res = await _api.post(
        endpoint,

        {"targetUserId": userId}, // ✅ send token
        requireAuth: true,
      );

      debugPrint("Bock response: ${res.data}");

      if (res.statusCode == 200) {
        debugPrint("✅ User blocked successfully!");
        return true;
      } else {
        debugPrint("⚠️ Failed to block user: ${res.statusMessage}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Error while blocking user: $e");
      return false;
    }
  }

  Future<bool> unblockUser(String userId) async {
    try {
      final endpoint = "${ApiEndpoints.unblockUser}/$userId";
      debugPrint("Unblocking user: $endpoint");

      final res = await _api.delete(
        endpoint,
        requireAuth: true,
        // ✅ send token
      );

      debugPrint("Unblock response: ${res.data}");

      if (res.statusCode == 200) {
        debugPrint("✅ User unblocked successfully!");
        return true;
      } else {
        debugPrint("⚠️ Failed to unblock user: ${res.statusMessage}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Error while unblocking user: $e");
      return false;
    }
  }

  Future<List<FriendModel>> getBlockedUsersList() async {
    try {
      debugPrint("Fetching Blocked list...");

      // ✅ Add token from session
      final res = await _api.get(
        ApiEndpoints.getBlockedUsers,
        requireAuth: true, // This will send token in header
      );

      debugPrint("Block list API response: $res");

      if (res["blocked"] == null) {
        debugPrint("No blocked users found in response.");
        return [];
      }

      final friends = (res["blocked"] as List)
          .map((e) => FriendModel.fromJson(e["user"]))
          .toList();

      debugPrint("Parsed friends count: ${friends.length}");
      return friends;
    } catch (e) {
      debugPrint("Error fetching friends: $e");
      rethrow;
    }
  }
}
