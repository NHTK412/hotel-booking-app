import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/data/model/accommodation/accommodation_detail.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/roomtype/room_type_summary.dart';
import 'package:hotel_booking_app/data/repositories/accommodation_repository.dart';
import 'package:hotel_booking_app/data/service/accommodation_service.dart';
import 'package:hotel_booking_app/screens/room_detail_screen.dart';
import 'package:readmore/readmore.dart';

class HotelListScreen extends StatefulWidget {
  final int accommodationId;

  const HotelListScreen({super.key, required this.accommodationId});

  @override
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  final AccommodationRepository accommodationRepository =
      AccommodationRepository(AccommodationService());

  AccommodationDetail? _accommodationDetail;
  bool _isLoading = true;
  bool _isUpdatingFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchAccommodationDetail();
  }

  Future<void> _fetchAccommodationDetail() async {
    try {
      ApiResponse<AccommodationDetail> response = await accommodationRepository
          .getAccommodationById(widget.accommodationId);
      setState(() {
        _accommodationDetail = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Màu nền sáng nhẹ
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _accommodationDetail == null
            ? const Center(child: Text("Không tìm thấy dữ liệu"))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: _createBody(_accommodationDetail!),
              ),
      ),
    );
  }

  Widget _createBody(AccommodationDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 20),

        // Banner Image
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.network(
            "${AppConfig.baseUrl}images/${detail.image}",
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 250,
              color: Colors.grey[300],
              child: const Icon(Icons.hotel),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Title & Star Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                detail.accommodationName ?? "",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildInfoChip(
              Icons.star,
              detail.starRating.toString(),
              Colors.amber,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Location & Type Info
        Row(
          children: [
            _buildInfoChip(Icons.hotel, detail.type ?? "", Colors.blueAccent),
            const SizedBox(width: 8),
            _buildInfoChip(Icons.location_on, "4.5 km", Colors.green),
            const Spacer(),
            _buildFavoriteButton(detail),
          ],
        ),
        const SizedBox(height: 20),

        // Description
        _buildDescription(detail.description ?? ""),
        const SizedBox(height: 25),

        // Room Options List
        const Text(
          "Lựa chọn phòng",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: detail.roomTypes?.length ?? 0,
          separatorBuilder: (_, __) => const SizedBox(height: 15),
          itemBuilder: (context, index) => _buildRoomCard(
            detail.roomTypes![index],
            () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => RoomDetailScreen(
              //       roomTypeId: detail.roomTypes![index].roomTypeId!,
              //     ),
              //   ),
              // );
              context.push("/room-type/${detail.roomTypes![index].roomTypeId}");
            },
          ),
          // itemBuilder: (context, index) =>
          //     Text("${detail.roomTypes![index].roomTypeId}"),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // _buildIconNav(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
        _buildIconNav(Icons.arrow_back_ios_new, () => context.pop()),
        const Text(
          "Chi Tiết Khách Sạn",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 45), // Cân bằng với nút Back
      ],
    );
  }

  Widget _buildIconNav(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
          ],
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(AccommodationDetail detail) {
    bool isFav = detail.isFavorite ?? false;
    return IconButton(
      onPressed: _isUpdatingFavorite
          ? null
          : () async {
              setState(() => _isUpdatingFavorite = true);
              try {
                final result = await accommodationRepository
                    .updateFavoriteByAccommondationId(
                      detail.accommodationId!,
                      !isFav,
                    );
                setState(() {
                  _accommodationDetail = result.data;
                  _isUpdatingFavorite = false;
                });
              } catch (e) {
                setState(() => _isUpdatingFavorite = false);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
              }
            },
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.red : Colors.grey,
        size: 28,
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mô tả",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ReadMoreText(
          text,
          textAlign: TextAlign.justify,
          trimLines: 3,
          colorClickableText: Colors.blue,
          trimMode: TrimMode.Line,
          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.6),
        ),
      ],
    );
  }

  Widget _buildRoomCard(RoomTypeSummary room, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // --- 1. ẢNH VÀ BADGE GIẢM GIÁ ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                  child: Image.network(
                    "${AppConfig.baseUrl}images/${room.image}",
                    width: 120, // Tăng nhẹ width để badge đỡ che ảnh
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                // Badge giảm giá
                if (room.hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        room.getDiscountLabel(), // Ví dụ "-20%"
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // --- 2. THÔNG TIN PHÒNG ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên và Sao
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            room.name ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 2, // Cho phép xuống dòng nếu tên dài
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        _buildStar(room.star ?? 0),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Standard King Bed", // Hardcode hoặc lấy từ model nếu có
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),

                    // --- 3. HIỂN THỊ GIÁ ---
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Giá gốc (Gạch ngang - Chỉ hiện khi có giảm giá)
                        if (room.hasDiscount)
                          Text(
                            "${room.getOriginalPriceToString()} VNĐ",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),

                        // Giá cuối cùng (Final Price)
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: room.getFinalPriceToString(),
                                style: TextStyle(
                                  color: room.hasDiscount
                                      ? Colors.redAccent
                                      : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const TextSpan(
                                text: ' VNĐ/đêm',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStar(int star) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 14),
        const SizedBox(width: 2),
        Text(
          star.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}
