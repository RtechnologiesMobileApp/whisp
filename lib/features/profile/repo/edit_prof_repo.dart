import 'dart:io';

import 'package:dio/dio.dart';
import 'package:whisp/core/network/api_client.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/features/auth/models/user_model.dart';

class EditProfRepo {
  final ApiClient _apiClient = ApiClient();
  Future<UserModel> updateProfile({
    String? fullName,
    String? dateOfBirth,
    String? gender,
    String? country,
    File? avatar,
  }) async {
    try {
      // ✅ Format DOB correctly if provided
      String? formattedDOB;
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        try {
          final parsed = DateTime.parse(dateOfBirth);
          formattedDOB =
              "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}";
        } catch (_) {
          formattedDOB = dateOfBirth; // fallback if already formatted
        }
      }
      // ✅ Only include non-null fields
      final formMap = <String, dynamic>{
        if (fullName != null && fullName.isNotEmpty) "fullName": fullName,
        if (formattedDOB != null && formattedDOB.isNotEmpty)
          "dateOfBirth": formattedDOB,
        if (gender != null && gender.isNotEmpty) "gender": gender,
        if (country != null && country.isNotEmpty) "country": country,
        if (avatar != null)
          "avatar": await MultipartFile.fromFile(
            avatar.path,
            filename: avatar.path.split("/").last,
          ),
      };
      final formData = FormData.fromMap(formMap);
      final token = SessionController().user?.token;
      print("Token: $token"); // Must not be null or empty
      // ✅ PUT request using your ApiClient
      final response = await _apiClient.put(
        ApiEndpoints.updateProfile,
        data: formData,
        isFormData: true,
        requireAuth: true,
      );
      // ✅ Extract and save user
      print("Token before update: ${SessionController().user?.token}");
      final updatedUser = UserModel.fromJson(
        response.data['user'],
      ).copyWith(token: SessionController().user?.token);
      SessionController().saveUserSession(updatedUser);
      print("Token after update: ${SessionController().user?.token}");
      return updatedUser;
    } catch (e) {
      rethrow;
    }
  }
}
