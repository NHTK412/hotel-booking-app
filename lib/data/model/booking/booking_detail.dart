//  "bookingId": 3,
//     "checkInDate": "2026-01-03",
//     "checkOutDate": "2026-01-05",
//     "customerEmail": "nguyenhuutuankhang412@gmail.com",
//     "customerName": "Nguyễn Hữu Tuấn Khang",
//     "customerPhone": "058205002155",
//     "discountedPrice": 0.1,
//     "finalPrice": 100000,
//     "originalPrice": 100000,
//     "status": "PENDING"

import 'package:hotel_booking_app/data/enum/booking_status_enum.dart';

class BookingDetail {
  final int bookingId;
  final DateTime checkInAt;
  final DateTime checkOutAt;
  final String customerEmail;
  final String customerName;
  final String customerPhone;
  final double discountedPrice;
  final double finalPrice;
  final double originalPrice;
  final BookingStatusEnum status;

  // final int roomTypeId;

  //   "roomNumber": "P102 - Deluxe",
  // "roomType": "Deluxe Ocean View",
  // "status": "WAITING_FOR_PAYMENT"

  final String roomNumber;
  final String roomType;
  final String accommodationName;
  final double lat;
  final double lng;

  final int reviewId;

  BookingDetail({
    required this.bookingId,
    required this.checkInAt,
    required this.checkOutAt,
    required this.customerEmail,
    required this.customerName,
    required this.customerPhone,
    required this.discountedPrice,
    required this.finalPrice,
    required this.originalPrice,
    required this.status,
    required this.roomNumber,
    required this.roomType,
    required this.accommodationName,
    required this.lat,
    required this.lng,
    required this.reviewId,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      bookingId: json['bookingId'],
      checkInAt: DateTime.parse(json['checkInAt']),
      checkOutAt: DateTime.parse(json['checkOutAt']),
      customerEmail: json['customerEmail'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      discountedPrice: (json['discountedPrice'] as num).toDouble(),
      finalPrice: (json['finalPrice'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      status: BookingStatusEnum.fromJson(json['status']),
      roomNumber: json['roomNumber'],
      roomType: json['roomType'],
      accommodationName: json['accommodationName'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      reviewId: json['reviewId'] ?? 0,
    );
  }
}
