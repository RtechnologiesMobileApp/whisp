import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/features/onboarding/controller/onboarding_controller.dart';
import 'package:whisp/utils/colors.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController controller = Get.put(OnboardingController());
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(AppImages.logo, height: 142, width: 142),

              SizedBox(height: 30),

              // PageView for onboarding items
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: controller.onBoardingData.length,
                 onPageChanged: (index) {
  controller.currentPage.value = index;

  // 👇 If last page reached, wait a moment then navigate
  if (index == controller.onBoardingData.length - 1) {
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.offAllNamed(Routes.signup); // or Get.offAll(() => SignupScreen());
    });
  }
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
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkgrey,
                          ),
                        ),
                        SizedBox(height: 30),

                        // Image/Illustration
                        Image.asset(
                          item['image'] ?? '',
                          height: 258,
                          width: 250,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 30),

                        // Subtitle
                        Text(
                          item['subtitle'] ?? '',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkgrey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: 30),

              // Dots Indicator
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.onBoardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      height: 7,
                      width: controller.currentPage.value == index ? 26 : 7,
                      decoration: BoxDecoration(
                        color: controller.currentPage.value == index
                            ? AppColors.vividPurple
                            : AppColors.deepblue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
