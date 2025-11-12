import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:whisp/core/services/session_manager.dart';

import 'api_exception.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://whisp-backend-production-1880.up.railway.app",
       // baseUrl: "https://251fa787eeab.ngrok-free.app",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

Future<dynamic> get(String endpoint, {bool requireAuth = false}) async {
  try {
    // ✅ token only if required
    final token = requireAuth ? SessionController().user!.token : "";

    final response = await _dio.get(
      endpoint,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (requireAuth && token!.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      ),
    );
    return response.data;
  } catch (e) {
    throw ApiException.handleError(e);
  }
}

    Future<dynamic> postMultipart(
    String endpoint, {
    required Map<String, dynamic> data,
    required File? file,
    required String fileField,
  }) async {
    final formData = FormData.fromMap({
      ...data,
      if (file != null)
        fileField: await MultipartFile.fromFile(file.path,
            filename: file.path.split("/").last),
    });

    final response = await _dio.post(endpoint, data: formData);
    return response.data;
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      log(data.toString());
      return response.data;
    } catch (e) {
      throw ApiException.handleError(e);
    }
  }

   

  Future<Response> put(
    String endpoint, {
    dynamic data,
    bool isFormData = false,
    bool requireAuth = false,
  }) async {
    try {
     final token = requireAuth ? SessionController().user?.token ?? "" : "";


      final options = Options(
        headers: {
          "Content-Type": isFormData
              ? "multipart/form-data"
              : "application/json",
          if (requireAuth && token.isNotEmpty) "Authorization": "Bearer $token",
        },
      );

      final response = await _dio.put(endpoint, data: data, options: options);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data ?? e.message);
      }
      throw Exception("Network error: ${e.message}");
    }
  }
}

 