
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/features/friends/controller/friend_controller.dart';
import 'package:whisp/features/friends/model/friend_model.dart';

void showUnfriendDialog( String name,String action,VoidCallback? callback) {
  Get.back(); // close bottom sheet first

  showDialog(
    context: Get.context!,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Align(
            alignment: Alignment.topLeft,
            child: IconButton(icon:Icon(Icons.close, color: Colors.grey), onPressed: () => Get.back(),),
          ),
          const SizedBox(height: 10),
          Text("$action ${name}?", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          const SizedBox(height: 8),
          const Text(
            "You won't be able to undo this. Are you sure you want to continue?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed:callback,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child:  Text("Yes, $action", style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCFCFCF),
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text("No", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    ),
  );
}