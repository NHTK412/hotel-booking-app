import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';

class UserService {
  final Dio _dio = ApiClient.dio;

  Future<Response> getUserProfile(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
