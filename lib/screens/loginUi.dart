import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/otpUi.dart';
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
            SizedBox(height: 15),
            Container(
              width: size.width * 0.8,

              decoration: BoxDecoration(
                color: Color(0xFFF0EEFD),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              // margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    // <-- Thêm Expanded ở đây
                    child: TextField(
                      style: TextStyle(fontSize: 14),
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
            SizedBox(height: 10),
            Container(
              width: size.width * 0.8,

              decoration: BoxDecoration(
                color: Color(0xFFF0EEFD),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(Icons.password, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    // <-- Thêm Expanded ở đây
                    child: TextField(
                      style: TextStyle(fontSize: 14),

                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.email),
                        hintText: "Password",
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OtpScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5496D2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "ĐĂNG NHẬP",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),

            TextButton(
              onPressed: () {},
              child: const Text(
                "Quên mật khẩu?",
                style: TextStyle(color: Color(0xFF8F91BF)),
              ),
            ),

            // SizedBox(height: 20),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     TextButton(
            //       style: TextButton.styleFrom(padding: EdgeInsets.zero),
            //       onPressed: () {
            //         // Navigator.push(
            //         //   context,
            //         //   MaterialPageRoute(
            //         //     builder: (context) => const RegisterUI(),
            //         //   ),
            //         // );
            //       },
            //       child: const Text(
            //         "Quên mật khẩu?",
            //         style: TextStyle(
            //           color: Color(0xFF8F91BF),
            //           fontSize: 15,
            //           decoration: TextDecoration.underline,
            //           fontWeight: FontWeight.bold,
            //           decorationColor: Color(0xFF8F91BF),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 2),
            //     TextButton(
            //       style: TextButton.styleFrom(padding: EdgeInsets.zero),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const RegisterUI(),
            //           ),
            //         );
            //       },
            //       child: const Text(
            //         "Đăng ký?",
            //         style: TextStyle(
            //           color: Color(0xFF8F91BF),
            //           fontSize: 15,
            //           decoration: TextDecoration.underline,
            //           fontWeight: FontWeight.bold,
            //           decorationColor: Color(0xFF8F91BF),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 5),
            Center(
              child: Text(
                "Hoặc",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),

            SizedBox(height: 5),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Container(
                // alignment: Alignment.center,
                // margin: EdgeInsets.symmetric(horizontal: 80),
                width: size.width * 0.7,
                // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      // image: NetworkImage(
                      //   "https://tse4.mm.bing.net/th/id/OIP.lsGmVmOX789951j9Km8RagHaHa?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3",
                      // ),
                      image: AssetImage("assets/images/logoGoogle.png"),
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Đăng nhập với Google",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            // Dòng chuyển sang trang Đăng ký nằm dưới cùng
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Chưa có tài khoản? ",
                  style: TextStyle(fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterUI(),
                      ),
                    );
                  },
                  child: const Text(
                    "Đăng ký ngay",
                    style: TextStyle(
                      color: Color(0xFF5496D2),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
