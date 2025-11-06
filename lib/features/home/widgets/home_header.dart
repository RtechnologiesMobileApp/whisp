import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/config/routes/app_pages.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String userImage;
  const HomeHeader({
    super.key,
    required this.userName,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.logo, height: 70, fit: BoxFit.contain),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.login);
              },
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: (userImage.isNotEmpty)
                    ? NetworkImage(userImage)
                    : const AssetImage(AppImages.placeholderpic)
                          as ImageProvider,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Welcome text + username below the top bar
        Text(
          "Welcome",
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
