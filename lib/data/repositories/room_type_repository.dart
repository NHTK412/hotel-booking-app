import 'package:dio/dio.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/roomtype/room_type_summary.dart';
import 'package:hotel_booking_app/data/service/room_type_service.dart';

import '../model/roomtype/room_type_detail.dart';

class RoomTypeRepository {
  final RoomTypeService _roomTypeService;

  RoomTypeRepository(this._roomTypeService);

  Future<ApiResponse<RoomTypeDetail>> getRoomTypeById(int roomTypeId) async {
    try {
      final Response response = await _roomTypeService.getRoomTypeById(
        roomTypeId,
      );

      return ApiResponse.fromJson(
        response.statusCode,
        response.data,
        (data) => RoomTypeDetail.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<List<RoomTypeSummary>>> getAllRoomTypes({
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
      final Response response = await _roomTypeService.getAllRoomTypes(
        district: district,
        city: city,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        capacity: capacity,
        bedrooms: bedrooms,
        page: page,
        pageSize: pageSize,
      );

      return ApiResponse.fromJson(
        response.statusCode,
        response.data,
        (data) => (data as List)
            .map((item) => RoomTypeSummary.fromJson(item))
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
