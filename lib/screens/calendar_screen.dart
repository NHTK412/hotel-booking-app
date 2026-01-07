import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarUI extends StatefulWidget {
  const CalendarUI({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarUIState();
}

class _CalendarUIState extends State<CalendarUI> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                "Lịch Trình",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            TableCalendar(
              // --- CẤU HÌNH CƠ BẢN (LOGIC) ---
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,

              // --- CẤU HÌNH TƯƠNG TÁC ---
              selectedDayPredicate: (day) {
                // Hàm này trả về true thì ngày đó sẽ sáng lên
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay =
                      focusedDay; // Cập nhật focus để lịch không bị nhảy
                });
              },

              // --- CẤU HÌNH GIAO DIỆN (STYLING) ---
              // HeaderStyle: Chỉnh phần "September 2024" và mũi tên
              headerStyle: HeaderStyle(
                titleCentered: false, // Tiêu đề nằm bên trái như hình
                formatButtonVisible: false, // Ẩn nút chọn 2 weeks/month
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                ),
              ),

              // CalendarStyle: Cấu hình màu sắc mặc định nhanh (nếu không dùng Builders)
              calendarStyle: CalendarStyle(
                outsideDaysVisible:
                    true, // Hiển thị ngày mờ của tháng trước/sau
                defaultTextStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                weekendTextStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              // --- CUSTOM BUILDERS (QUAN TRỌNG NHẤT VỚI UI CỦA BẠN) ---
              // Dùng cái này để vẽ chính xác cái ô tròn xanh và ô nét đứt
              calendarBuilders: CalendarBuilders(
                // 1. Vẽ ngày được chọn (Màu xanh tròn đặc - số 19, 25 trong hình)
                selectedBuilder: (context, date, events) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[300], // Màu xanh nhạt giống hình
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                },

                // 2. Vẽ ngày hiện tại (Viền nét đứt/chấm - số 8 trong hình)
                // Lưu ý: Flutter không hỗ trợ border nét đứt (dashed) mặc định,
                // ta thường dùng package khác hoặc custom painter.
                // Ở đây mình dùng border dotted cơ bản để mô phỏng.
                todayBuilder: (context, date, events) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 1.5,
                        style: BorderStyle
                            .solid, // Flutter native chưa có dashed border cho BoxDecor
                      ),
                      // Mẹo: Để có nét đứt thật sự, cần dùng CustomPaint hoặc package 'dotted_border'
                      // bọc lấy cái Text này.
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            calendarMe(),
          ],
        ),
      ),
    );
  }

  Widget calendarMe() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Lịch Trình Của Tôi",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Xem Tất Cả",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          calendarItem(),

          const SizedBox(height: 20),
          calendarItem(),

          const SizedBox(height: 20),
          calendarItem(),
        ],
      ),
    );
  }

  Widget calendarItem() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image(
              image: AssetImage("assets/images/anh.avif"),
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "The Aston Vill Hotel",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "20 Dec 2023",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "\$200.7",
                        style: TextStyle(
                          color: Colors.blue, // Màu xanh chủ đạo
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: ' /night',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          IconButton(
            onPressed: () {},
            icon: Icon(Icons.navigate_next_outlined, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
