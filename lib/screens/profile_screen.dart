import 'package:flutter/material.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/user/user_response.dart';
import 'package:hotel_booking_app/data/repositories/user_repository.dart';
import 'package:hotel_booking_app/data/service/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserRepository userRepository = UserRepository(UserService());
  late Future<ApiResponse<UserResponse>> _fetchUser;

  // Màu chủ đạo
  final Color colorTheme = const Color(0xFF64BCE3);
  final Color colorBackground = const Color(0xFFF5F7FA); // Màu nền xám nhạt

  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textPhoneController = TextEditingController();
  final TextEditingController _textEmailController = TextEditingController();
  final TextEditingController _textGenderController = TextEditingController();
  final TextEditingController _textBirthdayController = TextEditingController();
  final TextEditingController _textAddressController = TextEditingController();

  late int currentIndex; // Chỉ mục hiện tại của BottomNavigationBar
  bool isEditing = false;
  bool isDataLoaded = false; // Cờ để kiểm soát việc gán dữ liệu lần đầu

  @override
  void initState() {
    super.initState();
    // _fetchUser = userRepository.getUserProfile(4);
    _fetchUser = userRepository.getCurrentUser();
    currentIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground, // Nền tổng thể
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FutureBuilder<ApiResponse<UserResponse>>(
            future: _fetchUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final apiResponse = snapshot.data!;
                if (apiResponse.data != null) {
                  // Chỉ gán dữ liệu vào controller 1 lần đầu hoặc khi không edit
                  if (!isDataLoaded) {
                    _populateControllers(apiResponse.data!);
                    isDataLoaded = true;
                  }
                  return _buildProfileBody(apiResponse.data!);
                } else {
                  return const Center(
                    child: Text('Không có dữ liệu người dùng'),
                  );
                }
              } else {
                return const Center(child: Text('Không có dữ liệu'));
              }
            },
          ),
        ),
      ),
    );
  }

  // Hàm gán dữ liệu vào Controller
  void _populateControllers(UserResponse user) {
    _textNameController.text = user.name ?? "";
    _textPhoneController.text = user.phone ?? "";
    _textEmailController.text = user.email ?? "";
    _textGenderController.text = user.gender ?? "";
    _textBirthdayController.text = user.getBirthdayFormatted();
    _textAddressController.text = user.address ?? "";
  }

  Widget _buildProfileBody(UserResponse userResponse) {
    return Column(
      children: [
        _buildHeader(userResponse),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildSectionCard(
                title: "Thông tin tài khoản",
                children: [
                  _buildTextFieldItem(
                    controller: _textPhoneController,
                    label: "Số điện thoại",
                    icon: Icons.phone_android_rounded,
                  ),
                  const Divider(height: 20, thickness: 0.5),
                  _buildTextFieldItem(
                    controller: _textEmailController,
                    label: "Email",
                    icon: Icons.email_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: "Thông tin cá nhân",
                children: [
                  _buildTextFieldItem(
                    controller: _textGenderController,
                    label: "Giới tính",
                    icon: Icons.person_outline_rounded,
                  ),
                  const Divider(height: 20, thickness: 0.5),
                  _buildTextFieldItem(
                    controller: _textBirthdayController,
                    label: "Ngày sinh",
                    icon: Icons.cake_rounded,
                  ),
                  const Divider(height: 20, thickness: 0.5),
                  _buildTextFieldItem(
                    controller: _textAddressController,
                    label: "Địa chỉ",
                    icon: Icons.location_on_rounded,
                    maxLines: 2,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: _buildActionButton()),
                  const SizedBox(width: 10),
                  Expanded(child: _buildLogoutButton()),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  // Header chứa Avatar và Tên
  Widget _buildHeader(UserResponse userResponse) {
    return Column(
      children: [
        const SizedBox(height: 40),
        // Avatar với viền trắng
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              "${AppConfig.baseUrl}images/${userResponse.avatarUrl ?? ''}",
            ),
            onBackgroundImageError: (_, __) {
              // Fallback nếu ảnh lỗi
            },
            child: userResponse.avatarUrl == null
                ? const Icon(Icons.person, size: 60, color: Colors.grey)
                : null,
          ),
        ),
        const SizedBox(height: 15),
        // Tên người dùng (Cho phép sửa)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            controller: _textNameController,
            readOnly: !isEditing,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              border: isEditing
                  ? const UnderlineInputBorder()
                  : InputBorder.none,
              hintText: "Nhập tên của bạn",
              isDense: true,
            ),
          ),
        ),
      ],
      // ),
      // ],
    );
  }

  // Widget khung chứa từng nhóm thông tin (Card trắng)
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  // Widget tái sử dụng cho từng dòng nhập liệu
  Widget _buildTextFieldItem({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: maxLines > 1
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        // Icon bên trái
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorTheme.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colorTheme, size: 20),
        ),
        const SizedBox(width: 15),

        // Label và Input
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: controller,
                readOnly: !isEditing,
                maxLines: maxLines,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: isEditing ? 10 : 0,
                  ),
                  border: isEditing
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorTheme),
                        )
                      : InputBorder.none,
                  enabledBorder: isEditing
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        )
                      : InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorTheme),
                  ),
                  filled: isEditing,
                  fillColor: isEditing
                      ? Colors.grey.shade50
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Nút hành động
  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            isEditing = !isEditing;
          });
          // Nếu chuyển từ edit -> view thì có thể gọi API update tại đây
        },
        icon: Icon(isEditing ? Icons.save_rounded : Icons.edit_rounded),
        label: Text(isEditing ? 'Lưu' : 'Chỉnh sửa'),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorTheme,
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        label: const Text("Đăng xuất"),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
