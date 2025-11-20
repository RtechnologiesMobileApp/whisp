import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/features/friends/model/friend_model.dart';
import 'package:whisp/features/friends/model/friend_request_model.dart';
import 'package:whisp/features/premium/view/screens/premium_screen.dart';

class FriendCard extends StatelessWidget {
  final dynamic friend;
  final VoidCallback? onToggleFriend;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const FriendCard({
    super.key,
    required this.friend,
    this.onToggleFriend,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFriendModel = friend is FriendModel;
    final bool isRequestModel = friend is FriendRequestModel;

    final String name = isFriendModel
        ? (friend as FriendModel).name
        : (friend as FriendRequestModel).name;
    final String avatar = isFriendModel
        ? (friend as FriendModel).imageUrl
        : (friend as FriendRequestModel).imageUrl;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
          child: InkWell(
            onTap: isFriendModel
                ? () {
                    Get.toNamed(
                      Routes.chatscreen,
                      arguments: {
                        'partnerId': (friend as FriendModel).id,
                        'partnerName': name,
                        'partnerAvatar': avatar,
                        'isFriend': true,
                        'fromIndex':2,
                      },
                    );
                  }
                : null,
            borderRadius: BorderRadius.circular(12.r),
            child: Row(
              children: [
                // Avatar - Figma style (larger, no gradient border for cleaner look)
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: avatar.isNotEmpty
                      ? NetworkImage(avatar)
                      : null,
                  backgroundColor: Colors.grey[300],
                  child: avatar.isEmpty
                      ? Icon(Icons.person, size: 32.sp, color: Colors.grey[600])
                      : null,
                ),
                SizedBox(width: 12.w),

                // Name with verified badge (if needed)
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17.sp,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Optional: Add verified badge if needed
                      // SizedBox(width: 6.w),
                      // Icon(Icons.verified, color: Colors.blue, size: 18.sp),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // Buttons based on model type
                if (onToggleFriend != null && isFriendModel) ...[
                  // Single Unfriend button for Friends tab
                  ElevatedButton(
                    onPressed: onToggleFriend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 11.h,
                      ),
                    ),
                    child: Text(
                      "Unfriend",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
if (onAccept != null && onReject != null && isRequestModel) ...[
  // Accept/Reject buttons for Requests tab
  SizedBox(width: 6.w),
  
  // Accept Button
  ElevatedButton(
    onPressed: () {
      final user = SessionController().user;

      // 🔹 Check premium status
      if (user?.premium == false) {
        // Not premium -> redirect to premium screen
        Get.to(() => PremiumScreen());
        return; // stop here, don't call accept API
      }

      // 🔹 If premium -> proceed to accept request
      onAccept?.call();
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green.shade50, // Light green background
      foregroundColor: Colors.green.shade700, // Dark green text
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(
          color: Colors.green.shade200, // Border for definition
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
    ),
    child: Text(
      "Accept",
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  SizedBox(width: 6.w),
  
  // Reject Button
  ElevatedButton(
    onPressed: onReject,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red.shade50, // Light red background
      foregroundColor: Colors.red.shade700, // Dark red text
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(
          color: Colors.red.shade200, // Border for definition
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
    ),
    child: Text(
      "Reject",
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
],
                // if (onAccept != null && onReject != null && isRequestModel) ...[
                //   // Accept/Reject buttons for Requests tab
                //   SizedBox(width: 6.w),
                //   ElevatedButton(
                //     // onPressed: onAccept,
                //     onPressed: () {
                //       final user = SessionController().user;

                //       // 🔹 Check premium status
                //       if (user?.premium == false) {
                //         // Not premium -> redirect to premium screen
                //       Get.to(() => PremiumScreen());
                //         return; // stop here, don't call accept API
                //       }

                //       // 🔹 If premium -> proceed to accept request
                //       onAccept?.call();
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.transparent,
                //       shadowColor: Colors.transparent,
                //       elevation: 0,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10.r),
                //       ),
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 16.w,
                //         vertical: 8.h,
                //       ),
                //     ),
                //     child: Text(
                //       "Accept",
                //       style: TextStyle(
                //         color: Colors.green,
                //         fontSize: 13.sp,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                //   SizedBox(width: 6.w),
                //   ElevatedButton(
                //     onPressed: onReject,
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.transparent,
                //       shadowColor: Colors.transparent,
                //       elevation: 0,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10.r),
                //       ),
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 16.w,
                //         vertical: 8.h,
                //       ),
                //     ),
                //     child: Text(
                //       "Reject",
                //       style: TextStyle(
                //         color: Colors.red,
                //         fontSize: 13.sp,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                // ],
            
            
              ],
            ),
          ),
        ),
        // Divider line
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Divider(color: Colors.grey[300], thickness: 0.5, height: 1),
        ),
      ],
    );
  }
}
