import 'package:intl/intl.dart';

class AccommodationSummary {
  final int? accommodationId;
  final String? accommodationName;
  final String? address;
  final String? image;
  final String? type;
  final double? minPricePerNight; // Giá gốc
  final double? discountMinPricePerNight; // % Giảm giá (Ví dụ: 20 tức là 20%)
  final double? averageRating;

  AccommodationSummary({
    required this.accommodationId,
    required this.accommodationName,
    required this.address,
    required this.image,
    required this.type,
    required this.minPricePerNight,
    required this.averageRating,
    required this.discountMinPricePerNight,
  });

  factory AccommodationSummary.fromJson(Map<String, dynamic> json) {
    return AccommodationSummary(
      accommodationId: json['accommodationId'] as int?,
      accommodationName: json['accommodationName'] as String?,
      address: json['address'] as String?,
      image: json['image'] as String?,
      type: json['type'] as String?,
      minPricePerNight: (json['minPricePerNight'] as num?)?.toDouble(),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      discountMinPricePerNight: (json['discountMinPricePerNight'] as num?)?.toDouble(),
    );
  }

  // Kiểm tra có giảm giá hay không (Lớn hơn 0)
  bool get hasDiscount {
    return discountMinPricePerNight != null && discountMinPricePerNight! > 0;
  }

  // Format Giá Gốc (Formatted)
  String getOriginalPriceToString() {
    return (minPricePerNight == null)
        ? ""
        : NumberFormat("#,###").format(minPricePerNight);
  }

  // Tính Giá Sau Giảm (Final Price)
  double getFinalPrice() {
    if (minPricePerNight == null) return 0;
    if (!hasDiscount) return minPricePerNight!;
    
    // Công thức: Giá gốc * (1 - %giảm / 100)
    return minPricePerNight! * (1 - (discountMinPricePerNight! / 100));
  }

  // Format Giá Sau Giảm
  String getFinalPriceToString() {
    return NumberFormat("#,###").format(getFinalPrice());
  }

  // Lấy chuỗi hiển thị % giảm (Ví dụ: "-20%")
  String getDiscountLabel() {
    if (!hasDiscount) return "";
    // Xóa số 0 thừa (ví dụ 20.0 -> 20)
    String percent = discountMinPricePerNight.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
    return "-$percent%";
  }
}