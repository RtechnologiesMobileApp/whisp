import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/features/premium/model/premium_model.dart';
class PremiumCard extends StatelessWidget {
  final PremiumModel plan;
  final int index; // :point_left: add this
  const PremiumCard({super.key, required this.plan, required this.index});
  @override
  Widget build(BuildContext context) {
    // Define colors based on card index
    final bool isSecondCard = index == 1;
    final Color bgColor = isSecondCard
        ? AppColors
              .whiteColor // example for second card
        : AppColors.brightYellow.withOpacity(0.5);
    final Color textColor = isSecondCard
        ? Color(0xFF58245E)
        : AppColors.whiteColor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF141414).withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.title.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'PASS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(height: 43, width: 1.06, color: textColor),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        plan.price,
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Text(
                        plan.planMonth,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: textColor),
          Text(
            "The fun starts when Friday finishes. Premium from Friday to Sunday.",
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Includes:",
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...plan.features.map(
            (f) => Padding(
              padding: EdgeInsets.only(left: 17.0.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: textColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.inter(
                        color: textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}