import 'package:flutter/material.dart';
import 'package:hotel_booking_app/data/repositories/accommodationRepository.dart';
import 'package:hotel_booking_app/data/service/accommodationService.dart';
import 'package:hotel_booking_app/screens/detailCart.dart';
import 'package:hotel_booking_app/screens/hotalUi.dart';
import 'package:hotel_booking_app/screens/searchUi.dart';

import '../data/model/accommodation/accommodationSummary.dart';
import '../data/model/apiResponse.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeUiState();
  }
}

class _HomeUiState extends State<HomeUi> {
  final AccommodationRepository _accommodationRepository =
      AccommodationRepository(AccommodationService());

  // late Future<ApiResponse<List<AccommodationSummary>>> _fetchAll;

  late final Future<ApiResponse<List<AccommodationSummary>>> _fetchAll =
      _accommodationRepository.getAllAccommodations();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _fetchAll = _accommodationRepository.getAllAccommodations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
                      Text("Vị Trí Hiện Tại"),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blueAccent),
                          Text("Bình Thạnh, Thành Phố Hồ Chí Minh"),
                        ],
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SearchUi();
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.search, size: 30),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF64BCE3),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.home_outlined, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Hotel",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.house, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            "Homestay",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        // color: Color(0xFF64BCE3),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.home_outlined, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            "Apart",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        // color: Color(0xFF64BCE3),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          // Icon(Icons.home_outlined, color: Colors.white),
                          Icon(Icons.home_outlined, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            "Apart",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

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
                        onPressed: () {},
                        child: Text(
                          "Xem tất cả",
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
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Xem tất cả",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),

                  // createCart(),
                  createPopularCard(),
                  SizedBox(height: 15),
                  createPopularCard(),
                  SizedBox(height: 15),
                  createPopularCard(),
                  SizedBox(height: 15),
                  createPopularCard(),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailCart()),
        );
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
                          text: ' /night',
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
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (context) => HotelUi(
              accommodationId: accommodationSummary.accommodationId ?? 1,
            ),
          ),
        );
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
                    "http://10.0.2.2:8080/api/images/${accommodationSummary.image}",
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
                            text: ' /night',
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

  Widget createPopularCard() {
    return Container(
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
            borderRadius: BorderRadius.circular(17),
            child: Image(
              image: AssetImage("assets/images/anh.avif"),
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
                        "The Aston Vill Hotel",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
                    Text('5.0', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),

                SizedBox(height: 5),

                Text("Alice Springs NT 0870, Australia"),

                SizedBox(height: 15),

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '\$200.7',
                        style: TextStyle(
                          color: Colors.blue, // Màu xanh chủ đạo
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: ' /night',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
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
    );
  }
}
