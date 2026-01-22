import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';
import 'package:hotel_booking_app/data/enum/booking_status_enum.dart';
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

  // http://localhost:8080/api/bookings/me?page=0&size=10
  Future<Response> getBookingByMe({
    int? day,
    int? month,
    int? year,
    BookingStatusEnum? status,
    int? page = 0,
    int? size = 10,
  }) async {
    try {
      final queryParameters = {
        'day': day,
        'page': page,
        'size': size,
        'month': month,
        'year': year,
        'status': status?.toJson(),
      };

      // debugPrint('Query Parameters: $queryParameters');

      queryParameters.removeWhere((key, value) => value == null);

      final response = await dio.get(
        '/bookings/me',
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getBookingDetailById(int bookingId) async {
    try {
      final response = await dio.get('/bookings/$bookingId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> cancelBookingById(int bookingId) async {
    try {
      final response = await dio.patch('/bookings/$bookingId/cancel');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
