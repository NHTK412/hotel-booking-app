import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';

class RoomTypeService {
  final Dio dio = ApiClient().dio;

  Future<Response> getRoomTypeById(int roomTypeId) async {
    try {
      final Response response = await dio.get("room-types/${roomTypeId}");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllRoomTypes({
    String? district,
    String? city,
    String? checkInDate,
    String? checkOutDate,
    int? capacity,
    int? bedrooms,
    int? page,
    int? pageSize,
  }) async {
    try {
      final queryParams = {
        'district': district,
        'city': city,
        'checkInDate': checkInDate,
        'checkOutDate': checkOutDate,
        'capacity': capacity,
        'bedroom': bedrooms,
        'page': page,
        'pageSize': pageSize,
      };

      queryParams.removeWhere((key, value) => value == null);

      final Response response = await dio.get(
        "room-types/search",
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
