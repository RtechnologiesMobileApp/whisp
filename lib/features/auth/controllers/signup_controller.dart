import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/features/auth/models/user_model.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';
import 'package:whisp/features/auth/view/profile_screen.dart';
import 'package:whisp/core/services/socket_service.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();
  final Rx<File?> avatarFile = Rx<File?>(null);
  final RxString gender = "".obs;
  final RxString dob = "".obs;

  var selectedCountry = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final acceptTerms = false.obs;
  final isLoading = false.obs;
  var selectedGender = (-1).obs;
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  var selectedDate = DateTime(2000, 1, 1).obs;

  void toggleTerms(bool? value) => acceptTerms.value = value ?? false;

  // Step 1: Check email existence
  Future<void> checkEmailAndProceed() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar("Missing Email", "Please enter an email.");
      return;
    }

    isLoading.value = true;
    try {
      if (!acceptTerms.value) {
        Get.snackbar('Terms Required', 'Please accept terms and conditions.');
        return;
      }
      final exists = await _authRepo.checkEmailExists(email);
      if (exists) {
        Get.snackbar(
          "Email Exists",
          "An account with this email already exists.",
        );
      } else {
        Get.to(ProfileView());
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

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

  Future<void> googleSignIn() async {
    try {
      isLoading.value = true;
      final user = await _authRepo.signInWithGoogle();

      nameController.text = user.name;
      emailController.text = user.email;

      Get.toNamed(Routes.genderview);

    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAccount() async {
    // if (!acceptTerms.value) {
    //   Get.snackbar('Terms Required', 'Please accept terms and conditions.');
    //   return;
    // }
    // if (nameController.text.isEmpty ||
    //     emailController.text.isEmpty ||
    //     passwordController.text.isEmpty) {
    //   Get.snackbar('Error', 'Please fill all fields');
    //   return;
    // }
    try {
      isLoading.value = true;

      /// :small_blue_diamond: Call signup API
      final apiResponse = await _authRepo.registerUser(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        gender: gender.value,
        dob: dob.value,
        country: selectedCountry.value,
        avatar: selectedImage.value,
      );

      /// :small_blue_diamond: Handle Dio Response type (in case your repo returns Response)
      final data = apiResponse is Map ? apiResponse : apiResponse.data;

      final user = UserModel.fromJson(data['user']);
      final token = data['token'];

      final updatedUser = user.copyWith(token: token);
      await SessionController().saveUserSession(updatedUser);
      await SessionController().loadSession();
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
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectGender(int index) {
    selectedGender.value = index;
  }

  Future<void> genderContinue() async {
    if (selectedGender.value == -1) {
      Get.snackbar("Select Gender", "Please select your gender to continue");
      return;
    }

    // 👇 Convert index to string value based on your backend

    switch (selectedGender.value) {
      case 0:
        gender.value = "female";
        break;
      case 1:
        gender.value = "male";
        break;
      default:
        gender.value = "not_specified";
    }

    try {
      isLoading.value = true;

      Get.snackbar("Success", "Gender updated successfully");

      // 👇 navigate to DOB screen next
      Get.toNamed(Routes.dob);
    } catch (e) {
      print(":x: Gender update failed: $e");
      Get.snackbar("Error", "Failed to update gender: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveDateOfBirth() async {
    try {
      isLoading.value = true;

      // Check if user is at least 13 years old
      final now = DateTime.now();
      final age = now.year - selectedDate.value.year;
      final monthDifference = now.month - selectedDate.value.month;
      final dayDifference = now.day - selectedDate.value.day;

      final actualAge =
          (monthDifference < 0 || (monthDifference == 0 && dayDifference < 0))
          ? age - 1
          : age;

      if (actualAge < 13) {
        isLoading.value = false;
        Get.snackbar(
          "Age Requirement",
          "You must be at least 13 years old to continue. Please select a different date.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      dob.value = DateFormat('yyyy-MM-dd').format(selectedDate.value);

      Get.snackbar("Success", "Date of Birth updated successfully");

      print('Navigating to: ${Routes.country}');

      Get.toNamed(Routes.country);
    } catch (e) {
      print("❌ Unexpected error: $e");
      Get.snackbar("Error", "Failed to update Date of Birth");
    } finally {
      isLoading.value = false;
    }
  }

  /// Method to set selected country
  void selectCountry(String countryName) {
    selectedCountry.value = countryName;
  }

  /// API call to update country
  Future<void> updateCountry() async {
    if (selectedCountry.value.isEmpty) {
      Get.snackbar("Select Country", "Please select your country to continue");
      return;
    }

    try {
      isLoading.value = true;
      await createAccount();

      // ✅ Navigate to Welcome screen
      Get.offAllNamed(Routes.welcomehome);
    } catch (e) {
      print("❌ Country update failed: $e");
      Get.snackbar("Error", "Failed to update country: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
