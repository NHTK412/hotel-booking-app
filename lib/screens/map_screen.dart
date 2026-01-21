import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_map_learning/location_servider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotel_booking_app/data/service/location_servider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  void _showHotelBottomSheet(Hotel hotel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Để làm bo góc đẹp hơn
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh kéo nhỏ phía trên
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
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      hotel.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '4.5',
                            style: TextStyle(
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      hotel.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${hotel.price.toString()} đ',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Quận 1, TP. Hồ Chí Minh',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // Nút Chỉ đường
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openGoogleMapsDirection(hotel),
                      icon: const Icon(Icons.directions),
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
                  // Nút Xem chi tiết
                  Expanded(
                    flex: 2, // Tăng gấp đôi kích thước so với nút Chỉ đường
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: navigate detail screen
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

  // Hàm mở Google Maps để chỉ đường
  Future<void> _openGoogleMapsDirection(Hotel hotel) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${hotel.latitude},${hotel.longitude}&travelmode=driving";
    final Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  // Khởi tạo 1 controller của google map
  late GoogleMapController _googleMapController;

  // Vị trí ban đầu của bản đồ
  final CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(10.939883, 106.716107), // Vị trí của TP.HCM
    zoom: 14,
  );

  LatLng? _userLocation; // Vị trí hiện tại của người dùng

  // LatLng: Lớp đại diện cho một cặp tọa độ vĩ độ và kinh độ
  // Ví dụ: LatLng(10.762622, 106.660172) đại diện cho vị trí của TP.HCM

  Set<Marker> _markers = {}; // Tập hợp các đánh dấu trên bản đồ

  Future<void> _loadMarkers() async {
    // Lấy danh sách khách sạn từ kho lưu trữ
    final hotels = await HotelRepository.getHotels();

    // await _loadCustomMarker();

    // final Set<Marker> markers = hotels.map((hotel) {
    //   return Marker(
    //     markerId: MarkerId(hotel.id), // ID của đánh dấu
    //     position: LatLng(
    //       hotel.latitude,
    //       hotel.longitude,
    //     ), // Vị trí của khách sạn
    //     infoWindow: InfoWindow(
    //       title: hotel.name, // Tên khách sạn
    //     ),
    //     // icon: customIcon,
    //   );
    // }).toSet();

    final markers = hotels.map((hotel) {
      return Marker(
        markerId: MarkerId(hotel.id),
        position: LatLng(hotel.latitude, hotel.longitude),
        onTap: () {
          _showHotelBottomSheet(hotel);
        },
      );
    }).toSet();

    setState(() {
      _markers = markers; // Cập nhật tập hợp đánh dấu
    });
  }

  Future<void> _loadUserLocation() async {
    try {
      // await Future.delayed(const Duration(seconds: 60)); // Giả lập độ trễ mạng
      // Lấy vị trí hiện tại của người dùng
      final Position position = await LocationServider.getCurrentLocation();

      setState(() {
        // Cập nhật vị trí người dùng
        _userLocation = LatLng(position.latitude, position.longitude);
      });

      // Di chuyển camera đến vị trí người dùng với mức zoom 15
      // animateCamera: Phương thức để di chuyển camera một cách mượt mà
      // CameraUpdate.newLatLngZoom: Tạo một đối tượng CameraUpdate để di chuyển đến vị trí mới với mức zoom cụ thể
      _googleMapController.animateCamera(
        // Di chuyển camera đến vị trí người dùng với mức zoom 15
        CameraUpdate.newLatLngZoom(_userLocation!, 14),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserLocation(); // Tải vị trí người dùng khi khởi
    _loadMarkers(); // Tải các đánh dấu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bản đồ khách sạn',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: _cameraPosition, // Thiết lập vị trí ban đầu
        // Khi bản đồ được tạo
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller; // Gán controller
        },
        myLocationButtonEnabled: true, // Hiển thị nút vị trí hiện tại
        myLocationEnabled: true, // Hiển thị vị trí hiện tại của người dùng

        markers: _markers, // Thiết lập các đánh dấu trên bản đồ
      ),
    );
  }
}

// late BitmapDescriptor customIcon;

// Future<void> _loadCustomMarker() async {
//   customIcon = await BitmapDescriptor.fromAssetImage(
//     const ImageConfiguration(
//       devicePixelRatio: 10.0, // số càng lớn → icon càng nhỏ
//     ),
//     'assets/icon.png',
//   );
// }

class HotelRepository {
  static Future<List<Hotel>> getHotels() async {
    // await Future.delayed(const Duration(seconds: 3)); // Giả lập độ trễ mạng
    return [
      Hotel(
        id: '1',
        name: 'Hotel A',
        latitude: 10.939883,
        longitude: 106.716107,
        image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      ),
      Hotel(
        id: '2',
        name: 'Hotel B',
        latitude: 10.939903,
        longitude: 106.715549,
        image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
        // 10.939903,106.715549
      ),
      Hotel(
        id: '3',
        name: 'Hotel C',
        latitude: 10.9299,
        longitude: 106.7194,
        image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      ),
    ];
  }
}

class Hotel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String image;
  final int price = 500000;

  Hotel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.image,
  });
}
