import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/core/widgets/custom_button.dart';
import 'package:whisp/core/widgets/custom_text_field.dart';
import 'package:whisp/features/auth/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // App Title
              Column(
                children: [
                  const Text(
                    "Welcome To",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Transform.translate(
                    offset: const Offset(
                      0,
                      -10,
                    ), // 👈 slightly moves logo upward
                    child: Image.asset(AppImages.logo, height: 115),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Email
              CustomTextField(
                controller: controller.emailController,
                hint: "Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password
              CustomTextField(
                controller: controller.passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 12),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: controller.forgotPassword,
                  child: const Text(
                    "Forget Password?",
                    style: TextStyle(color: AppColors.pinkColor, fontSize: 13),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Sign in button
              Obx(()=>
                CustomButton(
                  isLoading: controller.isLoading.value,
                  text: "Sign in",
                  onPressed: controller.login,
                  borderRadius: 24,
                ),
              ),

              const SizedBox(height: 20),

              // Google sign in button
              CustomButton(
                text: "Continue with Google",
                color: Colors.grey[200]!,
                textColor: Colors.black,
                iconPath: AppImages.googleLogo,
                onPressed: controller.googleSignIn,
                borderRadius: 24,
              ),

              const SizedBox(height: 30),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account? "),
                  GestureDetector(
                    onTap: controller.goToSignup,
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: AppColors.pinkColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.pinkColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
