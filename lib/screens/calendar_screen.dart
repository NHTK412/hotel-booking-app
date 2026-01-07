import 'package:flutter/material.dart';
import 'package:hotel_booking_app/data/enum/booking_status_enum.dart';
import 'package:hotel_booking_app/data/model/booking/booking_detail.dart';
// import 'package:hotel_booking_app/models/booking_detail.dart';
import 'package:hotel_booking_app/screens/calendar_detail_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Khởi tạo giá trị mặc định để tránh lỗi Null
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Giả lập danh sách dữ liệu từ Backend
  final List<BookingDetail> _allBookings = [
    BookingDetail(
      bookingId: 3,
      checkInDate: DateTime.parse("2026-01-08"),
      checkOutDate: DateTime.parse("2026-01-10"),
      customerEmail: "khang@gmail.com",
      customerName: "Nguyễn Hữu Tuấn Khang",
      customerPhone: "058205002155",
      discountedPrice: 0.1,
      finalPrice: 100000,
      originalPrice: 100000,
      status: BookingStatusEnum.peding,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Đảm bảo _selectedDay có giá trị ngay từ đầu
    _selectedDay = _focusedDay;
  }

  List<BookingDetail> _getFilteredBookings(DateTime day) {
    return _allBookings
        .where((booking) => isSameDay(booking.checkInDate, day))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng toán tử ?? để tránh null khi lọc
    final selectedBookings = _getFilteredBookings(
      _selectedDay ?? DateTime.now(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Màu nền sáng chuyên nghiệp
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildTopBar(),
            const SizedBox(height: 20),
            _buildCalendarCard(),
            const SizedBox(height: 20),
            _buildListHeader(),
            Expanded(child: _buildBookingList(selectedBookings)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Lịch Trình Đặt Phòng",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        calendarStyle: CalendarStyle(
          markerDecoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent, width: 1),
          ),
          todayTextStyle: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        eventLoader: _getFilteredBookings,
      ),
    );
  }

  Widget _buildListHeader() {
    // Sửa lỗi ở đây: Sử dụng toán tử ?? để đảm bảo không bị crash nếu _selectedDay null
    String dateLabel = DateFormat(
      'dd MMMM, yyyy',
    ).format(_selectedDay ?? DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Danh sách đơn",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                dateLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CalendarDetailScreen(),
              ),
            ),
            icon: const Icon(Icons.list_alt, size: 18),
            label: const Text("Tất cả"),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<BookingDetail> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 12),
            Text(
              "Không có lịch trình ngày này",
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: bookings.length,
      itemBuilder: (context, index) => _buildBookingItem(bookings[index]),
    );
  }

  Widget _buildBookingItem(BookingDetail booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          _getStatusIcon(booking.status),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Phone: ${booking.customerPhone}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
              const SizedBox(height: 4),
              Text(
                "${booking.status.name}",
                style: TextStyle(
                  fontSize: 11,
                  color: _getStatusColor(booking.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
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

  Widget _getStatusIcon(BookingStatusEnum status) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getIconData(status),
        color: _getStatusColor(status),
        size: 20,
      ),
    );
  }

  IconData _getIconData(BookingStatusEnum status) {
    switch (status) {
      case BookingStatusEnum.peding:
        return Icons.access_time_rounded;
      case BookingStatusEnum.checkIn:
        return Icons.login_rounded;
      case BookingStatusEnum.checkedOut:
        return Icons.logout_rounded;
      case BookingStatusEnum.canceled:
        return Icons.cancel_outlined;
    }
  }
}
