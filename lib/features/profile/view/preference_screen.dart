import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/widgets/custom_back_button.dart';
import 'package:whisp/features/profile/controller/preference_controller.dart';
import 'package:whisp/features/profile/widgets/preference_selector_widget.dart';

class PreferenceScreen extends StatelessWidget {
  final PreferenceController controller = Get.find<PreferenceController>();

  PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: CustomBackButton(),
        title: Text(
          "Preferences",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: PreferenceSelectorWidget(
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }
}
