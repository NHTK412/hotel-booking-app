import 'package:hotel_booking_app/data/model/apiResponse.dart';
import 'package:hotel_booking_app/data/model/user/userResponse.dart';
import 'package:hotel_booking_app/data/service/userService.dart';

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
