import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisp/features/auth/models/user_model.dart';
import 'package:whisp/utils/manager/shared_preferences/shared_preferences_manager.dart';

extension UserPrefs on SharedPreferencesManager {
  /// Save user object in SharedPreferences
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String userJson = jsonEncode(user.toJson());
    return await sharedPreferences.setString("user", userJson);
  }

  /// Retrieve user object from SharedPreferences
  Future<UserModel?> getUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? userJson = sharedPreferences.getString("user");
    if (userJson == null || userJson.isEmpty) return null;

    return UserModel.fromJson(jsonDecode(userJson));
  }

  /// Clear saved user data
  Future<bool> clearUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return await sharedPreferences.remove("user");
  }
}
