import 'package:get/get.dart';
import 'package:whisp/features/premium/model/premium_model.dart';

class PremiumController extends GetxController {
  final premiumPlans = <PremiumModel>[
    PremiumModel(
      title: "Premium Pass",
      price: "\$15 / month",
      features: [
        "Add & accept friends",
        "Reconnect with previous partners",
        "Fewer ads (1 ad every 5 chats)",
        "Premium badge + exclusive chat themes",
      ],
    ),
    PremiumModel(
      title: "Premium Pass",
      price: "\$150 / year",
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
