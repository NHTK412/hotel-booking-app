import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';

class AccommodationService {
  final Dio dio = ApiClient.dio;

  Future<Response> getAllAccommodations() async {
    try {
      final Response response = await dio.get('accommodations');
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
} // This class will handle accommodation-related services
