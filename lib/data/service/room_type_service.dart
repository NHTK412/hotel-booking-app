import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';

class RoomTypeService {
  final Dio dio = ApiClient().dio;

  Future<Response> getRoomTypeById(int roomTypeId) async {
    try {
      final Response response = await dio.get("roomtypes/${roomTypeId}");
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
