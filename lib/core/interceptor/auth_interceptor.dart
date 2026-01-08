import 'package:dio/dio.dart';
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

    // print('Access Token in Interceptor: $accessToken');

    // print('Requesting URL: ${options.path}');

    final isPublicEndpoint =
        options.path.contains('auth/login') ||
        options.path.contains('auth/register') ||
        options.path.contains('auth/oauth');

    if (!isPublicEndpoint && accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }
}
