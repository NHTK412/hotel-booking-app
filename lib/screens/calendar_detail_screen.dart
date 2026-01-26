import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/data/enum/booking_status_enum.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/booking/booking_detail.dart';
// import 'package:hotel_booking_app/data/model/booking/booking_detail.dart'; // Có thể không cần nếu dùng Summary cho list
import 'package:hotel_booking_app/data/model/booking/booking_summary.dart';
import 'package:hotel_booking_app/data/model/zalopay/zalopay_request.dart';
import 'package:hotel_booking_app/data/model/zalopay/zalopay_response.dart';
import 'package:hotel_booking_app/data/repositories/booking_repostiory.dart';
import 'package:hotel_booking_app/data/repositories/review_repository.dart';
import 'package:hotel_booking_app/data/repositories/zalopay_repository.dart';
import 'package:hotel_booking_app/data/service/booking_service.dart';
import 'package:hotel_booking_app/data/service/review_service.dart';
import 'package:hotel_booking_app/data/service/zalopay_service.dart';
import 'package:hotel_booking_app/screens/map_screen.dart';
import 'package:hotel_booking_app/screens/web_view_screen.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarDetailScreen extends StatefulWidget {
  const CalendarDetailScreen({super.key});

  @override
  _CalendarDetailScreenState createState() => _CalendarDetailScreenState();
}

class _CalendarDetailScreenState extends State<CalendarDetailScreen> {
  final BookingRepository bookingRepository = BookingRepository(
    bookingService: BookingService(),
  );

  final ReviewRepository reviewRepository = ReviewRepository(
    reviewService: ReviewService(),
  );

  @override
  void initState() {
    super.initState();
    // Không cần gọi API ở đây nữa vì FutureBuilder sẽ lo việc đó theo từng Tab
    _isLoading = false;
  }

  late bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
          centerTitle: true,
          title: const Text(
            "Lịch Trình Chi Tiết",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blueAccent,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: "Chờ thanh toán"),
              Tab(text: "Chờ nhận"),
              Tab(text: "Đã nhận"),
              Tab(text: "Đã trả"),
              Tab(text: "Đã hủy"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListByStatus(BookingStatusEnum.waitingForPayment),
            _buildListByStatus(BookingStatusEnum.pending),
            _buildListByStatus(BookingStatusEnum.checkIn),
            _buildListByStatus(BookingStatusEnum.checkedOut),
            _buildListByStatus(BookingStatusEnum.canceled),
          ],
        ),
      ),
    );
  }

  // SỬA: Hàm này giờ gọi API trực tiếp dựa trên status được truyền vào
  Widget _buildListByStatus(BookingStatusEnum status) {
    return FutureBuilder<ApiResponse<List<BookingSummary>>>(
      future: bookingRepository.getBookingByMe(status: status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final list = snapshot.data!.data ?? [];

          // SỬA: Xử lý logic hiển thị ngay trong builder
          if (list.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) => _buildBookingCard(list[index]),
          );
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  // Widget hiển thị khi không có dữ liệu
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Không có dữ liệu",
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
        ],
      ),
    );
  }

  // SỬA: Đổi kiểu dữ liệu đầu vào thành BookingSummary để khớp với API
  Widget _buildBookingCard(BookingSummary booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showBookingDetailModal(booking.bookingId),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildLeadingStatusIcon(booking.status),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mã: #${booking.bookingId}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            booking.customerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${DateFormat('dd/MM').format(booking.checkInAt!)} - ${DateFormat('dd/MM').format(booking.checkOutAt!)}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      NumberFormat.currency(
                        locale: 'vi',
                        symbol: 'đ',
                      ).format(booking.finalPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openGoogleMapsDirection(
    double latitude,
    double longitude,
  ) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${latitude},${longitude}&travelmode=driving";
    final Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  Future<void> _handlePayment(BookingDetail bookingDetail) async {
    _showBlockingLoader();

    String? redirectUrl;
    String? errorMessage;

    try {
      final ZalopayRequest zalopayRequest = ZalopayRequest(
        bookingId: bookingDetail.bookingId,
        description: "Thanh toan don hang",
      );

      ApiResponse<ZalopayResponse> zalopayResult = await ZalopayRepository(
        zalopayService: ZalopayService(),
      ).createZalopayPayment(zalopayRequest);

      if (zalopayResult.code == 200 && zalopayResult.data != null) {
        redirectUrl = zalopayResult.data!.orderUrl;
      } else {
        errorMessage = "Lỗi tạo cổng thanh toán: ${zalopayResult.message}";
      }
    } catch (e) {
      errorMessage = "Đã xảy ra lỗi: $e";
    } finally {
      _hideBlockingLoader();
    }

    if (!mounted) return;

    if (redirectUrl != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WebViewScreen(url: redirectUrl!),
        ),
      );
    } else if (errorMessage != null) {
      _showErrorDialog(errorMessage);
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

  void _showBlockingLoader() {
    if (!mounted || _isLoading) return;

    _isLoading = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) => const Dialog(
        backgroundColor: Colors.transparent,
        child: Center(child: CircularProgressIndicator()),
      ),
    ).then((_) {
      if (mounted) {
        _isLoading = false;
      }
    });
  }

  void _hideBlockingLoader() {
    if (!_isLoading || !mounted) return;

    _isLoading = false;
    Navigator.of(context, rootNavigator: true).pop();
  }

  // SỬA: Đổi kiểu đầu vào thành BookingSummary
  void _showBookingDetailModal(int bookingId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        // height: MediaQuery.of(context).size.height * 0.85,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: FutureBuilder(
            future: bookingRepository.getBookingDetailById(bookingId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: Center(child: Text('Lỗi: ${snapshot.error}')),
                );
              } else if (snapshot.hasData && snapshot.data?.data != null) {
                final booking = snapshot.data!.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Thông Tin Chi Tiết",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildStatusBadge(booking.status),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoTile(
                            Icons.person_outline,
                            "Khách hàng",
                            booking.customerName,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: () async {
                            _openGoogleMapsDirection(booking.lat, booking.lng);
                          },
                          icon: Icon(
                            Icons.map,
                            size: 20,
                            color: Colors.blueAccent,
                          ),
                        ), // Nút bản đồ
                      ],
                    ),
                    _buildInfoTile(
                      Icons.phone_android_outlined,
                      "Số điện thoại",
                      booking.customerPhone,
                    ),
                    _buildInfoTile(
                      Icons.mail_outline_rounded,
                      "Email",
                      booking.customerEmail,
                    ),
                    _buildInfoTile(
                      Icons.location_on_outlined,
                      "Địa điểm",
                      booking.accommodationName,
                    ),
                    _buildInfoTile(
                      Icons.meeting_room_outlined,
                      "Loại phòng",
                      "${booking.roomType} - ${booking.roomNumber}",
                    ),

                    const Divider(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoTile(
                            Icons.login_rounded,
                            "Check-in",
                            DateFormat('dd/MM/yyyy').format(
                              booking.checkInAt,
                            ), // Đã bỏ ! vì trong model thường nullable, nhưng logic hiển thị cần đảm bảo
                          ),
                        ),
                        Expanded(
                          child: _buildInfoTile(
                            Icons.logout_rounded,
                            "Check-out",
                            DateFormat('dd/MM/yyyy').format(booking.checkOutAt),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Chỉ hiện QR Code khi trạng thái là Chờ nhận (pending)
                    if (booking.status == BookingStatusEnum.pending)
                      _buildQRCodeSection(booking),

                    const SizedBox(height: 25),

                    // Phần hiển thị giá tiền
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _buildPriceItem(
                            "Giá gốc",
                            booking.originalPrice,
                            isTotal: false,
                          ),
                          _buildPriceItem(
                            "Giảm giá",
                            booking.finalPrice - booking.originalPrice,
                            isTotal: false,
                            color: Colors.red,
                          ),
                          const Divider(height: 20),
                          _buildPriceItem(
                            "Thanh toán cuối",
                            booking.finalPrice,
                            isTotal: true,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- PHẦN NÚT THANH TOÁN ---
                    if (booking.status == BookingStatusEnum.waitingForPayment)
                      Container(
                        width: double.infinity,
                        height: 55,
                        margin: const EdgeInsets.only(
                          bottom: 20,
                        ), // Cách đáy một chút
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final bottomSheetContext = context;
                                  final rootContext = this.context;

                                  _showBlockingLoader();

                                  bool cancelSuccess = false;
                                  String? errorMessage;

                                  try {
                                    await bookingRepository.cancelBookingById(
                                      booking.bookingId,
                                    );
                                    cancelSuccess = true;
                                  } catch (e) {
                                    errorMessage =
                                        'Lỗi khi hủy: ${e.toString()}';
                                  } finally {
                                    _hideBlockingLoader();
                                  }

                                  if (!mounted) return;

                                  if (cancelSuccess) {
                                    if (bottomSheetContext.mounted) {
                                      bottomSheetContext.pop();
                                    }

                                    ScaffoldMessenger.of(
                                      rootContext,
                                    ).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Hủy đặt phòng thành công',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );

                                    setState(() {});
                                  } else if (errorMessage != null) {
                                    ScaffoldMessenger.of(
                                      rootContext,
                                    ).showSnackBar(
                                      SnackBar(
                                        content: Text(errorMessage),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.redAccent.withOpacity(
                                    0.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.delete, size: 18),
                                    SizedBox(width: 10),
                                    Text(
                                      "Hủy Phòng",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 20),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: Xử lý sự kiện bấm nút thanh toán
                                  // Ví dụ: context.push('/payment', extra: booking);
                                  print(
                                    "Chuyển đến màn hình thanh toán cho booking ${booking.bookingId}",
                                  );
                                  _handlePayment(booking);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.blueAccent.withOpacity(
                                    0.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.payment, size: 18),
                                    SizedBox(width: 10),
                                    Text(
                                      "Thanh Toán",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // --- PHẦN NÚT NHẬN XÉT (Đã trả phòng và chưa nhận xét) ---
                    if (booking.status == BookingStatusEnum.checkedOut &&
                        booking.reviewId == 0)
                      Container(
                        width: double.infinity,
                        height: 55,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            _showReviewDialog(booking.bookingId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shadowColor: Colors.green.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.rate_review, size: 18),
                              SizedBox(width: 10),
                              Text(
                                "Nhận Xét",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // ----------------------------------------
                  ],
                );
              } else {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: const Center(child: Text('Không có dữ liệu')),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQRCodeSection(BookingDetail booking) {
    return Center(
      child: Column(
        children: [
          const Text(
            "MÃ QR NHẬN PHÒNG",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=booking_${booking.bookingId}",
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.qr_code_2,
                      size: 100,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Đưa mã này cho nhân viên khi check-in",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // --- Các Widget hỗ trợ khác ---

  Widget _buildStatusBadge(BookingStatusEnum status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 15),
          Expanded(
            // Thêm Expanded để tránh lỗi tràn text nếu tên quá dài
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis, // Cắt bớt nếu quá dài
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceItem(
    String label,
    double price, {
    required bool isTotal,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          NumberFormat.currency(locale: 'vi', symbol: 'đ').format(price),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLeadingStatusIcon(BookingStatusEnum status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.hotel, color: color, size: 22),
    );
  }

  Color _getStatusColor(BookingStatusEnum status) {
    switch (status) {
      case BookingStatusEnum.pending:
        return Colors.orange;
      case BookingStatusEnum.checkIn:
        return Colors.blue;
      case BookingStatusEnum.checkedOut:
        return Colors.green;
      case BookingStatusEnum.canceled:
        return Colors.red;
      case BookingStatusEnum.waitingForPayment:
        return Colors.yellow.shade700; // Chỉnh lại màu vàng cho dễ nhìn hơn
    }
  }

  String _getStatusText(BookingStatusEnum status) {
    switch (status) {
      case BookingStatusEnum.pending:
        return "Chờ nhận";
      case BookingStatusEnum.checkIn:
        return "Đã nhận";
      case BookingStatusEnum.checkedOut:
        return "Đã trả";
      case BookingStatusEnum.canceled:
        return "Đã hủy";
      case BookingStatusEnum.waitingForPayment:
        return "Chờ thanh toán";
    }
  }

  // Hộp thoại nhận xét
  void _showReviewDialog(int bookingId) {
    int selectedRating = 5;
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (dialogStatefulContext, setState) {
            return AlertDialog(
              title: const Text(
                "Chia Sẻ Nhận Xét",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    // Phần rating stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.star,
                              size: 28,
                              color: index < selectedRating
                                  ? Colors.orange
                                  : Colors.grey[300],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    // Text field cho comment
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: "Viết nhận xét của bạn...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    commentController.dispose();
                  },
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (commentController.text.isEmpty) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text("Vui lòng nhập nhận xét"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    final comment = commentController.text;
                    final rating = selectedRating;

                    // Đóng review dialog
                    Navigator.pop(dialogContext);

                    // Show loading dialog
                    showDialog(
                      context: this.context,
                      barrierDismissible: false,
                      builder: (BuildContext loadingContext) {
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: Dialog(
                            backgroundColor: Colors.transparent,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );

                    try {
                      await reviewRepository.submitReview(
                        bookingId: bookingId,
                        rating: rating,
                        comment: comment,
                      );

                      // Delay để đảm bảo API xong
                      await Future.delayed(const Duration(milliseconds: 1000));

                      if (mounted) {
                        // Đóng loading dialog
                        Navigator.pop(this.context);

                        // Hiển thị snackbar thành công
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text("Gửi nhận xét thành công"),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Delay rồi đóng modal bottom sheet
                        await Future.delayed(
                          const Duration(milliseconds: 1500),
                        );
                        if (mounted) {
                          Navigator.pop(this.context);
                        }
                      }
                    } catch (e) {
                      debugPrint("Lỗi gửi nhận xét: $e");
                      if (mounted) {
                        try {
                          // Đóng loading dialog
                          Navigator.pop(this.context);
                        } catch (_) {
                          debugPrint("Loading dialog không tồn tại");
                        }

                        // Hiển thị snackbar lỗi
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text("Lỗi: ${e.toString()}"),
                            duration: const Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } finally {
                      commentController.dispose();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Gửi Nhận Xét"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
