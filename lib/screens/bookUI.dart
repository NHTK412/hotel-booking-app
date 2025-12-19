import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/paymentUI.dart';

class BookUi extends StatefulWidget {
  const BookUi({super.key});

  @override
  State<StatefulWidget> createState() => _BookUiState();
}

class _BookUiState extends State<BookUi> {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Họ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ví dụ: Nguyễn",
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Tên Đệm Và Tên",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ví dụ: Văn A",
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Số Điện Thoại",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ví dụ: 0123456789",
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Email",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ví dụ: example@email.com",
            ),
          ),
        ],
      ),
    );
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
