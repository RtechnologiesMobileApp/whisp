import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/features/friends/model/friend_model.dart';

class FriendCard extends StatelessWidget {
  final FriendModel friend;
  final VoidCallback onToggleFriend;

  const FriendCard({
    super.key,
    required this.friend,
    required this.onToggleFriend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //  margin: EdgeInsets.symmetric(vertical: 6.w),
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
                  backgroundImage: AssetImage(friend.imageUrl),
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

                ElevatedButton(
                  onPressed: onToggleFriend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                  ),
                  child: Text(
                    "Friend",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: onToggleFriend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    "Unfriend",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.kLightGray, height: 15.h),
        ],
      ),
    );
  }
}
