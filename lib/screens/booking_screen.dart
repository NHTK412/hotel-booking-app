import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/payment_screen.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final int roomTypeId;
  final String accommodationName;
  final String roomTypeName;
  final double price; // Giá mỗi đêm

  const BookingScreen({
    super.key,
    required this.roomTypeId,
    required this.price,
    required this.accommodationName,
    required this.roomTypeName,
  });

  @override
  State<StatefulWidget> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _anotherController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late DateTime _checkInDate;
  late DateTime _checkOutDate;

  // Cố định giờ nhận/trả phòng (Sau này có thể thay bằng dữ liệu từ API)
  final String hardcodedCheckInTime = "14:00";
  final String hardcodedCheckOutTime = "12:00";

  @override
  void initState() {
    super.initState();
    _checkInDate = DateTime.now();
    _checkOutDate = DateTime.now().add(const Duration(days: 1));
    _updateDateFields();
  }

  void _updateDateFields() {
    _dateController.text = DateFormat('dd/MM/yyyy').format(_checkInDate);
    _anotherController.text = DateFormat('dd/MM/yyyy').format(_checkOutDate);
  }

  int get _nights => _checkOutDate.difference(_checkInDate).inDays;

  double get _totalAmount => widget.price * (_nights > 0 ? _nights : 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                headerBooking(),
                const SizedBox(height: 25),
                formBooking(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomBooking(),
    );
  }

  Widget bottomBooking() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng ($_nights đêm)",
                  style: const TextStyle(color: Colors.grey),
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
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        roomTypeId: widget.roomTypeId,
                        customerName: _nameController.text,
                        customerPhone: _phoneController.text,
                        customerEmail: _emailController.text,
                        checkInDate: _checkInDate,
                        checkOutDate: _checkOutDate,
                        originPrice: _totalAmount,
                        accommodationName: widget.accommodationName,
                        roomTypeName: widget.roomTypeName,
                        checkInTime: hardcodedCheckInTime,
                        checkOutTime: hardcodedCheckOutTime,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: const Color(0xFF64BCE3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Xác Nhận Đặt Phòng",
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

  Widget formBooking() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDateInput("Ngày Nhận", _dateController, true),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildDateInput("Ngày Trả", _anotherController, false),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField(
            "Họ và Tên",
            "Nguyễn Văn A",
            Icons.person_outline,
            _nameController,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            "Số Điện Thoại",
            "0912345678",
            Icons.phone_android_outlined,
            _phoneController,
            type: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            "Email",
            "example@email.com",
            Icons.email_outlined,
            _emailController,
            type: TextInputType.emailAddress,
          ),
        ],
      ),
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: isCheckIn ? _checkInDate : _checkOutDate,
              firstDate: isCheckIn
                  ? DateTime.now()
                  : _checkInDate.add(const Duration(days: 1)),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                if (isCheckIn) {
                  _checkInDate = picked;
                  if (!_checkOutDate.isAfter(_checkInDate)) {
                    _checkOutDate = _checkInDate.add(const Duration(days: 1));
                  }
                } else {
                  _checkOutDate = picked;
                }
                _updateDateFields();
              });
            }
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: Color(0xFF64BCE3),
              size: 18,
            ),
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
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
          validator: (v) => v!.isEmpty ? "Vui lòng nhập thông tin" : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF64BCE3), size: 20),
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget headerBooking() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
      ),
      const Text(
        "Thông Tin Đặt Phòng",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(width: 45),
    ],
  );
}
