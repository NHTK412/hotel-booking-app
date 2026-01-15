import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/data/model/roomtype/room_type_summary.dart';

class FilterHotelScreen extends StatefulWidget {
  const FilterHotelScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FilterHotelScreenState();
}

class _FilterHotelScreenState extends State<FilterHotelScreen> {
  late String _location;

  late List<RoomTypeSummary> roomTypes;

  // Logic chọn ngày: Mặc định từ hôm nay đến ngày mai
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );

  // Logic chọn phòng và khách
  int _rooms = 1;
  int _guests = 2;

  @override
  void initState() {
    super.initState();
    _location = "Khách sạn gần bạn";

    // roomTypes = [
    //   RoomTypeSummary(
    //     roomTypeId: 1,
    //     name: "Phòng Deluxe",
    //     star: 5,
    //     price: 150000.0,
    //     image: "deluxe_room.jpg",
    //   ),
    //   RoomTypeSummary(
    //     roomTypeId: 2,
    //     name: "Phòng Superior",
    //     star: 4,
    //     price: 120000.0,
    //     image: "superior_room.jpg",
    //   ),
    //   RoomTypeSummary(
    //     roomTypeId: 3,
    //     name: "Phòng Standard",
    //     star: 3,
    //     price: 100000.0,
    //     image: "standard_room.jpg",
    //   ),
    // ];

    roomTypes = [];
  }

  // Hàm format ngày hiển thị
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Hàm xử lý chọn khoảng ngày
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF64BCE3),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  // Hàm hiển thị bộ chọn số phòng & khách
  void _showGuestPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Số lượng cụ thể",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildCounterRow("Số phòng", _rooms, (val) {
                    setModalState(() => _rooms = val);
                    setState(() {});
                  }),
                  const Divider(),
                  _buildCounterRow("Số khách", _guests, (val) {
                    setModalState(() => _guests = val);
                    setState(() {});
                  }),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64BCE3),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Xác nhận",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCounterRow(String title, int value, Function(int) onChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              IconButton(
                onPressed: value > 1 ? () => onChange(value - 1) : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: value > 1 ? Colors.redAccent : Colors.grey,
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 30),
                child: Text(
                  "$value",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () => onChange(value + 1),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFF64BCE3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerBooking(),
              const SizedBox(height: 25),
              findForm(),
              const SizedBox(height: 30),
              const Text(
                "Danh sách phòng",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // ListView.separated(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: 4,
              //   separatorBuilder: (context, index) =>
              //       const SizedBox(height: 15),
              //   itemBuilder: (context, index) => createPopularCard(),
              // ),
              if (roomTypes.isEmpty)
                Container(
                  // height: double.infinity,
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.room_preferences,
                          size: 50,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Không có phòng nào",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: roomTypes.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) =>
                      createPopularCard(roomTypes[index]),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget findForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFormRow(
            icon: Icons.location_on,
            iconColor: Colors.redAccent,
            label: "Điểm đến, khách sạn",
            value: _location,
            onTap: () async {
              final String? locationSelect = await context.push("/locations");
              if (locationSelect != null) {
                setState(() => _location = locationSelect);
              }
            },
          ),
          const Divider(height: 30),

          // Mục: Ngày Nhận & Ngày Trả
          Row(
            children: [
              Expanded(
                child: _buildFormRow(
                  icon: Icons.calendar_today,
                  iconColor: Colors.green,
                  label: "Ngày nhận phòng",
                  value: _formatDate(_selectedDateRange.start),
                  onTap: () => _selectDateRange(context),
                ),
              ),
              Container(height: 40, width: 1, color: Colors.grey[200]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: _buildFormRow(
                    label: "Ngày trả phòng",
                    value: _formatDate(_selectedDateRange.end),
                    onTap: () => _selectDateRange(context),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 30),

          // Mục: Khách hàng & Phòng
          _buildFormRow(
            icon: Icons.people,
            iconColor: Colors.blue,
            label: "Số phòng và khách",
            value: "$_rooms phòng, $_guests khách",
            onTap: () => _showGuestPicker(context),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF64BCE3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              elevation: 0,
            ),
            onPressed: () {
              // Xử lý tìm kiếm với các biến: _location, _selectedDateRange, _rooms, _guests
            },
            child: const Text(
              "Tìm Phòng Ngay",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormRow({
    IconData? icon,
    Color? iconColor,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 15),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createPopularCard(RoomTypeSummary? roomType) {
    return GestureDetector(
      // onTap: () => context.push("/room-type/1"),
      onTap: () => context.push('/room-type/${roomType?.roomTypeId ?? 0}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: const Image(
                image: AssetImage("assets/images/anh.avif"),
                // image: AssetImage("assets/images/hotel1.jpg"),
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          // "The Aston Vill Hotel",
                          roomType?.name ?? "Tên phòng",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            // '5.0',
                            roomType?.star.toString() ?? "0",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Alice Springs, Australia",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          // text: '\$200.7',
                          text: '${roomType?.getPriceToString() ?? "0"} VNĐ',
                          style: TextStyle(
                            color: Color(0xFF64BCE3),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        TextSpan(
                          text: ' / đêm',
                          style: TextStyle(
                            color: Colors.grey[400],
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
      ),
    );
  }

  Widget headerBooking() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
        ),
        const Text(
          "Tìm Phòng",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}
