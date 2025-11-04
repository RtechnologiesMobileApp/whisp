import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/features/auth/widgets/custom_button.dart';

class EnterOtpView extends StatefulWidget {
  const EnterOtpView({super.key});

  @override
  State<EnterOtpView> createState() => _EnterOtpViewState();
}

class _EnterOtpViewState extends State<EnterOtpView> {
  final List<TextEditingController> otpControllers =
      List.generate(5, (_) => TextEditingController());

  void onContinue() {
    final otp = otpControllers.map((e) => e.text.trim()).join();
    if (otp.length < 5) {
      Get.snackbar('Invalid OTP', 'Please enter the complete 4-digit OTP.');
      return;
    }

    // For now just navigate back to login (later: verify logic)
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
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
          "Forget Password",
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
                    controller: otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.purple.shade200, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.purple.shade400, width: 2),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            // Continue Button (Custom)
            CustomButton(
              text: "Continue",
              onPressed: onContinue,
            ),

            const SizedBox(height: 20),

            // Resend OTP text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn’t get OTP? "),
                GestureDetector(
                  onTap: () {
                    Get.snackbar("OTP Sent", "A new OTP has been sent!");
                  },
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: Color(0xFFD90166),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
