import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

// --- IMPORT MODEL & REPOSITORY ---
import 'package:hotel_booking_app/data/model/accommodation/accommodation_summary.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/repositories/accommodation_repository.dart';
import 'package:hotel_booking_app/data/service/accommodation_service.dart';
import 'package:hotel_booking_app/data/service/location_servider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late AccommodationRepository _accommodationRepository;
  GoogleMapController? _googleMapController;

  bool _isLoading = true;
  Set<Marker> _markers = {};
  LatLng? _userLocation;

  final CameraPosition _defaultCameraPosition = const CameraPosition(
    target: LatLng(10.762622, 106.660172),
    zoom: 14,
  );

  // --- CẤU HÌNH ĐƯỜNG DẪN ẢNH ---
  // Thay đổi dòng này thành IP máy tính của bạn (VD: 192.168.1.X)
  static const String _serverBaseUrl = "http://192.168.1.13:8080/images/";

  @override
  void initState() {
    super.initState();
    _accommodationRepository = AccommodationRepository(AccommodationService());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initMapData();
    });
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  Future<void> _initMapData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      await _loadUserLocation();
      await _loadAccommodations();
    } catch (e) {
      debugPrint("Lỗi init map: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadUserLocation() async {
    try {
      final Position position = await LocationServider.getCurrentLocation();
      _userLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("⚠️ Không lấy được vị trí user: $e");
    }
  }

  Future<void> _loadAccommodations() async {
    try {
      ApiResponse<List<AccommodationSummary>> response;
      if (_userLocation != null) {
        response = await _accommodationRepository.getAllAccommodationsByNearby(
          _userLocation!.latitude,
          _userLocation!.longitude,
          5,
        );
      } else {
        response = await _accommodationRepository.getAllAccommodations(
          page: 0,
          size: 20,
        );
      }

      if (response.data != null && response.data!.isNotEmpty) {
        final markers = _createMarkersFromData(response.data!);
        if (mounted) {
          setState(() {
            _markers = markers;
          });
          _zoomToFitMarkers(response.data!);
        }
      }
    } catch (e) {
      debugPrint("❌ Lỗi API: $e");
    }
  }

  // --- TẠO MARKER (ĐÃ BỎ TYPE) ---
  Set<Marker> _createMarkersFromData(List<AccommodationSummary> list) {
    Set<Marker> markers = {};
    for (var item in list) {
      if (item.lat != null && item.lng != null && item.lat != 0) {
        markers.add(
          Marker(
            markerId: MarkerId(item.accommodationId.toString()),
            position: LatLng(item.lat!, item.lng!),
            infoWindow: InfoWindow(title: item.accommodationName),
            icon: BitmapDescriptor.defaultMarker, // Mặc định màu đỏ
            onTap: () => _showHotelBottomSheet(item),
          ),
        );
      }
    }
    return markers;
  }

  void _zoomToFitMarkers(List<AccommodationSummary> list) {
    if (_googleMapController == null || list.isEmpty) return;
    final validPoints = list
        .where((i) => i.lat != null && i.lng != null && i.lat != 0)
        .toList();
    if (validPoints.isEmpty) return;

    if (validPoints.length == 1) {
      _googleMapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(validPoints.first.lat!, validPoints.first.lng!),
          15,
        ),
      );
    } else {
      double minLat = 90.0, maxLat = -90.0, minLng = 180.0, maxLng = -180.0;
      for (var item in validPoints) {
        if (item.lat! < minLat) minLat = item.lat!;
        if (item.lat! > maxLat) maxLat = item.lat!;
        if (item.lng! < minLng) minLng = item.lng!;
        if (item.lng! > maxLng) maxLng = item.lng!;
      }
      _googleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          100.0,
        ),
      );
    }
  }

  String _getValidImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith("http")) return imagePath;
    return "${AppConfig.baseUrl}images/$imagePath";
  }

  // --- BOTTOM SHEET (ĐÃ BỎ TYPE) ---
  void _showHotelBottomSheet(AccommodationSummary item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // --- ẢNH & RATING (Không còn Type) ---
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: item.image != null && item.image!.isNotEmpty
                        ? Image.network(
                            _getValidImageUrl(item.image),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),

                  // Chỉ còn Rating góc phải
                  if (item.averageRating != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.averageRating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // --- TÊN, ĐỊA CHỈ & GIÁ ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.accommodationName ?? "Chưa có tên",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.address ?? "Chưa có địa chỉ",
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${item.getFinalPriceToString()} đ',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.hasDiscount)
                        Text(
                          '${item.getOriginalPriceToString()} đ',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        "/đêm",
                        style: TextStyle(color: Colors.grey[500], fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- BUTTONS ---
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openGoogleMapsDirection(item),
                      icon: const Icon(Icons.directions_outlined),
                      label: const Text('Chỉ đường'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(id: item.accommodationId)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Xem chi tiết',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
          SizedBox(height: 8),
          Text("Chưa có hình ảnh", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Future<void> _openGoogleMapsDirection(AccommodationSummary item) async {
    if (item.lat == null || item.lng == null) return;
    final Uri uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=${item.lat},${item.lng}",
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bản đồ khách sạn'), centerTitle: true),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _defaultCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: _markers,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            padding: const EdgeInsets.only(bottom: 20),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (!_isLoading && _markers.isEmpty)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: Colors.orange),
                      SizedBox(width: 10),
                      Expanded(child: Text("Không tìm thấy địa điểm nào.")),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
