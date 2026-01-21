//  "bookingId": 27,
//       "customerEmail": "string",
//       "customerName": "string",
//       "customerPhone": "string",
//       "finalPrice": 250000,
//       "status": "PENDING"

import 'package:hotel_booking_app/data/enum/booking_status_enum.dart';

class BookingSummary {
  final int bookingId;
  final String customerEmail;
  final String customerName;
  final String customerPhone;
  final double finalPrice;
  final BookingStatusEnum status;
  final DateTime? checkInAt;

  BookingSummary({
    required this.bookingId,
    required this.customerEmail,
    required this.customerName,
    required this.customerPhone,
    required this.finalPrice,
    required this.status,
    this.checkInAt,
  });

  factory BookingSummary.fromJson(Map<String, dynamic> json) {
    return BookingSummary(
      bookingId: json['bookingId'],
      customerEmail: json['customerEmail'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      finalPrice: (json['finalPrice'] as num).toDouble(),
      status: BookingStatusEnum.fromJson(json['status']),
      checkInAt: json['checkInAt'] != null
          ? DateTime.parse(json['checkInAt'])
          : null,
    );
  }
}
