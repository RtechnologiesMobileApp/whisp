import 'package:get/get.dart';
import 'package:whisp/core/network/api_client.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';
import '../controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
     Get.put(ApiClient(), permanent: true);
    Get.put(AuthRepository(), permanent: true);
    Get.lazyPut(() => SignupController());
  }
}
