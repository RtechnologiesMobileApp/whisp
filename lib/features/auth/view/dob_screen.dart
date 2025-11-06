import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/widgets/custom_button.dart';
import 'package:whisp/core/widgets/custom_cupertino_date_picker.dart';
import 'package:whisp/core/widgets/custom_back_button.dart';
import 'package:whisp/features/auth/controllers/dob_controller.dart';

class DobScreen extends StatelessWidget {
  const DobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DobController());

    return Scaffold(
      appBar: AppBar(leading: CustomBackButton()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟣 Page Heading
            Text(
              "Date of Birth",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),

            // 🩶 Subtitle
            const Text(
              "Select your Date of Birth below",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              "You must be 13 years old to continue",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // 📅 Cupertino Date Picker
            CustomColoredDatePicker(),

            const Spacer(),

            // 🟣 Custom Continue Button
            Obx(
              () => CustomButton(
                text: "Continue",
                isLoading: controller.isLoading.value,
                onPressed: () async {
                  await controller.saveDateOfBirth();
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
