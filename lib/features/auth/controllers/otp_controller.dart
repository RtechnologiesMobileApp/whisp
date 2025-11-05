import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/features/auth/view/reset_password_screen.dart';
import 'package:flutter/material.dart';


class EnterOtpController extends GetxController {
  final Dio _dio = Dio();
  final RxBool isLoading = false.obs;
  late final String email;

  // For 5 OTP boxes
  final otpControllers = List.generate(5, (_) => TextEditingController());

  @override
  void onInit() {
    super.onInit();
    email = (Get.arguments ?? const {})['email'] ?? '';
  }

  /// Called when user taps Continue
  void onContinue() {
    final otp = otpControllers.map((e) => e.text.trim()).join();

    if (otp.isEmpty) {
      Get.snackbar('Invalid OTP', 'Please enter the OTP.');
      return;
    }

    verifyOtp(otp);
  }

  /// Verifies the OTP with backend
  Future<void> verifyOtp(String otp) async {
    try {
      isLoading.value = true;
      print('🔹 Sending OTP verification request...');
      print('📧 Email: $email');
      print('🔢 OTP: $otp');

      final response = await _dio.post(
        ApiEndpoints.verifyOtp,
        data: {
          "email": email,
          "otp": otp,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }),
      );

      print('✅ Server response: ${response.data}');
      final data = response.data is Map ? response.data as Map : <String, dynamic>{};
      final resetToken = data['resetToken'] ??
          (data['data'] is Map ? (data['data']['resetToken'] ?? '') : '') ??
          '';

      if (resetToken.isEmpty) {
        final msg = data['message']?.toString();
        print('⚠️ Missing resetToken: $data');
        Get.snackbar('Error', msg ?? 'Invalid response from server');
        return;
      }

      print('✅ OTP Verified! Token: $resetToken');
      Get.to(() => const ResetPasswordScreen(), arguments: {"resetToken": resetToken});
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.response?.data}');
      final res = e.response?.data;
      String msg;
      if (res is Map) {
        msg = res['message']?.toString() ?? res.toString();
      } else if (res is String) {
        msg = res.startsWith('<!DOCTYPE') ? 'Server error' : res;
      } else {
        msg = e.message ?? 'Failed to verify OTP';
      }
      Get.snackbar('Error', msg);
    } catch (e, st) {
      print('❌ Unknown Error: $e');
      print('🔸 Stacktrace: $st');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() {
    Get.snackbar("OTP Sent", "A new OTP has been sent!");
  }
}
