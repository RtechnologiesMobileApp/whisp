import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:whisp/config/routes/app_pages.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final acceptTerms = false.obs;

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
  void createAccount() {
    if (!acceptTerms.value) {
  
    Get.snackbar('Terms Required', 'Please accept terms and conditions.');
      return;
    }
    print("Navigating to gender screen...");
print(AppPages.routes.map((r) => r.name).toList());
   //   Get.offNamed(Routes.genderview);
   Get.toNamed(Routes.genderview);

  }
}
