import 'package:flutter/cupertino.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/review/review_summary.dart';
import 'package:hotel_booking_app/data/service/review_service.dart';

class ReviewRepository {
  final ReviewService reviewService;

  ReviewRepository({required this.reviewService});

  Future<ApiResponse<ReviewSummary>> submitReview({
    required int bookingId,
    required int rating,
    required String comment,
  }) async {
    final response = await reviewService.submitReview(
      bookingId: bookingId,
      rating: rating,
      comment: comment,
    );

    debugPrint('Submit Review Response data: ${response.data}');

    return ApiResponse<ReviewSummary>.fromJson(
      response.statusCode,
      response.data,
      (data) => ReviewSummary.fromJson(data),
    );
  }

  Future<ApiResponse<List<ReviewSummary>>> fetchReviews({
    required int roomType,
    int page = 0,
    int size = 10,
  }) async {
    final response = await reviewService.fetchReviews(
      roomType: roomType,
      page: page,
      size: size,
    );

    debugPrint('Fetch Reviews Response data: ${response.data}');


    return ApiResponse<List<ReviewSummary>>.fromJson(
      response.statusCode,
      response.data,
      (data) =>
          (data as List).map((item) => ReviewSummary.fromJson(item)).toList(),
    );
  }
}
