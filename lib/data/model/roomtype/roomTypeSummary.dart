// private Long roomtypeId;
// private String name;
// private Integer star;
// private Double price;
// private String image;

import 'package:intl/intl.dart';

class RoomTypeSummary {
  final int? roomTypeId;
  final String? name;
  final int? star;
  final double? price;
  final String? image;

  RoomTypeSummary({
    required this.roomTypeId,
    required this.name,
    required this.star,
    required this.price,
    required this.image,
  });

  factory RoomTypeSummary.fromJson(Map<String, dynamic> json) {
    return RoomTypeSummary(
      roomTypeId: json['roomTypeId'] as int?,
      name: json['name'] as String?,
      star: json['star'] as int?,
      price: json['price'] as double?,
      image: json['image'] as String?,
    );
  }

  String getPriceToString() {
    return (price != null) ? NumberFormat("#,###").format(price) : "";
  }

  @override
  String toString() {
    return 'RoomTypeSummary{roomTypeId: $roomTypeId, name: $name, star: $star, price: $price, image: $image}';
  }
}
