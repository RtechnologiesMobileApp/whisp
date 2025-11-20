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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Center aligned Report title
            const Text(
              "Report",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.bottomSheetTextColor,
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Tell us why you're reporting this message:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.bottomSheetTextColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Divider for separation
            Divider(
              color: AppColors.bottomSheetTextColor.withOpacity(0.2),
              thickness: 1,
            ),
            
            // Scrollable list of reasons
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: reasons.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.bottomSheetTextColor.withOpacity(0.1),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    title: Text(
                      reasons[index],
                      style: const TextStyle(
                        color: AppColors.bottomSheetTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onSelected(reasons[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
 