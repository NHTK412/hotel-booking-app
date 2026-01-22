
class ReviewSummary {
  final int reviewId;
  final int bookingId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  // final String userName;
  final String userFullName;
  final String userImage;

  ReviewSummary({
    required this.reviewId,
    required this.bookingId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    // required this.userName,
    required this.userFullName,
    required this.userImage,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      reviewId: json['reviewId'],
      bookingId: json['bookingId'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      // userName: json['userName'],
      userFullName: json['userFullName'],
      userImage: json['userImage'],
    );
  }
}
