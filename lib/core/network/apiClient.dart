import 'package:dio/dio.dart';
import 'package:hotel_booking_app/config/appConfig.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
