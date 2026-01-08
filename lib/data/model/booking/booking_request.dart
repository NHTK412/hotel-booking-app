// {
// "customerName": "Nguyễn Hữu Tuấn Khang",
// "customerPhone": "058205002155",
// "customerEmail": "nguyenhuutuankhang412@gmail.com",
// "checkInDate": "2026-01-03",
// "checkOutDate": "2026-01-05",
// "originalPrice": 100000,
// "discountedPrice": 0.1,
// "finalPrice": 100000,
// "roomTypeId": 1
// }

class BookingRequest {
  final String customerName;
  final String customerPhone;
  final String customerEmail;

  final DateTime checkInDate;
  final DateTime checkOutDate;

  final double originalPrice;
  final double discountedPrice;
  final double finalPrice;

  final int roomTypeId;

  BookingRequest({
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.checkInDate,
    required this.checkOutDate,
    required this.originalPrice,
    required this.discountedPrice,
    required this.finalPrice,
    required this.roomTypeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'checkInDate': checkInDate
          .toIso8601String()
          .split('T')
          .first, // Format as 'YYYY-MM-DD'
      'checkOutDate': checkOutDate.toIso8601String().split('T').first,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'finalPrice': finalPrice,
      'roomTypeId': roomTypeId,
    };
  }
}
