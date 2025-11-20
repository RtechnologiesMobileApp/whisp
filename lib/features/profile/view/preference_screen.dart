import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/widgets/custom_back_button.dart';
import 'package:whisp/features/profile/controller/preference_controller.dart';
import 'package:whisp/features/profile/widgets/preference_selector_widget.dart';

class PreferenceScreen extends StatefulWidget {

  PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
   final PreferenceController controller = Get.put(PreferenceController());
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.loadPreferences();
  });
  }

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

      body: Obx(() {
  if (controller.isLoadingPrefs.value) {
    return Center(child: CircularProgressIndicator());
  }
       return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: PreferenceSelectorWidget(
                controller: controller,
              ),
            ),
          ),
        );
      
      }
      ),
    );
  }
}
