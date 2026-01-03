import 'package:intl/intl.dart';

class AccommodationSummary {
  final int? accommodationId;
  final String? accommodationName;
  final String? address;
  final String? image;
  final String? type;
  final double? minPricePerNight;
  final double? averageRating;

  AccommodationSummary({
    required this.accommodationId,
    required this.accommodationName,
    required this.address,
    required this.image,
    required this.type,
    required this.minPricePerNight,
    required this.averageRating,
  });

  factory AccommodationSummary.fromJson(Map<String, dynamic> json) {
    return AccommodationSummary(
      accommodationId: json['accommodationId'] as int?,
      accommodationName: json['accommodationName'] as String?,
      address: json['address'] as String?,
      image: json['image'] as String?,
      type: json['type'] as String?,
      minPricePerNight: json['minPricePerNight'] as double?,
      averageRating: json['averageRating'] as double?,
    );
  }

  String getMinPricePerNightToString() {
    return (minPricePerNight == null)
        ? ""
        : NumberFormat("#,###").format(minPricePerNight);
  }
}
