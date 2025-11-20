import 'package:flutter/material.dart';
import 'package:whisp/config/constants/colors.dart';

void showReportBottomSheet(BuildContext context, Function(String reason) onSelected) {
  final reasons = [
    "False or misleading information",
    "Harmful / abusive content",
    "Harassment or bullying",
    "Sexual content",
    "Self-harm / dangerous advice",
    "Spam or unwanted content",
    "Sensitive / disallowed content",
    "Impersonation / fake identity",
    "Irrelevant / low-quality response",
    "Other",
  ];

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: AppColors.bottomSheetBack,
    
    
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
         
          children: [
            const Text(
              "Report",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.bottomSheetTextColor
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tell us why you're reporting this message:",
              style: TextStyle(fontSize: 14, color: AppColors.bottomSheetTextColor),
            ),
            const SizedBox(height: 15),
            ...reasons.map(
              (reason) => ListTile(
                title: Text(reason, style: const TextStyle(color: AppColors.bottomSheetTextColor)),
                onTap: () {
                  Navigator.pop(context);
                  onSelected(reason);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
