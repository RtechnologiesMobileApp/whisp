import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/network/api_endpoints.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final Dio _dio = Dio();

  Future<void> sendResetOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }

    try {
      isLoading.value = true;
      await _dio.post(
        ApiEndpoints.forgotPassword,
        data: {"email": email},
      );

      Get.snackbar("Success", "OTP sent to $email");
      Get.toNamed(Routes.enterOtp, arguments: {"email": email});
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message;
      Get.snackbar("Error", msg ?? "Failed to send OTP");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
