import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/data/repositories/accommodation_repository.dart';
import 'package:hotel_booking_app/data/service/accommodation_service.dart';
import 'package:hotel_booking_app/screens/room_detail_screen.dart';
import 'package:hotel_booking_app/screens/filter_hotel_screen.dart';
import 'package:hotel_booking_app/screens/hotel_list_screen.dart';
import 'package:hotel_booking_app/screens/search_hotel_screen.dart';

import '../data/model/accommodation/accommodation_summary.dart';
import '../data/model/api_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final AccommodationRepository _accommodationRepository =
      AccommodationRepository(AccommodationService());

  // Future cho danh sách dữ liệu
  late Future<ApiResponse<List<AccommodationSummary>>> _nearbyFuture;
  late Future<ApiResponse<List<AccommodationSummary>>> _popularFuture;

  late String currentLocation;
  late int typeAccommodationSelect;

  // Danh sách danh mục (Hardcode UI)
  final List<Map<String, dynamic>> types = [
    {"icon": Icons.hotel_outlined, "label": "Hotel", "id": 1},
    {"icon": Icons.house_outlined, "label": "Homestay", "id": 2},
    {"icon": Icons.apartment_outlined, "label": "Apartment", "id": 3},
    {"icon": Icons.villa_outlined, "label": "Villa", "id": 4},
    {"icon": Icons.cottage_outlined, "label": "Cottage", "id": 5},
    {"icon": Icons.beach_access_outlined, "label": "Resort", "id": 6},
  ];

  @override
  void initState() {
    super.initState();
    currentLocation = "Bình Thạnh, Thành Phố Hồ Chí Minh";
    typeAccommodationSelect = 0;

    // Gọi API (Tạm thời gọi chung getAllAccommodations, sau này tách API riêng nếu cần)
    _nearbyFuture = _accommodationRepository.getAllAccommodations();
    _popularFuture = _accommodationRepository.getAllAccommodations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Màu nền nhẹ nhàng
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Vị trí & Tìm kiếm)
              _buildHeader(),

              const SizedBox(height: 25),

              // 2. Danh mục (Horizontal List)
              _buildCategoryList(),

              const SizedBox(height: 25),

              // 3. Section: Vị trí gần (Horizontal List)
              _buildSectionTitle(
                title: "Vị Trí Gần",
                onTap: () => context.push("/filter"),
              ),
              const SizedBox(height: 15),
              _buildNearbyList(),

              const SizedBox(height: 25),

              // 4. Section: Khách sạn nổi bật (Vertical List)
              _buildSectionTitle(
                title: "Khách sạn nổi bật",
                onTap: () => context.push("/filter"),
              ),
              const SizedBox(height: 15),
              _buildPopularList(),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== WIDGET BUILDER METHODS ====================

  /// Widget Header: Hiển thị vị trí và nút tìm kiếm
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Vị Trí Hiện Tại",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  // TODO: Mở màn hình chọn vị trí
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF64BCE3),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        currentLocation,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Nút Search
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => context.push("/search"),
            icon: const Icon(Icons.search, size: 28, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  /// Widget Category: Danh sách loại phòng
  Widget _buildCategoryList() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: types.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final bool isSelected = index == typeAccommodationSelect;
          return GestureDetector(
            onTap: () {
              setState(() => typeAccommodationSelect = index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF64BCE3) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF64BCE3).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Icon(
                    types[index]["icon"],
                    color: isSelected ? Colors.white : Colors.black87,
                    size: 20,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      types[index]["label"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Widget Title Section: Tiêu đề và nút xem thêm
  Widget _buildSectionTitle({required String title, VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text(
            "Tìm phòng",
            style: TextStyle(color: Color(0xFF64BCE3)),
          ),
        ),
      ],
    );
  }

  /// Widget List Nearby: Danh sách nằm ngang
  Widget _buildNearbyList() {
    return SizedBox(
      height: 310, // Chiều cao đủ để chứa ảnh và thông tin giá
      child: FutureBuilder<ApiResponse<List<AccommodationSummary>>>(
        future: _nearbyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.data == null ||
              snapshot.data!.data!.isEmpty) {
            return const Center(child: Text("Không có dữ liệu"));
          }

          final data = snapshot.data!.data!;
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(width: 15),
            itemBuilder: (context, index) => _createNearbyCard(data[index]),
          );
        },
      ),
    );
  }

  /// Widget List Popular: Danh sách dọc
  Widget _buildPopularList() {
    return FutureBuilder<ApiResponse<List<AccommodationSummary>>>(
      future: _popularFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.data == null ||
            snapshot.data!.data!.isEmpty) {
          return const Text("Không có dữ liệu");
        }

        final data = snapshot.data!.data!;
        return ListView.separated(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // Scroll theo trang chính
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(height: 15),
          itemBuilder: (context, index) => _createPopularCard(data[index]),
        );
      },
    );
  }

  // ==================== ITEM CARD WIDGETS ====================

  /// Card cho danh sách ngang (Vị trí gần)
  Widget _createNearbyCard(AccommodationSummary item) {
    return GestureDetector(
      onTap: () => context.push("/accommodation/${item.accommodationId}"),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.1),
          //     spreadRadius: 2,
          //     blurRadius: 10,
          //     offset: const Offset(0, 5),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Ảnh + Badge giảm giá ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    "${AppConfig.baseUrl}images/${item.image}",
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                // Icon Tim
                // Positioned(
                //   top: 10,
                //   right: 10,
                //   child: Container(
                //     padding: const EdgeInsets.all(6),
                //     decoration: const BoxDecoration(
                //       color: Colors.white,
                //       shape: BoxShape.circle,
                //     ),
                //     child: const Icon(
                //       Icons.favorite_border,
                //       color: Colors.redAccent,
                //       size: 18,
                //     ),
                //   ),
                // ),
                // Badge Giảm giá (%)
                if (item.hasDiscount)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.getDiscountLabel(), // Ví dụ: -20%
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // --- 2. Thông tin chi tiết ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.accommodationName ?? "Unknown",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            "${item.averageRating ?? 0.0}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.address ?? "Chưa cập nhật địa chỉ",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // --- 3. Giá tiền (Xử lý hiển thị) ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nếu có giảm giá -> Hiện giá gốc bị gạch ngang
                      if (item.hasDiscount)
                        Text(
                          "${item.getOriginalPriceToString()} VNĐ",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration:
                                TextDecoration.lineThrough, // Gạch ngang
                          ),
                        ),
                      // Giá cuối cùng (Final Price)
                      Row(
                        children: [
                          Text(
                            "${item.getFinalPriceToString()} VNĐ",
                            style: TextStyle(
                              color: item.hasDiscount
                                  ? Colors
                                        .redAccent // Màu đỏ nếu giảm giá
                                  : const Color(0xFF64BCE3), // Màu xanh thường
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            " / đêm",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Card cho danh sách dọc (Nổi bật)
  Widget _createPopularCard(AccommodationSummary item) {
    return GestureDetector(
      onTap: () => context.push("/accommodation/${item.accommodationId}"),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Ảnh nhỏ bên trái
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "${AppConfig.baseUrl}images/${item.image}",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                // Badge giảm giá nhỏ
                if (item.hasDiscount)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.getDiscountLabel(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 15),

            // Thông tin bên phải
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.accommodationName ?? "Unknown",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${item.averageRating ?? 0.0}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.address ?? "No Address",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Giá tiền
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.hasDiscount)
                        Text(
                          "${item.getOriginalPriceToString()} VNĐ",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${item.getFinalPriceToString()} VNĐ",
                              style: TextStyle(
                                color: item.hasDiscount
                                    ? Colors.redAccent
                                    : const Color(0xFF64BCE3),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: ' / đêm',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
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
          ],
        ),
      ),
    );
  }
}
