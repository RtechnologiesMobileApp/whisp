// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:whisp/config/constants/images.dart';
// import 'package:whisp/core/widgets/custom_button.dart';
// import 'package:whisp/features/auth/controllers/profile_pic_controller.dart';

// class ProfileView extends StatelessWidget {
//   ProfileView({super.key});

//   final ProfileController controller = Get.put(ProfileController()); // ✅ Register controller

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 50),

//             // Avatar
//             GestureDetector(
//               onTap: controller.pickImage,
//               child: Obx(() {
//                 return CircleAvatar(
//                   radius: 70,
//                   backgroundImage: controller.selectedImage.value != null
//                       ? FileImage(controller.selectedImage.value!)
//                       : const AssetImage(AppImages.placeholderpic)
//                           as ImageProvider,
//                   backgroundColor: Colors.grey[200],
//                 );
//               }),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "Tap to change avatar",
//               style: TextStyle(color: Colors.grey),
//             ),

//             const Spacer(),

//             // Update button
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: CustomButton(
//                   text: "Update Profile",
//                   onPressed: controller.updateProfile,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/constants/images.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
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

            //             const SizedBox(height: 6),
            //             const Text('Select Avatar', style: TextStyle(color: Colors.grey)),
            // // Avatar
            // GestureDetector(
            //   onTap: controller.pickImage,
            //   child: Obx(() {
            //     return CircleAvatar(
            //       radius: 70,
            //       backgroundImage: controller.selectedImage.value != null
            //           ? FileImage(controller.selectedImage.value!)
            //           : const AssetImage(AppImages.placeholderpic)
            //                 as ImageProvider,
            //       backgroundColor: Colors.grey[200],
            //     );
            //   }),
            // ),
            // const SizedBox(height: 16),
            // const Text(
            //   "Tap to change avatar",
            //   style: TextStyle(color: Colors.grey),
            // ),

            // Date of Birth input

            // Country input
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
                        : "Update Profile",
                    onPressed: controller.updateAvatar,
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
