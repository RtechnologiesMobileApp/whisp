import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/routes/app_pages.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("Start button tapped :white_tick:");
        Get.toNamed(Routes.findMatch);
      },
      child: Container(
        width: 140, // button size
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF56B8), Color(0xFF8E2DE2), Color(0xFF03023C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // subtle shadow
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8), // border thickness
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // inner background
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "Start",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [
                        Colors.black, // orange
                        Colors.black, // purple
                      ],
                    ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
