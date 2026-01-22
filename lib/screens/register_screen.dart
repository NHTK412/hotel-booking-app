import 'dart:ui'; // Để dùng ImageFilter.blur

import 'package:dio/dio.dart'; // Import Dio để bắt lỗi chính xác
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/app_state.dart';
// Bỏ import vector_wave_clipper
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/auth/auth_resgister.dart';
import 'package:hotel_booking_app/data/model/auth/auth_response.dart';
import 'package:hotel_booking_app/data/repositories/auth_repository.dart';
import 'package:hotel_booking_app/data/service/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller nhập liệu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  // Trạng thái
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;
  bool _isLoading = false;

  // Màu chủ đạo (Đồng bộ với Login)
  final Color primaryBlue = const Color(0xFF5496D2);
  final Color lightBlueBg = const Color(0xFFF0F4F8);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- LỚP TRANG TRÍ NỀN (BACKGROUND BLOBS) ---
          // Blob 1: Góc trên phải (Ngược lại với Login chút cho đổi gió)
          Positioned(
            top: -size.width * 0.15,
            right: -size.width * 0.15,
            child: Container(
              height: size.width * 0.5,
              width: size.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryBlue.withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          // Blob 2: Góc dưới trái
          Positioned(
            bottom: -size.width * 0.15,
            left: -size.width * 0.15,
            child: Container(
              height: size.width * 0.6,
              width: size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF29B6F6).withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // --- NỘI DUNG CHÍNH ---
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Header & Nút Back
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
                    const SizedBox(height: 20),

                    // 2. Title
                    Text(
                      "Tạo tài khoản mới",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[800],
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Điền thông tin bên dưới để tham gia cộng đồng VnTravel",
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 30),

                    // 3. Form Inputs (Card container)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInputBox(
                            controller: _nameController,
                            icon: Icons.person_outline_rounded,
                            hint: "Họ và tên",
                            inputType: TextInputType.name,
                          ),
                          const SizedBox(height: 16),
                          _buildInputBox(
                            controller: _emailController,
                            icon: Icons.alternate_email_rounded,
                            hint: "Email",
                            inputType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          _buildInputBox(
                            controller: _phoneController,
                            icon: Icons.phone_android_rounded,
                            hint: "Số điện thoại",
                            inputType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          _buildInputBox(
                            controller: _passController,
                            icon: Icons.lock_outline_rounded,
                            hint: "Mật khẩu",
                            inputType: TextInputType.text,
                            isPassword: _obscurePass,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePass
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey[400],
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePass = !_obscurePass),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInputBox(
                            controller: _confirmPassController,
                            icon: Icons.lock_reset_rounded,
                            hint: "Nhập lại mật khẩu",
                            inputType: TextInputType.text,
                            isPassword: _obscureConfirmPass,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPass
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey[400],
                              ),
                              onPressed: () => setState(
                                () =>
                                    _obscureConfirmPass = !_obscureConfirmPass,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 4. Register Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleRegister,
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
                          "ĐĂNG KÝ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 5. Back to Login Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Đã có tài khoản? ",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Text(
                            "Đăng nhập",
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Bottom safe spacing
                  ],
                ),
              ),
            ),
          ),

          // 6. Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // --- LOGIC ---

  Future<void> _handleRegister() async {
    // Ẩn bàn phím
    FocusManager.instance.primaryFocus?.unfocus();

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passController.text;
    final confirmPassword = _confirmPassController.text;

    // Validate
    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorDialog("Vui lòng điền đầy đủ tất cả thông tin.");
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog("Mật khẩu xác nhận không khớp.");
      return;
    }

    if (password.length < 6) {
      _showErrorDialog("Mật khẩu phải có ít nhất 6 ký tự.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRegister = AuthRegister(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      final ApiResponse<AuthResponse> response = await AuthRepository(
        AuthService(),
      ).register(authRegister);

      if (!mounted) return;

      if (response.code == 200) {
        final AuthResponse authResponse = response.data!;
        String accessToken = authResponse.accessToken ?? "";

        // Đăng nhập luôn sau khi đăng ký thành công
        context.read<AppState>().logIn(accessToken);

        // Hiển thị thông báo hoặc chuyển trang (logic của appState sẽ tự chuyển trang)
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chào mừng bạn đến với VnTravel!")));
      }
      // Xử lý lỗi trả về từ API (ví dụ email đã tồn tại)
      else {
        _showErrorDialog(response.message ?? "Đăng ký thất bại.");
      }
    } on DioException catch (e) {
      // Xử lý lỗi kết nối hoặc server
      String errorMsg = "Lỗi kết nối server.";
      if (e.response?.statusCode == 409) {
        errorMsg = "Email hoặc số điện thoại đã được đăng ký.";
      } else if (e.response?.data != null &&
          e.response?.data['message'] != null) {
        errorMsg = e.response?.data['message'];
      }
      if (mounted) _showErrorDialog(errorMsg);
    } catch (e) {
      if (mounted) _showErrorDialog("Đã có lỗi không xác định xảy ra.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper Show Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Thông báo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text("Đóng", style: TextStyle(color: primaryBlue)),
          ),
        ],
      ),
    );
  }

  // Helper Widget Input (Đồng bộ style với Login)
  Widget _buildInputBox({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required TextInputType inputType,
    bool isPassword = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: lightBlueBg,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: inputType,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          icon: Icon(icon, color: primaryBlue.withOpacity(0.7), size: 22),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
