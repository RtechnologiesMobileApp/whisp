import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/features/home/controllers/finding_match_controller.dart';
 

class FindingMatchScreen extends StatefulWidget {
  const FindingMatchScreen({super.key});

  @override
  State<FindingMatchScreen> createState() => _FindingMatchScreenState();
}

class _FindingMatchScreenState extends State<FindingMatchScreen> {
  final FindingMatchController ctrl = Get.put(FindingMatchController());

  @override
  void initState() {
    super.initState();
    // start searching as soon as this screen opens
    Future.microtask(() => ctrl.startSearch());
  }

  @override
  void dispose() {
    // controller.onClose will handle cancel
    Get.delete<FindingMatchController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0220),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text('Finding Your Match', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              SizedBox(height: 200, width: 200, child: Lottie.asset(AppImages.findingMatch)),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  ctrl.cancelSearch(); // emits CANCEL_RANDOM and navigates back
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.purpleAccent, size: 32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 