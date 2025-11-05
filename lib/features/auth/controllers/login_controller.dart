import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/features/auth/models/user_model.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
    final AuthRepository _authRepository = Get.find<AuthRepository>();
   var isLoading = false.obs;
  UserModel? currentUser;

  void login() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    // API call will go here later
    Get.snackbar("Success", "Logged in successfully");
  }

  void forgotPassword() {
    Get.toNamed(Routes.forgetPassword);
 
  }

Future<void> googleSignIn() async {
  try {
    isLoading.value = true;

    final user = await _authRepository.signInWithGoogle();
    isLoading.value = false;

    if (user != null) {
      currentUser = user;

      // 🔥 check if gender already exists → means returning user
      if (user.gender != null && user.gender!.isNotEmpty) {
        Get.snackbar("Welcome Back", "Hello ${user.name}");
        // navigate to home/dashboard
        Get.offAllNamed(Routes.genderview); // change route later
      } else {
        Get.snackbar("Welcome", "Please complete your profile");
        // navigate to gender selection screen
        Get.offAllNamed(Routes.genderview);
      }
    } else {
      Get.snackbar("Cancelled", "Google Sign-in was cancelled");
    }
  } catch (e) {
    isLoading.value = false;
    Get.snackbar("Error", e.toString());
  }
}

  // Future<void> googleSignIn() async {
  //   try {
  //     isLoading.value = true;

  //     final result = await _authRepository.signInWithGoogle();
  //     isLoading.value = false;

  //     if (result["success"]) {
  //       currentUser = result["user"];
  //       Get.snackbar("Success", "Welcome ${currentUser?.name ?? ''}!");

       
  //       Get.offAllNamed(Routes.genderview);  
  //     } else {
  //       Get.snackbar("Error", result["message"] ?? "Something went wrong");
  //     }
  //   } catch (e) {
  //     isLoading.value = false;
  //     Get.snackbar("Error", e.toString());
  //   }
  // }

  void goToSignup() {
    Get.toNamed(Routes.signup);
  }
}
