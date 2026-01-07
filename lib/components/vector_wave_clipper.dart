import 'package:flutter/material.dart';

class VectorWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // 1. Bắt đầu từ góc trên trái (0,0)
    path.lineTo(0, size.height * 0.7); // Đi thẳng xuống cạnh trái khoảng 70%

    // 2. Vẽ đường cong phức tạp (Cubic Bezier)
    // Để tạo hình bầu bĩnh lệch về bên phải như ảnh vector:
    // - Điểm điều khiển 1 (p1): Kéo nhẹ ra ngang.
    // - Điểm điều khiển 2 (p2): Kéo thật sâu xuống dưới góc phải.
    // - Điểm kết thúc (end): Nằm ở cạnh phải, cao hơn điểm thấp nhất.

    var p1 = Offset(
      size.width * 0.3,
      size.height * 0.7,
    ); // Giữ đường cong là là ở đoạn đầu
    var p2 = Offset(
      size.width * 0.7,
      size.height * 1.15,
    ); // Đẩy bụng cong xuống sâu quá chiều cao thật (1.15)
    var end = Offset(
      size.width,
      size.height * 0.65,
    ); // Kết thúc ở cạnh phải, khoảng 65% chiều cao

    path.cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, end.dx, end.dy);

    // 3. Khép đường dẫn
    path.lineTo(size.width, 0); // Về góc trên phải
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
