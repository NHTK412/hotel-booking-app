import 'package:flutter/material.dart';

class PaymentUI extends StatefulWidget {
  const PaymentUI({super.key});

  @override
  State<StatefulWidget> createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám nhạt hiện đại
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerBooking(),
              const SizedBox(height: 25),

              /*  const Text(
                "Chi Tiết Đơn Hàng",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),*/
              detailBooking(),

              const SizedBox(height: 25),
              infoBooking(),

              const SizedBox(height: 25),
              paymentMethod(),
              const SizedBox(height: 20),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tổng cộng",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
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
                buttonBooking(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonBooking() {
    return ElevatedButton(
      onPressed: () {
        // Xử lý đặt phòng thành công
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: const Color(0xFF64BCE3),
        elevation: 0,
      ),
      child: const Text(
        "Đặt Ngay",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget paymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Phương Thức Thanh Toán",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF64BCE3),
              width: 1.5,
            ), // Hiệu ứng đang chọn
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Image.network(
                  "https://pngimg.com/uploads/paypal/paypal_PNG9.png",
                  width: 40,
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                "Paypal",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.check_circle, color: Color(0xFF64BCE3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget infoBooking() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thông Tin Khách Hàng",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildInfoRow("Họ và tên", "Nguyen Van A"),
          _buildInfoRow("Số Điện Thoại", "0123456789"),
          _buildInfoRow("Email", "example@example.com", isLast: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.grey.shade100, thickness: 1),
          ),
      ],
    );
  }

  Widget detailBooking() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15),
        ],
      ),
      child: Column(
        children: [
          // Header Khách sạn
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color(0xFF64BCE3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.hotel_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Pullman Vũng Tàu",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chi tiết phòng
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Superior Room, City View",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildMiniDetail(Icons.nightlight_round, "3 Đêm"),
                    const SizedBox(width: 20),
                    _buildMiniDetail(Icons.people, "2 Người"),
                  ],
                ),
                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 15),
                _buildDateRow("Nhận phòng", "Thứ 4, 02/02/2022"),
                const SizedBox(height: 10),
                _buildDateRow("Trả phòng", "Thứ 6, 04/02/2022"),
                const SizedBox(height: 15),
                _buildPolicyRow(
                  Icons.check_circle_outline,
                  "Miễn phí hủy phòng",
                  Colors.green,
                ),
                _buildPolicyRow(Icons.sync, "Áp dụng đổi lịch", Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }

  Widget _buildDateRow(String label, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          date,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPolicyRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
        ),
        const Text(
          // "Thanh Toán",
          "Chi Tiết Đơn Hàng",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 45),
      ],
    );
  }
}
