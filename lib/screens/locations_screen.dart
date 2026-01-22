import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/location/location_response.dart';
import 'package:hotel_booking_app/data/repositories/location_repository.dart';
import 'package:hotel_booking_app/data/service/location_service.dart';
import 'package:hotel_booking_app/data/service/location_servider.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  // List<Map<String, String>> locations = [
  //   {"district": "Bình Thạnh", "province": "Thành phố Hồ Chí Minh"},
  //   {"district": "Phú Nhuận", "province": "Thành phố Hồ Chí Minh"},
  //   {"district": "Quận 1", "province": "Thành phố Hồ Chí Minh"},
  //   {"district": "Đà Lạt", "province": "Lâm Đồng"},
  //   {"district": "Nha Trang", "province": "Khánh Hòa"},
  //   {"district": "Vũng Tàu", "province": "Bà Rịa - Vũng Tàu"},
  //   {"district": "Hội An", "province": "Quảng Nam"},
  //   {"district": "Huế", "province": "Thừa Thiên Huế"},
  // ];

  List<LocationResponse> locations = [];

  late bool _isLoading; // true: đang tải, false: đã tải xong
  late String _errorMessage;

  Future<void> _fetchLocations(String keyword) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Giả sử bạn có một hàm fetchLocationsFromApi() để lấy dữ liệu từ API
      // locations = await fetchLocationsFromApi();

      // Ví dụ tạm thời

      final ApiResponse<List<LocationResponse>> response =
          await LocationRepository(
            LocationService(),
          ).getLocations(keyword: keyword);

      if (response.data != null) {
        locations = response.data!;
      } else {
        _errorMessage = 'Không có dữ liệu địa điểm.';
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi tải địa điểm: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _errorMessage = '';
  }

  Widget headerBooking() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: IconButton(
            // onPressed: () => Navigator.pop(context),
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
        ),
        const Text(
          "Thay Đổi Vị trí",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 48), // Giữ cân bằng layout
      ],
    );
  }

  Widget _buidlSearchLocation() {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white, // Màu nền của cả khu vực nếu cần
        // color: Colors.amber,
      ),
      child: TextField(
        onSubmitted: (value) => _fetchLocations(value),
        decoration: InputDecoration(
          hintText: "Quận/Huyện, Tỉnh/Thành phố",
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          // Bật chế độ tô màu nền
          filled: true,
          fillColor:
              Colors.white, // Hoặc Color(0xFFF5F5F5) nếu muốn nền xám nhạt
          // Quan trọng: Loại bỏ viền mặc định
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  String? toNullIfBlank(String? value) {
    if (value == null) return null;
    if (value.trim().isEmpty) return null;
    return value.trim();
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          // backgroundColor: Colors.white,
          backgroundColor: Color(0xFFEAF3FF),
          // foregroundColor: Colors.black,
          foregroundColor: Color(0xFF84B5F0),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // side: BorderSide(color: Colors.grey.shade300),
        ),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });

          try {
            final Position position =
                await LocationServider.getCurrentLocation();

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

            final response = await Dio().get(
              "https://bilateral-misunderstandingly-veola.ngrok-free.dev/api/locations/me",
              queryParameters: queryParameters,
              options: Options(
                headers: {
                  "Content-Type": "application/json",
                  "Authorization":
                      "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJuZ3V5ZW5odXV0dWFua2hhbmc0MTJAZ21haWwuY29tIiwicm9sZSI6IlJPTEVfQ1VTVE9NRVIiLCJpYXQiOjE3Njg5NzkyMTIsImV4cCI6MTc2OTU4NDAxMn0.6MyZO7MQJw_5i4h0SPdbQ98DWg2nyGDWbQK5cr9P1H4",
                },
              ),
            );

            final data = response.data['data'];

            if (data == null) {
              throw Exception("API trả data null");
            }

            String label = "${data['districtName']}, ${data['provinceName']}";

            if (!mounted) return;

            context.pop({'label': label, 'locationId': data['locationId']});
          } on DioException catch (e) {
            debugPrint("Lỗi API: ${e.response?.data ?? e.message}");
          } catch (e, stackTrace) {
            debugPrint("Lỗi không xác định: $e");
            debugPrintStack(stackTrace: stackTrace);
          } finally {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.my_location_outlined, size: 20),
            SizedBox(width: 8),
            Text("Sử dụng vị trí hiện tại"),
          ],
        ),
      ),
    );
  }

  // List<Map<String, String>> locations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFFBF9FE),
      backgroundColor: const Color(0xFFF8F9FA),

      // appBar: AppBar(
      //   title: const Text(
      //     "Thay Đổi Vị trí",
      //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      //   ),
      //   backgroundColor: Colors.white,
      //   iconTheme: const IconThemeData(
      //     color: Colors.black, //change your color here
      //   ),
      // ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerBooking(),
              const SizedBox(height: 20),
              _buidlSearchLocation(),
              const SizedBox(height: 15),
              _buildButton(),

              // Container(
              //   child: Column(
              //     children: [

              //     ],
              //   ),
              // )
              const SizedBox(height: 20),
              Text(
                "Kết quả tìm kiếm",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: (_isLoading)
                    ? Center(child: CircularProgressIndicator())
                    : (locations.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 50,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Chưa có địa điểm nào được chọn",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () => context.pop({
                              'label':
                                  "${locations[index].districtName}, ${locations[index].provinceName}",
                              'locationId': locations[index].locationId ?? 1,
                            }),

                            leading: Icon(
                              Icons.location_on_outlined,
                              color: Colors.blueAccent,
                            ),
                            // title: Text(
                            //   "${locations[index]['district']}, ${locations[index]['province']}",
                            // ),
                            // title: Text("${locations[index]['district']}"),
                            title: Text("${locations[index].districtName}"),
                            // subtitle: Text("${locations[index]['province']}"),
                            subtitle: Text("${locations[index].provinceName}"),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, indent: 60),
                        itemCount: locations.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
