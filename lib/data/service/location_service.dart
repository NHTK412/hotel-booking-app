import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';

class LocationService {
  final Dio dio = ApiClient().dio;

  Future<Response> getLocations({
    required String keyword,
    int page = 0,
    int size = 10,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        'keyword': keyword,
        'page': page,
        'size': size,
      };
      final response = await dio.get(
        '/locations/search',
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
