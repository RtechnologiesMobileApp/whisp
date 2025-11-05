import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/features/auth/controllers/forgot_password_controller.dart';
import 'package:whisp/core/widgets/custom_text_field.dart';
import 'package:whisp/core/widgets/custom_button.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section (moved below AppBar)
            const Text(
              "Forget Password",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your registered email to receive an OTP.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),

            // Email TextField with rounded corners
            CustomTextField(
              controller: controller.emailController,
              hint: "Enter email",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),

            // Continue button
            Obx(() => CustomButton(
                  text: "Continue",
                  onPressed: controller.sendResetOtp,
                  isLoading: controller.isLoading.value,
                )),
          ],
        ),
      ),
    );
  }
}

 