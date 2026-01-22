import 'package:flutter/material.dart';

enum BookingStatusEnum {
  // chờ nhận phòng
  pending("Chờ nhận phòng", Colors.orange),
  // đã nhận phòng
  checkIn("Đã nhận phòng", Colors.green),
  // đã trả phòng
  checkedOut("Đã trả phòng", Colors.blue),
  // đã hủy
  canceled("Đã hủy", Colors.red),
  waitingForPayment("Chờ thanh toán", Colors.yellow);

  final String value;
  final Color color;

  const BookingStatusEnum(this.value, this.color);

  static BookingStatusEnum fromJson(String status) {
    switch (status) {
      case 'PENDING':
        return BookingStatusEnum.pending;
      case 'CHECKED_IN':
        return BookingStatusEnum.checkIn;
      case 'CHECKED_OUT':
        return BookingStatusEnum.checkedOut;
      case 'CANCELED':
        return BookingStatusEnum.canceled;
      case 'WAITING_FOR_PAYMENT':
        return BookingStatusEnum.waitingForPayment;
      default:
        throw Exception('Unknown booking status: $status');
    }
  }

  String toString() {
    return value;
  }

  // toJson
  String toJson() {
    return switch (this) {
      BookingStatusEnum.pending => 'PENDING',
      BookingStatusEnum.checkIn => 'CHECKED_IN',
      BookingStatusEnum.checkedOut => 'CHECKED_OUT',
      BookingStatusEnum.canceled => 'CANCELED',
      BookingStatusEnum.waitingForPayment => 'WAITING_FOR_PAYMENT',
    };
  }
}
