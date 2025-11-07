import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/widgets/custom_button.dart';
import 'package:whisp/core/widgets/custom_text_field.dart';
import 'package:whisp/features/auth/controllers/login_controller.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  SignupView({super.key});
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
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

              //             // Avatar Section
              //             GestureDetector(
              //   onTap: controller.pickImage,
              //   child: Obx(() {
              //     return Stack(
              //       clipBehavior: Clip.none,
              //       alignment: Alignment.topRight, // 👈 edit icon now top-right
              //       children: [
              //         CircleAvatar(
              //           radius: 55, // 👈 slightly larger avatar
              //           backgroundImage: controller.selectedImage.value != null
              //               ? FileImage(controller.selectedImage.value!)
              //               : const AssetImage(AppImages.placeholderpic) as ImageProvider,
              //           backgroundColor: Colors.grey[200],
              //         ),
              //         Positioned(
              //           top: -3, // slight adjustment to sit nicely
              //           right: -3,
              //           child: Container(
              //             padding: const EdgeInsets.all(6),
              //             decoration: const BoxDecoration(
              //               color: AppColors.primary,
              //               shape: BoxShape.circle,
              //             ),
              //             child: const Icon(
              //               Icons.edit,
              //               size: 20,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ),
              //       ],
              //     );
              //   }),
              // ),

              //             const SizedBox(height: 6),
              //             const Text('Select Avatar', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              // Text Fields
              CustomTextField(
                controller: controller.nameController,
                hint: 'Name',
                icon: Icons.person_2_outlined,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: controller.emailController,
                hint: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: controller.passwordController,
                hint: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 14),

              // GestureDetector(
              //   onTap: () => controller.pickDate(context),
              //   child: AbsorbPointer(
              //     // prevent keyboard from opening
              //     child: CustomTextField(
              //       controller: controller.dobController,
              //       hint: 'Date of Birth',
              //       icon: Icons.calendar_today,
              //       keyboardType: TextInputType.datetime,
              //     ),
              //   ),
              // ),
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
                child: CustomButton(
                  text: 'Create Account',
                  onPressed: controller.checkEmailAndProceed,
                  borderRadius: 24,
                ),
              ),

              const SizedBox(height: 16),
              const Text('or Signup with'),

              const SizedBox(height: 12),
              InkWell(
                onTap: loginController.googleSignIn,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFEFEFEF),
                    //  border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Image.asset(AppImages.googleLogo, height: 24),
                  ),
                ),
              ),

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
