import 'package:get/get.dart';
import 'package:whisp/features/auth/controllers/profile_pic_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
