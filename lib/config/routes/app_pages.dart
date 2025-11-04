import 'package:get/get.dart';
import 'package:whisp/features/auth/bindings/forgot_password_binding.dart';
import 'package:whisp/features/auth/bindings/gender_binding.dart';
import 'package:whisp/features/auth/bindings/login_binding.dart';
import 'package:whisp/features/auth/bindings/signup_binding.dart';
import 'package:whisp/features/auth/view/enter_otp_view.dart';
import 'package:whisp/features/auth/view/forgot_password_view.dart';
import 'package:whisp/features/auth/view/gender_view.dart';
import 'package:whisp/features/auth/view/login_view.dart';
import 'package:whisp/features/auth/view/signup_view.dart';
import 'package:whisp/features/onboarding/view/screen/spalsh_screen.dart';

part 'app_routes.dart';

class AppPages {
  static final  routes= [
    GetPage(
      name: Routes.signup,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: Routes.genderview,
      page: () => GenderView(), 
      binding: GenderBinding(),  
    ),
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
),
GetPage(
  name: Routes.splash,
  page: () => const SplashScreen(),
),




  ];
}
