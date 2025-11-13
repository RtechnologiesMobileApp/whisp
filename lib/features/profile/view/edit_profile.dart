import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/core/widgets/custom_button.dart';
import 'package:whisp/core/widgets/custom_text_field.dart';
import 'package:whisp/features/profile/controller/profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final controller = Get.put(EditProfileController());

  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final countryController = TextEditingController();
  final genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Pre-fill user data
    final user = controller.user.value;
    nameController.text = user.name ?? '';
    dobController.text = user.dob ?? '';
    genderController.text = user.gender ?? '';
    countryController.text = user.country ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: AppColors.whiteColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar Picker
              GestureDetector(
                onTap: controller.pickImage,
                child: Obx(() {
                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topRight, // edit icon top-right
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: controller.selectedImage.value != null
                            ? FileImage(controller.selectedImage.value!)
                            : (controller.user.value.profilePic != null &&
                                  controller.user.value.profilePic!.isNotEmpty)
                            ? NetworkImage(controller.user.value.profilePic!)
                            : const AssetImage(
                                    "assets/images/default_avatar.png",
                                  )
                                  as ImageProvider,
                        backgroundColor: Colors.grey[200],
                      ),
                      Positioned(
                        top: -3,
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
              const SizedBox(height: 25),
              // Full Name
              CustomTextField(
                icon: Icons.person_2_outlined,
                controller: nameController,
                hint: 'Full Name',
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    dobController.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    icon: Icons.calendar_month,
                    controller: dobController,
                    hint: 'Date of Birth (YYYY-MM-DD)',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Gender
              // CustomTextField(
              //   icon: Icons.male_outlined,
              //   controller: genderController,
              //   hint: 'Gender',
              // ),
              //   const SizedBox(height: 16),
              // Country
              CustomTextField(
                icon: Icons.flag_outlined,
                controller: countryController,
                hint: 'Country',
              ),
              const SizedBox(height: 30),
              // Update Button
              CustomButton(
                text: "Update Profile",
                onPressed: () {
                  controller.updateProfile(
                    fullName: nameController.text.trim(),
                    dateOfBirth: dobController.text.trim(),
                    // gender: genderController.text.trim(),
                    country: countryController.text.trim(),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}