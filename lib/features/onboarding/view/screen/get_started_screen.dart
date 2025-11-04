import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/features/onboarding/view/screen/on_boarding_screen.dart';

import 'package:whisp/utils/colors.dart';

import '../../../../core/widgets/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.splashBackColor,
      body: SafeArea(
        child: Stack(
          children: [
            // 🟣 Centered Logo (Vertically & Horizontally)
            Center(
              child: Image.asset(
                AppImages.applogo,
                width: 240,
                height: 240,
                fit: BoxFit.contain,
              ),
            ),

            // 🟣 Welcome Text + Button at Bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to Whisp',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: size.width * 0.8,
                      child: CustomButton(
                        text: 'Get Started',
                        onPressed: () {
                          Get.to(OnboardingScreen());
                        },
                        // background color
                        textColor: AppColors.whiteColor,
                        height: 48,
                        borderRadius: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
