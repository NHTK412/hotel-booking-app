import 'package:flutter/material.dart';
import 'package:hotel_booking_app/fcm_initializer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  AppState._internal();

  static final AppState instance = AppState._internal();

  // bool _isLoggedIn = false;

  // bool get isLoggedIn => _isLoggedIn;

  // String accessToken = '';

  // bool get isLoggedIn => accessToken.isNotEmpty;

  // void logIn(String token) async {
  //   // _isLoggedIn = true;
  //   // accessToken = token;

  //   final SharedPreferences pref = await SharedPreferences.getInstance();
  //   // await pref.setBool('isLoggedIn', true);
  //   await pref.setString('access_token', token);
  //   notifyListeners();
  // }

  // void logOut() async {
  //   // _isLoggedIn = false;
  //   // accessToken = '';
  //   final SharedPreferences pref = await SharedPreferences.getInstance();
  //   // await pref.setBool('isLoggedIn', false);
  //   await pref.remove('access_token');
  //   notifyListeners();
  // }

  // void fetchUserData() async {
  //   final SharedPreferences pref = await SharedPreferences.getInstance();

  //   // _isLoggedIn = pref.getBool('isLoggedIn') ?? false;
  //   accessToken = pref.getString('access_token') ?? '';

  //   notifyListeners();

  // }

  String? _token;

  String? get token => _token;

  bool get isLoggedIn => _token != null;

  bool _fcmInitialized = false;

  // String? _deviceType;

  // String? get deviceType => _deviceType;

  Future<void> loadToken() async {
    final pref = await SharedPreferences.getInstance();
    _token = pref.getString('access_token');

    if (!_fcmInitialized) {
      await FcmInitializer.init();

      _fcmInitialized = true;
    }
    notifyListeners();
  }

  void logIn(String token, int? userId) async {
    _token = token;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('access_token', token);

    if (userId != null) {
      await pref.setInt('user_id', userId);
      await FcmInitializer.init(userId: userId);
      _fcmInitialized = true;
    } else {
      await pref.remove('user_id');
    }

    notifyListeners();
  }

  void logOut() async {
    _token = null;
    final pref = await SharedPreferences.getInstance();
    await pref.remove('access_token');

    await pref.remove('user_id');
    FcmInitializer.clearUser();
    _fcmInitialized = false;

    notifyListeners();
  }
}
