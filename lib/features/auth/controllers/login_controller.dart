import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/features/auth/models/user_model.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';
import 'package:whisp/services/socket_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  var isLoading = false.obs;
  UserModel? currentUser;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }
    try {
      isLoading.value = true;
      final res = await _authRepository.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      final data = res is Map ? res : res?.data;
      final user = UserModel.fromJson(data['user']);
      final token = data['token'];
      final updatedUser = user.copyWith(token: token);
      currentUser = updatedUser;

      await SessionController().saveUserSession(updatedUser);
      await SessionController().loadSession();

      // Reconnect socket with new token
      try {
        if (Get.isRegistered<SocketService>()) {
          final socketService = SocketService.to;
          await socketService.reconnectWithToken(token);
        }
      } catch (e) {
        print('[socket] Error reconnecting after login: $e');
      }

      Get.offAllNamed(Routes.welcomehome);
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() {
    Get.toNamed(Routes.forgetPassword);
 
  }

Future<void> googleSignIn() async {
  try {
    isLoading.value = true;

    final user = await _authRepository.signInWithGoogle();
    isLoading.value = false;

    if (user != null) {
      currentUser = user;

      // 🔥 check if gender already exists → means returning user
      if (user.gender != null && user.gender!.isNotEmpty) {
        Get.snackbar("Welcome Back", "Hello ${user.name}");
        // navigate to home/dashboard
        Get.offAllNamed(Routes.genderview); // change route later
      } else {
        Get.snackbar("Welcome", "Please complete your profile");
        // navigate to gender selection screen
        Get.offAllNamed(Routes.genderview);
      }
    } else {
      Get.snackbar("Cancelled", "Google Sign-in was cancelled");
    }
  } catch (e) {
    isLoading.value = false;
    Get.snackbar("Error", e.toString());
  }
}

  // Future<void> googleSignIn() async {
  //   try {
  //     isLoading.value = true;

  //     final result = await _authRepository.signInWithGoogle();
  //     isLoading.value = false;

  //     if (result["success"]) {
  //       currentUser = result["user"];
  //       Get.snackbar("Success", "Welcome ${currentUser?.name ?? ''}!");

       
  //       Get.offAllNamed(Routes.genderview);  
  //     } else {
  //       Get.snackbar("Error", result["message"] ?? "Something went wrong");
  //     }
  //   } catch (e) {
  //     isLoading.value = false;
  //     Get.snackbar("Error", e.toString());
  //   }
  // }

  void goToSignup() {
    Get.toNamed(Routes.signup);
  }
}
