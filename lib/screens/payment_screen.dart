import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/app_router.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/booking/booking_detail.dart';
import 'package:hotel_booking_app/data/model/booking/booking_request.dart';
import 'package:hotel_booking_app/data/model/zalopay/zalopay_request.dart';
import 'package:hotel_booking_app/data/model/zalopay/zalopay_response.dart';
import 'package:hotel_booking_app/data/repositories/booking_repostiory.dart';
import 'package:hotel_booking_app/data/repositories/zalopay_repository.dart';
import 'package:hotel_booking_app/data/service/booking_service.dart';
import 'package:hotel_booking_app/data/service/zalopay_service.dart';
import 'package:hotel_booking_app/screens/web_view_screen.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  // final int roomTypeId;
  // final String customerName;
  // final String customerPhone;
  // final String customerEmail;
  // final DateTime checkInDate;
  // final DateTime checkOutDate;
  // final double originPrice;
  // final String accommodationName;
  // final String roomTypeName;
  // final String checkInTime;
  // final String checkOutTime;

  final BookingParams bookingParams;

  const PaymentScreen({
    super.key,
    // required this.roomTypeId,
    // required this.customerName,
    // required this.customerPhone,
    // required this.customerEmail,
    // required this.checkInDate,
    // required this.checkOutDate,
    // required this.originPrice,
    // required this.accommodationName,
    // required this.roomTypeName,
    // required this.checkInTime,
    // required this.checkOutTime,
    required this.bookingParams,
  });

  @override
  State<StatefulWidget> createState() {
    return _PaymentScreenState();
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
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
    int nights = widget.bookingParams.checkOutDate!
        .difference(widget.bookingParams.checkInDate!)
        .inDays;

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
                    widget.bookingParams.accommodationName,
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
                  widget.bookingParams.roomTypeName,
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
                  _formatFullDateTime(
                    widget.bookingParams.checkInDate!,
                    widget.bookingParams.checkInTime!,
                  ),
                ),
                const SizedBox(height: 10),
                _dateRow(
                  "Trả phòng",
                  _formatFullDateTime(
                    widget.bookingParams.checkOutDate!,
                    widget.bookingParams.checkOutTime!,
                  ),
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
          _infoRow("Họ và tên", widget.bookingParams.customerName!),
          _infoRow("Số điện thoại", widget.bookingParams.customerPhone!),
          _infoRow("Email", widget.bookingParams.customerEmail!, isLast: true),
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
            // "https://pngimg.com/uploads/paypal/paypal_PNG9.png",
            "https://cdn.moveek.com/bundles/ornweb/partners/zalopay-icon.png",
            width: 40,
            height: 30,
          ),
          const SizedBox(width: 15),
          const Text("ZaloPay", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  "${NumberFormat("#,###").format(widget.bookingParams.originalPrice)} VND",
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
                  roomTypeId: widget.bookingParams.roomTypeId,
                  customerName: widget.bookingParams.customerName!,
                  customerPhone: widget.bookingParams.customerPhone!,
                  customerEmail: widget.bookingParams.customerEmail!,
                  checkInDate: widget.bookingParams.checkInDate!,
                  checkOutDate: widget.bookingParams.checkOutDate!,
                  originalPrice: widget.bookingParams.originalPrice,
                  discountedPrice: 0,
                  finalPrice: widget.bookingParams.originalPrice,
                );

                ApiResponse<BookingDetail> result = await BookingRepository(
                  bookingService: BookingService(),
                ).createBooking(bookingRequest);

                if (result.code == 200) {
                  // Hiển thị thông báo thành công
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => AlertDialog(
                  //     title: const Text("Đặt phòng thành công"),
                  //     content: const Text("Bạn đã đặt phòng thành công."),
                  //     actions: [
                  //       TextButton(
                  //         onPressed: () {
                  //           Navigator.of(context).pop();
                  //           Navigator.of(context).pop();
                  //           Navigator.of(context).pop();
                  //           Navigator.of(context).pop();
                  //           Navigator.of(context).pop();
                  //         },
                  //         child: const Text("OK"),
                  //       ),
                  //     ],
                  //   ),
                  // );

                  print("DATA BOOKINGID" + result.data!.bookingId.toString());

                  final ZalopayRequest zalopayRequest = ZalopayRequest(
                    bookingId: result.data!.bookingId,
                    // amount: widget.originPrice,
                    description: "THANH TOAN HOA DON DAT PHONG",
                  );
                  ApiResponse<ZalopayResponse> zalopayResult =
                      await ZalopayRepository(
                        zalopayService: ZalopayService(),
                      ).createZalopayPayment(zalopayRequest);

                  if (zalopayResult.code == 200) {
                    final zalopayUrl = zalopayResult.data!.orderUrl;

                    print("ZalopayURL" + zalopayUrl);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            // WebViewScreen(url: zalopayUrl),
                            WebViewScreen(url: zalopayUrl),
                      ),
                    );

                    // final zalopayUrl = zalopayResult.data!.paymentUrl;
                    // Chuyển hướng người dùng đến URL thanh toán của ZaloPay
                    // Sử dụng package url_launcher hoặc WebView để mở URL này
                    // Ví dụ:
                    // await launchUrlString(zalopayUrl);
                  } else {
                    // Xử lý lỗi khi tạo thanh toán ZaloPay
                  }
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
        // onPressed: () => Navigator.pop(context),
        onPressed: () => context.pop(),
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
