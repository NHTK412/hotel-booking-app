import 'package:dio/dio.dart';
import 'package:hotel_booking_app/data/model/apiResponse.dart';
import 'package:hotel_booking_app/data/service/roomTypeService.dart';

import '../model/roomtype/roomTypeDetail.dart';

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
