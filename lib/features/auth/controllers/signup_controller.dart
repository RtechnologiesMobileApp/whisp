// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:whisp/config/constants/shared_preferences/shared_preferences_constants.dart';
// import 'package:whisp/features/auth/models/auth_response_model.dart';
// import 'package:whisp/features/auth/repo/auth_repo.dart';
// import 'package:whisp/features/auth/view/profile_screen.dart';
// import 'package:whisp/utils/manager/shared_preferences/shared_preferences_manager.dart';

// class SignupController extends GetxController {
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final dobController = TextEditingController();

//   final manager = SharedPreferencesManager.instance;
//   final constants = SharedPreferencesConstants.instance;
//   final Rx<File?> selectedImage = Rx<File?>(null);
//   final acceptTerms = false.obs;
//   final isLoading = false.obs;

//   final AuthRepository _authRepo = Get.find<AuthRepository>();

//   void toggleTerms(bool? value) => acceptTerms.value = value ?? false;

//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final XFile? pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 70,
//     );

//     if (pickedFile != null) {
//       selectedImage.value = File(pickedFile.path);
//     } else {
//       Get.snackbar('No image selected', 'Please choose an avatar image.');
//     }
//   }

//   Future<void> pickDate(BuildContext context) async {
//     final now = DateTime.now();
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime(now.year - 18),
//       firstDate: DateTime(1900),
//       lastDate: now,
//     );

//     if (pickedDate != null) {
//       dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
//     }
//   }

//   Future<void> createAccount() async {
//     if (!acceptTerms.value) {
//       Get.snackbar('Terms Required', 'Please accept terms and conditions.');
//       return;
//     }

//     if (nameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         passwordController.text.isEmpty ||
//         dobController.text.isEmpty) {
//       Get.snackbar('Error', 'Please fill all fields');
//       return;
//     }

//     try {
//       isLoading.value = true;

//       // 🔹 Call signup API
//       final response = await _authRepo.signup(
//         name: nameController.text.trim(),
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//         dob: dobController.text.trim(),
//       );

//       // 🔹 Parse JSON into model
//       final signupResponse = AuthResponseModel.fromJson(response);

//       // 🔹 Save user data in SharedPreferences
//       await manager.setString(
//         key: constants.userIdConstant,
//         value: signupResponse.user!.id.toString(),
//       );

//       await manager.setString(
//         key: constants.userTokenConstant,
//         value: signupResponse.token,
//       );
//       userController.setUser(signupResponse.user!);
//       userId = await manager.getString(key: constants.userIdConstant);
//       Get.snackbar("Success", "Account created successfully");

//       // 🔹 Navigate to profile view
//       Get.to(() => ProfileView());
//     } catch (e) {
//       Get.snackbar("Signup Failed", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:whisp/config/constants/shared_preferences/shared_preferences_constants.dart';
import 'package:whisp/features/auth/models/auth_response_model.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';
import 'package:whisp/features/auth/view/gender_view.dart';
import 'package:whisp/utils/manager/shared_preferences/shared_preferences_manager.dart';
import 'package:whisp/utils/manager/user_prefs.dart';

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
        passwordController.text.isEmpty ||
        dobController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;

      /// 🔹 Call signup API
      final apiResponse = await _authRepo.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        dob: dobController.text.trim(),
      );

      /// 🔹 Handle Dio Response type (in case your repo returns Response)
      final data = apiResponse is Map ? apiResponse : apiResponse.data;

      final signupResponse = AuthResponseModel.fromJson(data);

      if (signupResponse.user == null) {
        throw Exception("Invalid response: user is null");
      }

      /// 🔹 Save user data
      await manager.setString(
        key: constants.userIdConstant,
        value: signupResponse.user!.id.toString(),
      );

      await manager.setString(
        key: constants.userTokenConstant,
        value: signupResponse.token ?? "",
      );

      /// Optional: Save the full user model for later use
      await manager.saveUser(signupResponse.user!);

      /// ✅ Success
      Get.snackbar("Success", "Account created successfully");
      Get.offAll(() => GenderView());
    } catch (e) {
      Get.snackbar("Signup Failed", e.toString());
      debugPrint("❌ Signup Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
