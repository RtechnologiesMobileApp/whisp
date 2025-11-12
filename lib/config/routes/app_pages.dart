import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:whisp/config/bindings/app_bindings.dart';
import 'package:whisp/features/Chats/view/chat_screen.dart';
import 'package:whisp/features/auth/bindings/country_bindings.dart';
import 'package:whisp/features/auth/bindings/forgot_password_binding.dart';

import 'package:whisp/features/auth/bindings/login_binding.dart';
import 'package:whisp/features/auth/bindings/signup_binding.dart';
import 'package:whisp/features/auth/view/country_screen.dart';
import 'package:whisp/features/auth/view/dob_screen.dart';
import 'package:whisp/features/auth/view/enter_otp_view.dart';
import 'package:whisp/features/auth/view/forgot_password_view.dart';
import 'package:whisp/features/auth/view/gender_view.dart';
import 'package:whisp/features/auth/view/login_view.dart';
import 'package:whisp/features/auth/view/signup_view.dart';
import 'package:whisp/features/home/view/finding_match_screen.dart';
import 'package:whisp/features/home/view/home_screen.dart';
import 'package:whisp/features/home/view/welcome_home.dart';
import 'package:whisp/features/onboarding/view/screen/splash_screen.dart';
import 'package:whisp/features/auth/view/reset_password_screen.dart';
part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.signup,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(name: Routes.genderview, page: () => GenderView()),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.forgetPassword,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: Routes.enterOtp,
      page: () => const EnterOtpView(),
      binding: AppBindings(),
    ),
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(name: Routes.dob, page: () => const DobScreen()),
    GetPage(
      name: Routes.country,
      page: () => const CountryScreen(),
      // binding: CountryBinding(),
    ),
    GetPage(name: Routes.welcomehome, page: () => HomeScreen()),
    GetPage(
      name: Routes.resetPassword,
      page: () => const ResetPasswordScreen(),
      binding: AppBindings(),
    ),
    GetPage(name: Routes.findMatch, page: () => const FindingMatchScreen()),
 
 
    GetPage(name: Routes.mainHome, page: ()=>MainHomeScreen()),
 
    GetPage(
      name: Routes.chatscreen,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
         debugPrint("📦 ChatScreen Get.arguments: $args");
        return ChatScreen(
          partnerId: args['partnerId'],
          partnerName: args['partnerName'],
          partnerAvatar: args['partnerAvatar'],
          isFriend: args['isFriend'] ?? false,
        );
      },
      binding: AppBindings(),
    ),
  ];
}
