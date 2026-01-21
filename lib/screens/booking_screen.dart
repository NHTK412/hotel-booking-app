import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/app_router.dart'; // Đảm bảo import BookingParams
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final BookingParams bookingParams;

  const BookingScreen({super.key, required this.bookingParams});

  @override
  State<StatefulWidget> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _dateCheckInController = TextEditingController();
  final TextEditingController _dateCheckOutController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late DateTime _checkInDate;
  late DateTime _checkOutDate;

  // Cố định giờ nhận/trả phòng
  final String hardcodedCheckInTime = "14:00";
  final String hardcodedCheckOutTime = "12:00";

  // --- HÀM HELPER CHUẨN HÓA NGÀY (QUAN TRỌNG) ---
  // Loại bỏ giờ phút giây để tính toán số đêm chính xác
  DateTime _onlyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    // Khởi tạo ngày mặc định (đã loại bỏ giờ phút)
    _checkInDate = _onlyDate(now);
    _checkOutDate = _checkInDate.add(const Duration(days: 1));

    // Điền dữ liệu giả lập để test cho nhanh (Có thể xóa sau này)
    _nameController.text = "Nguyễn Hữu Tuấn Khang";
    _phoneController.text = "0912345678";
    _emailController.text = "tuankhang@gmail.com";

    _updateDateFields();
  }

  void _updateDateFields() {
    _dateCheckInController.text = DateFormat('dd/MM/yyyy').format(_checkInDate);
    _dateCheckOutController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(_checkOutDate);
  }

  // Logic tính số đêm chính xác
  int get _nights {
    DateTime start = _onlyDate(_checkInDate);
    DateTime end = _onlyDate(_checkOutDate);
    int days = end.difference(start).inDays;
    return days > 0 ? days : 1; // Tối thiểu 1 đêm
  }

  // Logic tính tổng tiền
  double get _totalAmount {
    // Giá gốc
    double original = widget.bookingParams.originalPrice;
    // % Giảm giá (ví dụ 20.0)
    double discountPercent =
        widget.bookingParams.discountedPrice; // Bạn đang lưu % vào biến này

    // Giá sau giảm mỗi đêm
    double pricePerNight = original * (1 - (discountPercent / 100));

    return pricePerNight * _nights;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header cố định
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildHeader(),
            ),

            // Nội dung cuộn được
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildFormBooking(),
                      const SizedBox(
                        height: 100,
                      ), // Khoảng trống dưới cùng để không bị che bởi bottom bar
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBooking(),
    );
  }

  // --- WIDGETS ---

  Widget _buildHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        style: IconButton.styleFrom(backgroundColor: Colors.white),
      ),
      const Text(
        "Thông Tin Đặt Phòng",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(width: 45), // Placeholder để cân giữa
    ],
  );

  Widget _buildFormBooking() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Hàng chọn ngày
          Row(
            children: [
              Expanded(
                child: _buildDateInput(
                  "Ngày Nhận",
                  _dateCheckInController,
                  true,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildDateInput(
                  "Ngày Trả",
                  _dateCheckOutController,
                  false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Các trường nhập liệu
          _buildTextField(
            "Họ và Tên",
            "Nhập họ tên",
            Icons.person_outline,
            _nameController,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            "Số Điện Thoại",
            "Nhập số điện thoại",
            Icons.phone_android_outlined,
            _phoneController,
            type: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            "Email",
            "Nhập địa chỉ email",
            Icons.email_outlined,
            _emailController,
            type: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBooking() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 15, spreadRadius: 2),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dòng 1: Đơn giá gốc
            _buildPriceRow(
              "Đơn giá / đêm",
              "${NumberFormat("#,###").format(widget.bookingParams.originalPrice)} VND",
            ),
            const SizedBox(height: 8),

            // Dòng 2: Giảm giá (Nếu có)
            if (widget.bookingParams.discountedPrice > 0)
              _buildPriceRow(
                "Giảm giá",
                "-${NumberFormat("#,###").format(widget.bookingParams.discountedPrice)} %",
                valueColor: Colors.redAccent,
              ),
            if (widget.bookingParams.discountedPrice > 0)
              const SizedBox(height: 8),

            const Divider(),
            const SizedBox(height: 8),

            // Dòng 3: Tổng cộng
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng ($_nights đêm)",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${NumberFormat("#,###").format(_totalAmount)} VND",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64BCE3),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Nút Xác nhận
            ElevatedButton(
              onPressed: _handleBooking,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: const Color(0xFF64BCE3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Xác Nhận Đặt Phòng",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS ---

  void _handleBooking() {
    if (_formKey.currentState!.validate()) {
      final BookingParams finalParams = widget.bookingParams.copyWith(
        customerName: _nameController.text,
        customerPhone: _phoneController.text,
        customerEmail: _emailController.text,
        checkInDate: _checkInDate,
        checkOutDate: _checkOutDate,
        checkInTime: hardcodedCheckInTime,
        checkOutTime: hardcodedCheckOutTime,
      );

      // Chuyển sang màn hình thanh toán
      context.push("/payment", extra: finalParams);
    }
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    Color valueColor = Colors.grey,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDateInput(
    String label,
    TextEditingController controller,
    bool isCheckIn,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _pickDate(isCheckIn),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: Color(0xFF64BCE3),
              size: 18,
            ),
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(bool isCheckIn) async {
    final initialDate = isCheckIn ? _checkInDate : _checkOutDate;
    final firstDate = isCheckIn
        ? DateTime.now()
        : _checkInDate.add(
            const Duration(days: 1),
          ); // Checkout ít nhất phải sau checkin 1 ngày

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF64BCE3), // Màu header datepicker
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
        // Chuẩn hóa ngày vừa chọn (bỏ giờ)
        picked = _onlyDate(picked!);

        if (isCheckIn) {
          _checkInDate = picked!;
          // Nếu ngày trả phòng bé hơn hoặc bằng ngày nhận -> Đẩy ngày trả lên +1
          if (!_checkOutDate.isAfter(_checkInDate)) {
            _checkOutDate = _checkInDate.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked!;
        }
        _updateDateFields();
      });
    }
  }

  Widget _buildTextField(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: type,
          validator: (v) {
            if (v == null || v.isEmpty) return "Vui lòng nhập $label";
            if (type == TextInputType.emailAddress && !v.contains("@"))
              return "Email không hợp lệ";
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFF64BCE3), size: 20),
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}
