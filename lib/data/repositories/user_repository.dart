import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/user/user_response.dart';
import 'package:hotel_booking_app/data/service/user_service.dart';

class UserRepository {
  final UserService userService;

  UserRepository(this.userService);

  Future<ApiResponse<UserResponse>> getUserProfile(int userId) async {
    try {
      final response = await userService.getUserProfile(userId);

      final apiResponse = ApiResponse<UserResponse>.fromJson(
        response.statusCode,
        response.data,
        (data) => UserResponse.fromJson(data),
      );
      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<UserResponse>> getCurrentUser() async {
    try {
      final response = await userService.getCurrentUser();

      final apiResponse = ApiResponse<UserResponse>.fromJson(
        response.statusCode,
        response.data,
        (data) => UserResponse.fromJson(data),
      );
      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<UserResponse>> updateCurrentUser({
    required String name,
    required String phone,
    required String email,
    required String gender,
    required DateTime birthday,
    required String address,
    required String avatarUrl,
  }) async {
    try {
      final response = await userService.updateCurrentUser(
        name: name,
        phone: phone,
        email: email,
        gender: gender,
        birthday: birthday,
        address: address,
        avatarUrl: avatarUrl,
      );

      final apiResponse = ApiResponse<UserResponse>.fromJson(
        response.statusCode,
        response.data,
        (data) => UserResponse.fromJson(data),
      );
      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }
}
