import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  SharedPreferencesManager._();

  static SharedPreferencesManager? _instance;

  static SharedPreferencesManager get instance {
    if (_instance == null) {
      _instance = SharedPreferencesManager._();
      return _instance!;
    }
    return _instance!;
  }

  Future<bool> getBool({required String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return (await sharedPreferences.getBool(key) ?? false);
  }

  Future<bool> setBool({required String key, required bool value}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(key, value);
  }

  Future<String> getString({required String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return (await sharedPreferences.getString(key) ?? "");
  }

  Future<bool> setString({required String key, required String value}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return await sharedPreferences.setString(key, value);
  }

  Future<int> getInt({required String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return (await sharedPreferences.getInt(key) ?? 0);
  }

  Future<bool> setInt({required String key, required int value}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return await sharedPreferences.setInt(key, value);
  }


}
