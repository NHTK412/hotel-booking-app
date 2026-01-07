import 'package:flutter/material.dart';

enum AmenityEnum {
  wifi("WIFI", Icons.wifi, "Wifi miễn phí"),
  airConditioning("AIR_CONDITIONING", Icons.ac_unit, "Điều hòa nhiệt độ"),
  tv("TV", Icons.tv, "Tivi"),
  miniBar("MINI_BAR", Icons.local_bar, "Quầy bar nhỏ"),
  roomService("ROOM_SERVICE", Icons.room_service, "Dịch vụ phòng"),
  swimmingPool("SWIMMING_POOL", Icons.pool, "Hồ bơi"),
  gym("GYM", Icons.fitness_center, "Phòng gym"),
  spa("SPA", Icons.spa, "Spa & Massage"),
  parking("PARKING", Icons.local_parking, "Chỗ đậu xe"),
  breakfastIncluded(
    "BREAKFAST_INCLUDED",
    Icons.restaurant,
    "Bữa sáng miễn phí",
  );

  final String apiValue;
  final IconData iconData;
  final String amenityName;

  const AmenityEnum(this.apiValue, this.iconData, this.amenityName);

  static AmenityEnum fromJson(String value) {
    return AmenityEnum.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => throw ArgumentError('AmenityEnum không hợp lệ: $value'),
    );
  }

  String toJson() => apiValue;
}
