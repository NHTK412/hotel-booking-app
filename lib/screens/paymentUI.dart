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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerBooking(),
              const SizedBox(height: 30),

              Text(
                "Chi Tiết Đơn Hàng",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              detailBooking(),

              const SizedBox(height: 20),

              // formBooking(),
              infoBooking(),

              const SizedBox(height: 10),

              paymentMethod(),

              // Divider(color: Colors.grey.shade400),
              // const SizedBox(height: 20),
              // bottomBooking(),
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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const PaymentUI()),
        // );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Color(0xFF64BCE3),
        foregroundColor: Colors.white,
      ),
      child: Text("Đặt Phòng", style: TextStyle(fontSize: 18)),
    );
  }

  Widget paymentMethod() {
    return Container(
      // color: Colors.amber,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      // padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Phương Thức Thanh Toán",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              Spacer(),

              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios)),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                // width: 50,
                // height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Image(
                  image: NetworkImage(
                    // "https://tse3.mm.bing.net/th/id/OIP.7rFRTzEO9ad8-m20UYxcOQHaFs?cb=ucfimg2&ucfimg=1&w=625&h=481&rs=1&pid=ImgDetMain&o=7&rm=360",
                    "https://pngimg.com/uploads/paypal/paypal_PNG9.png",
                  ),
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),

              Text(
                "Paypal",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoBooking() {
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        // color: Colors.purpleAccent,
        // color: Colors.white,
        // borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Thông Tin Đặt Phòng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Text(
                "Họ và tên",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Spacer(),
              Text(
                "Nguyen Van A",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Đường kẻ ngang
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade400),

          Row(
            children: [
              Text(
                "Số Điện Thoại",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Spacer(),
              Text(
                "0123456789",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Đường kẻ ngang
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade400),

          Row(
            children: [
              Text(
                "Email",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Spacer(),
              Text(
                "example@example.com",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget detailBooking() {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              border: Border.all(color: Colors.grey.shade300),

              // borderRadius: BorderRadius.circular(15),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.hotel, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  "Khách Sạn Pullman Vũng Tàu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Details
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              // color: Colors.orangeAccent,

              // border: Border(bottom: BorderSide(color: Colors.black)),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Kiểu text dài quá thì xuống dòng
                    Expanded(
                      child: Text(
                        "Phòng Superior, 2 giường đơn, quang cảnh thành phố",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(" X1", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Text("240m2 "),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              // color: Colors.pinkAccent,
              color: Colors.white,

              // border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.nightlight_round, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Số Đêm",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "3",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Icon(Icons.person, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Khách",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "2 Người Lớn, 1 Trẻ Em",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // const SizedBox(height: 25),
                const SizedBox(height: 10),

                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Icon(Icons.bed, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Loại Giường",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "2 giường đơn, 1 giường cỡ king",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
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

          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              // color: Colors.greenAccent,
              color: Colors.white,
              // border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nhận Phòng ",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Thứ Tư, 02/02/2022 (15:00 - 03:00)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // const SizedBox(height: 25),
                const SizedBox(height: 10),

                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Icon(Icons.calendar_today, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Trả Phòng ",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Thứ Sáu, 04/02/2022 (trước 11:00)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
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

          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              // color: Colors.yellowAccent,
              color: Colors.white,
              // border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              border: Border.all(color: Colors.grey.shade300),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      "Miễn phí hủy phòng",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(Icons.info, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      "Áp dụng chính sách đổi lịch",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // decoration: BoxDecoration(
      //   color: Colors.pinkAccent,
      //   borderRadius: BorderRadius.circular(15),
      // ),
      // padding: EdgeInsets.all(20),
      // width: double.infinity,
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [

      //     ),
      //   ],
      // ),
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
            "Thanh Toán",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
