import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final acceptTerms = false.obs;
  final isLoading = false.obs;
 final AuthRepository _authRepo = Get.find<AuthRepository>();
  void toggleTerms(bool? value) {
    acceptTerms.value = value ?? false;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    } else {
      Get.snackbar('No image selected', 'Please choose an avatar image.');
    }
  }

 Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18), // default 18 years old
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (pickedDate != null) {
      dobController.text = DateFormat('dd MMM yyyy').format(pickedDate);
    }
  }
  Future<void> createAccount() async {
    if (!acceptTerms.value) {
      Get.snackbar('Terms Required', 'Please accept terms and conditions.');
      return;
    }

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        dobController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;
      final response = await _authRepo.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        dob: dobController.text.trim(),
      );

      Get.snackbar("Success", "Account created successfully");
      print("Signup Response: $response");

      Get.toNamed(Routes.login);
    } catch (e) {
      Get.snackbar("Signup Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
    


}
