import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/apiClient.dart';
import 'package:hotel_booking_app/data/model/auth/authLogin.dart';

class AuthService {
  final Dio dio = ApiClient.dio;

  Future<Response> login(AuthLogin authLogin) async {
    try {
      final response = await dio.post('auth/login', data: authLogin.toJson());
      return response;
    } catch (e) {
      rethrow; // Nghĩa là chuyển tiếp lỗi để xử lý ở nơi gọi hàm
    }
  }
}
