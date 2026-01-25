import 'dart:async';
import 'dart:ui'; // Để dùng ImageFilter.blur

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/app_state.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/auth/verify_otp_response.dart';
import 'package:hotel_booking_app/data/repositories/auth_repository.dart';
import 'package:hotel_booking_app/data/service/auth_service.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Timer? _timer;
  late int _secondsRemaining;

  // Quản lý focus cho 4 ô
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  // Style đồng bộ
  final Color primaryBlue = const Color(0xFF5496D2);
  final Color lightBlueBg = const Color(0xFFF0F4F8);

  @override
  void initState() {
    super.initState();
    _startTimer();
    sendOtp();
  }

  Future<void> sendOtp() async {
    ApiResponse<bool> response = await AuthRepository(
      AuthService(),
    ).sendOtp(widget.email);

    if (response.code == 200) {
      // OTP đã được gửi thành công
    } else {
      // Xử lý lỗi nếu cần
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Lỗi"),
            content: const Text("Không thể gửi mã OTP. Vui lòng thử lại."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- BACKGROUND DECORATION (Blobs) ---
          Positioned(
            top: -size.width * 0.2,
            left: -size.width * 0.2,
            child: Container(
              height: size.width * 0.6,
              width: size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryBlue.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // --- MAIN CONTENT ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // 1. Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.grey[700],
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                        elevation: 2,
                        shadowColor: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 2. Icon & Title
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: lightBlueBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_person_rounded,
                      size: 50,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Xác thực OTP",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Mã xác thực 4 số đã được gửi đến email",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.email, // Hiển thị email người dùng
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 3. OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return _buildOtpBox(index);
                    }),
                  ),

                  const SizedBox(height: 40),

                  // 4. Timer & Resend
                  _secondsRemaining > 0
                      ? RichText(
                          text: TextSpan(
                            text: "Gửi lại mã trong ",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "00:${_secondsRemaining.toString().padLeft(2, '0')}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Không nhận được mã? ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _secondsRemaining = 60;
                                  // Reset các ô nhập liệu nếu cần
                                  // for (var c in _controllers) c.clear();
                                });
                                sendOtp();
                                _startTimer();
                                // TODO: Gọi API gửi lại OTP tại đây
                              },
                              child: Text(
                                "Gửi lại",
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),

                  const SizedBox(height: 50),

                  // 5. Verify Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Logic ghép mã OTP
                        String otpCode = _controllers.map((e) => e.text).join();
                        if (otpCode.length < 4) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Vui lòng nhập đủ 4 số OTP"),
                            ),
                          );
                          return;
                        }

                        ApiResponse<VerifyOtpResponse> response =
                            await AuthRepository(
                              AuthService(),
                            ).verifyOtp(widget.email, otpCode);
                        if (response.code == 200) {
                          final VerifyOtpResponse verifyOtpData =
                              response.data!;
                          if (verifyOtpData.isValid == true) {
                            // OTP hợp lệ, chuyển
                            String accessToken =
                                verifyOtpData.accessToken ?? "";
                            context.read<AppState>().logIn(accessToken , verifyOtpData.userId);

                            // Chuyển hướng về trang đổi mật khẩu
                            context.push("/reset-password");

                            return;

                          } else {
                            // OTP không hợp lệ
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Mã OTP không hợp lệ"),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: primaryBlue.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        "XÁC THỰC",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper: OTP Box Widget
  Widget _buildOtpBox(int index) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: lightBlueBg, // Màu nền xám xanh nhạt
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Đổ bóng nhẹ bên trong tạo cảm giác lõm (optional) hoặc nổi
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
        border: Border.all(
          // Viền sẽ đổi màu khi có focus
          color: _focusNodes[index].hasFocus ? primaryBlue : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          autofocus: index == 0, // Ô đầu tiên tự focus
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
          decoration: const InputDecoration(
            counterText: "", // Ẩn số đếm ký tự
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              // Nếu nhập xong 1 số -> chuyển sang ô tiếp theo
              if (index < 3) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else {
                // Ô cuối cùng -> ẩn bàn phím
                FocusScope.of(context).unfocus();
              }
            } else {
              // Nếu xóa (empty) -> chuyển về ô trước đó
              if (index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            }
            // Trigger rebuild để cập nhật border color
            setState(() {});
          },
          onTap: () {
            // Khi bấm vào ô, set state để border sáng lên
            setState(() {});
          },
        ),
      ),
    );
  }
}
