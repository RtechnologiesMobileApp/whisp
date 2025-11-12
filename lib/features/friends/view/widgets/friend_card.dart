import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/features/friends/model/friend_model.dart';
import 'package:whisp/features/friends/model/friend_request_model.dart';

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

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            // 👇 Avatar + Name clickable section
            Expanded(
              child: InkWell(
                onTap: () {
                  if (isFriendModel) {
                    Get.toNamed(
                      Routes.chatscreen,
                      arguments: {
                        'partnerId': (friend as FriendModel).id,
                        'partnerName': name,
                        'partnerAvatar': avatar,
                        'isFriend': true,
                      },
                    );
                  }
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.purpleAccent, Colors.pinkAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: EdgeInsets.all(2.5.w),
                      child: CircleAvatar(
                        radius: 22.r,
                        backgroundImage:
                            avatar.isNotEmpty ? NetworkImage(avatar) : null,
                        backgroundColor: Colors.grey[200],
                        child: avatar.isEmpty
                            ? Icon(Icons.person,
                                size: 24.sp, color: Colors.grey[400])
                            : null,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    // Name
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 👇 Right-side buttons
            if (onToggleFriend != null && isFriendModel) ...[
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: onToggleFriend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                ),
                child: Text(
                  "Unfriend",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],

            if (onAccept != null && onReject != null && isRequestModel) ...[
              SizedBox(width: 6.w),
              ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                child: Text(
                  "Accept",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              ElevatedButton(
                onPressed: onReject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                child: Text(
                  "Reject",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

 