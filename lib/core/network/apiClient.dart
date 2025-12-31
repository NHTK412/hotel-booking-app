import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8080/api/",
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
