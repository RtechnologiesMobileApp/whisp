import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/core/widgets/custom_button.dart';
import 'package:whisp/features/auth/controllers/forgot_password_controller.dart';
import 'package:whisp/features/auth/controllers/otp_controller.dart';

class EnterOtpView extends StatelessWidget {
  const EnterOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EnterOtpController());
    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Verify OTP",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Enter OTP",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "An OTP has been sent to your registered email",
              style: TextStyle(color: Colors.black54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // OTP Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return SizedBox(
                  width: 55,
                  height: 60,
                  child: TextField(
                    controller: controller.otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 4) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            BorderSide(color: AppColors.deepPurple, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            BorderSide(color: AppColors.deepPurple, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            BorderSide(color: AppColors.deepPurple, width: 1),)
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            // Continue Button
            Obx(() => CustomButton(
                  text: "Continue",
                  onPressed: controller.onContinue,
                  isLoading: controller.isLoading.value,
                )),

            const SizedBox(height: 20),

            // Resend OTP
           Obx(() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Didn’t get OTP? "),
      controller.canResend.value
          ? GestureDetector(
              onTap: controller.resendOtp,
              child: const Text(
                "Resend OTP",
                style: TextStyle(
                  color: Color(0xFFD90166),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : Text(
              "Resend in 00:${controller.remainingSeconds.value.toString().padLeft(2, '0')}",
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
    ],
  );
})

          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:dio/dio.dart';
// import 'package:whisp/core/widgets/custom_button.dart';
// import 'package:whisp/core/network/api_endpoints.dart';
// import 'package:whisp/features/auth/view/reset_password_screen.dart';

// class EnterOtpView extends StatefulWidget {
//   const EnterOtpView({super.key});

//   @override
//   State<EnterOtpView> createState() => _EnterOtpViewState();
// }

// class _EnterOtpViewState extends State<EnterOtpView> {
//   final List<TextEditingController> otpControllers =
//       List.generate(5, (_) => TextEditingController());
//   final RxBool isLoading = false.obs;
//   final Dio _dio = Dio();
//   late final String email;

//   @override
//   void initState() {
//     super.initState();
//     email = (Get.arguments ?? const {})['email'] ?? '';
//   }

//   void onContinue() {
//     final otp = otpControllers.map((e) => e.text.trim()).join();
//     if (otp.isEmpty) {
//       Get.snackbar('Invalid OTP', 'Please enter the OTP.');
//       return;
//     }
//     verifyOtp(otp);
//   }

//   Future<void> verifyOtp(String otp) async {
//     try {
//       isLoading.value = true;
//       final response = await _dio.post(
//         ApiEndpoints.verifyOtp,
//         data: {
//           "email": email,
//           // send both keys to be compatible with backend variants
//           "otp": otp,
          
//         },
//         options: Options(headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         }),
//       );
//       final data = response.data is Map ? response.data as Map : <String, dynamic>{};
//       // try multiple shapes to extract token
//       final resetToken = data['resetToken'] ??
//           (data['data'] is Map ? (data['data']['resetToken'] ?? '') : '') ?? '';
//       if (resetToken.isEmpty) {
//         final serverMsg = data['message']?.toString();
//         Get.snackbar('Error', serverMsg ?? 'Invalid response from server');
//         return;
//       }
//       Get.to(() => const ResetPasswordScreen(), arguments: {"resetToken": resetToken});
//     } on DioException catch (e) {
//       final res = e.response?.data;
//       String msg;
//       if (res is Map) {
//         msg = res['message']?.toString() ?? res.toString();
//       } else if (res is String) {
//         // Avoid dumping HTML in snackbar
//         msg = res.startsWith('<!DOCTYPE') ? 'Server error' : res;
//       } else {
//         msg = e.message ?? 'Failed to verify OTP';
//       }
//       Get.snackbar('Error', msg);
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           "Forget Password",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               "Enter OTP",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               "An OTP has been sent to your registered email",
//               style: TextStyle(color: Colors.black54, fontSize: 14),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),

//             // OTP Fields
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(5, (index) {
//                 return SizedBox(
//                   width: 55,
//                   height: 60,
//                   child: TextField(
//                     controller: otpControllers[index],
//                     keyboardType: TextInputType.number,
//                     textAlign: TextAlign.center,
//                     maxLength: 1,
//                     onChanged: (value) {
//                       if (value.isNotEmpty && index < 3) {
//                         FocusScope.of(context).nextFocus();
//                       } else if (value.isEmpty && index > 0) {
//                         FocusScope.of(context).previousFocus();
//                       }
//                     },
//                     decoration: InputDecoration(
//                       counterText: '',
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide:
//                             BorderSide(color: Colors.purple.shade200, width: 1),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide:
//                             BorderSide(color: Colors.purple.shade400, width: 2),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),

//             const SizedBox(height: 30),

//             // Continue Button (Custom)
//             Obx(() => CustomButton(
//                   text: "Continue",
//                   onPressed: onContinue,
//                   isLoading: isLoading.value,
//                 )),

//             const SizedBox(height: 20),

//             // Resend OTP text
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Didn’t get OTP? "),
//                 GestureDetector(
//                   onTap: () {
//                     Get.snackbar("OTP Sent", "A new OTP has been sent!");
//                   },
//                   child: const Text(
//                     "Resend OTP",
//                     style: TextStyle(
//                       color: Color(0xFFD90166),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
