 

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whisp/core/network/api_client.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/core/network/api_exception.dart';
import 'package:whisp/core/services/session_manager.dart';

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

    debugPrint("📤 Sending voice note to endpoint: $endpoint");
    debugPrint("📤 File path: ${audioFile.path}");
    debugPrint("📤 File field: voiceNote");
    debugPrint("📤 Using auth token: ${SessionController().user?.token != null ? 'Yes' : 'No'}");

    final response = await _apiClient.postMultipart(
      endpoint,
      data: {},  
      file: audioFile,
      fileField: "voiceNote",
      requireAuth: true, 
    );

    debugPrint("✅ Voice note upload response: $response");

    return response;
  } catch (e, st) {
    debugPrint("❌ Error sending voice note: $e");
    debugPrint(st.toString());
    throw ApiException.handleError(e);
  }
}

}
