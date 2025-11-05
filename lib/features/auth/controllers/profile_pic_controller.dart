 
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
 
      final updatedUser = await _authRepo.updateProfilePicture(
        userId: userId,
        imageFile: selectedImage.value!,
      );

      Get.snackbar("Success", "Profile updated successfully!");
      print("Updated User: ${updatedUser.toJson()}");
    } catch (e) {
 

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
