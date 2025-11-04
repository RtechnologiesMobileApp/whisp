import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:whisp/config/routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    // API call will go here later
    Get.snackbar("Success", "Logged in successfully");
  }

  void forgotPassword() {
    Get.toNamed(Routes.forgetPassword);
 
  }

  void googleSignIn() {
    Get.snackbar("Google", "Google sign-in coming soon!");
  }

  void goToSignup() {
    Get.toNamed(Routes.signup);
  }
}
