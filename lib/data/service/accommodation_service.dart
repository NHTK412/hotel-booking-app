import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';

class AccommodationService {
  final Dio dio = ApiClient().dio;

  Future<Response> getAllAccommodations({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await dio.get(
        'accommodations',
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllAccommondationById(int accommondationId) async {
    try {
      final Response response = await dio.get(
        'accommodations/$accommondationId',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllAccommondationByFavorite() async {
    try {
      final Response response = await dio.get('accommodations/favorite');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateFavoriteByAccommondationId(
    int accommondationId,
    bool isFavorite,
  ) async {
    try {
      // http://localhost:8080/api/accommodations/favorite/1?isFavorite=true
      // final Response response = await dio.get('accommodations/favorite');
      final Response response = await dio.put(
        'accommodations/favorite/${accommondationId}',
        queryParameters: Map.of({'isFavorite': isFavorite}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllAccommondationBySearch(
    String keyword,
    int page,
    int size,
  ) async {
    try {
      final Response response = await dio.get(
        'accommodations/search',
        queryParameters: Map.of({
          'keyword': keyword,
          'page': page,
          'size': size,
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // http://localhost:8080/api/accommodations/nearby?latitude=10.804239&longitude=106.716755&precision=5
  Future<Response> getAllAccommodondationByNearby(
    double latitude,
    double longitude,
    int precision,
  ) async {
    try {
      final Response response = await dio.get(
        'accommodations/nearby',
        queryParameters: Map.of({
          'latitude': latitude,
          'longitude': longitude,
          'precision': precision,
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
} // This class will handle accommodation-related services
