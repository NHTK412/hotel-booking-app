import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/paymentUI.dart';

class BookUi extends StatefulWidget {
  const BookUi({super.key});

  @override
  State<StatefulWidget> createState() => _BookUiState();
}

class _BookUiState extends State<BookUi> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _anotherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String formattedDate =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    _dateController.text = formattedDate;

    String anotherFormattedDate =
        "${DateTime.now().day + 1}/${DateTime.now().month}/${DateTime.now().year}";
    _anotherController.text = anotherFormattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Màu nền sáng
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              headerBooking(),
              const SizedBox(height: 25),
              formBooking(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBooking(),
    );
  }

  Widget bottomBooking() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tổng giá tiền",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "1,200,000 VND",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF64BCE3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  "Đã bao gồm thuế & phí",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 15),
            buttonBooking(),
          ],
        ),
      ),
    );
  }

  Widget buttonBooking() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentUI()),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: const Color(0xFF64BCE3),
        elevation: 0,
      ),
      child: const Text(
        "Xác Nhận Đặt Phòng",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ngày nhận/trả phòng
          Row(
            children: [
              Expanded(
                child: _buildInputLabel(
                  "Ngày Nhận",
                  _dateController,
                  Icons.calendar_today,
                  isDate: true,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildInputLabel(
                  "Ngày Trả",
                  _anotherController,
                  Icons.calendar_today,
                  isDate: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildTextField(
            "Họ và Tên",
            "Ví dụ: Nguyễn Văn A",
            Icons.person_outline,
          ),
          const SizedBox(height: 20),

          _buildTextField(
            "Số Điện Thoại",
            "Ví dụ: 0912345678",
            Icons.phone_android_outlined,
            type: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          _buildTextField(
            "Email",
            "Ví dụ: example@email.com",
            Icons.email_outlined,
            type: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  // Widget dùng chung cho Label + TextField
  Widget _buildTextField(
    String label,
    String hint,
    IconData icon, {
    TextInputType type = TextInputType.text,
  }) {
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
        TextField(
          keyboardType: type,
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
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ],
    );
  }

  // Widget dùng riêng cho Date Picker
  Widget _buildInputLabel(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isDate = false,
  }) {
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
        TextField(
          controller: controller,
          readOnly: true,
          onTap: isDate ? () => _selectDate(context, controller) : null,
          decoration: InputDecoration(
            hintText: "dd/mm/yyyy",
            prefixIcon: Icon(icon, color: const Color(0xFF64BCE3), size: 18),
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Không cho chọn ngày quá khứ
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
        ),
        const Text(
          "Thông Tin Đặt Phòng",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 45),
      ],
    );
  }
}
