import 'package:flutter/material.dart';
import 'package:hotel_booking_app/data/enum/booking_status_enum.dart';
import 'package:hotel_booking_app/data/model/booking/booking_detail.dart';
import 'package:intl/intl.dart';

class CalendarDetailScreen extends StatefulWidget {
  const CalendarDetailScreen({super.key});

  @override
  _CalendarDetailScreenState createState() => _CalendarDetailScreenState();
}

class _CalendarDetailScreenState extends State<CalendarDetailScreen> {
  final List<BookingDetail> _mockData = [
    BookingDetail(
      bookingId: 3,
      checkInDate: DateTime.parse("2026-01-03"),
      checkOutDate: DateTime.parse("2026-01-05"),
      customerEmail: "nguyenhuutuankhang412@gmail.com",
      customerName: "Nguyễn Hữu Tuấn Khang",
      customerPhone: "058205002155",
      discountedPrice: 10000,
      finalPrice: 90000,
      originalPrice: 100000,
      status: BookingStatusEnum.peding,
    ),
    BookingDetail(
      bookingId: 4,
      checkInDate: DateTime.now(),
      checkOutDate: DateTime.now().add(const Duration(days: 2)),
      customerEmail: "customer@example.com",
      customerName: "Trần Thị B",
      customerPhone: "0901234567",
      discountedPrice: 0,
      finalPrice: 250000,
      originalPrice: 250000,
      status: BookingStatusEnum.checkIn,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
            onPressed: () => Navigator.pop(context),
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
              Tab(text: "Chờ nhận"),
              Tab(text: "Đã nhận"),
              Tab(text: "Đã trả"),
              Tab(text: "Đã hủy"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListByStatus(BookingStatusEnum.peding),
            _buildListByStatus(BookingStatusEnum.checkIn),
            _buildListByStatus(BookingStatusEnum.checkedOut),
            _buildListByStatus(BookingStatusEnum.canceled),
          ],
        ),
      ),
    );
  }

  Widget _buildListByStatus(BookingStatusEnum status) {
    final filteredList = _mockData.where((b) => b.status == status).toList();

    if (filteredList.isEmpty) {
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) => _buildBookingCard(filteredList[index]),
    );
  }

  Widget _buildBookingCard(BookingDetail booking) {
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
          onTap: () => _showBookingDetailModal(booking),
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
                      "${DateFormat('dd/MM').format(booking.checkInDate)} - ${DateFormat('dd/MM').format(booking.checkOutDate)}",
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

  void _showBookingDetailModal(BookingDetail booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height:
            MediaQuery.of(context).size.height *
            0.85, // Tăng chiều cao để chứa mã QR
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  _buildStatusBadge(booking.status),
                ],
              ),
              const SizedBox(height: 25),
              _buildInfoTile(
                Icons.person_outline,
                "Khách hàng",
                booking.customerName,
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
              const Divider(height: 30),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoTile(
                      Icons.login_rounded,
                      "Check-in",
                      DateFormat('dd/MM/yyyy').format(booking.checkInDate),
                    ),
                  ),
                  Expanded(
                    child: _buildInfoTile(
                      Icons.logout_rounded,
                      "Check-out",
                      DateFormat('dd/MM/yyyy').format(booking.checkOutDate),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Phần QR Code
              _buildQRCodeSection(booking),
              const SizedBox(height: 25),
              // Phần Thanh toán
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
                      -booking.discountedPrice,
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
            ],
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
                "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=booking_${booking.bookingId}",
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 150,
                    height: 150,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.qr_code_2,
                      size: 80,
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

  // --- Các Widget hỗ trợ khác (Giữ nguyên logic cũ nhưng tối ưu UI) ---

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
          Column(
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
              ),
            ],
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
      case BookingStatusEnum.peding:
        return Colors.orange;
      case BookingStatusEnum.checkIn:
        return Colors.blue;
      case BookingStatusEnum.checkedOut:
        return Colors.green;
      case BookingStatusEnum.canceled:
        return Colors.red;
    }
  }

  String _getStatusText(BookingStatusEnum status) {
    switch (status) {
      case BookingStatusEnum.peding:
        return "Chờ nhận";
      case BookingStatusEnum.checkIn:
        return "Đã nhận";
      case BookingStatusEnum.checkedOut:
        return "Đã trả";
      case BookingStatusEnum.canceled:
        return "Đã hủy";
    }
  }
}
