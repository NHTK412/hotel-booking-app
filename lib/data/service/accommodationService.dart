import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/apiClient.dart';

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
} // This class will handle accommodation-related services
