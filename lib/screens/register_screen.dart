import 'package:flutter/material.dart';
import 'package:hotel_booking_app/components/vector_wave_clipper.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/auth/auth_resgister.dart';
import 'package:hotel_booking_app/data/model/auth/auth_response.dart';
import 'package:hotel_booking_app/data/repositories/auth_repository.dart';
import 'package:hotel_booking_app/data/service/auth_service.dart';
import 'package:hotel_booking_app/screens/home_screen.dart';
import 'package:hotel_booking_app/screens/main_menu_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller cho PageView
  final PageController _pageController = PageController();

  // Controller nhập liệu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  // Trạng thái mật khẩu
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;

  // Trạng thái trang hiện tại (0: Info, 1: Password)
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Dùng SingleChildScrollView bao ngoài để tránh lỗi render khi bàn phím hiện
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              // --- HEADER (Giữ nguyên Clippath đẹp) ---
              Stack(
                children: [
                  ClipPath(
                    clipper: VectorWaveClipper(),
                    child: Container(
                      height:
                          size.height *
                          0.5, // Giảm nhẹ chiều cao header chút cho thoáng form
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
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_currentPage == 1) {
                                // Nếu đang ở bước 2, quay lại bước 1
                                _pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          const Text(
                            "Đăng Ký",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ),
                  // Ảnh minh họa
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        "assets/images/registerImage.png",
                        height: size.height * 0.35, // Giới hạn chiều cao ảnh
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // --- TITLE & STEP INDICATOR ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentPage == 0
                              ? "Thông Tin Cá Nhân"
                              : "Thiết Lập Bảo Mật",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Thanh chỉ số trang (Indicator)
                        Row(
                          children: [
                            _buildStepIndicator(isActive: _currentPage >= 0),
                            const SizedBox(width: 5),
                            _buildStepIndicator(isActive: _currentPage >= 1),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "${_currentPage + 1}/2",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- FORM (PAGEVIEW) ---
              Expanded(
                child: PageView(
                  controller: _pageController, // Điều khiển chuyển trang
                  physics:
                      const NeverScrollableScrollPhysics(), // Chặn vuốt tay để bắt buộc nhấn nút
                  onPageChanged: (index) {
                    // Cập nhật trạng thái trang hiện tại
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    // TRANG 1: THÔNG TIN
                    Column(
                      children: [
                        _buildInputBox(
                          controller: _nameController,
                          icon: Icons.person,
                          hint: "Họ và tên",
                          inputType: TextInputType.name,
                        ),
                        const SizedBox(height: 15),
                        _buildInputBox(
                          controller: _emailController,
                          icon: Icons.email,
                          hint: "Email",
                          inputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15),
                        _buildInputBox(
                          controller: _phoneController,
                          icon: Icons.phone,
                          hint: "Số điện thoại",
                          inputType: TextInputType.phone,
                        ),
                      ],
                    ),

                    // TRANG 2: MẬT KHẨU
                    Column(
                      children: [
                        _buildInputBox(
                          controller: _passController,
                          icon: Icons.lock,
                          hint: "Mật khẩu",
                          inputType: TextInputType.text,
                          isPassword: _obscurePass,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePass
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePass = !_obscurePass),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildInputBox(
                          controller: _confirmPassController,
                          icon: Icons.lock_outline,
                          hint: "Xác nhận mật khẩu",
                          inputType: TextInputType.text,
                          isPassword: _obscureConfirmPass,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPass
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPass = !_obscureConfirmPass,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- BUTTON ---
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: _handleButtonPress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5496D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    _currentPage == 0 ? "TIẾP TỤC" : "ĐĂNG KÝ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Logic xử lý nút bấm
  void _handleButtonPress() async {
    if (_currentPage == 0) {
      // Validate sơ bộ trang 1 (ví dụ)
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin.")),
        );
        return;
      }

      // Chuyển sang trang 2
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Xử lý Đăng ký
      // print("Đăng ký thành công!");
      await _register();
    }
  }

  Future<void> _register() async {
    // Xử lý logic đăng ký ở đây
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final password = _passController.text;
    final confirmPassword = _confirmPassController.text;
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mật khẩu xác nhận không khớp.")),
      );
      return;
    }

    // Gọi API đăng ký với dữ liệu thu thập được
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
      // Đăng ký thành công
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đăng ký thành công!")));

      final AuthResponse authResponse = response.data!;

      String accessToken = authResponse.accessToken ?? "";

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('access_token', accessToken);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainMenuScreen()),
      );
      // Navigator.pop(context); // Quay
    } else {
      // Đăng ký thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng ký thất bại: ${response.message}")),
      );
    }
  }

  // Widget Indicator (Thanh gạch ngang nhỏ hiển thị bước)
  Widget _buildStepIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 4,
      width: isActive ? 30 : 20,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF5496D2) : Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

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
        color: const Color(0xFFF0EEFD),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              keyboardType: inputType,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                suffixIcon: suffixIcon,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
