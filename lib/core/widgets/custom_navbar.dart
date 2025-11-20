import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
 
import 'package:whisp/config/constants/images.dart'; // 👈 your icon paths
 import 'package:flutter_svg/flutter_svg.dart';

class CustomNavBar extends StatelessWidget {
  final RxInt selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(child: _buildNavItem(0, "Home", AppImages.homeUnselectedSvg, AppImages.homeSelectedSvg)),
            Flexible(child: _buildNavItem(1, "Chats", AppImages.chat_unselected, AppImages.chat_selected)),
            Flexible(child: _buildNavItem(2, "Friends", AppImages.friends_unselected, AppImages.friends_unselected)),
            Flexible(child: _buildNavItem(3, "Premium", AppImages.premium_unselected, AppImages.premium_unselected)),
            Flexible(child: _buildNavItem(4, "Profile", AppImages.profile_unselected, AppImages.profile_unselected)),
          ],
        ),
      );
    });
  }



Widget _buildNavItem(
  int index,
  String label,
  String iconUnselected,
  String iconSelected,
) {
  bool isSelected = selectedIndex.value == index;
  final iconPath = isSelected ? iconSelected : iconUnselected;
  final isSvg = iconPath.endsWith('.svg');

  return GestureDetector(
    onTap: () => onItemTapped(index),
    
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isSvg
            ? SvgPicture.asset(
                iconPath,
                height: 22,
                width: 22,
                color: isSelected ? AppColors.primary : Colors.black,
              )
            : Image.asset(
                iconPath,
                height: 24,
                width: 24,
                color: isSelected ? AppColors.primary : Colors.black,
              ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.primary : Colors.grey,
          ),
        ),
      ],
    ),
  );
}

}
