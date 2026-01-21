import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/data/model/accommodation/accommodation_summary.dart';
import 'package:hotel_booking_app/data/repositories/accommodation_repository.dart';
import 'package:hotel_booking_app/data/service/accommodation_service.dart';
import '../data/model/api_response.dart';

class FavoriteHotelScreen extends StatefulWidget {
  const FavoriteHotelScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteHotelScreenState();
}

class _FavoriteHotelScreenState extends State<FavoriteHotelScreen> {
  List<AccommodationSummary> accommodations = [];
  bool isLoading = true; // Mặc định là đang load
  String? error;
  bool _isUpdatingFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchAccommodations();
  }

  Future<void> _fetchAccommodations() async {
    try {
      setState(() => isLoading = true);
      ApiResponse<List<AccommodationSummary>> response =
          await AccommodationRepository(
            AccommodationService(),
          ).getAllAccommodationsByFavorite();
      accommodations = response.data ?? [];
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Màu nền xám nhạt hiện đại
      appBar: AppBar(
        title: const Text(
          "Danh Sách Yêu Thích",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchAccommodations,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : accommodations.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: accommodations.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildFavoriteCard(accommodations[index]);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    // return Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
    //       const SizedBox(height: 16),
    //       Text(
    //         "Chưa có khách sạn yêu thích",
    //         style: TextStyle(fontSize: 16, color: Colors.grey[600]),
    //       ),
    //     ],
    //   ),
    // );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(Icons.room_preferences, size: 50, color: Colors.grey[300]),
          Icon(Icons.favorite_border, size: 50, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(
            // "Không có phòng nào",
            "Chưa có khách sạn yêu thích",
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(AccommodationSummary hotel) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/accommodation/${hotel.accommodationId ?? 0}',
          // extra: {'accommodationId': hotel.accommodationId ?? 0},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh và Nút Like
              Stack(
                children: [
                  Image.network(
                    "${AppConfig.baseUrl}images/${hotel.image}",
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                  PositionBag(
                    right: 12,
                    top: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () async {
                          if (_isUpdatingFavorite) return;

                          setState(() => _isUpdatingFavorite = true);
                          try {
                            await AccommodationRepository(
                              AccommodationService(),
                            ).updateFavoriteByAccommondationId(
                              hotel.accommodationId!,
                              false,
                            );

                            setState(() {
                              accommodations.removeWhere(
                                (item) =>
                                    item.accommodationId ==
                                    hotel.accommodationId,
                              );
                              _isUpdatingFavorite = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${hotel.accommodationName} đã được xóa khỏi yêu thích",
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } catch (e) {
                            setState(() => _isUpdatingFavorite = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Lỗi: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            hotel.averageRating?.toString() ?? "0.0",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Thông tin văn bản
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.accommodationName ?? "Tên khách sạn",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.blue[400],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            hotel.address ?? "Địa chỉ",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${hotel.getFinalPriceToString()} VNĐ",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: " /đêm",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Chi tiết",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
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
      ),
    );
  }
}

// Widget con hỗ trợ định vị (Nếu không dùng Stack/Positioned mặc định)
class PositionBag extends StatelessWidget {
  final double? right, top, left, bottom;
  final Widget child;
  const PositionBag({
    super.key,
    this.right,
    this.top,
    this.left,
    this.bottom,
    required this.child,
  });
  @override
  Widget build(BuildContext context) => Positioned(
    right: right,
    top: top,
    left: left,
    bottom: bottom,
    child: child,
  );
}
