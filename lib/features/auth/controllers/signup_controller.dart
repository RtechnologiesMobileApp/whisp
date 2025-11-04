import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();

  final acceptTerms = false.obs;

  void toggleTerms(bool? value) {
    acceptTerms.value = value ?? false;
  }

  void createAccount() {
    if (!acceptTerms.value) {
      Get.snackbar('Terms Required', 'Please accept terms and conditions.');
      return;
    }
    // TODO: Add signup logic (API call or Firebase)
    Get.snackbar('Success', 'Account Created!');
  }
}
