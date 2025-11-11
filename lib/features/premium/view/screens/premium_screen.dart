import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/core/widgets/custom_button.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 14.w),
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
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    color: AppColors.whiteColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: PageController(
                    viewportFraction: 0.85,
                    initialPage: 0,
                  ),
                  padEnds: false,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.premiumPlans.length,
                  itemBuilder: (context, index) {
                    final plan = controller.premiumPlans[index];
                    return SizedBox(
                      //width: 330,
                      child: Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: InkWell(
                            onTap: () => controller.selectPlan(index),
                            child: PremiumCard(
                              plan: plan,
                              index: index,
                              borderColor:
                                  controller.selectedPlan.value == index
                                  ? AppColors.primary
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Text(
                  "Upgrade now and unlock all premium perks instantly.",
                  // textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.whiteColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Spacer(),
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
                            ? Color(0xFFFF56B8)
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
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: CustomButton(
                    text: 'Upgrade to Premium',
                    onPressed: () {
                      if (controller.selectedPlan.value == 2) {
                        Get.snackbar('Error', 'Please select a plan');
                        return;
                      }
                      controller.handleSubscription(
                        context,
                        controller
                            .premiumPlans[controller.selectedPlan.value]
                            .subscription,
                      );
                    },
                    borderRadius: 8,
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
