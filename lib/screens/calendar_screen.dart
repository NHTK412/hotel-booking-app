import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/data/model/booking/booking_summary.dart';
import 'package:hotel_booking_app/data/repositories/booking_repostiory.dart';
import 'package:hotel_booking_app/data/service/booking_service.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hotel_booking_app/data/enum/booking_status_enum.dart';
import 'package:hotel_booking_app/data/model/booking/booking_detail.dart';
// Import Repository của bạn
// import 'package:hotel_booking_app/data/repository/booking_repository.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final BookingRepository _bookingRepository = BookingRepository(
    bookingService: BookingService(),
  );

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // LIST 1: Dùng để hiện dấu chấm trên lịch (Lấy theo Tháng)
  List<BookingSummary> _monthEvents = [];

  // LIST 2: Dùng để hiện danh sách chi tiết bên dưới (Lấy theo Ngày)
  List<BookingSummary> _selectedDayBookings = [];

  bool _isLoadingList = false; // Loading cho phần danh sách dưới

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    // 1. Lấy dữ liệu tổng quan cho tháng hiện tại (để hiện chấm)
    _fetchMonthBookings(_focusedDay);

    // 2. Lấy chi tiết đơn của ngày hôm nay (để hiện list)
    _fetchDayBookings(_focusedDay);
  }

  // --- API 1: Lấy dữ liệu theo THÁNG (để hiện Marker trên lịch) ---
  Future<void> _fetchMonthBookings(DateTime date) async {
    try {
      final response = await _bookingRepository.getBookingByMe(
        // month: date.month,
        // year: date.year,
        month: 1,
        year: 2026,
        size: 100, // Lấy số lượng lớn để bao phủ cả tháng
        status: BookingStatusEnum
            .wattingForPayment, // Chỉ lấy các booking đang chờ xử lý
      );

      setState(() {
        _monthEvents = response.data ?? [];
      });
    } catch (e) {
      debugPrint("Lỗi lấy dữ liệu tháng: $e");
    }
  }

  // --- API 2: Lấy dữ liệu theo NGÀY (để hiện List bên dưới) ---
  Future<void> _fetchDayBookings(DateTime date) async {
    setState(() {
      _isLoadingList = true;
      _selectedDayBookings = []; // Clear list cũ trước khi load mới
    });

    try {
      debugPrint(
        "Fetching bookings for day: ${date.day}-${date.month}-${date.year}",
      );
      final response = await _bookingRepository.getBookingByMe(
        day: date.day, // Truyền thêm Day
        month: date.month,
        year: date.year,
        size: 50,
        status: BookingStatusEnum.wattingForPayment,
      );

      setState(() {
        _selectedDayBookings = response.data ?? [];
      });
    } catch (e) {
      debugPrint("Lỗi lấy dữ liệu ngày: $e");
    } finally {
      setState(() {
        _isLoadingList = false;
      });
    }
  }

  // Hàm filter local dùng cho eventLoader của TableCalendar
  // Nó lấy từ _monthEvents để quyết định ngày nào có dấu chấm
  List<BookingSummary> _getEventsForDay(DateTime day) {
    return _monthEvents
        .where((booking) => isSameDay(booking.checkInAt, day))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildTopBar(),
            const SizedBox(height: 20),
            _buildCalendarCard(),
            const SizedBox(height: 20),
            _buildListHeader(),

            // Hiển thị loading riêng cho phần list hoặc hiển thị danh sách
            Expanded(
              child: _isLoadingList
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBookingList(_selectedDayBookings),
            ),
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

        // Cấu hình Header
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        // Cấu hình Style
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

        // 1. Khi chọn ngày -> Gọi API lấy chi tiết ngày đó
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            // Gọi API lấy list chi tiết cho ngày được chọn
            _fetchDayBookings(selectedDay);
          }
        },

        // 2. Khi lướt qua tháng mới -> Gọi API lấy dữ liệu marker cho tháng đó
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
          _fetchMonthBookings(focusedDay);
        },

        // 3. Load dấu chấm từ dữ liệu tháng (_monthEvents)
        eventLoader: _getEventsForDay,
      ),
    );
  }

  Widget _buildListHeader() {
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
            onPressed: () => context.push("/calendar_detail"),
            icon: const Icon(Icons.list_alt, size: 18),
            label: const Text("Tất cả"),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<BookingSummary> bookings) {
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

  Widget _buildBookingItem(BookingSummary booking) {
    // (Code UI Item giữ nguyên như cũ)
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

  // --- Các hàm Helper UI ---
  Color _getStatusColor(BookingStatusEnum status) {
    switch (status) {
      case BookingStatusEnum.pending:
        return const Color(0xFFF57C00); // Muted orange
      case BookingStatusEnum.checkIn:
        return const Color(0xFF1976D2); // Muted blue
      case BookingStatusEnum.checkedOut:
        return const Color(0xFF388E3C); // Muted green
      case BookingStatusEnum.canceled:
        return const Color(0xFFD32F2F); // Muted red
      case BookingStatusEnum.wattingForPayment:
        return const Color(0xFFFBC02D); // Muted yellow
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
      case BookingStatusEnum.pending:
        return Icons.access_time_rounded;
      case BookingStatusEnum.checkIn:
        return Icons.login_rounded;
      case BookingStatusEnum.checkedOut:
        return Icons.logout_rounded;
      case BookingStatusEnum.canceled:
        return Icons.cancel_outlined;
      case BookingStatusEnum.wattingForPayment:
        return Icons.payment_rounded;
    }
  }
}
