import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/roomtype/room_type_detail.dart';
import 'package:hotel_booking_app/data/model/roomtype/room_type_summary.dart';
import 'package:hotel_booking_app/data/repositories/location_repository.dart';
import 'package:hotel_booking_app/data/repositories/room_type_repository.dart';
import 'package:hotel_booking_app/data/service/location_service.dart';
import 'package:hotel_booking_app/data/service/room_type_service.dart';
import 'package:intl/intl.dart';

class FilterHotelScreen extends StatefulWidget {
  const FilterHotelScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FilterHotelScreenState();
}

class _FilterHotelScreenState extends State<FilterHotelScreen> {
  late String _location;

  late List<RoomTypeSummary> roomTypes;

  final RoomTypeService _roomTypeService = RoomTypeService();

  bool _isLoading = false;
  String? _errorMessage;

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

  Future<void> _fetchRoomTypes() async {
    final String checkInDate = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDateRange.start);
    final String checkOutDate = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDateRange.end);

    final int? capacity = (_guests <= 0) ? null : _guests;
    final int? bedrooms = (_rooms <= 0) ? null : _rooms;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    List<RoomTypeSummary> fetchedRoomTypes = [];
    String? error;

    try {
      // final response = await _roomTypeService.getAllRoomTypes(
      //   checkInDate: checkInDate,
      //   checkOutDate: checkOutDate,
      //   capacity: capacity,
      //   bedrooms: bedrooms,
      // );

      // final ApiResponse<List<RoomTypeSummary>> apiResponse =
      //     ApiResponse.fromJson(
      //       response.statusCode,
      //       response.data,
      //       (data) => (data as List)
      //           .map(
      //             (item) =>
      //                 RoomTypeSummary.fromJson(item as Map<String, dynamic>),
      //           )
      //           .toList(),
      //     );

      List<String> address = _location.split(', ');

      String city = address.isNotEmpty ? address.last : '';
      String? district = address.length > 1
          ? address[address.length - 2]
          : null;

      final ApiResponse<List<RoomTypeSummary>> apiResponse =
          await RoomTypeRepository(RoomTypeService()).getAllRoomTypes(
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            capacity: capacity,
            bedrooms: bedrooms,
            city: city,
            district: district,
          );

      roomTypes = apiResponse.data ?? [];

      if (apiResponse.success == true) {
        fetchedRoomTypes = apiResponse.data ?? [];
      } else {
        error = apiResponse.message ?? 'Không thể tải danh sách phòng.';
      }
    } catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _errorMessage = error;
      roomTypes = (error == null) ? fetchedRoomTypes : [];
    });
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
                onPressed: value > 0 ? () => onChange(value - 1) : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: value > 0 ? Colors.redAccent : Colors.grey,
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
              if (_isLoading)
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              else if (_errorMessage != null)
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                )
              else if (roomTypes.isEmpty)
                Container(
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
          Row(
            children: [
              Expanded(
                child: _buildFormRow(
                  icon: Icons.location_on,
                  iconColor: Colors.redAccent,
                  label: "Điểm đến, khách sạn",
                  value: _location,
                  onTap: () async {
                    final String? locationSelect = await context.push(
                      "/locations",
                    );
                    if (locationSelect != null) {
                      setState(() => _location = locationSelect);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  context.push("/map");
                },
                icon: Icon(Icons.map, color: Colors.grey[400], size: 28),
              ),
            ],
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
              _fetchRoomTypes();
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
    // Helper để check nhanh
    bool hasDiscount = roomType?.hasDiscount ?? false;

    return GestureDetector(
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
            // --- 1. ẢNH & BADGE GIẢM GIÁ ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    "${AppConfig.baseUrl}images/${roomType?.image}",
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    // Fallback nếu ảnh lỗi hoặc null thì hiện ảnh asset cũ
                    errorBuilder: (context, error, stackTrace) => const Image(
                      image: AssetImage("assets/images/anh.avif"),
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Badge giảm giá
                if (hasDiscount)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        roomType?.getDiscountLabel() ?? "", // Vd: -20%
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 15),

            // --- 2. THÔNG TIN CHI TIẾT ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên và Sao
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          roomType?.name ?? "Tên phòng",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            roomType?.star.toString() ?? "0",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Địa chỉ (Có thể lấy từ model nếu có field address)
                  Text(
                    "Alice Springs, Australia",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  const SizedBox(
                    height: 8,
                  ), // Giảm khoảng cách chút cho cân đối
                  // --- GIÁ TIỀN (LOGIC MỚI) ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nếu có giảm giá -> Hiện giá gốc gạch ngang
                      if (hasDiscount)
                        Text(
                          "${roomType?.getOriginalPriceToString()} VNĐ",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),

                      // Giá cuối cùng (Màu nổi)
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${roomType?.getFinalPriceToString() ?? "0"} VNĐ',
                              style: TextStyle(
                                color: hasDiscount
                                    ? Colors.redAccent
                                    : const Color(0xFF64BCE3),
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
