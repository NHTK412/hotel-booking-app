import 'package:hotel_booking_app/data/enum/user_role_enum.dart';

class AuthResponse {
  final String? email;

  final UserRoleEnum? role;

  final String? accessToken;

  final String? refreshToken;

  final int? expiresIn;

  AuthResponse({
    required this.email,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthResponse.formJson(Map<String, dynamic> json) {
    return AuthResponse(
      email: json['email'] as String?,
      role: json['role'] != null
          ? UserRoleEnum.fromJson(json['role'] as String)
          : null,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: json['expiresIn'] as int?,
    );
  }
}
