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
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String customerEmail;
  final String customerName;
  final String customerPhone;
  final double discountedPrice;
  final double finalPrice;
  final double originalPrice;
  final BookingStatusEnum status;

  BookingDetail({
    required this.bookingId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.customerEmail,
    required this.customerName,
    required this.customerPhone,
    required this.discountedPrice,
    required this.finalPrice,
    required this.originalPrice,
    required this.status,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      bookingId: json['bookingId'],
      checkInDate: DateTime.parse(json['checkInDate']),
      checkOutDate: DateTime.parse(json['checkOutDate']),
      customerEmail: json['customerEmail'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      discountedPrice: (json['discountedPrice'] as num).toDouble(),
      finalPrice: (json['finalPrice'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      status: BookingStatusEnum.fromJson(json['status']),
    );
  }
}
