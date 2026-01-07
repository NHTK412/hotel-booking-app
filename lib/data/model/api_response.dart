class ApiResponse<T> {
  final int? code;
  final bool? success;

  final String? message;

  final T? data;

  ApiResponse({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    int? code,
    Map<String, dynamic> json,
    T Function(dynamic data) fromJsonT,
  ) {
    return ApiResponse<T>(
      // code: json['code'] as int?,
      code: code,
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] != null) ? fromJsonT(json['data']) : null,
    );
  }
}
