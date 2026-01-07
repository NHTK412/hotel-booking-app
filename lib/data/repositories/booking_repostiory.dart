import 'package:dio/dio.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/booking/booking_detail.dart';
import 'package:hotel_booking_app/data/model/booking/booking_request.dart';
import 'package:hotel_booking_app/data/service/booking_service.dart';

class BookingRepository {
  final BookingService bookingService;
  BookingRepository({required this.bookingService});

  Future<ApiResponse<BookingDetail>> createBooking(
    BookingRequest bookingRequest,
  ) async {
    try {
      final Response response = await bookingService.createBooking(
        bookingRequest,
      );
      return ApiResponse.fromJson(
        response.statusCode,
        response.data,
        (data) => BookingDetail.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }
}
