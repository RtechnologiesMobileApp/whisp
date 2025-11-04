import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisp/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final String? imagePath;
  final bool isGradient;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? radius;
  final double? width;
  final double? height;
  final VoidCallback? onclick;

  const CustomButton({
    super.key,
    this.text,
    this.imagePath,
    required this.isGradient,
    this.bgColor,
    this.textColor,
    this.borderColor,
    this.fontSize,
    this.radius,
    this.width,
    this.height,
    this.onclick,
    this.fontWeight,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onclick ?? () => print('Tapped'),
      child: Container(
        height: height ?? 52,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: isGradient ? null : bgColor ?? AppColors.vividPurple,
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(radius ?? 32.0),
          // gradient: isGradient ? AppColors.linearGradient : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imagePath != null && imagePath!.isNotEmpty) ...[
                Image.asset(
                  imagePath!,
                  height: 18,
                  width: 18, // Optional: adjust size
                ),
                SizedBox(width: 12),
              ],
              Text(
                text ?? '',
                style: GoogleFonts.inter(
                  color: textColor ?? AppColors.whiteColor,
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight ?? FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
