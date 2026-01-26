import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hotel_booking_app/data/service/fcm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmInitializer {
  static bool _appConfigured = false;
  static int? _lastRegisteredUserId;

  static Future<void> init({int? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final resolvedUserId = userId ?? prefs.getInt('user_id');

    if (!_appConfigured) {
      await _configureAppLevel();
    }

    if (resolvedUserId == null) {
      return;
    }

    if (_lastRegisteredUserId == resolvedUserId) {
      return;
    }

    await FcmService.registerToken(resolvedUserId);
    FcmService.listenTokenRefresh(resolvedUserId);
    _lastRegisteredUserId = resolvedUserId;
  }

  static Future<void> _configureAppLevel() async {
    await FcmService.requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      print('FCM FOREGROUND');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    });

    _appConfigured = true;
  }

  static void clearUser() {
    _lastRegisteredUserId = null;
    FcmService.clearTokenRefreshListener();
  }
}
