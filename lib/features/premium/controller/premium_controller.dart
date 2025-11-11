import 'package:get/get.dart';
import 'package:whisp/features/premium/model/premium_model.dart';
class PremiumController extends GetxController {
  final premiumPlans = <PremiumModel>[
    PremiumModel(
      title: "Premium",
      price: "\$15",
      planMonth: 'per month',
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
}