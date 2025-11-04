import 'package:get/get.dart';
import 'package:whisp/features/auth/controllers/login_controller.dart';
import 'package:whisp/features/auth/controllers/signup_controller.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);

    // Controllers
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
  }
}
