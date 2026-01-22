import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/data/model/accommodation/accommodation_summary.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/repositories/accommodation_repository.dart';
import 'package:hotel_booking_app/data/service/accommodation_service.dart';
import 'package:hotel_booking_app/screens/hotel_list_screen.dart';

class SearchHotelScreen extends StatefulWidget {
  const SearchHotelScreen({super.key});

  @override
  _SearchHotelScreenState createState() => _SearchHotelScreenState();
}

class _SearchHotelScreenState extends State<SearchHotelScreen> {
  late List<AccommodationSummary> searchResults;

  // Biến trạng thái tải dữ liệu ( true - đang tải, false - đã tải xong )
  late bool isLoading;

  late bool isError;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchResults = [];
    isLoading = false;
    isError = false;
  }

  void fetchSearchResults(String keyword, int page, int size) async {
    try {
      setState(() {
        isLoading = true;
      });

      final ApiResponse<List<AccommodationSummary>> response =
          await AccommodationRepository(
            AccommodationService(),
          ).getAllAccommodationsBySearch(keyword, page, size);

      if (response.data != null) {
        debugPrint("Search results count: ${response.data!.length}");
        setState(() {
          searchResults = response.data!;
        });
      }
    } catch (e) {
      // Xử lý lỗi nếu cần
      setState(() {
        isError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám nhạt hiện đại
      body: SafeArea(
        child: Column(
          children: [
            // Thanh tìm kiếm cố định phía trên
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildSearchBar(),
            ),

            // Danh sách kết quả cuộn được
            Expanded(
              child: (isLoading)
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    )
                  : (isError)
                  ? Center(
                      child: Text(
                        "Đã có lỗi xảy ra. Vui lòng thử lại.",
                        style: TextStyle(color: Colors.redAccent, fontSize: 16),
                      ),
                    )
                  : (searchResults.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.room_preferences, size: 50, color: Colors.grey[300]),
                          Icon(
                            // Icons.favorite_border,
                            Icons.search_off,
                            size: 50,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            // "Không có phòng nào",
                            // "Chưa có khách sạn yêu thích",
                            "Chưa có kết quả tìm kiếm",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: searchResults.length, // Số lượng kết quả
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: buildResultCard(
                            accommodation: searchResults[index],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResultCard({required AccommodationSummary accommodation}) {
    return GestureDetector(
      onTap: () {
        context.push("/accommodation/${accommodation.accommodationId}");
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Phần ảnh ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20.0),
                  ),
                  child: Image(
                    image: NetworkImage(
                      "${AppConfig.baseUrl}images/${accommodation.image}",
                    ),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),

                // Badge Loại hình (Góc trái)
                Positioned(
                  top: 12,
                  left: 12,
                  child: _buildBadge(
                    Icons.hotel,
                    accommodation.type ?? "Loại",
                    Colors.blueAccent,
                  ),
                ),

                // Badge Giảm giá (Góc phải - MỚI THÊM)
                if (accommodation.hasDiscount)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        accommodation.getDiscountLabel(), // Ví dụ: -20%
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

            // --- 2. Phần thông tin chi tiết ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          accommodation.accommodationName ?? "Tên khách sạn",
                          maxLines: 1,
                          overflow: TextOverflow
                              .ellipsis, // Thêm cái này để tránh lỗi tràn text
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 18.0,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${accommodation.averageRating ?? 0.0}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Địa điểm
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14.0,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          accommodation.address ?? "Địa chỉ khách sạn",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),
                  const Divider(height: 1),
                  const SizedBox(height: 12.0),

                  // --- 3. Giá tiền (CẬP NHẬT LOGIC GIẢM GIÁ) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment
                        .end, // Căn đáy để giá tiền thẳng hàng
                    children: [
                      const Text(
                        "Giá mỗi đêm",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),

                      // Cột hiển thị giá (Giá gốc + Giá giảm)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Nếu có giảm giá -> Hiện giá gốc gạch ngang
                          if (accommodation.hasDiscount)
                            Text(
                              "${accommodation.getOriginalPriceToString()} VND",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                decoration:
                                    TextDecoration.lineThrough, // Gạch ngang
                              ),
                            ),

                          // Giá cuối cùng (Final Price)
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: accommodation.getFinalPriceToString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    // Đổi màu đỏ nếu đang giảm giá cho nổi bật
                                    color: accommodation.hasDiscount
                                        ? Colors.redAccent
                                        : const Color(0xFF64BCE3),
                                  ),
                                ),
                                TextSpan(
                                  text: " VND",
                                  style: TextStyle(
                                    fontSize:
                                        14, // Nhỏ hơn số tiền một chút cho đẹp
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
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

  // Helper để build badge loại hình (giữ nguyên hoặc tùy chỉnh)
  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBadge(IconData icon, String label, Color color) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.9),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(icon, size: 14, color: color),
  //         const SizedBox(width: 4),
  //         Text(
  //           label,
  //           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onSubmitted: (value) {
                String keyword = value.trim();
                if (keyword.isNotEmpty) {
                  fetchSearchResults(keyword, 0, 10);
                }
              },
              decoration: InputDecoration(
                hintText: 'Bạn muốn đi đâu?',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              controller: _searchController,
            ),
          ),
        ),
        const SizedBox(width: 10),
        TextButton(
          // onPressed: () => Navigator.pop(context),
          onPressed: () => context.pop(),
          child: const Text(
            "Hủy",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
