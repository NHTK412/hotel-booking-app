# Hotel Booking App

Một ứng dụng đặt phòng khách sạn hiện đại được phát triển bằng Flutter, hỗ trợ đa nền tảng với tính năng tìm kiếm, đặt phòng và quản lý các đơn đặt hàng.

## Mô Tả Dự Án

Hotel Booking App là một ứng dụng di động toàn diện cho phép người dùng:
- Tìm kiếm và khám phá các khách sạn gần nhất
- Xem chi tiết phòng và giá cả
- Thực hiện đặt phòng trực tuyến
- Quản lý các đơn đặt phòng của mình
- Xác thực tài khoản an toàn

## Tính Năng Chính

- **Xác Thực Người Dùng**: Đăng nhập và đăng ký an toàn với Firebase Authentication
- **Tìm Kiếm Khách Sạn**: Tìm kiếm khách sạn theo vị trí địa lý
- **Google Maps Integration**: Hiển thị vị trí khách sạn trên bản đồ
- **Quản Lý Đơn Đặt**: Theo dõi và quản lý các đơn đặt phòng
- **Hình Ảnh & Media**: Tải lên hình ảnh chi tiết về phòng
- **Thông Báo Push**: Nhận thông báo về đơn đặt phòng qua FCM
- **Địa Chỉ Tìm Kiếm**: Tìm kiếm ngoạn từ ngữ hàm địa lý

## Công Nghệ Sử Dụng

### Framework & SDK
- **Flutter**: Khung phát triển ứng dụng đa nền tảng
- **Dart**: Ngôn ngữ lập trình

### Backend & Services
- **Backend**: Sử dụng Java Spring Boot
- **Firebase Authentication**: Xác thực người dùng
- **Firebase Cloud Messaging**: Thông báo đẩy
- **Google Maps API**: Dịch vụ bản đồ

### Dependencies Chính
- **google_maps_flutter**: Tích hợp Google Maps
- **firebase_auth**: Xác thực Firebase
- **firebase_messaging**: Thông báo đẩy
- **image_picker**: Chọn hình ảnh từ thư viện
- **geolocator**: Dịch vụ định vị địa lý
- **geocoding**: Chuyển đổi địa chỉ và tọa độ
- **google_sign_in**: Đăng nhập với Google
- **shared_preferences**: Lưu trữ dữ liệu cục bộ

## Nền Tảng Được Hỗ Trợ

- Android

## Bắt Đầu

### Yêu Cầu Tiên Quyết

- Flutter SDK (phiên bản 3.0 trở lên)
- Dart SDK
- Android Studio hoặc Xcode
- Tài khoản Firebase

### Cài Đặt

1. **Clone repository:**
```bash
git clone https://github.com/NHTK412/hotel-booking-fe
cd hotel-booking-fe
```

2. **Cài đặt dependencies:**
```bash
flutter pub get
```

3. **Cấu hình Firebase:**
   - Tạo dự án Firebase trên [Firebase Console](https://console.firebase.google.com)
   - Tải xuống `google-services.json` (Android) và `GoogleService-Info.plist` (iOS)
   - Đặt chúng vào thư mục tương ứng

4. **Chạy ứng dụng:**
```bash
flutter run
```

## Cấu Trúc Dự Án

```
lib/
├── main.dart                 # Điểm vào của ứng dụng
├── app_router.dart          # Định tuyến ứng dụng
├── app_state.dart           # Quản lý trạng thái toàn cục
├── firebase_options.dart    # Cấu hình Firebase
├── fcm_initializer.dart     # Khởi tạo FCM
│
├── components/              # Widget tái sử dụng
├── config/                  # Cấu hình ứng dụng
├── core/                    # Lõi ứng dụng
├── data/                    # Tầng dữ liệu (models, services)
├── providers/               # State management (Riverpod/Provider)
├── screens/                 # Các màn hình chính
└── utils/                   # Hàm tiện ích
```

## Cấu Hình Firebase

1. Đảm bảo Firebase được khởi tạo trong `main.dart`
2. Cấu hình các quy tắc Firestore cho phép truy cập phù hợp
3. Kích hoạt các phương thức xác thực cần thiết (Email, Google, v.v.)

## Kiểm Thử

Chạy các bài kiểm thử:
```bash
flutter test
```