// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:whisp/config/routes/app_pages.dart';
// // import 'package:whisp/features/auth/services/profile_services.dart';

// // class ProfileController extends GetxController {
// //   final Rx<File?> selectedImage = Rx<File?>(null);
// //   final RxString gender = "male".obs;
// //   final RxString dob = "2000-01-01".obs;
// //   final RxString country = "USA".obs;

// //   final ProfileService _service = ProfileService();

// //   Future<void> pickImage() async {
// //     final picker = ImagePicker();
// //     final picked = await picker.pickImage(source: ImageSource.gallery);
// //     if (picked != null) {
// //       selectedImage.value = File(picked.path);
// //     }
// //   }

// //   Future<void> updateProfile() async {
// //     try {
// //       Get.dialog(
// //         const Center(child: CircularProgressIndicator()),
// //         barrierDismissible: false,
// //       );

// //       final result = await _service.updateProfile(
// //         avatar: selectedImage.value,
// //         gender: gender.value,
// //         dateOfBirth: dob.value,
// //         country: country.value,
// //       );

// //       Get.back(); // close loader
// //       Get.snackbar("Success", "Profile updated successfully!");
// //       print("✅ Response: $result");
// //       Get.toNamed(Routes.genderview);
// //     } catch (e) {
// //       Get.back();
// //       Get.snackbar("Error", e.toString());
// //     }
// //   }
// // }

// import 'dart:io';

// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:whisp/features/auth/services/profile_services.dart';

// class ProfileController extends GetxController {
//   final ProfileService _service = ProfileService();

//   final Rx<File?> selectedImage = Rx<File?>(null);
//   final RxString gender = ''.obs;
//   final RxString dateOfBirth = ''.obs;
//   final RxString country = ''.obs;
//   final isLoading = false.obs;

//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       selectedImage.value = File(picked.path);
//     }
//   }

//   Future<void> updateProfile() async {
//     if (isLoading.value) return;

//     try {
//       isLoading.value = true;
//       final response = await _service.updateProfile(
//         avatar: selectedImage.value,
//         gender: gender.value,
//         dateOfBirth: dateOfBirth.value,
//         country: country.value,
//       );

//       print("✅ Profile update response: $response");
//       Get.snackbar("Success", "Profile updated successfully!");
//     } catch (e) {
//       print("❌ Update failed: $e");
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:whisp/config/constants/shared_preferences/shared_preferences_constants.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/utils/manager/shared_preferences/shared_preferences_manager.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final selectedGender = ''.obs;
  final selectedImage = Rx<File?>(null);
  final dobController = TextEditingController();

  final manager = SharedPreferencesManager.instance;
  final constants = SharedPreferencesConstants.instance;

  final Dio dio = Dio();

  // 🧩 Pick gender from dropdown or selection
  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  // 📅 Pick Date of Birth
  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (pickedDate != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  // 🖼 Pick Profile Image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    } else {
      Get.snackbar('No Image Selected', 'Please select a profile image.');
    }
  }

  // 🔹 Update Gender
  Future<void> updateGender() async {
    if (selectedGender.value.isEmpty) {
      Get.snackbar("Error", "Please select a gender");
      return;
    }

    try {
      isLoading.value = true;

      final token = await manager.getString(key: constants.userTokenConstant);

      final response = await dio.put(
        ApiEndpoints.updateProfile,
        data: {"gender": selectedGender.value},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      Get.snackbar("Success", "Gender updated successfully");
      print("✅ Gender updated: ${response.data}");
    } catch (e) {
      Get.snackbar("Error", "Failed to update gender: $e");
      print("❌ Update gender failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Update Date of Birth
  Future<void> updateDateOfBirth() async {
    if (dobController.text.isEmpty) {
      Get.snackbar("Error", "Please select a date of birth");
      return;
    }

    try {
      isLoading.value = true;

      final token = await manager.getString(key: constants.userTokenConstant);

      final response = await dio.put(
        ApiEndpoints.updateProfile,
        data: {"dateOfBirth": dobController.text},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      Get.snackbar("Success", "Date of birth updated successfully");
      print("✅ Date updated: ${response.data}");
    } catch (e) {
      Get.snackbar("Error", "Failed to update date: $e");
      print("❌ Update date failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Update Profile Picture
  Future<void> updateAvatar() async {
    if (selectedImage.value == null) {
      Get.snackbar("Error", "Please select an image first");
      return;
    }

    try {
      isLoading.value = true;

      final token = await manager.getString(key: constants.userTokenConstant);

      final formData = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(selectedImage.value!.path),
      });

      final response = await dio.put(
        ApiEndpoints.updateProfile,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      Get.snackbar("Success", "Profile picture updated successfully");
      print("✅ Avatar updated: ${response.data}");
    } catch (e) {
      Get.snackbar("Error", "Failed to update avatar: $e");
      print("❌ Update avatar failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
