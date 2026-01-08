import 'package:dio/dio.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/core/interceptor/auth_interceptor.dart';

class ApiClient {
  // static final Dio dio = Dio(
  //   BaseOptions(
  //     baseUrl: AppConfig.baseUrl,
  //     headers: {'Content-Type': 'application/json'},
  //     //   connectTimeout: const Duration(seconds: 10), // Thời gian chờ kết nối
  //     // receiveTimeout: const Duration(seconds: 10), // Thời gian chờ nhận dữ liệu
  //   ),

  // );

  final Dio dio;

  ApiClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          // connectTimeout: const Duration(seconds: 10), // Thời gian chờ kết nối
          // receiveTimeout: const Duration(seconds: 10), // Thời gian chờ nhận dữ liệu
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    dio.interceptors.add(AuthInterceptor());
  }
}
