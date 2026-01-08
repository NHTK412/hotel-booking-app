import 'package:dio/dio.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/auth/auth_login.dart';
import 'package:hotel_booking_app/data/model/auth/auth_resgister.dart';
import 'package:hotel_booking_app/data/model/auth/auth_response.dart';
import 'package:hotel_booking_app/data/model/auth/oauth_login.dart';
import 'package:hotel_booking_app/data/service/auth_service.dart';

class AuthRepository {
  final AuthService apiService;

  AuthRepository(this.apiService);

  Future<ApiResponse<AuthResponse>> login(AuthLogin authLogin) async {
    try {
      final Response response = await apiService.login(authLogin);

      final ApiResponse<AuthResponse> apiResponse = ApiResponse.fromJson(
        response.statusCode,
        response.data,
        (data) => AuthResponse.formJson(data as Map<String, dynamic>),
      );
      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<AuthResponse>> oauthLogin(OAuthLogin oauthLogin) async {
    try {
      final Response response = await apiService.oauthLogin(oauthLogin);

      final ApiResponse<AuthResponse> apiResponse = ApiResponse.fromJson(
        response.statusCode,
        response.data,
        (data) => AuthResponse.formJson(data as Map<String, dynamic>),
      );
      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<AuthResponse>> register(AuthRegister authRegister) async {
    try {
      final Response response = await apiService.register(authRegister);

      final ApiResponse<AuthResponse> apiResponse = ApiResponse.fromJson(
        response.statusCode,
        response.data,
        (data) => AuthResponse.formJson(data as Map<String, dynamic>),
      );
      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }
}
