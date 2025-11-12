 

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
}
