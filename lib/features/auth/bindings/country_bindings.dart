import 'package:get/get.dart';
import 'package:whisp/features/auth/controllers/country_controller.dart';

class CountryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CountryController>(() => CountryController());
  }
}


