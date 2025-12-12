import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/registerUI.dart';
import 'package:hotel_booking_app/widgets/vectorWaveClipper.dart';

class LoginUI extends StatelessWidget {
  const LoginUI({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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

                const Positioned(
                  top: 15,
                  left: 20,
                  child: SafeArea(
                    child: Text(
                      "Khám phá trải nghiệm\nthú vị cùng với\nVnTravel !",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: -20,

                  // 1. Muốn lệch sang trái, hãy TĂNG số này lên
                  // right: 0 (sát lề phải) -> right: 40 (cách lề phải 40px, tức là bị đẩy sang trái)
                  right: 40,

                  // 2. Thiết lập chiều rộng cố định bằng 70% màn hình ngay tại đây
                  // Thay vì dùng FractionallySizedBox, ta tính toán trực tiếp
                  width: size.width * 0.6,

                  child: Image.asset(
                    "assets/images/loginImage.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
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
                      textAlign: TextAlign.center,
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

            SizedBox(height: 20),

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
                "ĐĂNG NHẬP",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterUI()),
                );
              },
              child: const Text(
                "Tại tài khoản mới ?",
                style: TextStyle(
                  color: Color(0xFF8F91BF),
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  decorationColor: Color(0xFF8F91BF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
