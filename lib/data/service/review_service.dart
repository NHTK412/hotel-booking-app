import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';

class ReviewService {
  final Dio dio = ApiClient().dio;

  Future<Response> submitReview({
    required int bookingId,
    required int rating,
    required String comment,
  }) async {
    final data = {'bookingId': bookingId, 'rating': rating, 'comment': comment};

    try {
      final response = await dio.post('/reviews', data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> fetchReviews({
    required int roomType,

    required int page,
    required int size,

    // required bool sort;
  }) async {
    try {
      final response = await dio.get(
        '/reviews',
        queryParameters: {'roomType': roomType, 'page': page, 'size': size},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
