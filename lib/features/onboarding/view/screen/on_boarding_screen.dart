// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:whisp/config/constants/colors.dart';
// import 'package:whisp/config/constants/images.dart';
// import 'package:whisp/config/routes/app_pages.dart';
// import 'package:whisp/features/onboarding/controller/onboarding_controller.dart';

// class OnboardingScreen extends StatefulWidget {
//   OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final OnboardingController controller = Get.put(OnboardingController());
//   bool _navigated = false;
//   final PageController pageController = PageController();
// @override
// void initState() {
//   super.initState();
//  pageController.addListener(() {
//     if (_navigated) return;

//     final lastPage = controller.onBoardingData.length - 1;
//     final currentPage = pageController.page ?? 0;

//     if (currentPage > lastPage + 0.2) {
//       _navigated = true;
//       Get.offAllNamed(Routes.login);
//     }
//   });
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // App Logo
//               Image.asset(AppImages.logo, height: 142, width: 142),

//               // SizedBox(height: 10),

//               // PageView for onboarding items
//               Expanded(
//                 child: PageView.builder(
//                   controller: pageController,
//                   itemCount: controller.onBoardingData.length,
//                   onPageChanged: (index) {
//                     controller.currentPage.value = index;

//                     // 👇 If last page reached, wait a moment then navigate
//                     // if (index == controller.onBoardingData.length - 1) {
//                     if (index == controller.onBoardingData.length ) {
//                       Future.delayed(const Duration(milliseconds: 300), () {
//                         Get.offAllNamed(
//                           Routes.login,
//                         ); // or Get.offAll(() => SignupScreen());
//                       });
//                     }
//                   },

//                   itemBuilder: (context, index) {
//                     final item = controller.onBoardingData[index];
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           item['title'] ?? '',
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.inter(
//                             fontSize: 24.sp,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.darkgrey,
//                           ),
//                         ),
//                         SizedBox(height: 40),

//                         // Image/Illustration
//                         Image.asset(
//                           item['image'] ?? '',
//                           height: 258,
//                           width: 250,
//                           fit: BoxFit.contain,
//                         ),
//                         SizedBox(height: 20),

//                         // Subtitle
//                         Text(
//                           item['subtitle'] ?? '',
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.inter(
//                             fontSize: 13.sp,
//                             fontWeight: FontWeight.w400,
//                             color: AppColors.darkgrey,
//                             height: 1.5,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),

//               SizedBox(height: 30),

//               // Dots Indicator
//               Obx(
//                 () => Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     controller.onBoardingData.length,
//                     (index) => AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       margin: EdgeInsets.symmetric(horizontal: 4),
//                       height: 7,
//                       width: controller.currentPage.value == index ? 26 : 7,
//                       decoration: BoxDecoration(
//                         color: controller.currentPage.value == index
//                             ? AppColors.primary
//                             : AppColors.deepblue,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/features/onboarding/controller/onboarding_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingController controller = Get.put(OnboardingController());
  final PageController pageController = PageController();
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.addListener(() {
        if (_navigated || !pageController.hasClients) return;

        final lastPage = controller.onBoardingData.length - 1;
        final maxScrollExtent = pageController.position.maxScrollExtent;
        final currentOffset = pageController.offset;

        // 👇 Detect swipe past the last page
        if (currentOffset > maxScrollExtent + 20) {
          _navigated = true;
          Get.offAllNamed(Routes.login);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(AppImages.logo, height: 142, width: 142),

              // PageView for onboarding items
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  physics: const BouncingScrollPhysics(), // 👈 allows overscroll
                  itemCount: controller.onBoardingData.length,
                  onPageChanged: (index) {
                    controller.currentPage.value = index;
                  },
                  itemBuilder: (context, index) {
                    final item = controller.onBoardingData[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title'] ?? '',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkgrey,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Image/Illustration
                        Image.asset(
                          item['image'] ?? '',
                          height: 258,
                          width: 250,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),

                        // Subtitle
                        Text(
                          item['subtitle'] ?? '',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkgrey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Dots Indicator
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.onBoardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 7,
                      width: controller.currentPage.value == index ? 26 : 7,
                      decoration: BoxDecoration(
                        color: controller.currentPage.value == index
                            ? AppColors.primary
                            : AppColors.deepblue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
