import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      final response = await _apiClient.post(ApiEndpoints.login, {
        "email": email,
        if (password != null) "password": password,
        "type": type,
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
          throw ApiException("User not found");
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
      final res = await _apiClient.post(ApiEndpoints.checkEmailExists, {"email": email});
      return res['exists'] ?? false; // backend should return { exists: true/false }
    } catch (e) {
      rethrow;
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
      final data = {
        "fullName": name,
        "email": email,
        "password": password,
        "gender": gender,
        "dateOfBirth": dob,
        "country": country,
        "type": type,
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
    if (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      if (msg.toString().contains("email")) return "Email already exists.";
      return msg ?? "Something went wrong, please try again.";
    } else {
      return "Unexpected error: $e";
    }
  }
}