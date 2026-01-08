import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';
import 'package:hotel_booking_app/data/model/auth/auth_login.dart';
import 'package:hotel_booking_app/data/model/auth/auth_resgister.dart';
import 'package:hotel_booking_app/data/model/auth/oauth_login.dart';

class AuthService {
  final Dio dio = ApiClient().dio;

  Future<Response> login(AuthLogin authLogin) async {
    try {
      final response = await dio.post('auth/login', data: authLogin.toJson());
      return response;
    } catch (e) {
      rethrow; // Nghĩa là chuyển tiếp lỗi để xử lý ở nơi gọi hàm
    }
  }

  Future<Response> oauthLogin(OAuthLogin oauthLogin) async {
    try {
      final response = await dio.post('auth/oauth', data: oauthLogin.toJson());
      return response;
    } catch (e) {
      rethrow; // Nghĩa là chuyển tiếp lỗi để xử lý ở nơi gọi hàm
    }
  }

  Future<Response> register(AuthRegister authRegister) async {
    try {
      final Response response = await dio.post(
        'auth/register',
        data: authRegister.toJson(),
      );
      return response;
    } catch (e) {
      rethrow; // Nghĩa là chuyển tiếp lỗi để xử lý ở nơi gọi hàm
    }
  }
}

// Future<Response<dynamic>> register() async {}
