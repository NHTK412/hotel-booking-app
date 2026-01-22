import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';

class UserService {
  final Dio _dio = ApiClient().dio;

  Future<Response> getUserProfile(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateCurrentUser({
    required String name,
    required String phone,
    required String email,
    required String gender,
    required DateTime birthday,
    required String address,
    required String avatarUrl,
  }) async {
    try {
      final response = await _dio.put(
        '/users/me',
        data: {
          'name': name,
          'phone': phone,
          'email': email,
          'gender': gender,
          'birthday': birthday.toIso8601String(),
          'address': address,
          'avatarUrl': avatarUrl,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
