// lib/core/services/payment_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;


class PaymentService {
  final BuildContext context;
  final String baseUrl;
  final String deviceId;
  final Future<void> Function() onCreditsRefresh;

  PaymentService({
    required this.context,
    required this.baseUrl,
    required this.deviceId,
    required this.onCreditsRefresh,
  });

Future<void> handleSubscription(String plan) async {
  try {
    _showLoadingSnack('Preparing payment for $plan plan...');

    await _testBackendConnection();
    final data = await _createPaymentIntent(plan);

    final clientSecret = data['clientSecret'] as String?;
    final ephemeralKey = data['ephemeralKey'] as String?;
    final customerId = data['customerId'] as String?;
    final paymentIntentId = data['paymentIntentId'];

    if (clientSecret == null) throw Exception('No payment intent received');

    Navigator.pop(context); // closes bottom sheet

    await _initAndPresentPaymentSheet(
      clientSecret: clientSecret,
      ephemeralKey: ephemeralKey,
      customerId: customerId,
    );

    // await _notifyBackendPaymentSuccess(paymentIntentId);

    // 🔹 Wait a tick to ensure context is stable
    Future.delayed(const Duration(milliseconds: 300), () {
      if (context.mounted) {
        _showSnack('Payment successful! Welcome to Whisp Pro! 🎉', Colors.green);
      }
    });

    await onCreditsRefresh();
  } catch (error) {
    print('❌ Payment error: $error');
    if (context.mounted) _handlePaymentError(error);
  }
}

  
  // --- Helper methods ---

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLoadingSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
        backgroundColor: Colors.amber,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _testBackendConnection() async {
    final res = await http.get(
      Uri.parse('$baseUrl/status'),
      headers: {'x-device-id': deviceId},
    );
    if (res.statusCode != 200) {
      throw Exception('Backend not reachable');
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(String plan) async {
    final response = await http.post(
      Uri.parse('$baseUrl/billing/create-payment-intent'),
      headers: {
        'Content-Type': 'application/json',
        'x-device-id': deviceId,
      },
      body: jsonEncode({'plan': plan, 'deviceId': deviceId}),
    );
    print('🛑 Payment intent response: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to create payment intent');
    }

    return jsonDecode(response.body);
  }

  Future<void> _initAndPresentPaymentSheet({
    required String clientSecret,
    String? ephemeralKey,
    String? customerId,
  }) async {
    await Stripe.instance.applySettings();
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Whisp Pro',
        customerEphemeralKeySecret: ephemeralKey,
        customerId: customerId,
        style: ThemeMode.dark,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }

// Future<void> _notifyBackendPaymentSuccess(String paymentIntentId) async {
//   final res = await http.post(
//     Uri.parse('$baseUrl/billing/payment-success'),
//     headers: {
//       'Content-Type': 'application/json',
//       'x-device-id': deviceId,
//     },
//     body: jsonEncode({'paymentIntentId': paymentIntentId}),
//   );

//   if (res.statusCode != 200) {
//     throw Exception('Failed to notify backend of payment success.');
//   }

//   // // ✅ Notify backend done, now refresh credits via socket
//   // try {
//   //   final chatSocket = ChatSocketService();
//   //   chatSocket.requestCredits(); // 🔥 trigger credits_info event
//   //   print('📡 Requested updated credits after payment success');
//   // } catch (e) {
//   //   print('⚠️ Could not refresh credits via socket: $e');
//   // }
// }

//   // Future<void> _notifyBackendPaymentSuccess(String paymentIntentId) async {
//   //   final res = await http.post(
//   //     Uri.parse('$baseUrl/billing/payment-success'),
//   //     headers: {
//   //       'Content-Type': 'application/json',
//   //       'x-device-id': deviceId,
//   //     },
//   //     body: jsonEncode({'paymentIntentId': paymentIntentId}),
//   //   );

//   //   if (res.statusCode != 200) {
//   //     throw Exception('Failed to notify backend of payment success.');
//   //   }
//   // }


  void _handlePaymentError(dynamic error) {
    String message = 'Payment failed. Please try again.';
    if (error.toString().contains('User cancelled')) {
      message = 'Payment cancelled';
    }
    _showSnack(message, Colors.red);
  }
}
