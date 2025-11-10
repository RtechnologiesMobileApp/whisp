import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/features/auth/models/user_model.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';
import 'package:whisp/core/services/socket_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  var isLoading = false.obs;
  final isGoogleLoading = false.obs;

  UserModel? currentUser;

  Future<void> login({
    String type = "email",
    String? email,
    String? password,
    bool showLoadingIndicator = true,
  }) async {
    email = email ?? emailController.text.trim();
    password = password ?? passwordController.text.trim();
   if (type == "email") {
  if (email.isEmpty && password.isEmpty) {
    Get.snackbar("Error", "Please fill all fields");
    return;
  } else if (email.isEmpty) {
    Get.snackbar("Error", "Email is required");
    return;
  } else if (password.isEmpty) {
    Get.snackbar("Error", "Password is required");
    return;
  }
}

    debugPrint("[login api] email: $email, password: $password, type: $type");
    try {
      if (showLoadingIndicator) {
        isLoading.value = true;
      }
      final res = await _authRepository.login(
        email: email,
        password: password,
        type: type,
      );
      debugPrint("[login api] res: $res");
      final data = res is Map ? res : res?.data;

        // 🛑 Handle API error before parsing user
  if (data == null) {
    throw Exception("No response from server");
  }
  if (data.containsKey('error')) {
    final error = data['error'];
    if (error == 'INCORRECT_PASSWORD') {
      throw Exception("Incorrect password");
    } else if (error == 'USER_NOT_FOUND') {
      throw Exception("Email Does not exist");
    } else {
      throw Exception(error.toString());
    }
  }

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
        debugPrint('[socket] Error reconnecting after login: $e');
      }

      Get.offAllNamed(Routes.welcomehome);
    } catch (e) {
      debugPrint("[login api] error: $e");
      Get.snackbar("Login Failed", e.toString());
    } finally {
      if (showLoadingIndicator) {
        isLoading.value = false;
      }
    }
  }

  void forgotPassword() {
    Get.toNamed(Routes.forgetPassword);
  }

  Future<void> googleSignIn() async {
    try {
      isGoogleLoading.value = true;
      final user = await _authRepository.signInWithGoogle();

      currentUser = user;

      await login(
        email: user.email,
        type: "google",
        showLoadingIndicator: false,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isGoogleLoading.value = false;
    }
  }

  void goToSignup() {
    Get.toNamed(Routes.signup);
  }
}
