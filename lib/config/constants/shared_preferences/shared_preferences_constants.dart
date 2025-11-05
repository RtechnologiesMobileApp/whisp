class SharedPreferencesConstants {
  SharedPreferencesConstants._();
  static SharedPreferencesConstants? _instance;

  static SharedPreferencesConstants get instance {
    if (_instance == null) {
      _instance = SharedPreferencesConstants._();
      return _instance!;
    }
    return _instance!;
  }

  final String userIdConstant = "userId";
  final String userTokenConstant = "userToken";
  final String routinePreferenceConstant = "routinePreference";
  final String stripeCustomerId = "stripeCustomerId";
}
