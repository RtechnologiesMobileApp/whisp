import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/features/friends/model/friend_model.dart';

class FriendCard extends StatelessWidget {
  final FriendModel friend;

  // Callbacks
  final VoidCallback? onToggleFriend; // Friends tab
  final VoidCallback? onAccept;       // Requests tab
  final VoidCallback? onReject;       // Requests tab

  const FriendCard({
    super.key,
    required this.friend,
    this.onToggleFriend,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent, width: 1.2.w),
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundImage: friend.imageUrl.isNotEmpty
                      ? NetworkImage(friend.imageUrl)
                      : null,
                  backgroundColor: Colors.grey[200],
                ),
                SizedBox(width: 12.h),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        friend.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      if (friend.isVerified) ...[
                        SizedBox(width: 4.h),
                        Icon(
                          Icons.verified,
                          color: AppColors.blue,
                          size: 14.sp,
                        ),
                      ],
                    ],
                  ),
                ),

                // ------------------------------
                // Friends tab buttons
                // ------------------------------
                if (onToggleFriend != null) ...[
                  ElevatedButton(
                    onPressed: onToggleFriend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: friend.isFriend
                          ? AppColors.grey
                          : Colors.purpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                    ),
                    child: Text(
                      friend.isFriend ? "Unfriend" : "Friend",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],

                // ------------------------------
                // Requests tab buttons
                // ------------------------------
                if (onAccept != null && onReject != null) ...[
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                    ),
                    child: Text(
                      "Accept",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: onReject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                    ),
                    child: Text(
                      "Reject",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Divider(color: AppColors.kLightGray, height: 15.h),
        ],
      ),
    );
  }
}
