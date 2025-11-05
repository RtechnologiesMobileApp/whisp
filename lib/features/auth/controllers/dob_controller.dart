import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DobController extends GetxController {
  var selectedDate = DateTime(2000, 1, 1).obs;
  var isLoading = false.obs;

  Future<void> saveDateOfBirth() async {
    isLoading.value = true;

    // TODO: Integrate API call or Firebase update later
    await Future.delayed(const Duration(seconds: 1));

    // Example: Navigate to next screen
    Get.snackbar(
      'Success',
      'Date of Birth saved: ${selectedDate.value.toLocal().toString().split(' ')[0]}',
      backgroundColor: Colors.greenAccent,
      colorText: Colors.white,
    );

    // Navigate to next screen (replace with your route)
    // Get.to(() => const NextScreen());

    isLoading.value = false;
  }
}
