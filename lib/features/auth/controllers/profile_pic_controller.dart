import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/core/services/session_manager.dart';
class ProfileController extends GetxController {
  final isLoading = false.obs;
  final selectedGender = ''.obs;
  final selectedImage = Rx<File?>(null);
  final dobController = TextEditingController();
  final Dio dio = Dio();
  // :jigsaw: Pick gender from dropdown or selection
  void selectGender(String gender) {
    selectedGender.value = gender;
  }
  // :date: Pick Date of Birth
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
  // :frame_with_picture: Pick Profile Image
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
 
 
  // :small_blue_diamond: Update Date of Birth
  Future<void> updateDateOfBirth() async {
    if (dobController.text.isEmpty) {
      Get.snackbar("Error", "Please select a date of birth");
      return;
    }
    try {
      isLoading.value = true;
      final token = SessionController().user?.token;
      final response = await dio.put(
        ApiEndpoints.updateProfile,
        data: {"dateOfBirth": dobController.text},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      Get.snackbar("Success", "Date of birth updated successfully");
      print(":white_tick: Date updated: ${response.data}");
    } catch (e) {
      Get.snackbar("Error", "Failed to update date: $e");
      print(":x: Update date failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
 
  // :small_blue_diamond: Update Profile Picture
  Future<void> updateAvatar() async {
    if (selectedImage.value == null) {
      Get.snackbar("Error", "Please select an image first");
      return;
    }
    try {
      isLoading.value = true;
      final token = SessionController().user?.token;
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
      Get.toNamed(Routes.genderview);
      print(":white_tick: Avatar updated: ${response.data}");
    } catch (e) {
      Get.snackbar("Error", "Failed to update avatar: $e");
      print(":x: Update avatar failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}