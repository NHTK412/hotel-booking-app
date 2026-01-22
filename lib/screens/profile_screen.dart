import 'package:flutter/material.dart';
import 'package:hotel_booking_app/app_state.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/user/user_response.dart';
import 'package:hotel_booking_app/data/repositories/user_repository.dart';
import 'package:hotel_booking_app/data/service/user_service.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserRepository userRepository = UserRepository(UserService());
  late Future<ApiResponse<UserResponse>> _fetchUser;
  final ImagePicker _picker = ImagePicker();

  // Màu chủ đạo
  final Color colorTheme = const Color(0xFF64BCE3);
  final Color colorBackground = const Color(0xFFF5F7FA); // Màu nền xám nhạt

  // Mapping giữa enum value và display name
  static const Map<String, String> genderMapping = {
    'MALE': 'Nam',
    'FEMALE': 'Nữ',
    'OTHER': 'Khác',
  };

  static const Map<String, String> genderReverseMapping = {
    'Nam': 'MALE',
    'Nữ': 'FEMALE',
    'Khác': 'OTHER',
  };

  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textPhoneController = TextEditingController();
  final TextEditingController _textEmailController = TextEditingController();
  final TextEditingController _textGenderController = TextEditingController();
  final TextEditingController _textBirthdayController = TextEditingController();
  final TextEditingController _textAddressController = TextEditingController();

  late int currentIndex; // Chỉ mục hiện tại của BottomNavigationBar
  bool isEditing = false;
  bool isDataLoaded = false; // Cờ để kiểm soát việc gán dữ liệu lần đầu
  bool isUploadingImage = false; // Cờ để kiểm soát trạng thái upload
  bool isSavingProfile = false; // Cờ để kiểm soát trạng thái lưu
  String _currentImageFileName = ""; // Lưu tên file ảnh hiện tại
  late UserResponse _currentUserResponse; // Lưu thông tin người dùng hiện tại

  @override
  void initState() {
    super.initState();
    // _fetchUser = userRepository.getUserProfile(4);
    _fetchUser = userRepository.getCurrentUser();
    currentIndex = 1;
  }

  Future<XFile?> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<void> _uploadImage(XFile image) async {
    setState(() {
      isUploadingImage = true;
    });

    try {
      final Dio dio = Dio();

      MultipartFile file = await MultipartFile.fromFile(
        image.path,
        filename: image.name,
      );

      FormData formData = FormData.fromMap({'file': file});

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('access_token');

      final response = await dio.post(
        '${AppConfig.baseUrl}file-upload/image',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      debugPrint('Upload response: ${response.data}');
      if (response.data != null && response.data['data'] != null) {
        debugPrint("File name: ${response.data['data']['fileName']}");

        setState(() {
          _currentImageFileName = response.data['data']['fileName'] ?? "";
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tải ảnh lên thành công'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tải ảnh: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      setState(() {
        isUploadingImage = false;
      });
    }
  }

  Future<void> _saveUserProfile() async {
    setState(() {
      isSavingProfile = true;
    });

    try {
      // Parse ngày sinh từ text
      final birthdayParts = _textBirthdayController.text.split('/');
      DateTime birthday = DateTime.now();
      if (birthdayParts.length == 3) {
        birthday = DateTime(
          int.parse(birthdayParts[2]),
          int.parse(birthdayParts[1]),
          int.parse(birthdayParts[0]),
        );
      }

      // Lấy avatar URL hiện tại (từ upload mới hoặc từ dữ liệu cũ)
      String avatarUrl = _currentImageFileName.isNotEmpty
          ? _currentImageFileName
          : _currentUserResponse.avatarUrl ?? "";

      // Chuyển display name sang enum value
      String genderValue =
          genderReverseMapping[_textGenderController.text] ??
          _textGenderController.text;

      final response = await userRepository.updateCurrentUser(
        name: _textNameController.text,
        phone: _textPhoneController.text,
        email: _textEmailController.text,
        gender: genderValue,
        birthday: birthday,
        address: _textAddressController.text,
        avatarUrl: avatarUrl,
      );

      if (response.data != null) {
        // Cập nhật lại dữ liệu hiện tại
        _currentUserResponse = response.data!;

        setState(() {
          isEditing = false;
          isDataLoaded = false; // Reset cờ để reload dữ liệu
          _fetchUser = userRepository.getCurrentUser();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật thông tin thành công'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi cập nhật thông tin: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      setState(() {
        isSavingProfile = false;
      });
    }
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
                  // Lưu userResponse hiện tại
                  _currentUserResponse = apiResponse.data!;
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
    // Chuyển enum value sang display name
    _textGenderController.text =
        genderMapping[user.gender] ?? user.gender ?? "";
    _textBirthdayController.text = user.getBirthdayFormatted();
    _textAddressController.text = user.address ?? "";
  }

  // Widget dropdown cho giới tính
  Widget _buildGenderDropdown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon bên trái
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorTheme.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.person_outline_rounded,
            color: colorTheme,
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        // Label và Dropdown
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Giới tính',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              if (isEditing)
                DropdownButtonFormField<String>(
                  value: _textGenderController.text.isNotEmpty
                      ? _textGenderController.text
                      : null,
                  items: genderMapping.values
                      .map(
                        (gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _textGenderController.text = value ?? "";
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorTheme),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorTheme),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                )
              else
                Text(
                  _textGenderController.text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
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
                  _buildGenderDropdown(),
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
        // Avatar với nút upload
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            // Avatar container
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
                backgroundImage: _currentImageFileName.isNotEmpty
                    ? NetworkImage(
                        "${AppConfig.baseUrl}images/$_currentImageFileName",
                      )
                    : NetworkImage(
                        "${AppConfig.baseUrl}images/${userResponse.avatarUrl ?? ''}",
                      ),
                onBackgroundImageError: (_, __) {
                  // Fallback nếu ảnh lỗi
                },
                child:
                    (userResponse.avatarUrl == null &&
                        _currentImageFileName.isEmpty)
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
              ),
            ),
            // Nút upload ảnh
            if (isEditing)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorTheme,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isUploadingImage
                        ? null
                        : () async {
                            final XFile? image = await _pickImageFromGallery();
                            if (image != null) {
                              await _uploadImage(image);
                            }
                          },
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isUploadingImage
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                ),
              ),
          ],
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
        onPressed: isSavingProfile
            ? null
            : () async {
                if (isEditing) {
                  // Lưu thông tin
                  await _saveUserProfile();
                } else {
                  // Chuyển sang chế độ chỉnh sửa
                  setState(() {
                    isEditing = true;
                  });
                }
              },
        icon: Icon(isEditing ? Icons.save_rounded : Icons.edit_rounded),
        label: isSavingProfile
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(isEditing ? 'Lưu' : 'Chỉnh sửa'),
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
        onPressed: () {
          context.read<AppState>().logOut();
        },
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
