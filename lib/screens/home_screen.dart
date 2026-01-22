import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'
    show Placemark, placemarkFromCoordinates;
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/data/repositories/accommodation_repository.dart';
import 'package:hotel_booking_app/data/service/accommodation_service.dart';
import 'package:hotel_booking_app/data/service/location_servider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Future cho vị trí (để hiển thị trên Header)
  late Future<Map<String, dynamic>> _locationFuture;

  late String currentLocation;
  late int typeAccommodationSelect;

  // [FIX 1] Chuyển thành nullable để tránh lỗi "Field accessed before initialization"
  int? locationId;

  final List<Map<String, dynamic>> types = [
    {"icon": Icons.hotel_outlined, "label": "Hotel", "id": 1, "json": "HOTEL"},
    {
      "icon": Icons.house_outlined,
      "label": "Homestay",
      "id": 2,
      "json": "HOMESTAY",
    },
    {
      "icon": Icons.apartment_outlined,
      "label": "Apartment",
      "id": 3,
      "json": "APARTMENT",
    },
    {"icon": Icons.hotel, "label": "Hostel", "id": 4, "json": "HOSTEL"},
    {
      "icon": Icons.beach_access_outlined,
      "label": "Resort",
      "id": 5,
      "json": "RESORT",
    },
  ];

  String? toNullIfBlank(String? value) {
    if (value == null) return null;
    if (value.trim().isEmpty) return null;
    return value.trim();
  }

  Future<Map<String, dynamic>> _fetchLocations() async {
    try {
      final Position position = await LocationServider.getCurrentLocation();

      double latitude = position.latitude;
      double longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      Placemark place = placemarks.first;

      String? sub =
          toNullIfBlank(place.subAdministrativeArea) ??
          toNullIfBlank(place.locality);

      String? ad = toNullIfBlank(
        place.administrativeArea == "Bình Dương"
            ? "Hồ Chí Minh"
            : place.administrativeArea,
      );

      if (ad != null) {
        ad = ad.replaceAll(RegExp(r'^(Tỉnh|Thành phố)\s*'), '');
      }

      debugPrint("subAdministrativeArea: $sub");
      debugPrint("administrativeArea: $ad");

      Map<String, dynamic> queryParameters = {
        "subAdministrativeArea": sub,
        "administrativeArea": ad,
      };

      queryParameters.removeWhere((key, value) => value == null);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String? accessToken = prefs.getString('access_token');

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("Access token is null or empty");
      }

      final response = await Dio().get(
        "https://bilateral-misunderstandingly-veola.ngrok-free.dev/api/locations/me",
        queryParameters: queryParameters,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      final data = response.data['data'];

      if (data == null) {
        throw Exception("API trả data null");
      }

      String label = "${data['districtName']}, ${data['provinceName']}";

      // Trả về map dữ liệu để hàm _initData xử lý
      return {'label': label, 'locationId': data['locationId']};
    } on DioException catch (e) {
      debugPrint("Lỗi API: ${e.response?.data ?? e.message}");
      return {};
    } catch (e, stackTrace) {
      debugPrint("Lỗi không xác định: $e");
      debugPrintStack(stackTrace: stackTrace);
      return {};
    }
  }

  @override
  void initState() {
    super.initState();
    currentLocation = "Đang xác định vị trí...";
    typeAccommodationSelect = 0;

    // [FIX 2] Khởi tạo Future rỗng ban đầu để UI không bị crash khi chưa có ID
    _nearbyFuture = Future.value(
      ApiResponse(success: true, message: " ", code: 200, data: []),
    );

    _popularFuture = Future.value(
      ApiResponse(success: true, message: " ", code: 200, data: []),
    );

    // Bắt đầu quy trình lấy dữ liệu
    _initData();
  }

  // [FIX 3] Hàm quản lý luồng dữ liệu tuần tự
  Future<void> _initData() async {
    // 1. Gán Future lấy location
    _locationFuture = _fetchLocations();

    try {
      // 2. Đợi kết quả location
      final locationData = await _locationFuture;

      if (locationData.containsKey('locationId') && mounted) {
        setState(() {
          // 3. Cập nhật state khi có ID
          locationId = locationData['locationId'];
          currentLocation = locationData['label'] ?? "Unknown";

          // 4. Gọi API lấy danh sách phòng dựa trên ID vừa có
          _refreshAccommodationData(locationId!);
        });
      }
    } catch (e) {
      debugPrint("Lỗi khởi tạo dữ liệu: $e");
    }
  }

  // [FIX 4] Hàm gọi API Accommodations tách riêng để tái sử dụng
  void _refreshAccommodationData(int locId) {
    _nearbyFuture = _accommodationRepository.getAllAccommodations(
      page: 0,
      size: 10,
      sortBy: false,
      type: types[typeAccommodationSelect]["json"],
      locationId: locId,
    );

    _popularFuture = _accommodationRepository.getAllAccommodations(
      page: 0,
      size: 10,
      sortBy: true,
      type: types[typeAccommodationSelect]["json"],
      locationId: locId,
    );
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
                // onTap: () => context.push("/filter"),
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
              // Sử dụng FutureBuilder để hiển thị trạng thái loading của Location
              FutureBuilder(
                future: _locationFuture,
                builder: (context, snapshot) {
                  // Chỉ cần xử lý hiển thị, logic gán biến đã làm ở _initData
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      "Đang tải...",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }

                  return GestureDetector(
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
                            currentLocation, // Biến này đã được update ở _initData
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
                  );
                },
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
              // [FIX 5] Chỉ gọi API khi đã có locationId
              if (locationId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Đang xác định vị trí, vui lòng đợi..."),
                  ),
                );
                return;
              }

              setState(() {
                typeAccommodationSelect = index;
                // Gọi hàm làm mới dữ liệu
                _refreshAccommodationData(locationId!);
              });
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
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: const Text(
              "Tìm phòng",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64BCE3),
                fontWeight: FontWeight.w500,
              ),
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
          // 1. Trạng thái đang tải
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 250,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // [FIX Logic] Nếu đang đợi Location (locationId == null) thì vẫn hiện loading hoặc trống
          if (locationId == null) {
            return const SizedBox(
              height: 250,
              child: Center(child: Text("Đang tải dữ liệu vị trí...")),
            );
          }

          // Kiểm tra các điều kiện lỗi hoặc rỗng
          final bool isError = snapshot.hasError;
          final bool noData =
              !snapshot.hasData ||
              snapshot.data?.data == null ||
              snapshot.data!.data!.isEmpty;

          // 2. Trạng thái Lỗi hoặc Không có dữ liệu
          if (isError || noData) {
            return Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10),
              // decoration: BoxDecoration(
              //   color: Colors.grey[50],
              //   borderRadius: BorderRadius.circular(16),
              //   border: Border.all(color: Colors.grey[200]!),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isError
                        ? Icons.wifi_off_rounded
                        : Icons.location_off_rounded,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isError
                        ? "Đã xảy ra lỗi kết nối"
                        : "Không tìm thấy chỗ nghỉ nào gần đây",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (isError)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: TextButton.icon(
                        onPressed: () {
                          if (locationId != null)
                            _refreshAccommodationData(locationId!);
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text("Thử lại"),
                      ),
                    ),
                ],
              ),
            );
          }

          // 3. Trạng thái có dữ liệu (Success)
          final data = snapshot.data!.data!;
          return SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(width: 15),
              itemBuilder: (context, index) => _createNearbyCard(data[index]),
            ),
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
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (locationId == null) {
          return const SizedBox.shrink(); // Ẩn đi nếu chưa có vị trí
        }

        final bool isError = snapshot.hasError;
        final bool noData =
            !snapshot.hasData ||
            snapshot.data?.data == null ||
            snapshot.data!.data!.isEmpty;

        if (isError || noData) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            // decoration: BoxDecoration(
            //   color: Colors.grey.withOpacity(0.05),
            //   borderRadius: BorderRadius.circular(12),
            //   border: Border.all(color: Colors.grey.withOpacity(0.2)),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isError
                      ? Icons.error_outline_rounded
                      : Icons.star_border_rounded,
                  size: 50,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  isError
                      ? "Không thể tải danh sách phổ biến"
                      : "Chưa có địa điểm nổi bật nào",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isError)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: InkWell(
                      onTap: () {
                        if (locationId != null)
                          _refreshAccommodationData(locationId!);
                      },
                      child: Text(
                        "Nhấn để thử lại",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        final data = snapshot.data!.data!;
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                        item.getDiscountLabel(),
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

                  // --- 3. Giá tiền ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.hasDiscount)
                        Text(
                          "${item.getOriginalPriceToString()} VNĐ",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Row(
                        children: [
                          Text(
                            "${item.getFinalPriceToString()} VNĐ",
                            style: TextStyle(
                              color: item.hasDiscount
                                  ? Colors.redAccent
                                  : const Color(0xFF64BCE3),
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
