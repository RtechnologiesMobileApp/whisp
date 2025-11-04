import 'package:get/get.dart';
import 'package:whisp/features/auth/bindings/signup_binding.dart';
import 'package:whisp/features/auth/view/signup_view.dart';

part 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.signup,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
  ];
}
