 

import 'dart:io';

import 'package:whisp/core/network/api_client.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/core/network/api_exception.dart';

class ChatRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getChatList() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getFreindChatList,
        requireAuth: true,
      );

      // The response looks like: { "chatFriends": [ {...}, {...} ] }
      if (response is Map && response['chatFriends'] is List) {
        return response['chatFriends'];
      } else {
        return [];
      }
    } catch (e) {
      throw ApiException.handleError(e);
    }
  }

Future<Map<String, dynamic>> sendVoiceMessage({
  required String friendId, // 👈 yeh friend ki id
  required File audioFile,
}) async {
  try {
    // Endpoint me friendId include karna
    final endpoint = "/api/chat/voice-note/$friendId";

    final response = await _apiClient.postMultipart(
      endpoint,
      data: {}, // extra data agar koi nahi hai toh empty map
      file: audioFile,
      fileField: "voiceNote",
      requireAuth: true, // Auth token include hoga header me
    );

    return response;
  } catch (e) {
    throw ApiException.handleError(e);
  }
}

}
