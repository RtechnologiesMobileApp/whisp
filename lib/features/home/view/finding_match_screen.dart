import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whisp/config/constants/images.dart';

class FindingMatchScreen extends StatelessWidget {
  const FindingMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0220), // dark gradient-like background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Finding Your Match',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
          
              // 🎞 Lottie animation here
              SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  AppImages.findingMatch,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
          
              const SizedBox(height: 60),
          
              // ❌ Circular Cancel Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.purpleAccent,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
