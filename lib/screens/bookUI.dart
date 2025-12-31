import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/paymentUI.dart';

class BookUi extends StatefulWidget {
  const BookUi({super.key});

  @override
  State<StatefulWidget> createState() => _BookUiState();
}

class _BookUiState extends State<BookUi> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _anotherController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              headerBooking(),
              const SizedBox(height: 30),
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
      // height: 190,
      decoration: BoxDecoration(
        color: Colors.white,
        // Ở khung ở trên
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      padding: EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Tổng Giá Tiền",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(), // Đẩy phần giá tiền về bên phải
                // Công dụng của Widget Spacer là tạo ra một khoảng trống linh hoạt giữa các widget con trong một Row, Column hoặc Flex.
                Row(
                  children: [
                    Text(
                      "1,200,000 VND",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64BCE3),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(Icons.info_outline, color: Colors.grey),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Spacer(),
                Text("Đã bao gồm thuế", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
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
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Color(0xFF64BCE3),
        foregroundColor: Colors.white,
      ),
      child: Text("Tiếp Tục", style: TextStyle(fontSize: 18)),
    );
  }

  Widget formBooking() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0), // Thêm padding cho đỡ sát lề
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HÀNG CHỨA 2 NGÀY (Dùng Expanded để chia đôi) ---
          Row(
            children: [
              // Cột 1: Ngày nhận phòng
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ngày Nhận Phòng",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _dateController,
                      readOnly: true, // Chỉ đọc, chặn bàn phím
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "dd/mm/yyyy",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        suffixIcon: Icon(Icons.calendar_today, size: 20),
                        isDense: true, // Giúp ô input gọn hơn
                      ),
                      onTap: () => _selectDate(context, _dateController),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16), // Khoảng cách giữa 2 ô ngày
              // Cột 2: Ngày trả phòng
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ngày Trả Phòng",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _anotherController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "dd/mm/yyyy",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        suffixIcon: Icon(Icons.calendar_today, size: 20),
                        isDense: true,
                      ),
                      onTap: () => _selectDate(context, _anotherController),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --- HỌ VÀ TÊN ---
          Text(
            "Họ và Tên",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ví dụ: Nguyễn Văn A",
              prefixIcon: Icon(Icons.person), // Thêm icon cho trực quan
            ),
          ),

          const SizedBox(height: 20),

          // --- SỐ ĐIỆN THOẠI (Quan trọng: Keyboard Type) ---
          Text(
            "Số Điện Thoại",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.phone, // <--- Bàn phím số
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ví dụ: 0912345678",
              prefixIcon: Icon(Icons.phone),
            ),
          ),

          const SizedBox(height: 20),

          // --- EMAIL (Quan trọng: Keyboard Type) ---
          Text(
            "Email",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.emailAddress, // <--- Bàn phím Email (@)
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ví dụ: example@email.com",
              prefixIcon: Icon(Icons.email),
            ),
          ),
        ],
      ),
    );
  }

  // --- HÀM RIÊNG ĐỂ XỬ LÝ CHỌN NGÀY (Tránh lặp code) ---
  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Widget headerBooking() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),

          Text(
            "Thông Tin Đặt Phòng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
