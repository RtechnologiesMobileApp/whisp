import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/features/friends/model/friend_model.dart';
import 'package:whisp/features/friends/model/friend_request_model.dart';

class FriendCard extends StatelessWidget {
  final dynamic friend;

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
    // Determine the type
    final bool isFriendModel = friend is FriendModel;
    final bool isRequestModel = friend is FriendRequestModel;

    final String name = isFriendModel
        ? (friend as FriendModel).name
        : (friend as FriendRequestModel).name;

    final String avatar = isFriendModel
        ? (friend as FriendModel).imageUrl
        : (friend as FriendRequestModel).imageUrl;

    final bool isFriend = isFriendModel ? (friend as FriendModel).isFriend : false;

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
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            // Profile Avatar with gradient border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(2.5.w),
              child: CircleAvatar(
                radius: 22.r,
                backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
                backgroundColor: Colors.grey[200],
                child: avatar.isEmpty
                    ? Icon(Icons.person, size: 24.sp, color: Colors.grey[400])
                    : null,
              ),
            ),
            SizedBox(width: 14.w),

            // Name Text
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: Colors.black87,
                  letterSpacing: 0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Friends tab button
         // FriendCard.dart
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
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
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

            // Requests tab buttons
            if (onAccept != null && onReject != null && isRequestModel) ...[
              SizedBox(width: 6.w),
              ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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