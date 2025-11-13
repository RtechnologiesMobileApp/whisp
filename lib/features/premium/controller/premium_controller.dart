import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/core/services/payment_services.dart';
import 'package:whisp/features/premium/model/premium_model.dart';
class PremiumController extends GetxController {
  RxInt selectedPlan = 2.obs;
  final premiumPlans = <PremiumModel>[
    PremiumModel(
      title: "Premium",
      price: "\$15",
      planMonth: 'per month',
      subscription: 'monthly',
      features: [
        "Add & accept friends",
        "Reconnect with previous partners",
        "Fewer ads (1 ad every 5 chats)",
        "Premium badge + exclusive chat themes",
      ],
    ),
    PremiumModel(
      title: "Premium",
      price: "\$150",
      planMonth: 'per year  (2 months free)',
      subscription: 'yearly',
      features: [
        "Add & accept friends",
        "Reconnect with previous partners",
        "Fewer ads (1 ad every 5 chats)",
        "Premium badge + exclusive chat themes",
      ],
    ),
  ].obs;
  final currentPage = 0.obs;
  void onPageChanged(int index) {
    currentPage.value = index;
  }
  void selectPlan(int index) {
    selectedPlan.value = index;
    print('✅ Selected plan: ${premiumPlans[selectedPlan.value].subscription}');
  }

  
Future<void> handleSubscription(BuildContext context, String plan) async {
 
  // if (_deviceId == null || _baseUrl == null) {
  //   Get.snackbar('Error', 'Device ID or base URL missing.');
  //   return;
  // }

  final paymentService = PaymentService(
    context: context,
    baseUrl: ApiEndpoints.baseUrl,
    deviceId: '1234567890',
    onCreditsRefresh: () async {
      // Refresh credits after successful payment
      // voiceSocket.requestCredits();
    },
  );

  await paymentService.handleSubscription(plan);
}

}