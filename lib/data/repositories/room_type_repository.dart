import 'package:dio/dio.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
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
}
