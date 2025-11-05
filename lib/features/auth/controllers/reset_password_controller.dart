import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/features/auth/view/password_changed_success_view.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController reEnterPasswordController =
      TextEditingController();

  final RxBool isLoading = false.obs;
  final Dio _dio = Dio();
  late final String resetToken;

  @override
  void onInit() {
    super.onInit();
    resetToken = (Get.arguments ?? const {})['resetToken'] ?? '';
  }

  Future<void> resetPassword() async {
    // ✅ UI-only for now
    // later you'll add API logic here
    final newPass = newPasswordController.text.trim();
    final rePass = reEnterPasswordController.text.trim();

    if (newPass.isEmpty || rePass.isEmpty) {
      Get.snackbar('Error', 'Please fill both fields');
      return;
    }

    if (newPass != rePass) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    if (resetToken.isEmpty) {
      Get.snackbar('Error', 'Reset token missing. Please request OTP again.');
      return;
    }

    try {
      isLoading.value = true;
      await _dio.post(
        ApiEndpoints.resetPassword,
        data: {
          "resetToken": resetToken,
          "newPassword": newPass,
        },
      );
      Get.snackbar('Success', 'Password reset successfully');
      Get.to(() => const PasswordChangedSuccessView());
     // Get.offAllNamed(Routes.login);
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message;
      Get.snackbar('Error', msg ?? 'Failed to reset password');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    reEnterPasswordController.dispose();
    super.onClose();
  }
}
