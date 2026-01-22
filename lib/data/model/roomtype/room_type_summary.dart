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
  final double? discount;

  RoomTypeSummary({
    required this.roomTypeId,
    required this.name,
    required this.star,
    required this.price,
    required this.image,
    required this.discount,
  });

  factory RoomTypeSummary.fromJson(Map<String, dynamic> json) {
    return RoomTypeSummary(
      roomTypeId: json['roomtypeId'] as int?,
      name: json['name'] as String?,
      star: json['star'] as int?,
      price: json['price'] as double?,
      image: json['image'] as String?,
      discount: json['discount'] as double?,
    );
  }

  String getPriceToString() {
    return (price != null) ? NumberFormat("#,###").format(price) : "";
  }

  @override
  String toString() {
    return 'RoomTypeSummary{roomTypeId: $roomTypeId, name: $name, star: $star, price: $price, image: $image}';
  }

  // 1. Kiểm tra có giảm giá không
  bool get hasDiscount {
    return discount != null && discount! > 0;
  }

  // 2. Lấy label giảm giá (VD: -20%)
  String getDiscountLabel() {
    if (!hasDiscount) return "";
    String percent = discount.toString().replaceAll(
      RegExp(r"([.]*0)(?!.*\d)"), // loại bỏ các số 0 không cần thiết ở cuối
      "",
    );
    return "-$percent%";
  }

  // 3. Hiển thị giá gốc
  String getOriginalPriceToString() {
    return (price == null) ? "" : NumberFormat("#,###").format(price);
  }

  // 4. Tính và hiển thị giá sau giảm
  String getFinalPriceToString() {
    double finalPrice = (price ?? 0);
    if (hasDiscount) {
      finalPrice = finalPrice * (1 - (discount! / 100));
    }
    return NumberFormat("#,###").format(finalPrice);
  }
}
