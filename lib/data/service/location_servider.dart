import 'package:geolocator/geolocator.dart';

class LocationServider {
  // Phương thức tĩnh để lấy vị trí hiện tại của người dùng
  // Position: Lớp đại diện cho vị trí địa lý với vĩ độ, kinh độ, độ cao, tốc độ, v.v.
  /// Trong position có các thuộc tính như:
  /// - latitude (vĩ độ),
  /// - longitude (kinh độ),
  /// - accuracy (độ chính xác),
  /// - timestamp (thời gian lấy vị trí), v.v.
  static Future<Position> getCurrentLocation() async {
    // Kiểm tra dịch vụ định vị nghĩa là kiểm tra xem dịch vụ định vị trên thiết bị có được bật hay không
    // Kiểm tra quyền truy cập vị trí nghĩa là kiểm tra xem ứng dụng có quyền truy cập vị trí của thiết bị hay không

    bool servicerEnabled; // Kiểm tra dịch vụ định vị có được bật không

    LocationPermission permission; // Kiểm tra quyền truy cập vị trí

    servicerEnabled =
        await Geolocator.isLocationServiceEnabled(); // Kiểm tra dịch vụ định vị

    // Nếu dịch vụ định vị không được bật, trả về lỗi
    if (!servicerEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission =
        await Geolocator.checkPermission(); // Kiểm tra quyền truy cập vị trí
    if (permission == LocationPermission.denied) {
      // Nếu quyền bị từ chối
      permission =
          await Geolocator.requestPermission(); // Yêu cầu quyền truy cập vị trí
      if (permission == LocationPermission.denied) {
        // Nếu vẫn bị từ chối
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Nếu quyền bị từ chối vĩnh viễn
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Trả về vị trí hiện tại
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, // Độ chính xác cao
    );
  }
}
