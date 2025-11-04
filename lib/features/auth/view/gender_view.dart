import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/routes/app_pages.dart';
import '../controllers/gender_controller.dart';
import '../../../core/widgets/custom_button.dart';

class GenderView extends GetView<GenderController> {
  const GenderView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.toNamed( Routes.signup),
        ),
       
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Please enter your Gender",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Gender Buttons
            Obx(() => Column(
                  children: [
                    _genderOption("Female", 0),
                    const SizedBox(height: 12),
                    _genderOption("Male", 1),
                    const SizedBox(height: 12),
                    _genderOption("Not Specified", 2),
                  ],
                )),

            const Spacer(),

            // Continue Button
            CustomButton(
              text: "Continue",
              onPressed: controller.continueNext,
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _genderOption(String label, int index) {
    final isSelected = controller.selectedGender.value == index;
    return GestureDetector(
      onTap: () => controller.selectGender(index),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 1.2,
          ),
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
