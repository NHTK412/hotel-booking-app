import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/components/vector_wave_clipper.dart';
import 'package:hotel_booking_app/data/enum/oauth_provider_type_enum.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/auth/auth_login.dart';
import 'package:hotel_booking_app/data/model/auth/auth_response.dart';
import 'package:hotel_booking_app/data/model/auth/oauth_login.dart';
import 'package:hotel_booking_app/data/repositories/auth_repository.dart';
import 'package:hotel_booking_app/data/service/auth_service.dart';
import 'package:hotel_booking_app/screens/home_screen.dart';
import 'package:hotel_booking_app/screens/main_menu_screen.dart';
import 'package:hotel_booking_app/screens/otp_verification_screen.dart';
import 'package:hotel_booking_app/screens/register_screen.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _obscureText = true;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double headerHeight = min(size.height * 0.5, 450);
    final double contentWidth = min(size.width * 0.85, 400);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 1. Phần Header (Sóng nước & Ảnh)
                _buildHeader(size, headerHeight),

                SizedBox(height: size.height * 0.03),

                // 2. Phần Form đăng nhập
                Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: Column(
                      children: [
                        _buildEmailInput(),
                        SizedBox(height: size.height * 0.02),
                        _buildPasswordInput(),
                        SizedBox(height: size.height * 0.03),
                        _buildLoginButton(context),
                        const SizedBox(height: 10),
                        _buildForgotPassword(),
                        _buildDivider(),
                        SizedBox(height: size.height * 0.02),
                        _buildGoogleLoginButton(context),
                        SizedBox(height: size.height * 0.03),
                        _buildRegisterLink(context),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3. Loading Overlay
        if (_isLoading) _buildLoadingOverlay(),
      ],
    );
  }

  // --- CÁC HÀM CON (EXTRACTED METHODS) ---

  // 1. Header Widget
  Widget _buildHeader(Size size, double headerHeight) {
    return SizedBox(
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
          Positioned(
            left: 20,
            child: SafeArea(
              child: Text(
                "Khám phá trải nghiệm\nthú vị cùng với\nVnTravel !",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: min(size.width * 0.08, 32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            right: size.width * 0.05,
            width: min(size.width * 0.6, 300),
            child: Image.asset(
              "assets/images/loginImage.png",
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Input Email
  Widget _buildEmailInput() {
    return _buildInputBox(
      icon: Icons.email,
      hint: "Email",
      inputType: TextInputType.emailAddress,
      controller: _email,
    );
  }

  // 3. Input Password
  Widget _buildPasswordInput() {
    return _buildInputBox(
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
          (_obscureText) ? Icons.remove_red_eye : Icons.visibility_off,
        ),
        style: IconButton.styleFrom(padding: EdgeInsetsGeometry.zero),
      ),
    );
  }

  // 4. Nút Đăng nhập (Logic chính nằm ở đây)
  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            if (_email.text.isEmpty || _pass.text.isEmpty) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Đăng Nhập Thất Bại"),
                  content: const Text("Vui lòng nhập đầy đủ thông tin!"),
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

            setState(() {
              _isLoading = true;
            });

            final ApiResponse<AuthResponse> login = await AuthRepository(
              AuthService(),
            ).login(authLogin);

            if (login.code == 200) {
              // ignore: use_build_context_synchronously
              String accessToken = login.data?.accessToken ?? "";

              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              await prefs.setString('access_token', accessToken);

              if (!context.mounted) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  // builder: (context) => const OtpVerificationScreen(),
                  builder: (context) => const MainMenuScreen(),
                ),
              );
            }
          } on DioException catch (e) {
            late String mess;
            if (e.response?.statusCode == 401) {
              mess = "Email hoặc mật khẩu không hợp lệ!";
            } else {
              mess = "Đã có lỗi xảy ra"; // Fallback message
            }
            // ignore: use_build_context_synchronously
            showDialog(
              context: Navigator.of(context).context,
              builder: (_) => AlertDialog(
                title: const Text("Đăng Nhập Thất Bại"),
                content: Text(mess),
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
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5496D2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 3,
        ),
        child: const Text(
          "ĐĂNG NHẬP",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 5. Quên mật khẩu
  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Quên mật khẩu?",
        style: TextStyle(color: Color(0xFF8F91BF)),
      ),
    );
  }

  // 6. Divider (Hoặc)
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Hoặc",
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  // 7. Nút Google
  Widget _buildGoogleLoginButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          // if (_email.text.isEmpty || _pass.text.isEmpty) {
          //   showDialog(
          //     context: context,
          //     builder: (context) => AlertDialog(
          //       title: const Text("Đăng Nhập Thất Bại"),
          //       content: const Text("Vui lòng nhập đầy đủ thông tin!"),
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //             Navigator.of(context).pop();
          //           },
          //           child: const Text("OK"),
          //         ),
          //       ],
          //     ),
          //   );
          //   return;
          // }

          // final authLogin = AuthLogin(email: _email.text, password: _pass.text);

          setState(() {
            _isLoading = true;
          });

          final OAuthLogin? oAuthLogin = await signInWithGoogle();
          if (oAuthLogin == null) {
            // Người dùng đã hủy đăng nhập
            setState(() {
              _isLoading = false;
            });

            // showDialog(
            //   context: Navigator.of(context).context,
            //   builder: (_) => AlertDialog(
            //     title: const Text("Đăng Nhập Thất Bại"),
            //     content: const Text("Đăng nhập Google đã bị hủy."),
            //     actions: [
            //       TextButton(
            //         onPressed: () {
            //           Navigator.of(context).pop();
            //         },
            //         child: const Text("OK"),
            //       ),
            //     ],
            //   ),
            // );
            return;
          }

          // showDialog(
          //   context: Navigator.of(context).context,
          //   builder: (_) => AlertDialog(
          //     title: const Text("Đăng Nhập Thất Bại"),
          //     content: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text("Provider: ${oAuthLogin.provider.toJson()}"),
          //         Text("Access Token: ${oAuthLogin.accessToken}"),
          //         Text("ID Token: ${oAuthLogin.idToken}"),
          //         Text("Name: ${oAuthLogin.name}"),
          //       ],
          //     ),
          //     actions: [
          //       TextButton(
          //         onPressed: () {
          //           Navigator.of(context).pop();
          //         },
          //         child: const Text("OK"),
          //       ),
          //     ],
          //   ),
          // );

          final ApiResponse<AuthResponse> oauthLogin = await AuthRepository(
            AuthService(),
          ).oauthLogin(oAuthLogin);

          if (oauthLogin.code == 200) {
            // ignore: use_build_context_synchronously

            String accessToken = oauthLogin.data?.accessToken ?? "";

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            await prefs.setString('access_token', accessToken);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainMenuScreen()),
            );
          }

          // final ApiResponse<AuthResponse> login = await AuthRepository(
          //   AuthService(),
          // ).login(authLogin);

          // if (login.code == 200) {
          //   // ignore: use_build_context_synchronously
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const OtpVerificationScreen(),
          //     ),
          //   );
          // }
        } on DioException catch (e) {
          late String? mess;
          if (e.response?.statusCode == 401) {
            mess = "Email hoặc mật khẩu không hợp lệ!";
          } else {
            // mess = "Đã có lỗi xảy ra"; // Fallback message
            mess = e.message;
          }
          // ignore: use_build_context_synchronously
          showDialog(
            context: Navigator.of(context).context,
            builder: (_) => AlertDialog(
              title: const Text("Đăng Nhập Thất Bại"),
              content: Text(mess ?? "Đã có lỗi xảy ra"),
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
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      },
      borderRadius: BorderRadius.circular(30),
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
            Image.asset("assets/images/logoGoogle.png", width: 24, height: 24),
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
    );
  }

  // 8. Link Đăng ký
  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Chưa có tài khoản? ", style: TextStyle(fontSize: 14)),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
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
    );
  }

  // 9. Màn hình loading
  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black26,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // 10. Helper Input Box (Giữ nguyên từ code gốc)
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
              keyboardType: inputType,
              decoration: InputDecoration(
                suffixIcon: (suffixIcon != null) ? suffixIcon : null,
                hintText: hint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<OAuthLogin?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signIn(); // Dùng để chọn tài khoản Google

      // User hủy login
      if (googleUser == null) {
        return null; // Kết thúc hàm nếu người dùng hủy đăng nhập
      }

      // Lấy thông tin xác thực từ tài khoản Google đã chọn
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication; // Lấy thông tin xác thực từ tài khoản Google đã chọn

      // Lưu ý: Chỉ dùng idToken (accessToken có thể null trên một số platform)
      // Tạo thông tin đăng nhập cho Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        // Tạo thông tin đăng nhập cho Firebase
        accessToken:
            googleAuth.accessToken, // Mặc dù có thể null trên một số nền tảng
        idToken:
            googleAuth.idToken, // Bắt buộc phải có để xác thực với Firebase
      );

      // Đăng nhập vào Firebase với thông tin đăng nhập Google
      final UserCredential userCredential = await FirebaseAuth
          .instance // Đăng nhập vào Firebase bằng thông tin đăng nhập Google
          .signInWithCredential(credential);

      // await FirebaseAuth
      //     .instance // Đăng nhập vào Firebase bằng thông tin đăng nhập Google
      //     .signInWithCredential(credential);

      // return userCredential.user;
      return OAuthLogin(
        provider: OauthProviderTypeEnum.google,
        accessToken: googleAuth.accessToken ?? "",
        // idToken: googleAuth.idToken ?? "",
        idToken: userCredential.user?.uid ?? "",
        name: googleUser.displayName ?? "",
      );
    } catch (e) {
      // print("Lỗi: $e");
      rethrow;
    }
  }
}
