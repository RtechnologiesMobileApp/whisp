import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/features/auth/view/login_view.dart';

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
    Offset? tapPosition;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.logo, height: 70, fit: BoxFit.contain),
          

GestureDetector(
  onTapDown: (details) {
    // Save the tap position for accurate dropdown placement
    tapPosition = details.globalPosition;
  },
  onTap: () async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        tapPosition!.dx,
        tapPosition!.dy + 20, // 👈 Adds slight spacing below avatar
        overlay.size.width - tapPosition!.dx,
        overlay.size.height - tapPosition!.dy,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      items: [
        PopupMenuItem<String>(
          value: "logout",
          height: 40,
          child: Row(
            children: const [
              Icon(Icons.logout, color: Colors.redAccent, size: 18),
              SizedBox(width: 10),
              Text(
                "Logout",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );

    if (selected == "logout") {
      SessionController().clearSession();
      Get.offAll(() => LoginView());
    }
  },
  child: CircleAvatar(
    radius: 20,
    backgroundColor: Colors.grey.shade200,
    backgroundImage: userImage.isNotEmpty
        ? NetworkImage(userImage)
        : const AssetImage(AppImages.placeholderpic) as ImageProvider,
  ),
)

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
