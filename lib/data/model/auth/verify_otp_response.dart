class VerifyOtpResponse {

  final int? expiresIn;
  final bool? isValid;
  final String? accessToken;
  final String? refreshToken;
  final int? userId;

  VerifyOtpResponse({
    this.expiresIn,
    this.isValid,
    this.accessToken,
    this.refreshToken, 
    this.userId,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      expiresIn: json['expiresIn'] as int?,
      isValid: json['isValid'] as bool?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      userId: json['userId'] as int?,
    );
  }
}