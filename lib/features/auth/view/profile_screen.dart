import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/widgets/custom_button.dart';
//import 'package:whisp/features/auth/controllers/profile_controller.dart';
import 'package:whisp/features/auth/controllers/profile_pic_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.toNamed(Routes.signup),
        ),

        centerTitle: false,
      ),
 
      body: SafeArea(
        child: Column(
          children: [
            //const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please select your avatar",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Avatar Section
            GestureDetector(
              onTap: controller.pickImage,
              child: Obx(() {
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight, // 👈 edit icon now top-right
                  children: [
                    CircleAvatar(
                      radius: 55, // 👈 slightly larger avatar
                      backgroundImage: controller.selectedImage.value != null
                          ? FileImage(controller.selectedImage.value!)
                          : const AssetImage(AppImages.placeholderpic)
                                as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                    Positioned(
                      top: -3, // slight adjustment to sit nicely
                      right: -3,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 6),
            const Text('Select Avatar', style: TextStyle(color: Colors.grey)),

            const Spacer(),

            // Update button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: CustomButton(
                    text: controller.isLoading.value
                        ? "Updating..."
                        : "Continue",
                    onPressed: controller.updateAvatar,
                    borderRadius: 24,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
