import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_booking_app/data/model/accommodation/accommodation_detail.dart';
import 'package:hotel_booking_app/data/model/accommodation/accommodation_summary.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/service/accommodation_service.dart';

class AccommodationRepository {
  final AccommodationService accommodationService;

  AccommodationRepository(this.accommodationService);
  // http://localhost:8080/api/accommodations?page=0&size=1&type=HOTEL&locationId=2650&sortBy=true
  Future<ApiResponse<List<AccommodationSummary>>> getAllAccommodations({
    int page = 0,
    int size = 10,
    String? type,
    int? locationId,
    bool? sortBy,
  }) async {
    try {
      final Response response = await accommodationService.getAllAccommodations(
        queryParameters: {
          'page': page,
          'size': size,
          if (type != null) 'type': type,
          if (locationId != null) 'locationId': locationId,
          if (sortBy != null) 'sortBy': sortBy,
        },
      );

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

  Future<ApiResponse<AccommodationDetail>> updateFavoriteByAccommondationId(
    int accommodationId,
    bool isFavorite,
  ) async {
    try {
      final Response response = await accommodationService
          .updateFavoriteByAccommondationId(accommodationId, isFavorite);

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

  Future<ApiResponse<List<AccommodationSummary>>> getAllAccommodationsBySearch(
    String keyword,
    int page,
    int size,
  ) async {
    try {
      final Response response = await accommodationService
          .getAllAccommondationBySearch(keyword, page, size);

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

  Future<ApiResponse<List<AccommodationSummary>>> getAllAccommodationsByNearby(
    double latitude,
    double longitude,
    int precision,
  ) async {
    try {

      debugPrint("Fetching nearby accommodations for lat: $latitude, lng: $longitude, precision: $precision");

      final Response response = await accommodationService
          .getAllAccommodondationByNearby(latitude, longitude, precision);

        debugPrint("Received response for nearby accommodations: ${response.data}");

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


      debugPrint('Nearby Accommodations: ${apiResponse.data?.length} found.');
      debugPrint('Response Data: ${response.data}');
      
      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }
}
