import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/app_router.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/data/enum/amenity_enum.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/roomtype/room_type_detail.dart';
// import 'package:hotel_booking_app/data/model/roomtype/room_type_detail.dart'; // Sử dụng class model ở trên
import 'package:hotel_booking_app/data/repositories/room_type_repository.dart';
import 'package:hotel_booking_app/data/service/room_type_service.dart';
import 'package:hotel_booking_app/screens/booking_screen.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';

class RoomDetailScreen extends StatefulWidget {
  final int roomTypeId;

  const RoomDetailScreen({Key? key, required this.roomTypeId})
    : super(key: key);

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  late Future<ApiResponse<RoomTypeDetail>> _roomDetailFuture;

  final RoomTypeRepository _roomTypeRepository = RoomTypeRepository(
    RoomTypeService(),
  );

  @override
  void initState() {
    super.initState();
    _roomDetailFuture = _roomTypeRepository.getRoomTypeById(widget.roomTypeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<ApiResponse<RoomTypeDetail>>(
          future: _roomDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Lỗi: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data?.data != null) {
              final roomTypeDetail = snapshot.data!.data!;

              // Tính toán giá để truyền vào nút đặt phòng
              final double finalPrice = roomTypeDetail.getFinalPrice();

              return Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const DetailHeader(),
                          const SizedBox(height: 20),
                          _createImageBanner(roomTypeDetail.image ?? ""),
                          const SizedBox(height: 25),

                          // --- UPDATED: Truyền toàn bộ object để hiển thị giá ---
                          _createDetailTitle(roomType: roomTypeDetail),

                          const SizedBox(height: 15),
                          _createBasicInfoRow(
                            bedroom: roomTypeDetail.bedroom ?? 0,
                            capacity: roomTypeDetail.capacity ?? 0,
                          ),
                          const SizedBox(height: 20),
                          const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                          const SizedBox(height: 15),
                          const Text(
                            "Tiện ích",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _createCategory(roomTypeDetail.amenities),
                          const SizedBox(height: 25),
                          _buildDescription(
                            roomTypeDetail.description ?? "Chưa có mô tả",
                          ),
                          const SizedBox(height: 25),
                          if (roomTypeDetail.imagesPreview.isNotEmpty)
                            DetailPreview(images: roomTypeDetail.imagesPreview),
                          const SizedBox(height: 25),
                          const ReviewSection(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, -4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: BookingButton(
                        roomTypeId: widget.roomTypeId,
                        // --- UPDATED: Sử dụng giá Final ---
                        price: roomTypeDetail.price ?? 0,
                        accommodationName: "Demo Accommodation",
                        roomTypeName: roomTypeDetail.name ?? "",
                        discountedPrice: roomTypeDetail.discount ?? 0,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("Không tìm thấy dữ liệu"));
            }
          },
        ),
      ),
    );
  }

  // --- WIDGET CẬP NHẬT HIỂN THỊ GIÁ ---
  Widget _createDetailTitle({required RoomTypeDetail roomType}) {
    // Lấy thông tin giá từ Model
    String originalPrice = roomType.getOriginalPriceToString(); // Giá gốc
    String finalPrice = roomType.getFinalPriceToString(); // Giá sau giảm
    String? discountBadge = roomType.getDiscountString(); // "-20%"

    // Kiểm tra xem có giảm giá không (nếu discount > 0)
    bool hasDiscount = (roomType.discount != null && roomType.discount! > 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cột TRÁI: Tên và Sao
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomType.name ?? "N/A",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < (roomType.star ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.orange,
                        size: 18,
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Cột PHẢI: Giá hiển thị
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 1. Hiển thị Giá Gốc (nếu có giảm giá)
                if (hasDiscount)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          discountBadge ?? "",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "$originalPrice ₫",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough, // Gạch ngang
                        ),
                      ),
                    ],
                  ),

                // 2. Hiển thị Giá Cuối (Final Price)
                Text(
                  "$finalPrice ₫",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    // Nếu có giảm giá thì màu Đỏ cho nổi bật, không thì màu xanh chủ đạo
                    color: hasDiscount
                        ? const Color(0xFFE53935)
                        : const Color(0xFF64BCE3),
                  ),
                ),
                const Text(
                  "/ đêm",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Location
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: Colors.redAccent,
              size: 18,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                roomType.localtion ?? "Unknown",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ... Các widget khác (_createImageBanner, _createBasicInfoRow, etc.) giữ nguyên như cũ ...

  Widget _createImageBanner(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        "${AppConfig.baseUrl}images/$imageUrl",
        fit: BoxFit.cover,
        height: 250,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 250,
          color: Colors.grey[200],
          child: const Center(
            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _createBasicInfoRow({required int bedroom, required int capacity}) {
    return Row(
      children: [
        _buildInfoItem(Icons.bed_outlined, "$bedroom Phòng ngủ"),
        const SizedBox(width: 20),
        _buildInfoItem(Icons.people_outline, "$capacity Khách"),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _createCategory(List<AmenityEnum> amenities) {
    if (amenities.isEmpty)
      return const Text(
        "Chưa cập nhật tiện ích",
        style: TextStyle(color: Colors.grey),
      );
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: amenities
          .map(
            (item) =>
                _buildAmenityChip(item.iconData, item.amenityName, Colors.blue),
          )
          .toList(),
    );
  }

  Widget _buildAmenityChip(IconData icon, String label, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mô tả",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ReadMoreText(
          description,
          textAlign: TextAlign.justify,
          trimMode: TrimMode.Line,
          trimLines: 3,
          colorClickableText: const Color(0xFF64BCE3),
          trimCollapsedText: ' Xem thêm',
          trimExpandedText: ' Rút gọn',
          style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
        ),
      ],
    );
  }
}

// --- CÁC COMPONENT CON ---
class DetailHeader extends StatelessWidget {
  const DetailHeader({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Colors.black,
            ),
          ),
        ),
        const Text(
          "Chi Tiết Phòng",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 45),
      ],
    );
  }
}

class DetailPreview extends StatelessWidget {
  final List<String> images;
  const DetailPreview({Key? key, required this.images}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hình ảnh xem trước",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "${AppConfig.baseUrl}images/${images[index]}",
                  width: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 130,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReviewSection extends StatelessWidget {
  const ReviewSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Nhận xét",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Xem tất cả",
                style: TextStyle(color: Color(0xFF64BCE3)),
              ),
            ),
          ],
        ),
        // Hardcode review example
        _buildReviewItem(
          "Nguyễn Văn A",
          "https://i.pinimg.com/originals/c6/e5/65/c6e56503cfdd87da299f72dc416023d4.jpg",
          5,
          "Phòng sạch đẹp, nhân viên thân thiện.",
          "12/10/2025",
        ),
      ],
    );
  }

  Widget _buildReviewItem(
    String name,
    String avatar,
    int rating,
    String comment,
    String date,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(avatar), radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.orange),
                  Text(
                    "$rating",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class BookingButton extends StatelessWidget {
  final int roomTypeId;
  final double price; // Đây là giá Final
  final String accommodationName;
  final String roomTypeName;
  final double discountedPrice;

  const BookingButton({
    Key? key,
    required this.roomTypeId,
    required this.price,
    required this.accommodationName,
    required this.roomTypeName,
    required this.discountedPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          context.push(
            "/booking",
            extra: BookingParams(
              roomTypeId: roomTypeId,
              originalPrice: price, // Truyền giá Final sang màn booking
              accommodationName: accommodationName,
              roomTypeName: roomTypeName,
              discountedPrice: discountedPrice,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF64BCE3),
          elevation: 0,
        ),
        child: const Text(
          "Đặt Phòng Ngay",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
