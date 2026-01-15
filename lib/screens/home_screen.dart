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

  // late Future<ApiResponse<List<AccommodationSummary>>> _fetchAll;

  late final Future<ApiResponse<List<AccommodationSummary>>> _fetchAll =
      _accommodationRepository.getAllAccommodations();

  late final Future<ApiResponse<List<AccommodationSummary>>> _fetch =
      _accommodationRepository.getAllAccommodations();

  late String localtion;

  late int typeAccommodationSelect;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localtion = "Bình Thạnh, Thành Phố Hồ Chí Minh";
    typeAccommodationSelect = 0;

    // _fetchAll = _accommodationRepository.getAllAccommodations();
  }

  List<Map<String, dynamic>> types = [
    {"icon": Icons.hotel_outlined, "label": "Hotel", "id": 1},
    {"icon": Icons.house_outlined, "label": "Homestay", "id": 2},
    {"icon": Icons.apartment_outlined, "label": "Apartment", "id": 3},
    {"icon": Icons.villa_outlined, "label": "Villa", "id": 4},
    {"icon": Icons.cottage_outlined, "label": "Cottage", "id": 5},
    {"icon": Icons.beach_access_outlined, "label": "Resort", "id": 6},
  ];

  Widget buildItem(int index) {
    bool isSelected =
        typeAccommodationSelect == index; // Giả sử bạn có biến này

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 350,
      ), // Tăng nhẹ thời gian để cảm nhận độ mượt
      curve: Curves.easeOut, // Curve này giúp hiệu ứng phản hồi nhanh và êm hơn
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.only(right: (index == types.length - 1) ? 0 : 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF64BCE3) : Colors.white,
        borderRadius: BorderRadius.circular(15), // Bo góc mềm mại hơn
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: const Color(0xFF64BCE3).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sử dụng TweenAnimationBuilder để Icon đổi màu mượt mà
          TweenAnimationBuilder<Color?>(
            duration: const Duration(milliseconds: 300),
            tween: ColorTween(
              begin: Colors.black,
              end: isSelected ? Colors.white : Colors.black87,
            ),
            builder: (context, color, child) {
              return Icon(types[index]["icon"], color: color, size: 22);
            },
          ),

          // Hiệu ứng văn bản trượt ra hoặc hiện hình mượt mà
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              // Nếu bạn muốn text biến mất khi không chọn, dùng: child: isSelected ? ... : SizedBox.shrink()
              padding: EdgeInsets.only(left: isSelected ? 10 : 0),
              child: isSelected
                  ? AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.transparent,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      child: Text(types[index]["label"]),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buidlType(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Cuộn ngang
        itemBuilder: (context, index) {
          final bool isSelected = index == typeAccommodationSelect;

          return GestureDetector(
            onTap: () {
              setState(() {
                typeAccommodationSelect = index;
              });
            },
            child: buildItem(index),
            // child: AnimatedContainer(
            //   duration: const Duration(milliseconds: 250),
            //   curve: Curves.easeInOut,
            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //   margin: EdgeInsets.only(
            //     right: (index == types.length - 1) ? 0 : 10,
            //   ),
            //   decoration: BoxDecoration(
            //     color: isSelected ? Color(0xFF64BCE3) : Colors.white,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Row(
            //     children: [
            //       Icon(
            //         types[index]["icon"],
            //         color: isSelected ? Colors.white : Colors.black,
            //       ),
            //       const SizedBox(width: 10),
            //       // Text(
            //       //   types[index]["label"],
            //       //   style: TextStyle(
            //       //     color: isSelected ? Colors.white : Colors.black,
            //       //     fontWeight: FontWeight.bold,
            //       //   ),
            //       // ),
            //       AnimatedDefaultTextStyle(
            //         duration: const Duration(milliseconds: 250),
            //         curve: Curves.easeInOut,
            //         style: TextStyle(
            //           color: isSelected ? Colors.white : Colors.black,
            //           fontWeight: FontWeight.bold,
            //         ),
            //         child: Text(types[index]["label"]),
            //       ),
            //     ],
            //   ),
            // ),
            // child: Container(
            //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //   margin: EdgeInsets.only(
            //     right: (index == types.length - 1) ? 0 : 10,
            //   ),
            //   decoration: BoxDecoration(
            //     // color: Color(0xFF64BCE3),
            //     // color: Colors.white,
            //     color: isSelected ? Color(0xFF64BCE3) : Colors.white,
            //     borderRadius: BorderRadius.all(Radius.circular(10)),
            //   ),
            //   child: Row(
            //     children: [
            //       // Icon(Icons.home_outlined, color: Colors.white),
            //       Icon(
            //         types[index]["icon"],
            //         color: isSelected ? Colors.white : Colors.black,
            //       ),
            //       SizedBox(width: 10),
            //       Text(
            //         // "Apart",
            //         types[index]["label"],
            //         style: TextStyle(
            //           color: isSelected ? Colors.white : Colors.black,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          );
        },
        itemCount: types.length,
      ),
    );

    // return SingleChildScrollView(
    //   scrollDirection: Axis.horizontal,
    //   child: Row(
    //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       GestureDetector(
    //         onTap: () {},
    //         child: Container(
    //           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //           decoration: BoxDecoration(
    //             color: Color(0xFF64BCE3),
    //             borderRadius: BorderRadius.all(Radius.circular(10)),
    //           ),
    //           child: Row(
    //             children: [
    //               Icon(Icons.home_outlined, color: Colors.white),
    //               SizedBox(width: 10),
    //               Text(
    //                 "Hotel",
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),

    //       SizedBox(width: 10),
    //       GestureDetector(
    //         onTap: () {},
    //         child: Container(
    //           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.all(Radius.circular(10)),
    //           ),
    //           child: Row(
    //             children: [
    //               Icon(Icons.house, color: Colors.black),
    //               SizedBox(width: 10),
    //               Text(
    //                 "Homestay",
    //                 style: TextStyle(
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),

    //       SizedBox(width: 10),

    //       GestureDetector(
    //         onTap: () {},
    //         child: Container(
    //           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //           decoration: BoxDecoration(
    //             // color: Color(0xFF64BCE3),
    //             color: Colors.white,
    //             borderRadius: BorderRadius.all(Radius.circular(10)),
    //           ),
    //           child: Row(
    //             children: [
    //               Icon(Icons.home_outlined, color: Colors.black),
    //               SizedBox(width: 10),
    //               Text(
    //                 "Apart",
    //                 style: TextStyle(
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),

    //       SizedBox(width: 10),

    //       GestureDetector(
    //         onTap: () {},
    //         child: Container(
    //           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //           decoration: BoxDecoration(
    //             // color: Color(0xFF64BCE3),
    //             color: Colors.white,
    //             borderRadius: BorderRadius.all(Radius.circular(10)),
    //           ),
    //           child: Row(
    //             children: [
    //               // Icon(Icons.home_outlined, color: Colors.white),
    //               Icon(Icons.home_outlined, color: Colors.black),
    //               SizedBox(width: 10),
    //               Text(
    //                 "Apart",
    //                 style: TextStyle(
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // child: Container(
        // padding: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vị Trí Hiện Tại",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final String? locationSelect = await context
                              .push<String>("/locations");
                          if (locationSelect != null) {
                            setState(() {
                              localtion = locationSelect;
                            });
                          }
                        },

                        // final List<Map<String, String>> locations = [
                        //   {
                        //     "index": "1",
                        //     "location": "Quận 1, Thành Phố Hồ Chí Minh",
                        //   },
                        //   {
                        //     "index": "2",
                        //     "location": "Quận 2, Thành Phố Hồ Chí Minh",
                        //   },
                        //   {
                        //     "index": "3",
                        //     "location": "Quận 3, Thành Phố Hồ Chí Minh",
                        //   },
                        //   {
                        //     "index": "4",
                        //     "location": "Quận 4, Thành Phố Hồ Chí Minh",
                        //   },
                        //   {
                        //     "index": "5",
                        //     "location": "Quận 5, Thành Phố Hồ Chí Minh",
                        //   },
                        // ];

                        // // showModalBottomSheet(
                        // //   useRootNavigator: true,
                        // //   isScrollControlled:
                        // //       true, // Cho phép tùy chỉnh chiều cao tốt hơn
                        // //   backgroundColor: Colors
                        // //       .transparent, // Để làm hiệu ứng bo góc mượt
                        // //   context: context,
                        // //   builder: (context) {
                        // //     return Container(
                        // //       height:
                        // //           MediaQuery.of(context).size.height * 0.6,
                        // //       decoration: const BoxDecoration(
                        // //         color: Colors.white,
                        // //         borderRadius: BorderRadius.vertical(
                        // //           top: Radius.circular(25),
                        // //         ),
                        // //       ),
                        // //       child: Column(
                        // //         children: [
                        // //           // 1. Handle bar trang trí
                        // //           Container(
                        // //             margin: const EdgeInsets.only(
                        // //               top: 12,
                        // //               bottom: 8,
                        // //             ),
                        // //             height: 4,
                        // //             width: 40,
                        // //             decoration: BoxDecoration(
                        // //               color: Colors.grey[300],
                        // //               borderRadius: BorderRadius.circular(10),
                        // //             ),
                        // //           ),

                        // //           // 2. Tiêu đề
                        // //           const Padding(
                        // //             padding: EdgeInsets.symmetric(
                        // //               vertical: 10,
                        // //             ),
                        // //             child: Text(
                        // //               "Chọn địa điểm",
                        // //               style: TextStyle(
                        // //                 fontSize: 18,
                        // //                 fontWeight: FontWeight.bold,
                        // //               ),
                        // //             ),
                        // //           ),
                        // //           const Divider(),

                        // //           // 3. Danh sách địa điểm
                        // //           Expanded(
                        // //             child: ListView.separated(
                        // //               // Sử dụng ListView.separated để có separator giữa các item ( separator là gì ? Là đường kẻ ngăn cách giữa các item )
                        // //               itemCount: locations.length,
                        // //               separatorBuilder: (context, index) =>
                        // //                   const Divider(
                        // //                     height: 1,
                        // //                     indent:
                        // //                         70, // Cách lề trái 70 để thẳng với nội dung
                        // //                   ),
                        // //               itemBuilder: (context, index) {
                        // //                 final item = locations[index];
                        // //                 return ListTile(
                        // //                   contentPadding:
                        // //                       const EdgeInsets.symmetric(
                        // //                         horizontal: 20,
                        // //                         vertical: 5,
                        // //                       ),
                        // //                   leading: CircleAvatar(
                        // //                     backgroundColor: Colors.blue[50],
                        // //                     child: Text(
                        // //                       item['index'] ?? "",
                        // //                       style: TextStyle(
                        // //                         color: Colors.blue[800],
                        // //                         fontWeight: FontWeight.bold,
                        // //                       ),
                        // //                     ),
                        // //                   ),
                        // //                   title: Text(
                        // //                     item['location'] ?? "",
                        // //                     style: const TextStyle(
                        // //                       fontSize: 15,
                        // //                       fontWeight: FontWeight.w500,
                        // //                     ),
                        // //                     maxLines: 2,
                        // //                     overflow: TextOverflow.ellipsis,
                        // //                   ),
                        // //                   trailing: const Icon(
                        // //                     Icons.chevron_right,
                        // //                     color: Colors.grey,
                        // //                   ),
                        // //                   onTap: () {
                        // //                     // Xử lý chọn địa điểm
                        // //                     Navigator.pop(context, item);
                        // //                   },
                        // //                 );
                        // //               },
                        // //             ),
                        // //           ),
                        // //         ],
                        // //       ),
                        // //     );
                        //   },
                        // );
                        // },
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.blueAccent),
                            // Text("Bình Thạnh, Thành Phố Hồ Chí Minh"),
                            Text(localtion),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(5),

                    // borderRadius: BorderRadius.circular(10),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return SearchHotelScreen();
                      //     },
                      //   ),
                      // );
                      context.push("/search");
                    },
                    icon: Icon(Icons.search, size: 30),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            //  -----
            _buidlType(context),

            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Vị Trí Gần",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => FilterHotelScreen(),
                          //   ),
                          // );

                          context.push("/filter");
                        },
                        child: Text(
                          // "Xem tất cả",
                          "Tìm phòng",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),

                  // danh sách
                  // SingleChildScrollView(
                  //   // padding: EdgeInsets.all(0),
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       createCart(),
                  //       SizedBox(width: 15),
                  //       createCart(),
                  //       SizedBox(width: 15),
                  //       createCart(),
                  //       SizedBox(width: 15),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    height: 300,
                    child: FutureBuilder(
                      future: _fetchAll,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }

                        if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                          return const Text("No data");
                        }

                        List<AccommodationSummary> data = snapshot.data!.data!;

                        // return Text("Số phần tử: ${snapshot.data!.data!.length}");
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            // return createCart();
                            return createCartWithData(data[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 5),

            Container(
              // decoration: BoxDecoration(color: Colors.cyanAccent),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Khách sạn nổi bật",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "Xem tất cả",
                      //     style: TextStyle(color: Colors.blue),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // createCart(),
                  // createPopularCard(),
                  // SizedBox(height: 15),
                  // createPopularCard(),
                  // SizedBox(height: 15),
                  // createPopularCard(),
                  // SizedBox(height: 15),
                  // createPopularCard(),

                  // FETCH KHACH SAN NOI BAT
                  FutureBuilder(
                    future: _fetch,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                        return Text("No data");
                      }
                      List<AccommodationSummary> data = snapshot.data!.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return createPopularCard(data[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // Danh sách nổi tiếng
            // SizedBox(height: 5),
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 10),
            //   width: double.infinity,
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           Expanded(
            //             child: Text(
            //               "Khách sạn nổi tiếng",
            //               style: TextStyle(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ),
            //           TextButton(
            //             onPressed: () {},
            //             child: Text(
            //               "Xem tất cả",
            //               style: TextStyle(color: Colors.blue),
            //             ),
            //           ),
            //         ],
            //       ),
            //       SingleChildScrollView(
            //         scrollDirection: Axis.vertical,
            //         child: Column(
            //           children: [
            //             createPopularCard(),
            //             SizedBox(width: 15),
            //             createPopularCard(),
            //             SizedBox(width: 15),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget createCart() {
    // return Container(
    //   padding: EdgeInsets.symmetric(vertical: 10),
    //   width: 250,
    //   child: Column(
    //     children: [
    //       Container(
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => RoomDetailScreen(roomTypeId: 1),
        //   ),
        // );
        context.push("/room-type/1");
      },
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 10),
        width: 250,
        // Giới hạn chiều rộng của card để giống trong hình
        //  padding: EdgeInsets.symmetric(vertical: 10),
        // width: 250,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20), // Bo góc toàn bộ card
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), // Màu bóng mờ
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5), // Độ lệch bóng xuống dưới
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái nội dung
          children: [
            // --- PHẦN 1: ẢNH VÀ ICON TIM (Dùng Stack) ---
            Stack(
              children: [
                // Ảnh nền
                ClipRRect(
                  // Chỉ bo góc trên trái và trên phải cho ảnh
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  // child: Image.network(
                  //   'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80', // Link ảnh mẫu
                  //   height: 180,
                  //   width: double.infinity,
                  //   fit: BoxFit.cover,
                  // ),
                  child: Image.asset(
                    "assets/images/anh.avif",
                    height: 180,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                // Icon Tim (Overlay)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            // --- PHẦN 2: THÔNG TIN CHI TIẾT ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dòng 1: Tên + Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'The Aston Vill Hotel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 4),
                          Text(
                            '5.0',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Dòng 2: Địa chỉ
                  const Text(
                    'Alice Springs NT 0870, Australia',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Dòng 3: Giá tiền (Dùng RichText để style 2 màu khác nhau)
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: '\$200.7',
                          style: TextStyle(
                            color: Colors.blue, // Màu xanh chủ đạo
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: ' / Mỗi Đêm',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    //     ],
    //   ),
    // );
  }

  Widget createCartWithData(AccommodationSummary accommodationSummary) {
    // return Container(
    //   padding: EdgeInsets.symmetric(vertical: 10),
    //   width: 250,
    //   child: Column(
    //     children: [
    //       Container(
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,

        //   MaterialPageRoute(
        //     builder: (context) => HotelListScreen(
        //       accommodationId: accommodationSummary.accommodationId ?? 1,
        //     ),
        //   ),
        // );
        context.push("/accommodation/${accommodationSummary.accommodationId}");
      },
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 10),
        width: 250,
        // Giới hạn chiều rộng của card để giống trong hình
        //  padding: EdgeInsets.symmetric(vertical: 10),
        // width: 250,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20), // Bo góc toàn bộ card
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), // Màu bóng mờ
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5), // Độ lệch bóng xuống dưới
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái nội dung
          children: [
            // --- PHẦN 1: ẢNH VÀ ICON TIM (Dùng Stack) ---
            Stack(
              children: [
                // Ảnh nền
                ClipRRect(
                  // Chỉ bo góc trên trái và trên phải cho ảnh
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    "${AppConfig.baseUrl}images/${accommodationSummary.image}",
                    height: 180,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                // Icon Tim (Overlay)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            // --- PHẦN 2: THÔNG TIN CHI TIẾT ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dòng 1: Tên + Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            // 'The Aston Vill Hotel',
                            '${accommodationSummary.accommodationName}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            Text(
                              // '5.0',
                              '${accommodationSummary.averageRating}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Dòng 2: Địa chỉ
                    Text(
                      // 'Alice Springs NT 0870, Australia',
                      '${accommodationSummary.address}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Dòng 3: Giá tiền (Dùng RichText để style 2 màu khác nhau)
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            // text: '\$200.7',
                            // text: '{accommodationSummary.minPricePerNight} VNĐ',
                            text:
                                // '${accommodationSummary.minPricePerNight} VNĐ',
                                '${accommodationSummary.getMinPricePerNightToString()} VNĐ',

                            style: TextStyle(
                              color: Colors.blue, // Màu xanh chủ đạo
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextSpan(
                            text: ' / Mỗi Đêm',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    //     ],
    //   ),
    // );
  }

  Widget createPopularCard(AccommodationSummary accommodationSummary) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HotelListScreen(
        //       accommodationId: accommodationSummary.accommodationId ?? 1,
        //     ),
        //   ),
        // );
        context.push("/accommodation/${accommodationSummary.accommodationId}");
      },
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.8,
        // width: double.infinity,
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color: Colors.yellow,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        // width: double.infinity,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                // image: AssetImage("assets/images/anh.avif"),
                image: NetworkImage(
                  "${AppConfig.baseUrl}images/${accommodationSummary.image}",
                ),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            // Column(
            //   children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      // SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          // "The Aston Vill Hotel",
                          accommodationSummary.accommodationName ?? "Not found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      // Text(
                      //   "The Aston Vill Hotel",
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text(
                        // '5.0',
                        accommodationSummary.averageRating.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),

                  // Text("Alice Springs NT 0870, Australia"),
                  Text(accommodationSummary.address ?? "Not found"),
                  SizedBox(height: 15),

                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          // text: '\$200.7',
                          text:
                              "${accommodationSummary.getMinPricePerNightToString()} VNĐ",
                          style: TextStyle(
                            color: Colors.blue, // Màu xanh chủ đạo
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: ' / Mỗi Đêm',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // ],
        // ),
      ),
    );
  }
}
