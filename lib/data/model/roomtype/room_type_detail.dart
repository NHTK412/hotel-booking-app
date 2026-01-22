import 'package:intl/intl.dart';

import '../../enum/amenity_enum.dart';

// {
//   "success": true,
//   "message": "Room type retrieved successfully",
//   "data": {
//     "amenities": [ v
//       "WIFI",
//       "GYM",
//       "MINI_BAR",
//       "SPA",
//       "ROOM_SERVICE"
//     ],
//     "bedroom": null,
//     "capacity": null,
//     "discount": null,
//     "image": "image.png",
//     "imagesPreview": [
//       "image.png",
//       "image.png"
//     ],
//     "localtion": "123 Võ Nguyên Giáp",
//     "name": "Deluxe Ocean View",
//     "price": 250000,
//     "roomtypeId": 1,
//     "star": 5
//   }
// }
class RoomTypeDetail {
  final int? roomTypeId;
  final String? name;
  final String? image;
  final List<String> imagesPreview;
  final List<AmenityEnum> amenities;
  final int? star;
  final String? localtion;
  final String? description;

  final double? price; // Đây là GIÁ GỐC
  final double? discount; // Đây là % GIẢM (ví dụ 0.1 hoặc 10)

  final int? bedroom;
  final int? capacity;

  RoomTypeDetail({
    required this.roomTypeId,
    required this.name,
    required this.price,
    required this.image,
    required this.imagesPreview,
    required this.amenities,
    required this.star,
    required this.localtion,
    required this.discount,
    required this.bedroom,
    required this.capacity,
    required this.description,
  });

  // Helper hiển thị giá gốc (Formatted)
  String getOriginalPriceToString() {
    return (price == null) ? "" : NumberFormat("#,###").format(price);
  }

  // Helper tính giá SAU KHI GIẢM (Final Price)
  double getFinalPrice() {
    if (price == null) return 0;
    if (discount == null || discount == 0) return price!;

    // Xử lý trường hợp discount trả về số thập phân (0.2) hay số nguyên (20)
    double discountPercent = (discount! > 1) ? discount! / 100 : discount!;

    return price! * (1 - discountPercent);
  }

  // Helper hiển thị giá Final (Formatted)
  String getFinalPriceToString() {
    return NumberFormat("#,###").format(getFinalPrice());
  }

  // Helper hiển thị % giảm (ví dụ: -20%)
  String? getDiscountString() {
    if (discount == null || discount == 0) return null;
    double percent = (discount! > 1) ? discount! : discount! * 100;
    return "-${percent.toStringAsFixed(0)}%";
  }

  // Factory fromJson giữ nguyên như cũ...
  factory RoomTypeDetail.fromJson(Map<String, dynamic> json) {
    return RoomTypeDetail(
      roomTypeId: json['roomtypeId'] as int?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      image: json['image'] as String?,
      imagesPreview: List<String>.from(json['imagesPreview'] ?? []),
      amenities: (json['amenities'] as List? ?? [])
          .map((e) => AmenityEnum.fromJson(e as String))
          .toList(),
      star: json['star'] as int?,
      localtion: json['localtion'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
      bedroom: json['bedroom'] as int?,
      capacity: json['capacity'] as int?,
      description: json['description'] as String?,
    );
  }
}
