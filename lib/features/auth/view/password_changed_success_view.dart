import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/widgets/custom_button.dart';
 // 👈 agar color constants use karte ho

class PasswordChangedSuccessView extends StatelessWidget {
  const PasswordChangedSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🟡 Avatar Circle
          
              // 📝 Title
              Text(
                'Password changed',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 10.h),

              // 📄 Subtitle
              Text(
                'Your password has been changed successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 40.h),

              // 🔘 Custom Button
              CustomButton(
                text: "Back to login",
                onPressed: () {
                  Get.offAllNamed(Routes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
