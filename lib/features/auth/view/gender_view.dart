import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/core/widgets/custom_back_button.dart';
import 'package:whisp/features/auth/controllers/signup_controller.dart';

import '../../../core/widgets/custom_button.dart';


class GenderView extends StatelessWidget {
  const GenderView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(leading: CustomBackButton()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //   const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please enter your Gender",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Gender Buttons
            Obx(
              () => Column(
                children: [
                  _genderOption("Female", 0,controller),
                  const SizedBox(height: 12),
                  _genderOption("Male", 1,controller),
                  const SizedBox(height: 12),
                  _genderOption("Not Specified", 2,controller),
                ],
              ),
            ),

            const Spacer(),

            // Continue Button
            CustomButton(
              text: "Continue",
              onPressed: controller.genderContinue,
              borderRadius: 24,
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _genderOption(String label, int index,SignupController controller) {
    final isSelected = controller.selectedGender.value == index;
    return GestureDetector(
      onTap: () => controller.selectGender(index),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(24),
          // border: Border.all(
          //   color: isSelected ? AppColors.primary : Colors.grey.shade300,
          //   width: 1.2,
          // ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
