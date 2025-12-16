import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/menuUI.dart';
import 'package:hotel_booking_app/screens/profileUi.dart';
import 'package:hotel_booking_app/widgets/vectorWaveClipper.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Timer? _timer;

  late int second;

  void _startTimer() {
    _timer?.cancel();

    second = 60;

    _timer = Timer.periodic(Duration(seconds: 1), (Timer? timer) {
      if (second >= 0) {
        setState(() {
          second--;
        });
      } else {
        second = 0;
        timer?.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- PHẦN HEADER VỚI VECTOR SHAPE MỚI ---
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
                // Nội dung Header (Nút Back và Text)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: Text(
                            "Đăng nhập",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  bottom: -20, // Thụt xuống dưới 20px
                  left: 0,
                  // top: 0,
                  right: 0,
                  child: const Image(
                    image: AssetImage("assets/images/image.png"),
                  ),
                ),
              ],
            ),

            // --- PHẦN NHẬP OTP (Giữ nguyên) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Điều chỉnh khoảng cách âm (negative margin) nếu muốn nội dung đè lên hình nền
                  // Ở đây tôi dùng SizedBox thông thường
                  const SizedBox(height: 10),
                  const Text(
                    "Nhập mã OTP...",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      bool first = (index == 0) ? true : false;
                      bool last = (index == 3) ? true : false;
                      return _buildOtpBox(first: first, last: last);
                    }),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    height:
                        40, // Cố định chiều cao là 40 (hoặc số khác tùy bạn chỉnh)
                    child: Center(
                      child: second > 0
                          ? RichText(
                              text: TextSpan(
                                text: "Gửi lại mã trong ",
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: "$second giây",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Bạn chưa nhận được mã? ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      second = 60;
                                    });
                                    _startTimer();
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    "Gửi lại mã!",
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  // Center(
                  //   child: second > 0
                  //       ? RichText(
                  //           text: TextSpan(
                  //             text: "Gửi lại mã trong ",
                  //             style: TextStyle(
                  //               color: Colors.blueAccent,
                  //               fontSize: 14,
                  //             ),
                  //             children: [
                  //               TextSpan(
                  //                 text: "$second giây",
                  //                 style: TextStyle(fontWeight: FontWeight.bold),
                  //               ),
                  //             ],
                  //           ),
                  //         )
                  //       : Row(
                  //           mainAxisAlignment: MainAxisAlignment
                  //               .center, // Căn giữa dòng chữ này trong màn hình
                  //           children: [
                  //             // Phần 1: Text tĩnh (Không bấm được)
                  //             Text(
                  //               "Bạn chưa nhận được mã? ",
                  //               style: TextStyle(
                  //                 fontSize: 14,
                  //                 color:
                  //                     Colors.black, // Hoặc màu xám tùy design
                  //                 // color: Theme.of(context).colorScheme.primary,
                  //               ),
                  //             ),

                  //             // Phần 2: TextButton (Nút bấm Gửi lại mã)
                  //             TextButton(
                  //               onPressed: () {
                  //                 // Logic đếm ngược và gửi lại của bạn
                  //                 setState(() {
                  //                   second = 60;
                  //                 });
                  //                 _startTimer();
                  //               },
                  //               // Tinh chỉnh style để nút bấm không bị khoảng cách quá xa so với chữ
                  //               style: TextButton.styleFrom(
                  //                 padding: EdgeInsets
                  //                     .zero, // Xóa khoảng trắng mặc định quanh nút
                  //                 minimumSize: Size
                  //                     .zero, // Xóa kích thước tối thiểu để nó gọn như text thường
                  //                 tapTargetSize: MaterialTapTargetSize
                  //                     .shrinkWrap, // Thu gọn vùng bấm
                  //               ),
                  //               child: const Text(
                  //                 "Gửi lại mã!",
                  //                 style: TextStyle(
                  //                   color: Colors.blueAccent,
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  // ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MenuUi(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5A9BD5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        "XÁC THỰC",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox({required bool first, required bool last}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextFormField(
          onChanged: (value) => {
            if (value.length == 1 && !last)
              {FocusScope.of(context).nextFocus()}
            else if (value.isEmpty && !first)
              {FocusScope.of(context).previousFocus()},

            // if (value.isEmpty && value.length == 0)

            // {
            //   FocusScope.of(context).previousFocus(),
            // }
          },
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }
}
