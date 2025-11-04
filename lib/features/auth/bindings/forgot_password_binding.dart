import 'package:get/get.dart';
import 'package:whisp/features/auth/controllers/forgot_password_controller.dart';
 

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetPasswordController());
  }
}
