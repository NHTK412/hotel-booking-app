import 'package:flutter/material.dart';

enum BookingStatusEnum {
  // chờ nhận phòng
  peding("Chờ nhận phòng", Colors.orange),
  // đã nhận phòng
  checkIn("Đã nhận phòng", Colors.green),
  // đã trả phòng
  checkedOut("Đã trả phòng", Colors.blue),
  // đã hủy
  canceled("Đã hủy", Colors.red);

  final String value;
  final Color color;

  const BookingStatusEnum(this.value, this.color);

  static BookingStatusEnum fromJson(String status) {
    switch (status) {
      case 'PENDING':
        return BookingStatusEnum.peding;
      case 'CHECKED_IN':
        return BookingStatusEnum.checkIn;
      case 'CHECKED_OUT':
        return BookingStatusEnum.checkedOut;
      case 'CANCELED':
        return BookingStatusEnum.canceled;
      default:
        throw Exception('Unknown booking status: $status');
    }
  }
}
