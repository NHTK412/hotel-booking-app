import 'package:flutter/material.dart';
import 'package:hotel_booking_app/data/model/apiResponse.dart';
import 'package:hotel_booking_app/data/model/booking/bookingDetail.dart';
import 'package:hotel_booking_app/data/model/booking/bookingRequest.dart';
import 'package:hotel_booking_app/data/repositories/bookingRepostiory.dart';
import 'package:hotel_booking_app/data/service/bookingService.dart';
import 'package:intl/intl.dart';

class PaymentUI extends StatefulWidget {
  final int roomTypeId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double originPrice;
  final String accommodationName;
  final String roomTypeName;
  final String checkInTime;
  final String checkOutTime;

  const PaymentUI({
    super.key,
    required this.roomTypeId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.checkInDate,
    required this.checkOutDate,
    required this.originPrice,
    required this.accommodationName,
    required this.roomTypeName,
    required this.checkInTime,
    required this.checkOutTime,
  });

  @override
  State<StatefulWidget> createState() {
    return _PaymentUIState();
  }
}

class _PaymentUIState extends State<PaymentUI> {
  String? _error;
  bool _isLoading = false;
  BookingDetail? _bookingDetail;

  @override
  void initState() {
    super.initState();
  }

  // Hàm chuyển đổi DateTime sang "Thứ X, dd/mm/yyyy (HH:mm)"
  String _formatFullDateTime(DateTime date, String hour) {
    List<String> weekDays = [
      "",
      "Thứ 2",
      "Thứ 3",
      "Thứ 4",
      "Thứ 5",
      "Thứ 6",
      "Thứ 7",
      "Chủ Nhật",
    ];
    String dayName = weekDays[date.weekday];
    return "$dayName, ${DateFormat('dd/MM/yyyy').format(date)} ($hour)";
  }

  @override
  Widget build(BuildContext context) {
    int nights = widget.checkOutDate.difference(widget.checkInDate).inDays;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _header(context),
              const SizedBox(height: 25),
              _detailCard(nights),
              const SizedBox(height: 25),
              _customerInfoCard(),
              const SizedBox(height: 25),
              _paymentMethodCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomBar(context),
    );
  }

  Widget _detailCard(int nights) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color(0xFF64BCE3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.hotel_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.accommodationName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.roomTypeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _miniIconDetail(Icons.nightlight_round, "$nights Đêm"),
                    const SizedBox(width: 20),
                    _miniIconDetail(Icons.people, "2 Người"),
                  ],
                ),
                const Divider(height: 30),
                _dateRow(
                  "Nhận phòng",
                  _formatFullDateTime(widget.checkInDate, widget.checkInTime),
                ),
                const SizedBox(height: 10),
                _dateRow(
                  "Trả phòng",
                  _formatFullDateTime(widget.checkOutDate, widget.checkOutTime),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Miễn phí hủy phòng",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thông Tin Khách Hàng",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _infoRow("Họ và tên", widget.customerName),
          _infoRow("Số điện thoại", widget.customerPhone),
          _infoRow("Email", widget.customerEmail, isLast: true),
        ],
      ),
    );
  }

  Widget _paymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF64BCE3), width: 1.5),
      ),
      child: Row(
        children: [
          Image.network(
            "https://pngimg.com/uploads/paypal/paypal_PNG9.png",
            width: 40,
            height: 30,
          ),
          const SizedBox(width: 15),
          const Text("Paypal", style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          const Icon(Icons.check_circle, color: Color(0xFF64BCE3)),
        ],
      ),
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tổng thanh toán",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  "${NumberFormat("#,###").format(widget.originPrice)} VND",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64BCE3),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                // Xử lý thanh toán ở đây

                BookingRequest bookingRequest = BookingRequest(
                  roomTypeId: widget.roomTypeId,
                  customerName: widget.customerName,
                  customerPhone: widget.customerPhone,
                  customerEmail: widget.customerEmail,
                  checkInDate: widget.checkInDate,
                  checkOutDate: widget.checkOutDate,
                  originalPrice: widget.originPrice,
                  discountedPrice: 0,
                  finalPrice: widget.originPrice,
                );

                ApiResponse<BookingDetail> result = await BookingRepository(
                  bookingService: BookingService(),
                ).createBooking(bookingRequest);

                if (result.code == 200) {
                  // Hiển thị thông báo thành công
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Đặt phòng thành công"),
                      content: const Text("Bạn đã đặt phòng thành công."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Hiển thị thông báo lỗi
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Đặt phòng thất bại"),
                      content: Text("Lỗi: ${result.message}"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF64BCE3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Đặt Ngay",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
      ),
      const Text(
        "Chi Tiết Đơn Hàng",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(width: 45),
    ],
  );

  Widget _miniIconDetail(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey),
      const SizedBox(width: 5),
      Text(text),
    ],
  );

  Widget _dateRow(String label, String val) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      Text(
        val,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    ],
  );

  Widget _infoRow(String label, String val, {bool isLast = false}) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      if (!isLast) const Divider(height: 20),
    ],
  );
}
