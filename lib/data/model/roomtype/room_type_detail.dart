import 'package:intl/intl.dart';

import '../../enum/amenity_enum.dart';

class RoomTypeDetail {
  final int? roomTypeId;
  final String? name;
  final double? price;
  final String? image;
  final List<String> imagesPreview;
  final List<AmenityEnum> amenities;
  final int? star;
  final String? localtion;

  RoomTypeDetail({
    this.roomTypeId,
    this.name,
    this.price,
    this.image,
    required this.imagesPreview,
    required this.amenities,
    this.star,
    required this.localtion,
  });

  String getMinPricePerNightToString() {
    return (price == null) ? "" : NumberFormat("#,###").format(price);
  }

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
    );
  }
}
