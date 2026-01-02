import 'package:dio/dio.dart';
import 'package:hotel_booking_app/data/model/accommodation/accommodationDetail.dart';
import 'package:hotel_booking_app/data/model/accommodation/accommodationSummary.dart';
import 'package:hotel_booking_app/data/model/apiResponse.dart';
import 'package:hotel_booking_app/data/service/accommodationService.dart';

class AccommodationRepository {
  final AccommodationService accommodationService;

  AccommodationRepository(this.accommodationService);

  Future<ApiResponse<List<AccommodationSummary>>> getAllAccommodations() async {
    try {
      final Response response = await accommodationService
          .getAllAccommodations();

      final ApiResponse<List<AccommodationSummary>> apiResponse =
          ApiResponse.fromJson(
            response.statusCode,
            response.data,
            (data) => (data as List)
                .map(
                  (item) => AccommodationSummary.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList(),
          );
      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<AccommodationDetail>> getAccommodationById(
    int accommodationId,
  ) async {
    try {
      final Response response = await accommodationService
          .getAllAccommondationById(accommodationId);

      final ApiResponse<AccommodationDetail> apiResponse = ApiResponse.fromJson(
        response.statusCode,
        response.data,
        (data) => AccommodationDetail.fromJson(data),
      );

      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<List<AccommodationSummary>>>
  getAllAccommodationsByFavorite() async {
    try {
      final Response response = await accommodationService
          .getAllAccommondationByFavorite();

      final ApiResponse<List<AccommodationSummary>> apiResponse =
          ApiResponse.fromJson(
            response.statusCode,
            response.data,
            (data) => (data as List)
                .map(
                  (item) => AccommodationSummary.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList(),
          );
      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }
}
