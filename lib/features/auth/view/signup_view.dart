import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/features/auth/widgets/custom_button.dart';
import '../controllers/signup_controller.dart';
import '../widgets/custom_text_field.dart';

class SignupView extends GetView<SignupController> {
   SignupView({super.key});
 

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Welcome Text
              const Text(
                'Welcome To',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),

              // Whisp Logo
              const SizedBox(height: 6),
              Image.asset(AppImages.logo, height: 60),

              const SizedBox(height: 20),

              // Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: const AssetImage('assets/images/logo.png'),
                    backgroundColor: Colors.grey[200],
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, size: 18, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text('Select Avatar',
                  style: TextStyle(color: Colors.grey)),

              const SizedBox(height: 20),

              // Text Fields
              CustomTextField(
                controller: controller.nameController,
                hint: 'Name',
                icon: Icons.person,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: controller.emailController,
                hint: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: controller.passwordController,
                hint: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: controller.dobController,
                hint: 'Date of Birth',
                icon: Icons.calendar_today,
              ),

              const SizedBox(height: 12),

              // Terms Checkbox
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.acceptTerms.value,
                        onChanged: controller.toggleTerms,
                        activeColor: Colors.purple,
                      ),
                      const Text('Accept '),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Terms and Conditions',
                          style: TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )),
              const SizedBox(height: 12),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 52,
                 child: CustomButton(
  text: 'Create Account',
  onPressed: controller.createAccount,
),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.purple,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //   ),
                //   onPressed: controller.createAccount,
                //   child: const Text(
                //     'Create Account',
                //     style: TextStyle(fontSize: 16, color: Colors.white),
                //   ),
                // ),
              ),

              const SizedBox(height: 16),
              const Text('or Signup with'),

              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset('assets/images/google.png', height: 24),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => Get.back(),
                child: const Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Sign in',
                        style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w600),
                      )
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
