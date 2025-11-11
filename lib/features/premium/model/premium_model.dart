class PremiumModel {
  final String title;
  final String price;
  final String planMonth;
  final List<String> features;
  final String subscription;
  PremiumModel({
    required this.title,
    required this.price,
    required this.features,
    required this.planMonth,
    required this.subscription,
  });
}