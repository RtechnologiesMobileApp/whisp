import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/core/widgets/custom_button.dart';
import 'package:whisp/core/widgets/custom_text_field.dart';
import 'package:whisp/features/auth/controllers/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section (below AppBar)
            const Text(
              "Reset Password",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your new password below to reset your account.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),

            // New Password Field
            CustomTextField(
              controller: controller.newPasswordController,
              hint: 'Enter new password',
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 20),

            // Re-enter Password Field
            CustomTextField(
              controller: controller.reEnterPasswordController,
              hint: 'Re-enter new password',
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 36),

            // Continue Button
            Obx(
              () => CustomButton(
                text: 'Continue',
                onPressed: controller.resetPassword,
                color: AppColors.primary,
                isLoading: controller.isLoading.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
