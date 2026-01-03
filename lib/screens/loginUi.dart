import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/data/model/apiResponse.dart';
import 'package:hotel_booking_app/data/model/auth/authLogin.dart';
import 'package:hotel_booking_app/data/model/auth/authResponse.dart';
import 'package:hotel_booking_app/data/repositories/authRepository.dart';
import 'package:hotel_booking_app/data/service/authService.dart';
import 'package:hotel_booking_app/screens/otpUi.dart';
import 'package:hotel_booking_app/screens/registerUI.dart';
import 'package:hotel_booking_app/widgets/vectorWaveClipper.dart';
import 'dart:math'; // Import thư viện toán học để dùng hàm min, max

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginUIState();
  }
}

class _LoginUIState extends State<LoginUI> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  late bool _obscureText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obscureText = true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Tính toán chiều cao header hợp lý hơn:
    // Lấy 50% màn hình nhưng không quá 450px để tránh chiếm hết chỗ trên Tablet/PC
    final double headerHeight = min(size.height * 0.5, 450);

    // Tính toán chiều rộng form:
    // Lấy 85% màn hình nhưng tối đa chỉ 400px (đẹp cho cả Tablet)
    final double contentWidth = min(size.width * 0.85, 400);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- PHẦN HEADER ---
            SizedBox(
              height: headerHeight,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: VectorWaveClipper(),
                    child: Container(
                      height: headerHeight,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF29B6F6), Color(0xFF039BE5)],
                        ),
                      ),
                    ),
                  ),

                  // Text tiêu đề
                  Positioned(
                    // top: size.height * 0.05,
                    // Cách top 5% thay vì hardcode 15px
                    left: 20,
                    child: SafeArea(
                      // child: ConstrainedBox(
                      // constraints: BoxConstraints(maxWidth: size.width * 0.6),
                      child: Text(
                        "Khám phá trải nghiệm\nthú vị cùng với\nVnTravel !",
                        style: TextStyle(
                          color: Colors.white,
                          // Font size tự chỉnh theo chiều ngang, max 32
                          fontSize: min(size.width * 0.08, 32),
                          fontWeight: FontWeight.bold,
                        ),
                        // ),
                      ),
                    ),
                  ),

                  // Ảnh minh họa
                  Positioned(
                    bottom: -20,
                    right: size.width * 0.05,
                    // Cách phải 5%
                    width: min(size.width * 0.6, 300),
                    // Giới hạn ảnh không quá to
                    child: Image.asset(
                      "assets/images/loginImage.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.03), // Khoảng cách động
            // --- PHẦN FORM (Bọc trong Center để cân đối trên Tablet) ---
            Center(
              child: SizedBox(
                width: contentWidth, // Dùng width đã tính toán ở trên
                child: Column(
                  children: [
                    // Input Email
                    _buildInputBox(
                      icon: Icons.email,
                      hint: "Email",
                      inputType: TextInputType.emailAddress,
                      controller: _email,
                    ),

                    SizedBox(height: size.height * 0.02), // Khoảng cách động
                    // Input Password
                    _buildInputBox(
                      icon: Icons.password,
                      hint: "Password",
                      inputType: TextInputType.text,
                      isPassword: _obscureText,
                      controller: _pass,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          (_obscureText)
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                        ),
                        style: IconButton.styleFrom(
                          // backgroundColor: Colors.blue,
                          padding: EdgeInsetsGeometry.zero,
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    // Nút Đăng nhập
                    SizedBox(
                      width: double.infinity,
                      // Full chiều rộng của contentWidth
                      child: ElevatedButton(
                        onPressed: () async {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const OtpScreen(),
                          //   ),
                          // );

                          try {
                            if (_email.text.isEmpty || _pass.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Đăng Nhập Thất Bại"),
                                  content: Text(
                                    // e?? "Đã có lỗi xảy ra",
                                    "Vui lòng nhập đầy đủ thông tin!",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            final authLogin = AuthLogin(
                              email: _email.text,
                              password: _pass.text,
                            );

                            final ApiResponse<AuthResponse> login =
                                await AuthRepository(
                                  AuthService(),
                                ).login(authLogin);

                            if (login.code == 200) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OtpScreen(),
                                ),
                              );
                            }

                            // final Future<ApiResponse<AuthResponse>> _login =
                            //     AuthRepository(AuthService()).login(authLogin);
                          } on DioException catch (e) {
                            late String mess;
                            if (e.response?.statusCode == 401) {
                              mess = "Email hoặc mật khẩu không hợp lệ!";
                            }
                            showDialog(
                              context: Navigator.of(context).context,
                              builder: (_) => AlertDialog(
                                title: const Text("Đăng Nhập Thất Bại"),
                                content: const Text(
                                  "Vui lòng nhập đầy đủ thông tin!",
                                ),
                              ),
                            );

                            // );
                            // rethrow;
                            // }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5496D2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          // Padding dọc cố định cho nút đẹp
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "ĐĂNG NHẬP",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Quên mật khẩu?",
                        style: TextStyle(color: Color(0xFF8F91BF)),
                      ),
                    ),

                    // Divider "Hoặc"
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Hoặc",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02),

                    // Google Login
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(30),
                      // Bo tròn đồng bộ
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/logoGoogle.png",
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              "Đăng nhập với Google",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    // Đăng ký
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
                    const SizedBox(height: 30), // Padding bottom an toàn
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tách riêng để tái sử dụng và code gọn hơn
  Widget _buildInputBox({
    required IconData icon,
    required String hint,
    required TextInputType inputType,
    required TextEditingController controller,
    bool isPassword = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEFD),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              style: const TextStyle(fontSize: 15),
              // textAlign: TextAlign.center, // Bỏ center để nhập liệu tự nhiên hơn
              keyboardType: inputType,
              decoration: InputDecoration(
                suffixIcon: (suffixIcon != null) ? suffixIcon : null,

                // suffix: (suffixIcon != null) ? suffixIcon : null,
                hintText: hint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                ), // Căn giữa text dọc
              ),
            ),
          ),
        ],
      ),
    );
  }
}
