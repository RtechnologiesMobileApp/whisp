import 'package:shared_preferences/shared_preferences.dart'; // Importing SharedPreferences for local storage

/// A class for managing local storage using SharedPreferences.
class LocalStorage {
  /// Sets a key-value pair in the local storage.
  ///
  Future<bool> setValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  /// Reads the value associated with the given key from the local storage.
  ///
  Future<String?> readValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Clears the value associated with the given key from the local storage.
  ///
  Future<bool> clearValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
