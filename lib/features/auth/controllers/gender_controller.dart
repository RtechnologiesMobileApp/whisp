import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class GenderController extends GetxController {
  var selectedGender = (-1).obs;

  void selectGender(int index) {
    selectedGender.value = index;
  }


  void continueNext() {
    if (selectedGender.value == -1) {
      Get.snackbar("Select Gender", "Please select your gender to continue");
      return;
    }
    // Navigate to next screen
    Get.toNamed('/nextStep'); // Replace with your next route
  }
}
