import 'package:get/get.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/features/Chats/controllers/chat_controller.dart';

import 'package:whisp/features/auth/controllers/login_controller.dart';
import 'package:whisp/features/auth/controllers/signup_controller.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';
import 'package:whisp/features/auth/controllers/otp_controller.dart';
import 'package:whisp/features/auth/controllers/reset_password_controller.dart';
import 'package:whisp/features/auth/controllers/forgot_password_controller.dart';
import 'package:whisp/features/home/controllers/finding_match_controller.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/core/services/session_manager.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);

    // Controllers
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
    Get.lazyPut<EnterOtpController>(() => EnterOtpController(), fenix: true);
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController(), fenix: true);
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController(), fenix: true);
    Get.lazyPut<FindingMatchController>(() => FindingMatchController(), fenix: true);
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);

      // 🧩 Socket Service (global singleton)
    // Only initialize if not already initialized
    if (!Get.isRegistered<SocketService>()) {
      Get.putAsync<SocketService>(() async {
        final token = SessionController().user?.token;

        // token stored in SharedPreferences with key "userToken"

        if (token?.isEmpty ?? true) {
          print('[socket] Warning: No token found in Session. Socket will connect after login.');
        }

        final service = SocketService();
        // Only initialize socket if token exists
        if (token?.isNotEmpty ?? false) {
          await service.init(
            baseUrl: ApiEndpoints.baseUrl,  
            token: token ?? '',
          );
        }

        return service;
      });
    }
  }
}
