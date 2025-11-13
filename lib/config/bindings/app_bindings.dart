import 'package:get/get.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/features/Chats/controllers/chat_controller.dart';
import 'package:whisp/features/Chats/controllers/chat_list_controller.dart';

import 'package:whisp/features/auth/controllers/login_controller.dart';
import 'package:whisp/features/auth/controllers/signup_controller.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';
import 'package:whisp/features/auth/controllers/otp_controller.dart';
import 'package:whisp/features/auth/controllers/reset_password_controller.dart';
import 'package:whisp/features/auth/controllers/forgot_password_controller.dart';
import 'package:whisp/features/friends/controller/friend_controller.dart';
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
    Get.lazyPut<FriendsController>(() => FriendsController(), fenix: true);
    Get.lazyPut<ChatListController>(() => ChatListController(), fenix: true);

      // 🧩 Socket Service (global singleton)
    // Only initialize if not already initialized
    if (!Get.isRegistered<SocketService>()) {
  // Just register singleton, don’t init socket yet
  Get.put<SocketService>(SocketService(), permanent: true);
}
     
  }
}
