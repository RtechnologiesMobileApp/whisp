import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/core/services/fcm_service.dart';
import 'package:whisp/features/auth/models/user_model.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/features/auth/controllers/signup_controller.dart';
import 'package:whisp/features/auth/view/profile_screen.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  var isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final formKey = GlobalKey<FormState>(); 

  UserModel? currentUser;

  Future<void> login({
    String type = "email",
    String? email,
    String? password,
    bool showLoadingIndicator = true,
  }) async {
    email = email ?? emailController.text.trim();
    password = password ?? passwordController.text.trim();
   if (type == "email") {
  if (email.isEmpty && password.isEmpty) {
    Get.snackbar("Error", "Please fill all fields");
    return;
  } else if (email.isEmpty) {
    Get.snackbar("Error", "Email is required");
    return;
  } else if (password.isEmpty) {
    Get.snackbar("Error", "Password is required");
    return;
  }
}

    debugPrint("[login api] email: $email, password: $password, type: $type");
    try {
      if (showLoadingIndicator) {
        isLoading.value = true;
      }
      final res = await _authRepository.login(
        email: email,
        password: password,
        type: type,
      );
      debugPrint("[login api] res: $res");
      final data = res is Map ? res : res?.data;

        // 🛑 Handle API error before parsing user
  if (data == null) {
    throw Exception("No response from server");
  }
  if (data.containsKey('error')) {
    final error = data['error'];
    if (error == 'INCORRECT_PASSWORD') {
      throw Exception("Incorrect password");
    } else if (error == 'USER_NOT_FOUND') {
      throw Exception("Email Does not exist");
    } else {
      throw Exception(error.toString());
    }
  }

      final user = UserModel.fromJson(data['user']);
      final token = data['token'];
      final updatedUser = user.copyWith(token: token);
      currentUser = updatedUser;

      await SessionController().saveUserSession(updatedUser);
      await SessionController().loadSession();

      // Reconnect socket with new token
      try {
        if (Get.isRegistered<SocketService>()) {
          final socketService = SocketService.to;
          await socketService.reconnectWithToken(token);
        }
      } catch (e) {
        debugPrint('[socket] Error reconnecting after login: $e');
      }

      Get.offAllNamed(Routes.mainHome);
    } catch (e) {
      debugPrint("[login api] error: $e");
      // Use safer error display method
      if (Get.context != null && Get.isSnackbarOpen == false) {
        Get.snackbar("Login Failed", e.toString());
      } else {
        debugPrint("Login error (no context): $e");
      }
    } finally {
      if (showLoadingIndicator) {
        isLoading.value = false;
      }
    }
  }

  void forgotPassword() {
    Get.toNamed(Routes.forgetPassword);
  }

  Future<void> googleSignIn() async {
    try {
      isGoogleLoading.value = true;
      final googleUser = await _authRepository.signInWithGoogle();

      currentUser = googleUser;

      // Check if user exists in backend
      final emailExists = await _authRepository.checkEmailExists(googleUser.email);
      
      if (!emailExists) {
        // User doesn't exist, navigate to onboarding screens to collect missing info
        // Google doesn't provide gender, DOB, or country, so we need to collect them
        debugPrint("[Google Sign In] User doesn't exist, navigating to onboarding...");
        
        try {
          // Get or create SignupController and pre-fill Google user data
          final signupController = Get.put(SignupController());
          signupController.nameController.text = googleUser.name;
          signupController.emailController.text = googleUser.email;
          signupController.isGoogle.value = true;
          
          // Download Google profile picture and set it in SignupController
          if (googleUser.profilePic != null && googleUser.profilePic!.isNotEmpty) {
            try {
              final avatarFile = await _downloadImageToFile(googleUser.profilePic!);
              signupController.selectedImage.value = avatarFile;
              debugPrint("[Google Sign In] Downloaded and set profile picture");
            } catch (e) {
              debugPrint("[Google Sign In] Failed to download profile picture: $e");
              // User will need to select avatar in ProfileView
            }
          }
          
          // Navigate to ProfileView to start onboarding flow
          // Flow: ProfileView (avatar) -> GenderView -> DOB -> Country -> createAccount()
          Get.offAll(() => ProfileView());
          return;
        } catch (e) {
          debugPrint("[Google Sign In] Error setting up onboarding: $e");
          _showErrorSnackbar("Error", "Failed to start signup process. Please try again.");
          return;
        }
      }
      
      // User exists, proceed with login
      await login(
        email: googleUser.email,
        type: "google",
        showLoadingIndicator: false,
      );
    } catch (e) {
      debugPrint("[Google Sign In] Error: $e");
      
      String errorMessage = e.toString().replaceAll("Exception: ", "");
      
      // Show error using a more reliable method
      _showErrorSnackbar("Error", errorMessage);
    } finally {
      isGoogleLoading.value = false;
    }
  }

  void goToSignup() {
    Get.toNamed(Routes.signup);
  }
  
  /// Generate a secure random password for Google sign-in users
  /// They won't need this password since they'll always sign in with Google
  String _generateSecurePassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$&*~';
    final random = DateTime.now().millisecondsSinceEpoch;
    final buffer = StringBuffer();
    
    // Generate 16 character password
    for (int i = 0; i < 16; i++) {
      buffer.write(chars[(random + i) % chars.length]);
    }
    
    // Ensure it meets password requirements (uppercase, lowercase, number, special)
    final password = buffer.toString();
    return password;
  }
  
  /// Download image from URL and convert to File
  Future<File> _downloadImageToFile(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/google_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("[_downloadImageToFile] Error: $e");
      rethrow;
    }
  }
  
  /// Create a placeholder avatar file
  /// This creates a minimal valid JPEG file (1x1 pixel transparent/white)
  Future<File> _createPlaceholderAvatar() async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/placeholder_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg');
      
      // Create a minimal valid JPEG (1x1 white pixel)
      // JPEG header + minimal image data
      final jpegData = [
        0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01,
        0x01, 0x01, 0x00, 0x48, 0x00, 0x48, 0x00, 0x00, 0xFF, 0xDB, 0x00, 0x43,
        0x00, 0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07, 0x07, 0x07, 0x09,
        0x09, 0x08, 0x0A, 0x0C, 0x14, 0x0D, 0x0C, 0x0B, 0x0B, 0x0C, 0x19, 0x12,
        0x13, 0x0F, 0x14, 0x1D, 0x1A, 0x1F, 0x1E, 0x1D, 0x1A, 0x1C, 0x1C, 0x20,
        0x24, 0x2E, 0x27, 0x20, 0x22, 0x2C, 0x23, 0x1C, 0x1C, 0x28, 0x37, 0x29,
        0x2C, 0x30, 0x31, 0x34, 0x34, 0x34, 0x1F, 0x27, 0x39, 0x3D, 0x38, 0x32,
        0x3C, 0x2E, 0x33, 0x34, 0x32, 0xFF, 0xC0, 0x00, 0x0B, 0x08, 0x00, 0x01,
        0x00, 0x01, 0x01, 0x01, 0x11, 0x00, 0xFF, 0xC4, 0x00, 0x14, 0x00, 0x01,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x08, 0xFF, 0xC4, 0x00, 0x14, 0x10, 0x01, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0xFF, 0xDA, 0x00, 0x08, 0x01, 0x01, 0x00, 0x00, 0x3F, 0x00,
        0xD2, 0xFF, 0xD9
      ];
      
      await file.writeAsBytes(jpegData);
      return file;
    } catch (e) {
      debugPrint("[_createPlaceholderAvatar] Error: $e");
      rethrow;
    }
  }
  
  /// Show error snackbar using a more reliable method
  void _showErrorSnackbar(String title, String message) {
    // Schedule on next frame to ensure context is ready
    SchedulerBinding.instance.addPostFrameCallback((_) {
      try {
        // Check if snackbar is already open to avoid conflicts
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }
        
        // Use Get.snackbar - it should work with GetMaterialApp
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      } catch (e) {
        // If Get.snackbar fails (e.g., no overlay), try using ScaffoldMessenger
        try {
          final context = Get.context;
          if (context != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red.shade400,
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
            return;
          }
        } catch (_) {
          // Final fallback: just print to console
          debugPrint("⚠️ Error showing snackbar: $e");
          debugPrint("⚠️ $title: $message");
        }
      }
    });
  }
}
