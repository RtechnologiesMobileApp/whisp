import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/features/profile/view/preference_screen.dart';

class PreferenceLoaderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 10), () {
      Get.off(() => PreferenceScreen());
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
