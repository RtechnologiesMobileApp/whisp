import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/features/onboarding/presentation/screen/on_boarding_screen.dart';
import 'package:whisp/features/onboarding/presentation/widgets/custom_elevated_button.dart';
import 'package:whisp/utils/colors.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackColor,
      body: Column(
        children: [
          Container(
            color: AppColors.splashBackColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.logo,
                    width: 298,
                    height: 298,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Spacer(),
          Text(
            'Welcome to Whisp ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.whiteColor,
            ),
          ),
          SizedBox(height: 10),
          CustomButton(
            height: 48,
            width: 313,
            radius: 8,
            bgColor: AppColors.vividPurple,
            textColor: AppColors.whiteColor,
            text: 'Get Started',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            onclick: () {
              Get.to(OnboardingScreen());
            },
            isGradient: false,
          ),
        ],
      ),
    );
  }
}
