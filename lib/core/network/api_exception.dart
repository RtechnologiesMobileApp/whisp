import 'dart:convert';
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  static ApiException handleError(dynamic error) {
    if (error is DioException) {
      // Extract message safely
      dynamic responseData = error.response?.data;
      if (responseData is String) {
        try {
          responseData = jsonDecode(responseData);
        } catch (_) {}
      }

      // 💬 If API returned a JSON error body
      if (responseData is Map && responseData.containsKey('error')) {
        final err = responseData['error'];
        switch (err) {
          case 'INCORRECT_PASSWORD':
            return ApiException('Incorrect password');
          case 'USER_NOT_FOUND':
            return ApiException('User not found');
          default:
            return ApiException(err.toString());
        }
      }

      // 🌐 Handle Dio-specific types
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ApiException("Connection Timeout. Please check your internet.");
        case DioExceptionType.sendTimeout:
          return ApiException("Request Timeout. Try again.");
        case DioExceptionType.receiveTimeout:
          return ApiException("Server took too long to respond.");
        case DioExceptionType.connectionError:
          return ApiException("No Internet connection. Please check your network.");
        case DioExceptionType.badResponse:
          return ApiException(
            "Server returned an error: ${error.response?.statusCode ?? ''}",
          );
        default:
          return ApiException("Unexpected Error occurred.");
      }
    } else {
      return ApiException("Something went wrong. Please try again.");
    }
  }

  @override
  String toString() => message;
}
