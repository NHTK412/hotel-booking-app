import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hotel_booking_app/data/enum/booking_status_enum.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/booking/booking_detail.dart';
import 'package:hotel_booking_app/data/model/booking/booking_request.dart';
import 'package:hotel_booking_app/data/model/booking/booking_summary.dart';
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

  Future<ApiResponse<List<BookingSummary>>> getBookingByMe({
    int? day,
    int? month,
    int? year,
    BookingStatusEnum? status,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final Response response = await bookingService.getBookingByMe(
        day: day,
        month: month,
        year: year,
        status: status,
        page: page,
        size: size,
      );
      return ApiResponse.fromJson(
        response.statusCode,
        response.data,
        (data) => (data as List)
            .map((item) => BookingSummary.fromJson(item))
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<BookingDetail>> getBookingDetailById(int bookingId) async {
    try {
      final Response response = await bookingService.getBookingDetailById(
        bookingId,
      );


      debugPrint('Response data: ${response.data}');


      return ApiResponse.fromJson(
        response.statusCode,
        response.data,
        (data) => BookingDetail.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<BookingDetail>> cancelBookingById(int bookingId) async {
    try {
      final Response response = await bookingService.cancelBookingById(
        bookingId,
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
