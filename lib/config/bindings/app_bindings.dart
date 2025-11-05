import 'package:get/get.dart';
import 'package:whisp/features/auth/controllers/country_controller.dart';
import 'package:whisp/features/auth/controllers/dob_controller.dart';
import 'package:whisp/features/auth/controllers/login_controller.dart';
import 'package:whisp/features/auth/controllers/signup_controller.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';
import 'package:whisp/features/auth/controllers/otp_controller.dart';
import 'package:whisp/features/auth/controllers/reset_password_controller.dart';
import 'package:whisp/features/auth/controllers/forgot_password_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);

    // Controllers
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
    Get.lazyPut<DobController>(() => DobController(), fenix: true);
    Get.lazyPut<CountryController>(() => CountryController(), fenix: true);
    Get.lazyPut<EnterOtpController>(() => EnterOtpController(), fenix: true);
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController(), fenix: true);
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController(), fenix: true);
    
  }
}
