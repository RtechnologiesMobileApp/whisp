import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/core/widgets/custom_button.dart';
import 'package:whisp/core/widgets/custom_date_picker.dart';
import 'package:whisp/features/auth/controllers/dob_controller.dart';
 

class DobScreen extends StatelessWidget {
  const DobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DobController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
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
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "You must be 13 years old to continue",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            // 📅 Cupertino Date Picker
 
            SizedBox(
  height: 200,
  child: CupertinoTheme(
    data: CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary, // 💜 sets highlight color
    ),
    child: CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: DateTime(2000, 1, 1),
      maximumDate: DateTime.now(),
      minimumYear: 1900,
      onDateTimeChanged: (DateTime newDate) {
        controller.selectedDate.value = newDate;
      },
    ),
  ),
),

            const Spacer(),

            // 🟣 Custom Continue Button
            Obx(() => CustomButton(
                  text: "Continue",
                  isLoading: controller.isLoading.value,
                  onPressed: () async {
                    await controller.saveDateOfBirth();
                  },
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

 