import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/features/onboarding/view/screen/get_started_screen.dart';
import 'package:whisp/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Get.offAll(() =>   GetStartedScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackColor,
      body: Container(
        color: AppColors.splashBackColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.applogo,
                width: 298,
                height: 298,
                fit: BoxFit.contain,
              ),
              Transform.translate(
                offset: const Offset(0, -50), // 🟣 Negative value = move UP
                child: Image.asset(
                  AppImages.talkbeyondnoise,
                  width: 166,
                  height: 39,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}