import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/routes/app_pages.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();

  void sendResetLink() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }
     
    Get.toNamed(Routes.enterOtp);
    // Simulate sending email
    Get.snackbar("Success", "Password reset link sent to $email");
  }
}
