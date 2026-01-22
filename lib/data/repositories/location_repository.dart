import 'package:dio/dio.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/location/location_response.dart';
import 'package:hotel_booking_app/data/service/location_service.dart';

class LocationRepository {
  final LocationService locationService;

  LocationRepository(this.locationService);

  Future<ApiResponse<List<LocationResponse>>> getLocations({
    required String keyword,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final Response response = await locationService.getLocations(
        keyword: keyword,
        page: page,
        size: size,
      );

      return ApiResponse.fromJson(
        response.statusCode,
        response.data,
        (data) => (data as List)
            .map((item) => LocationResponse.fromJson(item))
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
