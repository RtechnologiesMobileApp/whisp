import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/features/premium/controller/premium_controller.dart';

import '../widgets/premium_card.dart';

class PremiumScreen extends StatelessWidget {
  PremiumScreen({super.key});
  final controller = Get.put(PremiumController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepPurpleColor, // Purple background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              Text(
                "Go Premium",
                style: GoogleFonts.inter(
                  fontSize: 32.sp,

                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Text(
                  "Chat without limits. Connect without ads.\nUnlock everything with Whisp Premium.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.whiteColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                height: 150,
                child: Expanded(
                  child: PageView.builder(
                    onPageChanged: controller.onPageChanged,
                    itemCount: controller.premiumPlans.length,
                    itemBuilder: (context, index) {
                      final plan = controller.premiumPlans[index];
                      return SizedBox(
                        height: 150,
                        child: PremiumCard(plan: plan),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.premiumPlans.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.currentPage.value == index
                            ? Colors.white
                            : Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle upgrade logic
                    Get.snackbar("Premium", "Upgrade feature coming soon!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Upgrade to Premium",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
