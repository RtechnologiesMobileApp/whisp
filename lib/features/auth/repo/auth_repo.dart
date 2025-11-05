import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whisp/features/auth/models/user_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class AuthRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserModel> login(String email, String password) async {
    return await _apiClient.post(ApiEndpoints.login, {
      "email": email,
      "password": password,
    });
  }

  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
    required String dob,
  }) async {
    return await _apiClient.post(ApiEndpoints.signUp, {
      "name": name,
      "email": email,
      "password": password,
      "dob": dob,
    });
  }

  Future<dynamic> forgotPassword(String email) async {
    return await _apiClient.post(ApiEndpoints.forgotPassword, {
      "email": email,
    });
  }
  Future<UserModel> updateProfilePicture({
  required String userId,
  required File imageFile,
}) async {
  try {
    final response = await _apiClient.postMultipart(
      ApiEndpoints.updateProfile,  
      data: {"userId": userId},
      file: imageFile,
      fileField: "profilePic",  
    );

    return UserModel.fromJson(response);
  } catch (e) {
    rethrow;
  }
}


Future<UserModel?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // user cancelled sign-in

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;
    if (user == null) return null;

    // create user model
    final userData = UserModel(
      name: user.displayName ?? "",
      email: user.email ?? "",
      profilePic: user.photoURL,
      dob: "",
      gender: null,
    );

    // 🔥 Call backend signup/login endpoint
    // backend should decide automatically:
    //  - if user exists => login
    //  - else => signup new user
    final response = await _apiClient.post(ApiEndpoints.signUp, userData.toJson());

    // assuming backend returns the same user JSON
    return UserModel.fromJson(response);

  } catch (e, stackTrace) {
    print("❌ Google Sign-In Error: $e");
    print("📄 StackTrace:\n$stackTrace");
    rethrow; // Let controller handle error
  }
}

// Future<dynamic> signInWithGoogle() async {
//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) {
//       return {"success": false, "message": "Sign-in cancelled"};
//     }

//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     final UserCredential userCredential =
//         await _auth.signInWithCredential(credential);
//     final User? user = userCredential.user;

//     if (user == null) {
//       return {"success": false, "message": "Failed to get user data"};
//     }

//     final userData = UserModel(
//       name: user.displayName ?? "",
//       email: user.email ?? "",
//       profilePic: user.photoURL,
//       dob: "",
//     );
//          // temporarily skipping signup API call
//     //final signupResponse =  await _apiClient.post(ApiEndpoints.signUp, userData.toJson());

//    return {"success": true, "user": userData};
//   } catch (e, stackTrace) {
//     // 🔥 Print the exact error in console
//     print("❌ Google Sign-In Error: $e");
//     print("📄 StackTrace:\n$stackTrace");

//     return {"success": false, "message": e.toString()};
//   }
// }

  

}
