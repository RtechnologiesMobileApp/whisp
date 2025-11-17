import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whisp/core/services/fcm_service.dart';
import 'package:whisp/features/auth/models/user_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';

class AuthRepository {
  final ApiClient _apiClient = Get.isRegistered<ApiClient>() ? Get.find<ApiClient>() : Get.put(ApiClient());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
 
Future<dynamic> login({
    required String email,
    String? password,
    required String type,
  }) async {
    print("[login api] url: ${ApiEndpoints.login}");
    try {
      String? fcm=await FCMService().getToken();
      log("${FCMService().getToken()}");
      final response = await _apiClient.post(ApiEndpoints.login, {
        "email": email,
        if (password != null) "password": password,
        "type": type,
        'fcmToken':"${fcm}"
      });

      print("[login api] success: ${response}");
      return response;
    } on DioException catch (e) {
      print("[login api] DioException caught!");
      print("[login api] status: ${e.response?.statusCode}");
      print("[login api] data: ${e.response?.data}");

      dynamic data = e.response?.data;
      // Some APIs return a JSON string instead of a Map
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {}
      }

      if (data is Map && data.containsKey('error')) {
        final error = data['error'];
        print("[login api] parsed error: $error");
        if (error == 'INCORRECT_PASSWORD') {
          throw ApiException("Incorrect password");
        } else if (error == 'USER_NOT_FOUND') {
          throw ApiException("Email Does not exist");
        } else {
          throw ApiException(error.toString());
        }
      }

      // if data is null or unexpected, use general handler
      throw ApiException.handleError(e);
    } catch (e, s) {
      print("[login api] UNEXPECTED: $e");
      print(s);
      throw ApiException(e.toString());
    }
  }
  // Future<dynamic> login({required String email, String? password, required String type}) async {
  //   print("[login api] url: ${ApiEndpoints.login}");
  //   final response = await _apiClient.post(ApiEndpoints.login, {
  //     "email": email,
  //     if (password != null) "password": password,
  //     "type":type
  //   });
  //   print("[login api] response: $response");
  //   return response;
  // }

  Future<void> logout() async {
    await _auth.signOut();
  }
  
  Future<dynamic> forgotPassword(String email) async {
    return await _apiClient.post(ApiEndpoints.forgotPassword, {"email": email});
  }
  Future<UserModel> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // Ensure any previous session is cleared
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Sign-in cancelled");
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;
      if (user == null) {
        throw Exception("Failed to get user data");
      }
      final userData = UserModel(
        name: user.displayName ?? "",
        email: user.email ?? "",
        profilePic: user.photoURL,
        dob: "",
      );
      // temporarily skipping signup API call
      //final signupResponse =  await _apiClient.post(ApiEndpoints.signUp, userData.toJson());
      return userData;
    } catch (e, stackTrace) {
      // :fire: Print the exact error in console
      debugPrint(":x: Google Sign-In Error: $e");
      debugPrint(":page_facing_up: StackTrace:\n$stackTrace");
      throw Exception(e.toString());
    }
  }
  Future<bool> checkEmailExists(String email) async {
  try {
    print('📨 [checkEmailExists] Sending email check request: $email');

    final res = await _apiClient.post(
      ApiEndpoints.checkEmailExists,
      {"email": email},
    );

    // Debug log to verify structure
    print('📡 [checkEmailExists] Raw response: $res (${res.runtimeType})');

    // Ensure response is a Map (not Dio Response or null)
    if (res == null) {
      print('⚠️ Response is null');
      return false;
    }

    if (res is Map<String, dynamic>) {
      final exists = res['exists'] == true;
      print('✅ Parsed exists = $exists');
      return exists;
    } else {
      print('⚠️ Unexpected response type — converting manually');
      try {
        final data = jsonDecode(res.toString());
        final exists = data['exists'] == true;
        print('✅ Parsed from string: exists = $exists');
        return exists;
      } catch (e) {
        print('❌ Failed to parse response: $e');
        return false;
      }
    }
  } catch (e, s) {
    print('❌ [checkEmailExists] Exception: $e');
    print('🧩 StackTrace: $s');
    return false; // avoid crash
  }
}

  

  Future<dynamic> registerUser({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String dob,
    required String country,
    required File? avatar,
    String type = "email",
  }) async {
    try {
      String? fcm=await FCMService().getToken();
      final data = {
        "fullName": name,
        "email": email,
        "password": password,
        "gender": gender,
        "dateOfBirth": dob,
        "country": country,
        "type": type,
        'fcmToken':"$fcm"
      };

      final response = await _apiClient.postMultipart(
        ApiEndpoints.signUp,
        data: data,
        file: avatar,
        fileField: "avatar",
      );

      print("[register user api] response: $response");

      return response;
    } catch (e) {
      print("[register user api] error: $e");
      throw Exception(_handleError(e));
    }
  }

  String _handleError(dynamic e) {
    if (e is DioException) {
      // Extract error message from DioException
      final responseData = e.response?.data;
      String? errorMessage;
      
      if (responseData is Map) {
        // Backend returns errors as an array in 'errors' field
        if (responseData.containsKey('errors') && responseData['errors'] is List) {
          final errors = responseData['errors'] as List;
          if (errors.isNotEmpty) {
            // Format errors array into readable message
            errorMessage = errors
                .map((err) => err.toString().replaceAll('_', ' ').toLowerCase())
                .join(', ');
          }
        } else {
          errorMessage = responseData['message'] ?? responseData['error'];
        }
      } else if (responseData is String) {
        try {
          final parsed = jsonDecode(responseData);
          if (parsed is Map) {
            if (parsed.containsKey('errors') && parsed['errors'] is List) {
              final errors = parsed['errors'] as List;
              if (errors.isNotEmpty) {
                errorMessage = errors
                    .map((err) => err.toString().replaceAll('_', ' ').toLowerCase())
                    .join(', ');
              }
            } else {
              errorMessage = parsed['message'] ?? parsed['error'];
            }
          }
        } catch (_) {
          errorMessage = responseData;
        }
      }
      
      if (errorMessage != null && errorMessage.isNotEmpty) {
        // Make error messages more user-friendly
        if (errorMessage.toLowerCase().contains("email") || 
            errorMessage.toLowerCase().contains("user_already_exists")) {
          return "Email already exists.";
        }
        if (errorMessage.toLowerCase().contains("avatar_required")) {
          return "Profile picture is required.";
        }
        if (errorMessage.toLowerCase().contains("gender_required")) {
          return "Gender is required.";
        }
        if (errorMessage.toLowerCase().contains("date_of_birth_required") ||
            errorMessage.toLowerCase().contains("dob")) {
          return "Date of birth is required.";
        }
        if (errorMessage.toLowerCase().contains("country_required")) {
          return "Country is required.";
        }
        return errorMessage;
      }
      
      // Fallback to status message
      return e.message ?? "Something went wrong, please try again.";
    } else if (e is Exception) {
      return e.toString();
    } else {
      return "Unexpected error: $e";
    }
  }
}