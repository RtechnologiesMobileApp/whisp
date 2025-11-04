import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  static ApiException handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ApiException("Connection Timeout");
        case DioExceptionType.receiveTimeout:
          return ApiException("Receive Timeout");
        case DioExceptionType.badResponse:
          return ApiException(error.response?.data["message"] ?? "Bad Response");
        default:
          return ApiException("Unexpected Error");
      }
    } else {
      return ApiException("Something went wrong");
    }
  }

  @override
  String toString() => message;
}
