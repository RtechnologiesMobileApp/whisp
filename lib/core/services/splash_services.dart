import 'package:get/get.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/features/auth/view/login_view.dart';
import 'package:whisp/features/home/view/home_screen.dart';
import 'package:whisp/features/home/view/welcome_home.dart';
import 'package:whisp/features/onboarding/view/screen/get_started_screen.dart';

class SplashServices {
  static Future<void> navigateToLogin() async {
    final SessionController sC = SessionController();

    await sC.loadSession();

    await Future.delayed(const Duration(seconds: 1), () {});
   
     if (sC.isFirstVisit) {
      Get.offAll(() => GetStartedScreen());
    } else {
      Get.offAll(() => MainHomeScreen());
    }

    if (sC.user == null && !sC.isFirstVisit) {
       Get.offAll(() => LoginView());
      return;
    }

    if (sC.user != null) {
      Get.offAll(() => MainHomeScreen());
    }

   
  }
}
