class ZalopayRequest {
  final int bookingId;
  final String description;

  ZalopayRequest({required this.bookingId, required this.description});

  Map<String, dynamic> toJson() {
    return {'bookingId': bookingId, 'description': description};
  }
}

// {
//   "bookingId": 0,
//   "description": "string"
// }
