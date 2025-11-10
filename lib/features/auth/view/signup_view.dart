import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/widgets/custom_button.dart';
import 'package:whisp/core/widgets/custom_text_field.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
  final controller = Get.put(SignupController());

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Welcome Text
              Column(
                children: [
                  const Text(
                    "Welcome To",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Transform.translate(
                    offset: const Offset(
                      0,
                      -20,
                    ), // 👈 slightly moves logo upward
                    child: Image.asset(AppImages.logo, height: 120),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Text Fields
             Form(
              key: controller.formKey,
               child: Column(
                children: [
                   // Text Fields
                CustomTextField(
                  controller: controller.nameController,
                  hint: 'Name',
                  icon: Icons.person_2_outlined,
                    validator: (value) {
          if (value == null || value.isEmpty) return "Name is required";
          return null;
        },
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: controller.emailController,
                  hint: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                       {return ("Email is required");};
                    if (!value.contains('@')) return "Enter a valid email";
                    return null;  
                  },
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: controller.passwordController,
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                    validator: (value) {
          if (value == null || value.isEmpty) return "Password is required";
          
          return null;
        },
                ),
               
                ],
               ),
             ),
               SizedBox(height: 14),

              const SizedBox(height: 12),

              // Terms Checkbox
              Obx(
                () => Row(
                  children: [
                    Checkbox(
                      value: controller.acceptTerms.value,
                      onChanged: controller.toggleTerms,
                      activeColor:
                          AppColors.primary, // ✅ check fill color when checked
                      checkColor:
                          Colors.white, // ✅ color of the checkmark inside
                      side: const BorderSide(
                        // ✅ border color when unchecked
                        color: AppColors.secondary,
                        width: 2,
                      ),
                      fillColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary; // when checked
                        }
                        return Colors.transparent; // when unchecked
                      }),
                    ),

                    const Text(
                      'Accept ',
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Terms and Conditions',
                        style: TextStyle(
                          color: AppColors.pinkColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.pinkColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(() {
                  return CustomButton(
                    text: controller.isLoading.value
                        ? 'Loading...'
                        : 'Create Account',
                    onPressed: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.checkEmailAndProceed();
                        return;
                      }
                      
                     
                    },
                    borderRadius: 24,
                    isLoading: controller
                        .isLoading
                        .value, // agar CustomButton loader support karta hai
                  );
                }),
              ),

              const SizedBox(height: 16),
              const Text('or Signup with'),

              const SizedBox(height: 12),
              Obx(() {
                return InkWell(
                  onTap: controller.isGoogleLoading.value
                      ? null // disable while loading
                      : controller.googleSignIn,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: controller.isGoogleLoading.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.black,
                              ),
                            )
                          : Image.asset(AppImages.googleLogo, height: 24),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Sign up link
              // Sign up text link section
              GestureDetector(
                onTap: () =>
                    Get.toNamed(Routes.login), // ✅ navigate to login route
                child: RichText(
                  text: const TextSpan(
                    text: "Already have an account?",
                    style: TextStyle(
                      color: Colors.black, // whole text in #D90166
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign in",
                        style: TextStyle(
                          color: Color(0xFFD90166),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration
                              .underline, // underline only for “Sign up”
                          decorationColor: Color(0xFFD90166),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
