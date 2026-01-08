import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';
import 'package:hotel_booking_app/data/model/booking/booking_request.dart';

class BookingService {
  final Dio dio = ApiClient().dio;

  Future<Response> createBooking(BookingRequest bookingRequest) async {
    try {
      final response = await dio.post(
        '/bookings',
        data: bookingRequest.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
