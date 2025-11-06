import 'package:flutter/material.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/core/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SplashServices.navigateToLogin();
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
