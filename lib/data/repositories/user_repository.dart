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
}
