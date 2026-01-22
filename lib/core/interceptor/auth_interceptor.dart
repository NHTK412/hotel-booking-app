import 'package:dio/dio.dart';
import 'package:hotel_booking_app/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // super.onRequest(options, handler); /// Bỏ để không báo lỗi next được gọi nhiều lần

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('access_token');

    print('Access Token in Interceptor: $accessToken');

    // print('Requesting URL: ${options.path}');

    final isPublicEndpoint =
        options.path.contains('auth/login') ||
        options.path.contains('auth/register') ||
        options.path.contains('auth/oauth') ||
        options.path.contains('auth/send-otp') ||
        options.path.contains('auth/verify-otp');

    if (!isPublicEndpoint && accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Xử lý lỗi 401 Unauthorized ở đây, ví dụ: chuyển hướng người dùng đến trang đăng nhập

      final AppState appState = AppState.instance;
      appState.logOut();
    }

    super.onError(err, handler);
  }
}
