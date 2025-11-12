import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? _deviceId;
  late String _backendUrl;
  bool _initialized = false;

  /// Initialize only once
  Future<void> init({required String baseUrl}) async {
    if (_initialized) return; // Prevent re-init
    _backendUrl = baseUrl;
    await _initialize();
    _initialized = true;
  }

  Future<void> _initialize() async {
    try {
      // Request permission
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ FCM permission granted');
      } else {
        print('⚠️ FCM permission not granted');
      }

      // Get token
      _fcmToken = await _fcm.getToken();
      print('✅ FCM Token: $_fcmToken');

      // Listen for token refresh
      _fcm.onTokenRefresh.listen((token) {
        _fcmToken = token;
        print('♻️ FCM Token refreshed: $token');
        _sendTokenToBackend(token);
      });

      // Background handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Foreground handler
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Local notifications
      await _initializeLocalNotifications();

      if (_fcmToken != null) {
        await _sendTokenToBackend(_fcmToken!);
      }

      print('✅ FCM Service initialized');
    } catch (e) {
      print('❌ FCM init error: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: iOS);
    await _localNotifications.initialize(initSettings);
  }

  /// 🧩 Handle foreground message and show local notification
  void _handleForegroundMessage(RemoteMessage message) {
    print('📩 Foreground message received: ${message.data}');
    if (message.notification != null) {
      _showLocalNotification(message);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'fcm_channel',
      'FCM Notifications',
      channelDescription: 'Firebase Cloud Messaging notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Whisp',
      message.notification?.body ?? '',
      details,
      payload: json.encode(message.data),
    );
  }

  Future<void> _sendTokenToBackend(String token) async {
    if (_backendUrl.isEmpty) return;
    try {
      await http.post(
        Uri.parse('$_backendUrl/fcm-token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'fcmToken': token}),
      );
      print('✅ Sent FCM token to backend');
    } catch (e) {
      print('⚠️ Failed to send FCM token: $e');
    }
  }

  Future<String?> getToken() async {
    return _fcmToken ?? await _fcm.getToken();
  }
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 Background message: ${message.messageId}');
}
