import 'package:flutter/material.dart';
import 'package:hotel_booking_app/widgets/vectorWaveClipper.dart';

class RegisterUI extends StatelessWidget {
  const RegisterUI({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: VectorWaveClipper(), // Sử dụng Clipper mới
                  child: Container(
                    height:
                        size.height *
                        0.55, // Tăng chiều cao để chứa đường cong sâu
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF29B6F6), // Màu xanh sáng (Light Blue)
                          Color(0xFF039BE5), // Màu xanh đậm hơn một chút
                        ],
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),

                        const Text(
                          "Đăng Ký",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          width: 48,
                        ), // Đặt một khoảng trống tương đương nút bên trái
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter, // căn giữa
                    child: Image.asset(
                      "assets/images/registerImage.png",
                      width: size.width * 0.9, // 50% chiều rộng màn hình
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Thông Tin Cá Nhân",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 25),

            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF0EEFD),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    // <-- Thêm Expanded ở đây
                    child: TextField(
                      // textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.email),
                        hintText: "Họ và tên",
                        border: InputBorder.none,

                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF0EEFD),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    // <-- Thêm Expanded ở đây
                    child: TextField(
                      // textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.email),
                        hintText: "Email",
                        border: InputBorder.none,

                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF0EEFD),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(Icons.phone, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    // <-- Thêm Expanded ở đây
                    child: TextField(
                      // textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.email),
                        hintText: "Số điện thoại",
                        border: InputBorder.none,

                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5496D2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "ĐĂNG KÝ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
