import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:whisp/config/constants/shared_preferences/shared_preferences_constants.dart';
import 'package:whisp/features/auth/models/auth_response_model.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';
import 'package:whisp/features/auth/view/profile_screen.dart';
import 'package:whisp/utils/manager/shared_preferences/shared_preferences_manager.dart';
import 'package:whisp/utils/manager/user_prefs.dart';
import 'package:whisp/services/socket_service.dart';
class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();
  final manager = SharedPreferencesManager.instance;
  final constants = SharedPreferencesConstants.instance;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final acceptTerms = false.obs;
  final isLoading = false.obs;
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  void toggleTerms(bool? value) => acceptTerms.value = value ?? false;
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
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
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (pickedDate != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }
  Future<void> createAccount() async {
    if (!acceptTerms.value) {
      Get.snackbar('Terms Required', 'Please accept terms and conditions.');
      return;
    }
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty 
         ) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    try {
      isLoading.value = true;
      /// :small_blue_diamond: Call signup API
      final apiResponse = await _authRepo.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        
      );
      /// :small_blue_diamond: Handle Dio Response type (in case your repo returns Response)
      final data = apiResponse is Map ? apiResponse : apiResponse.data;
      final signupResponse = AuthResponseModel.fromJson(data);
      /// :small_blue_diamond: Save user data
      await manager.setString(
        key: constants.userIdConstant,
        value: signupResponse.user.id.toString(),
      );
      final token = signupResponse.token ?? "";
      await manager.setString(
        key: constants.userTokenConstant,
        value: token,
      );
      /// Optional: Save the full user model for later use
      await manager.saveUser(signupResponse.user);

      // Reconnect socket with new token
      if (token.isNotEmpty) {
        try {
          if (Get.isRegistered<SocketService>()) {
            final socketService = SocketService.to;
            await socketService.reconnectWithToken(token);
          }
        } catch (e) {
          print('[socket] Error reconnecting after signup: $e');
        }
      }

      /// :white_tick: Success
      Get.snackbar("Success", "Account created successfully");
      Get.offAll(() => ProfileView());
    } catch (e) {
      Get.snackbar("Signup Failed", e.toString());
      debugPrint(":x: Signup Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}