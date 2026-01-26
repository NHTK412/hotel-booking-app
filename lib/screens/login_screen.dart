import 'dart:ui'; // Cần import thư viện này để dùng ImageFilter.blur

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/app_state.dart';
// Bỏ import vector_wave_clipper
import 'package:hotel_booking_app/data/enum/oauth_provider_type_enum.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/auth/auth_login.dart';
import 'package:hotel_booking_app/data/model/auth/auth_response.dart';
import 'package:hotel_booking_app/data/model/auth/oauth_login.dart';
import 'package:hotel_booking_app/data/repositories/auth_repository.dart';
import 'package:hotel_booking_app/data/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  late bool _obscureText;
  late bool _isLoading;

  // Màu chủ đạo (Lấy từ header cũ của bạn để đồng bộ)
  final Color primaryBlue = const Color(0xFF5496D2);
  final Color lightBlueBg = const Color(0xFFF0F4F8);

  @override
  void initState() {
    super.initState();
    _obscureText = true;
    _isLoading = false;
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Màu nền hơi xám xanh nhẹ, không trắng tinh để đỡ chói
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- LỚP TRANG TRÍ NỀN (BACKGROUND DECORATION) ---
          // Blob 1: Góc trên trái
          Positioned(
            top: -size.width * 0.2,
            left: -size.width * 0.2,
            child: Container(
              height: size.width * 0.6,
              width: size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryBlue.withOpacity(0.15), // Màu xanh rất nhạt
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          // Blob 2: Góc dưới phải
          Positioned(
            bottom: -size.width * 0.3,
            right: -size.width * 0.2,
            child: Container(
              height: size.width * 0.7,
              width: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFF29B6F6,
                ).withOpacity(0.1), // Xanh dương nhạt khác
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // --- LỚP NỘI DUNG CHÍNH (FORM) ---
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                // Thêm padding để nội dung không dính sát lề khi màn hình nhỏ
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Logo & Header Text
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        // Thay bằng Image.asset logo của bạn nếu có
                        child: Icon(
                          Icons.travel_explore_rounded,
                          size: 40,
                          color: primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Chào mừng trở lại!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800, // Chữ đậm hơn
                        color: Colors.grey[800],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Đăng nhập để tiếp tục hành trình với VnTravel",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 40),

                    // 2. Form Inputs (Được bọc trong Card để nổi bật hơn)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: const Offset(
                              0,
                              5,
                            ), // Đổ bóng nhẹ xuống dưới
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildEmailInput(),
                          const SizedBox(height: 15),
                          _buildPasswordInput(),
                        ],
                      ),
                    ),

                    // Quên mật khẩu
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                        child: _buildForgotPassword(),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 3. Buttons
                    _buildLoginButton(context),

                    const SizedBox(height: 30),
                    _buildDivider(),
                    const SizedBox(height: 30),

                    _buildGoogleLoginButton(context),

                    const SizedBox(height: 40),
                    _buildRegisterLink(context),
                  ],
                ),
              ),
            ),
          ),

          // 4. Loading Overlay
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // --- CÁC HÀM CON (ĐÃ TỐI ƯU UI) ---

  // Input Email
  Widget _buildEmailInput() {
    return _buildInputBox(
      icon: Icons.alternate_email_rounded, // Icon hiện đại hơn
      hint: "Địa chỉ Email",
      inputType: TextInputType.emailAddress,
      controller: _email,
    );
  }

  // Input Password
  Widget _buildPasswordInput() {
    return _buildInputBox(
      icon: Icons.lock_outline_rounded,
      hint: "Mật khẩu",
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
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  // Nút Đăng nhập
  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          try {
            if (_email.text.isEmpty || _pass.text.isEmpty) {
              _showErrorDialog("Vui lòng nhập đầy đủ email và mật khẩu.");
              return;
            }

            setState(() => _isLoading = true);

            final authLogin = AuthLogin(
              email: _email.text,
              password: _pass.text,
            );
            final ApiResponse<AuthResponse> login = await AuthRepository(
              AuthService(),
            ).login(authLogin);

            if (login.code == 200) {
              String accessToken = login.data?.accessToken ?? "";
              if (!context.mounted) return;
              context.read<AppState>().logIn(accessToken, login.data?.userId);
            }
          } on DioException catch (e) {
            String mess = (e.response?.statusCode == 401)
                ? "Thông tin đăng nhập không chính xác."
                : "Lỗi kết nối (${e.response?.statusCode}). Vui lòng thử lại.";
            if (context.mounted) _showErrorDialog(mess);
          } catch (e) {
            if (context.mounted) _showErrorDialog("Đã có lỗi xảy ra: $e");
          } finally {
            if (mounted) setState(() => _isLoading = false);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryBlue.withOpacity(0.4), // Bóng màu xanh
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          "Đăng Nhập",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Quên mật khẩu
  Widget _buildForgotPassword() {
    return GestureDetector(
      onTap: () {
        if (_email.text.isEmpty) {
          _showErrorDialog("Vui lòng nhập email để đặt lại mật khẩu.");
          return;
        }

        context.push(
          Uri(
            path: "/password_reset",
            queryParameters: {"email": _email.text},
          ).toString(),
        );
      },
      child: Text(
        "Quên mật khẩu?",
        style: TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  // Divider
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Hoặc tiếp tục với",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
      ],
    );
  }

  // Nút Google
  Widget _buildGoogleLoginButton(BuildContext context) {
    return SizedBox(
      height: 55,
      child: OutlinedButton(
        onPressed: () async {
          setState(() => _isLoading = true);
          try {
            final OAuthLogin? oAuthLogin = await signInWithGoogle();
            if (oAuthLogin == null) {
              setState(() => _isLoading = false);
              return;
            }
            final ApiResponse<AuthResponse> oauthLogin = await AuthRepository(
              AuthService(),
            ).oauthLogin(oAuthLogin);
            if (oauthLogin.code == 200 && context.mounted) {
              context.read<AppState>().logIn(
                oauthLogin.data?.accessToken ?? "",
                oauthLogin.data?.userId,
              );
            }
          } catch (e) {
            if (context.mounted)
              _showErrorDialog("Không thể đăng nhập bằng Google.");
          } finally {
            if (mounted) setState(() => _isLoading = false);
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade200, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[800], // Màu hiệu ứng khi nhấn
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logoGoogle.png", width: 24, height: 24),
            const SizedBox(width: 12),
            const Text(
              "Google",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // Link Đăng ký
  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bạn mới biết đến VnTravel? ",
          style: TextStyle(fontSize: 15, color: Colors.grey[600]),
        ),
        GestureDetector(
          onTap: () {
            context.push(
              Uri(
                path: "/register",
                queryParameters: {"email": _email.text},
              ).toString(),
            );
          },
          child: Text(
            "Tạo tài khoản",
            style: TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  // Helper Input Box (Được thiết kế lại để sạch sẽ hơn trong Card)
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
        color: lightBlueBg, // Nền input xám xanh rất nhạt
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: inputType,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: primaryBlue.withOpacity(0.7),
            size: 22,
          ), // Icon màu xanh nhạt
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  // Loading Overlay (Tối hơn một chút để nổi bật)
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
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

  // Logic Google Sign-In (Giữ nguyên)
  Future<OAuthLogin?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      return OAuthLogin(
        provider: OauthProviderTypeEnum.google,
        accessToken: googleAuth.accessToken ?? "",
        idToken: userCredential.user?.uid ?? "",
        name: googleUser.displayName ?? "",
      );
    } catch (e) {
      rethrow;
    }
  }
}
