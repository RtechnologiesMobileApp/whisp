import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:whisp/features/auth/models/user_model.dart';
import 'shared_prefs_services.dart';

class SessionController {
  static final SessionController _instance = SessionController._internal();
  factory SessionController() => _instance;
  SessionController._internal();

  final LocalStorage _localStorage = LocalStorage();

  UserModel? _user;
  bool _isFirstVisit = true;

  UserModel? get user => _user;
  bool get isFirstVisit => _isFirstVisit;

  Future<void> loadSession() async {
    try {
      final userData = await _localStorage.readValue('user');
      final firstVisitStr = await _localStorage.readValue('isFirstVisit');

      _isFirstVisit = firstVisitStr != 'false';

      if (userData != null) {
        final userModel = UserModel.fromJson(jsonDecode(userData));
        _user = userModel;
      } else {
        _user = null;
      }
      log('User session loaded: ${user != null? _user!.toJson() : null}');
    } catch (e) {
      log('Session load error: $e');
    }
  }

  Future<void> saveUserSession(UserModel user) async {
    try {
      _user = user;
      _isFirstVisit = false;
      await _localStorage.setValue('user', jsonEncode(user.toJson()));
      await _localStorage.setValue('isLogin', 'true');
      await setFirstVisit();
      log('User session saved: ${user.toJson()}');
    } catch (e) {
      log('Save session error: $e');
    }
  }

  Future<void> setFirstVisit() async {
    _isFirstVisit = false;
    await _localStorage.setValue('isFirstVisit', 'false');
  }

  Future<void> clearSession() async {
    try {
      await _localStorage.clearValue('user');
      await _localStorage.clearValue('isFirstVisit');
      _user = null;
      debugPrint('Session cleared');
    } catch (e) {
      debugPrint('Error clearing session: $e');
    }
  }
}