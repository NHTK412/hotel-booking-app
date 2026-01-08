import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 1. Thêm thư viện này để chỉnh Status Bar
import 'package:hotel_booking_app/screens/login_screen.dart';
import 'package:hotel_booking_app/screens/main_menu_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // 2. Thêm đoạn cấu hình này trước khi chạy app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Làm thanh trạng thái trong suốt
      statusBarIconBrightness:
          Brightness.dark, // Icon (pin, giờ) màu tối cho dễ nhìn
      // statusBarIconBrightness: Brightness.light, // Dùng cái này nếu nền app của bạn màu tối
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking', // Sửa lỗi chính tả Hottel -> Hotel
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 3. Đồng bộ màu xanh 0xFF64BCE3 vào đây
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF64BCE3),
          primary: const Color(0xFF64BCE3), // Ép màu chính là màu này
        ),
        useMaterial3: true, // Khuyên dùng Material 3 cho giao diện hiện đại
      ),
      home: const LoginScreen(),
      // home :  MenuUi(),
    );
  }
}
