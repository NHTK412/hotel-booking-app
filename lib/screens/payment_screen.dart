import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/app_router.dart'; // Chứa BookingParams
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
  final BookingParams bookingParams;

  const PaymentScreen({super.key, required this.bookingParams});

  @override
  State<StatefulWidget> createState() {
    return _PaymentScreenState();
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false; // Biến quản lý trạng thái loading

  @override
  Widget build(BuildContext context) {
    // 1. Tính toán số đêm (Logic chuẩn hóa ngày để tránh lỗi giờ)
    DateTime start = DateTime(
      widget.bookingParams.checkInDate!.year,
      widget.bookingParams.checkInDate!.month,
      widget.bookingParams.checkInDate!.day,
    );
    DateTime end = DateTime(
      widget.bookingParams.checkOutDate!.year,
      widget.bookingParams.checkOutDate!.month,
      widget.bookingParams.checkOutDate!.day,
    );
    int nights = end.difference(start).inDays;
    if (nights <= 0) nights = 1;

    // 2. Tính toán tiền
    double pricePerNight = widget.bookingParams.originalPrice;
    double totalOriginal = pricePerNight * nights;

    // Tính giảm giá (bookingParams.discountedPrice là % giảm, ví dụ 20.0)
    double discountPercent = widget.bookingParams.discountedPrice;
    double totalDiscountAmount = totalOriginal * (discountPercent / 100);

    double finalTotalPrice = totalOriginal - totalDiscountAmount;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Hiển thị Loading toàn màn hình nếu đang xử lý
      body: Stack(
        children: [
          SafeArea(
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
                  const SizedBox(height: 100), // Khoảng trống cho bottom bar
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF64BCE3)),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _bottomBar(
        context,
        totalOriginal: totalOriginal,
        totalDiscount: totalDiscountAmount,
        finalPrice: finalTotalPrice,
      ),
    );
  }

  // --- WIDGETS ---

  Widget _header(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
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

  Widget _detailCard(int nights) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Tên Khách Sạn
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
          // Nội dung chi tiết
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bookingParams.roomTypeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _miniIconDetail(Icons.nightlight_round, "$nights Đêm"),
                    const SizedBox(width: 20),
                    _miniIconDetail(
                      Icons.calendar_month,
                      "Check-in: ${widget.bookingParams.checkInTime}",
                    ),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle, size: 16, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        "Miễn phí hủy phòng",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
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
          _infoRow("Họ và tên", widget.bookingParams.customerName ?? ""),
          _infoRow("Số điện thoại", widget.bookingParams.customerPhone ?? ""),
          _infoRow(
            "Email",
            widget.bookingParams.customerEmail ?? "",
            isLast: true,
          ),
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
            "https://cdn.moveek.com/bundles/ornweb/partners/zalopay-icon.png",
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.payment, size: 40, color: Colors.blue),
          ),
          const SizedBox(width: 15),
          const Text(
            "ZaloPay",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          const Icon(Icons.check_circle, color: Color(0xFF64BCE3)),
        ],
      ),
    );
  }

  Widget _bottomBar(
    BuildContext context, {
    required double totalOriginal,
    required double totalDiscount,
    required double finalPrice,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Giá gốc
              _buildPriceDetailRow("Tổng giá phòng", totalOriginal),
              const SizedBox(height: 8),

              // 2. Giảm giá (Chỉ hiện nếu có)
              if (totalDiscount > 0)
                _buildPriceDetailRow(
                  "Giảm giá ưu đãi",
                  -totalDiscount,
                  isDiscount: true,
                ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Color(0xFFE0E0E0),
                ),
              ),

              // 3. Tổng thanh toán
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tổng thanh toán",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${NumberFormat("#,###").format(finalPrice)} VND",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64BCE3),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Nút Thanh Toán
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => _handlePayment(finalPrice),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF64BCE3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "THANH TOÁN NGAY",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- LOGIC XỬ LÝ THANH TOÁN ---

  Future<void> _handlePayment(double finalPrice) async {
    setState(() => _isLoading = true);

    try {
      // B1: Tạo Booking Request Object
      BookingRequest bookingRequest = BookingRequest(
        roomTypeId: widget.bookingParams.roomTypeId,
        customerName: widget.bookingParams.customerName!,
        customerPhone: widget.bookingParams.customerPhone!,
        customerEmail: widget.bookingParams.customerEmail!,
        checkInDate: widget.bookingParams.checkInDate!,
        checkOutDate: widget.bookingParams.checkOutDate!,
        // Lưu ý: Backend có thể cần giá final hoặc tự tính, ở đây mình truyền tạm
        // Bạn cần kiểm tra xem model BookingRequest của bạn có field price không
      );

      // B2: Gọi API Tạo Booking
      ApiResponse<BookingDetail> result = await BookingRepository(
        bookingService: BookingService(),
      ).createBooking(bookingRequest);

      if (result.code == 200 && result.data != null) {
        print("Booking Created ID: ${result.data!.bookingId}");

        // B3: Gọi API Tạo Payment ZaloPay
        final ZalopayRequest zalopayRequest = ZalopayRequest(
          bookingId: result.data!.bookingId,
          // description: "Thanh toán đơn hàng #${result.data!.bookingId}",
          description: "Thanh toan don hang",
        );

        ApiResponse<ZalopayResponse> zalopayResult = await ZalopayRepository(
          zalopayService: ZalopayService(),
        ).createZalopayPayment(zalopayRequest);

        if (zalopayResult.code == 200 && zalopayResult.data != null) {
          final zalopayUrl = zalopayResult.data!.orderUrl; // URL thanh toán

          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WebViewScreen(url: zalopayUrl),
              ),
            );
          }
        } else {
          _showErrorDialog("Lỗi tạo cổng thanh toán: ${zalopayResult.message}");
        }
      } else {
        _showErrorDialog("Lỗi đặt phòng: ${result.message}");
      }
    } catch (e) {
      _showErrorDialog("Đã xảy ra lỗi: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thông báo"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  // --- HELPERS ---

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

  Widget _buildPriceDetailRow(
    String label,
    double amount, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          "${amount > 0 && isDiscount ? '-' : ''}${NumberFormat("#,###").format(amount.abs())} VND",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDiscount ? Colors.redAccent : const Color(0xFF424242),
          ),
        ),
      ],
    );
  }

  Widget _miniIconDetail(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey),
      const SizedBox(width: 5),
      Text(text, style: const TextStyle(fontSize: 13)),
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
      if (!isLast) const Divider(height: 20, color: Color(0xFFEEEEEE)),
    ],
  );
}
