import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/routes/app_pages.dart';
 
import 'package:whisp/core/services/socket_service.dart';  

void showChatBottomSheet(BuildContext context) {
  final socketService = Get.find<SocketService>();  

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _tile(
              "Exit",
              Colors.black,
              onTap: () => _showExitDialog(socketService),
            ),
            _tile(
              "Next Chat",
              Colors.black,
              onTap: () {
                socketService.endSession(); // end current session
                Get.offAllNamed(Routes.findMatch);
              },
            ),
            _tile("Report", Colors.red, onTap: () {}),
            _tile("Cancel", Colors.black, onTap: () => Get.back()),
          ],
        ),
      );
    },
  );
}

Widget _tile(String title, Color color, {required VoidCallback onTap}) {
  return ListTile(
    title: Center(
      child: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    ),
    onTap: onTap,
  );
}

void _showExitDialog(SocketService socketService) {
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
          const Text("Exit Chat?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
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
              onPressed: () {
                socketService.endSession(); // ✅ end session before leaving
                Get.offAllNamed(Routes.mainHome);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text("Yes, Exit", style: TextStyle(color: Colors.white)),
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