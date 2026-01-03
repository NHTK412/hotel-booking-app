import 'package:dio/dio.dart';
import 'package:hotel_booking_app/data/model/apiResponse.dart';
import 'package:hotel_booking_app/data/model/booking/bookingDetail.dart';
import 'package:hotel_booking_app/data/model/booking/bookingRequest.dart';
import 'package:hotel_booking_app/data/service/bookingService.dart';

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
