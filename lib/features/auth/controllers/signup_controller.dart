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
  final RxBool isGoogle = false.obs;
  var selectedCountry = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final acceptTerms = false.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  var selectedGender = (-1).obs;
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  var selectedDate = DateTime(2000, 1, 1).obs;
  final formKey = GlobalKey<FormState>();


  void toggleTerms(bool? value) => acceptTerms.value = value ?? false;

  // Step 1: Check email existence
  Future<void> checkEmailAndProceed({bool showPrimaryLoader = true}) async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
     
      return;
    }

    if (showPrimaryLoader) {
      isLoading.value = true;
    }
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
      if (showPrimaryLoader) {
        isLoading.value = false;
      }
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
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate.value,
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );

  if (picked != null && picked != selectedDate.value) {
    selectedDate.value = picked; // 🔥 THIS is the key line
    print("✅ New DOB selected: $picked");
  }
}


  Future<void> googleSignIn() async {
    if (!acceptTerms.value) {
      Get.snackbar(
        'Terms Required',
        'Please accept terms and conditions before continuing.',
      );
      return;
    }
    try {
      isGoogleLoading.value = true;
      isGoogle.value = true;
      final user = await _authRepo.signInWithGoogle();

      nameController.text = user.name;
      emailController.text = user.email;
      await checkEmailAndProceed(showPrimaryLoader: false);
      // Get.toNamed(Routes.genderview);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isGoogleLoading.value = false;
    }
  }

  Future<void> createAccount() async {
   
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
        type: isGoogle.value ? "google" : "email",
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
          debugPrint('[socket] Error reconnecting after signup: $e');
        }
      }
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
      // Get.snackbar("Select Gender", "Please select your gender to continue");
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

      // Get.snackbar("Success", "Gender updated successfully");

      // 👇 navigate to DOB screen next
      Get.toNamed(Routes.dob);
    } catch (e) {
      debugPrint(":x: Gender update failed: $e");
      // Get.snackbar("Error", "Failed to update gender: $e");
    } finally {
      isLoading.value = false;
    }
  }

Future<void> saveDateOfBirth() async {
  try {
    isLoading.value = true;

    final now = DateTime.now();
    final birth = selectedDate.value;

    // 🔥 Calculate exact age difference
    int age = now.year - birth.year;

    // Agar birth month/day abhi aane wale hain to ek saal kam kar do
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }

    debugPrint("🎂 User age: $age years");

    // 🚫 Check if user is under 13
    if (age < 13) {
      isLoading.value = false;
      Get.snackbar(
        "Age Requirement",
        "You must be at least 13 years old to continue.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ Save date if valid
    dob.value = DateFormat('yyyy-MM-dd').format(birth);
    debugPrint('Navigating to: ${Routes.country}');
    Get.toNamed(Routes.country);

  } catch (e) {
    debugPrint("❌ Unexpected error: $e");
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
      // Get.snackbar("Select Country", "Please select your country to continue");
      return;
    }

    try {
      isLoading.value = true;
      await createAccount();

      // ✅ Navigate to Welcome screen
      Get.offAllNamed(Routes.welcomehome);
    } catch (e) {
      debugPrint("❌ Country update failed: $e");
      Get.snackbar("Error", "Failed to update country: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
