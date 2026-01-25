import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static StreamSubscription<String>? _tokenRefreshSubscription;

  static Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true, // iOS only
      badge: true, // iOS only
      sound: true, // iOS only
    );
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  static Future<void> registerToken(int userId) async {
    final String? token = await getToken();

    if (token == null) {
      debugPrint('Không thể lấy FCM token để đăng ký.');
      return;
    }

    final dio = ApiClient().dio;
    final deviceType = await _getOrCreateDeviceType();
    final headers = await _buildHeaders();

    debugPrint(
      '[FCM] Đăng ký token mới: userId=$userId, deviceType=$deviceType, token=$token',
    );

    if (headers == null) {
      debugPrint('Thiếu access token để đăng ký thiết bị.');
      return;
    }

    try {
      final response = await dio.post(
        '${AppConfig.baseUrl}devices/register',
        data: {
          'fcmToken': token,
          'deviceType': deviceType,
          'platform': _resolvePlatform(),
          'userId': userId,
        },
        options: Options(headers: headers),
      );

      final payload = response.data;
      debugPrint('[FCM] Phản hồi đăng ký: $payload');
      final bool isSuccess =
          payload is Map<String, dynamic> && payload['success'] == true;
      final bool accepted =
          payload is Map<String, dynamic> && payload['data'] == true;

      if (!isSuccess || !accepted) {
        debugPrint('Server từ chối đăng ký FCM token: $payload');
      }
    } on DioException catch (error, stackTrace) {
      debugPrint('Lỗi khi đăng ký token FCM: ${error.message}');
      debugPrint('$stackTrace');
    } catch (error, stackTrace) {
      debugPrint('Lỗi không xác định khi đăng ký token FCM: $error');
      debugPrint('$stackTrace');
    }
  }

  static void listenTokenRefresh(int userId) {
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((
      newToken,
    ) async {
      final dio = ApiClient().dio;
      final deviceType = await _getOrCreateDeviceType();
      final headers = await _buildHeaders();

      debugPrint(
        '[FCM] Làm mới token: userId=$userId, deviceType=$deviceType, token=$newToken',
      );

      if (headers == null) {
        debugPrint('Thiếu access token để cập nhật thiết bị.');
        return;
      }

      try {
        final response = await dio.post(
          '${AppConfig.baseUrl}devices/refresh',
          data: {
            'fcmToken': newToken,
            'deviceType': deviceType,
            'platform': _resolvePlatform(),
            'userId': userId,
          },
          options: Options(headers: headers),
        );

        final payload = response.data;
        debugPrint('[FCM] Phản hồi refresh: $payload');
        final bool isSuccess =
            payload is Map<String, dynamic> && payload['success'] == true;
        final bool accepted =
            payload is Map<String, dynamic> && payload['data'] == true;

        if (!isSuccess || !accepted) {
          debugPrint('Server từ chối cập nhật FCM token: $payload');
        }
      } on DioException catch (error, stackTrace) {
        debugPrint('Lỗi khi cập nhật token FCM: ${error.message}');
        debugPrint('$stackTrace');
      } catch (error, stackTrace) {
        debugPrint('Lỗi không xác định khi cập nhật token FCM: $error');
        debugPrint('$stackTrace');
      }
    });
  }

  static void clearTokenRefreshListener() {
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
  }

  static Future<void> logout() async {
    final String deviceId = 'flutter-${DateTime.now().millisecondsSinceEpoch}';

    // xóa token khỏi server
  }

  static Future<String> _getOrCreateDeviceType() async {
    final pref = await SharedPreferences.getInstance();
    final stored = pref.getString('device_type');
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }

    final newId = const Uuid().v4();
    await pref.setString('device_type', newId);
    return newId;
  }

  static String _resolvePlatform() {
    if (kIsWeb) {
      return 'Web';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }

  static Future<Map<String, String>?> _buildHeaders() async {
    final pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString('access_token');

    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    return {
      'Authorization': 'Bearer $accessToken',
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }
}
