import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whisp/features/auth/models/user_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
class AuthRepository {
  final ApiClient _apiClient = Get.isRegistered<ApiClient>() ? Get.find<ApiClient>() : Get.put(ApiClient());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<dynamic> login(String email, String password,String type) async {
    return await _apiClient.post(ApiEndpoints.login, {
      "email": email,
      "password": password,
      "type":type
    });
  }
  // Future<dynamic> signup({
  //   required String name,
  //   required String email,
  //   required String password,
    
  // }) async {
  //   return await _apiClient.post(ApiEndpoints.signUp, {
  //     "fullName": name,
  //     "email": email,
  //     "password": password,
       
  //   });
  // }
  Future<dynamic> forgotPassword(String email) async {
    return await _apiClient.post(ApiEndpoints.forgotPassword, {"email": email});
  }
  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {"success": false, "message": "Sign-in cancelled"};
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
        return {"success": false, "message": "Failed to get user data"};
      }
      final userData = UserModel(
        name: user.displayName ?? "",
        email: user.email ?? "",
        profilePic: user.photoURL,
        dob: "",
      );
      // temporarily skipping signup API call
      //final signupResponse =  await _apiClient.post(ApiEndpoints.signUp, userData.toJson());
      return {"success": true, "user": userData};
    } catch (e, stackTrace) {
      // :fire: Print the exact error in console
      print(":x: Google Sign-In Error: $e");
      print(":page_facing_up: StackTrace:\n$stackTrace");
      return {"success": false, "message": e.toString()};
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

      return response;
    } catch (e) {
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