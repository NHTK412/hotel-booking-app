import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/bookUI.dart';
import 'package:readmore/readmore.dart';

class DetailCart extends StatefulWidget {
  const DetailCart({Key? key}) : super(key: key);

  @override
  _DetailCartState createState() => _DetailCartState();
}

class _DetailCartState extends State<DetailCart> {
  // Criteria
  // final List<Map<Icon, String>> criteria = [
  //   {Icon(Icons.wifi, color: Colors.white, size: 20): "Free Wifi"},
  //   {
  //     Icon(Icons.breakfast_dining, color: Colors.white, size: 20):
  //         "Free Breakfast",
  //   },
  //   {Icon(Icons.star, color: Colors.white, size: 20): "5.0"},
  // ];

  bool isReadMore = false;

  final List<Map<String, dynamic>> criteria = [
    {"icon": Icons.wifi, "text": "Free Wifi"},
    {"icon": Icons.breakfast_dining, "text": "Free Breakfast"},
    {"icon": Icons.star, "text": "5.0"},
    // {"icon": Icons.pool, "text": "Pool"}, // Thêm ví dụ để thấy xuống dòng
    // {"icon": Icons.ac_unit, "text": "A/C"},
    // {"icon": Icons.local_parking, "text": "Parking"},
    // {"icon": Icons.fitness_center, "text": "Gym"},
    // Thêm ví dụ để thấy xuống dòng
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Detail Cart')),
      // body: Center(child: Text('This is the Detail Cart screen')),
      body: SafeArea(
        child: SingleChildScrollView(
          // padding: EdgeInsets.all(16),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            children: [
              header(),

              const SizedBox(height: 20),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: AssetImage("assets/images/anh.avif"),
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
              ),

              const SizedBox(height: 25),

              category(),

              const SizedBox(height: 25),

              titleDetail(),

              const SizedBox(height: 25),

              description(),

              const SizedBox(height: 25),

              preview(),

              const SizedBox(height: 30),
              button(),
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookUi()),
        );
      },
      child: Text("Đặt Phòng"),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Color(0xFF64BCE3),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget preview() {
    return Container(
      width: double.infinity,

      // decoration: BoxDecoration(color: Colors.redAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Preview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                    image: AssetImage("assets/images/anh.avif"),
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 15),

                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                    image: AssetImage("assets/images/anh.avif"),
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 15),

                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                    image: AssetImage("assets/images/anh.avif"),
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          // Add review items here
        ],
      ),
    );
  }

  Widget description() {
    return Container(
      child: Column(
        // Căn lề trái
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            "Description",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ReadMoreText(
            "The Aston Vill Hotel is a luxurious and modern hotel located in the heart of the city. It offers comfortable rooms, top-notch amenities, and exceptional service to ensure a memorable stay for all guests. Whether you're traveling for business or leisure, The Aston Vill Hotel provides the perfect blend of convenience and elegance. ",

            textAlign: TextAlign.justify,

            trimMode: TrimMode.Line, // dùng để cắt theo dòng

            trimLines: 3, // số dòng hiển thị ban đầu

            colorClickableText: Colors.blue,

            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5, // Khoảng cách dòng cho dễ đọc
            ),

            // Style cho chữ Read More/Show Less (đậm hơn, màu khác)
            // moreStyle: TextStyle(
            //   fontSize: 14,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.blueAccent,
            // ),

            //  moreStyle: TextStyle(
            //   fontSize: 14,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.blueAccent,
            // ),
          ),

          // Text.rich(
          //   TextSpan(
          //     style: TextStyle(color: Colors.black, fontSize: 16),
          //     // text:
          //     //     "The Aston Vill Hotel is a luxurious and modern hotel located in the heart of the city. It offers comfortable rooms, top-notch amenities, and exceptional service to ensure a memorable stay for all guests. Whether you're traveling for business or leisure, The Aston Vill Hotel provides the perfect blend of convenience and elegance.",
          //     children: [
          //       TextSpan(
          //         text:
          //             "The Aston Vill Hotel is a luxurious and modern hotel located in the heart of the city. It offers comfortable rooms, top-notch amenities, and exceptional service to ensure a memorable stay for all guests. Whether you're traveling for business or leisure, The Aston Vill Hotel provides the perfect blend of convenience and elegance.",
          //       ),
          //       TextSpan(
          //         text: isReadMore ? " Read Less" : " Read More",
          //         style: TextStyle(
          //           color: Colors.blue,
          //           fontWeight: FontWeight.bold,
          //         ),
          //         recognizer: TapGestureRecognizer()
          //           ..onTap = () {
          //             setState(() {
          //               isReadMore = !isReadMore;
          //             });
          //           },
          //       ),
          //     ],
          //   ),
          //   maxLines: isReadMore ? null : 3,
          //   overflow: TextOverflow.ellipsis,
          // ),
        ],
      ),
    );
  }
  // Widget category() {
  //   return Container(
  // width: double.infinity,
  // decoration: BoxDecoration(color: Colors.redAccent),
  // child: SingleChildScrollView(
  // padding: EdgeInsets.zero,
  // scrollDirection: Axis.horizontal,
  // child: Row(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(Radius.circular(10)),
  //             color: Colors.amber,
  //           ),
  //           padding: EdgeInsets.all(10),
  //           child: Row(
  //             children: [
  //               Icon(Icons.wifi, color: Colors.white, size: 20),
  //               const SizedBox(width: 5),
  //               Text("Free Wifi", style: TextStyle(color: Colors.white)),
  //             ],
  //           ),
  //         ),

  //         const SizedBox(width: 15),

  //         Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(Radius.circular(10)),
  //             color: Colors.amber,
  //           ),
  //           padding: EdgeInsets.all(10),
  //           child: Row(
  //             children: [
  //               Icon(Icons.breakfast_dining, color: Colors.white, size: 20),
  //               const SizedBox(width: 5),
  //               Text("Free Breakfast", style: TextStyle(color: Colors.white)),
  //             ],
  //           ),
  //         ),

  //         const SizedBox(width: 15),

  //         Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(Radius.circular(10)),
  //             color: Colors.amber,
  //           ),
  //           padding: EdgeInsets.all(10),
  //           child: Row(
  //             children: [
  //               Icon(Icons.star, color: Colors.white, size: 20),
  //               const SizedBox(width: 5),
  //               Text("5.0", style: TextStyle(color: Colors.white)),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //     // ),
  //   );
  // }

  // Widget category() {
  //   return Container(
  //     // padding: EdgeInsets.all(10), // Padding tổng thể
  //     child: GridView.builder(
  //       shrinkWrap: true, // Chỉ chiếm diện tích vừa đủ
  //       physics: NeverScrollableScrollPhysics(), // Tắt cuộn riêng của Grid
  //       itemCount: criteria.length,

  //       // CẤU HÌNH LƯỚI: 3 CỘT
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 3, // Cố định 3 phần tử một hàng
  //         mainAxisSpacing: 12, // Khoảng cách dọc giữa các hàng
  //         crossAxisSpacing: 12, // Khoảng cách ngang giữa các ô
  //         childAspectRatio: 2.8, // Tỉ lệ: càng lớn thì ô càng dẹt (thấp)
  //       ),

  //       itemBuilder: (context, index) {
  //         final item = criteria[index];

  //         return Container(
  //           decoration: BoxDecoration(
  //             // Màu nền tím nhạt giống hình mẫu
  //             // color: Color(0xFFF8F5FE),
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(12)),
  //           ),
  //           padding: EdgeInsets.symmetric(horizontal: 4),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center, // Căn giữa
  //             children: [
  //               Icon(item['icon'], color: item['iconColor'], size: 20),
  //               const SizedBox(width: 6), // Khoảng cách giữa icon và chữ
  //               // Dùng Flexible để chữ tự co lại nếu dài quá ô lưới
  //               Flexible(
  //                 child: Text(
  //                   item['text'],
  //                   style: TextStyle(
  //                     color: Colors.black87,
  //                     fontWeight: FontWeight.w500, // Chữ hơi đậm xíu
  //                     fontSize: 13,
  //                   ),
  //                   overflow: TextOverflow.ellipsis, // Dài quá thì hiện dấu ...
  //                   maxLines: 1,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  Widget category() {
    return Container(
      width: double.infinity, // Để Wrap chiếm hết chiều ngang có thể
      // padding: EdgeInsets.all(10),
      child: Wrap(
        // alignment: WrapAlignment.center, // Căn giữa toàn bộ các cục
        alignment: WrapAlignment.spaceBetween,

        spacing: 12.0, // Khoảng cách ngang giữa các nút
        runSpacing: 12.0, // Khoảng cách dọc giữa các dòng
        children: criteria.map((item) {
          return Container(
            decoration: BoxDecoration(
              // color: Color(0xFFF8F5FE),
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ), // Padding bên trong nút
            child: Row(
              mainAxisSize:
                  MainAxisSize.min, // Quan trọng: Co lại vừa đủ nội dung
              children: [
                Icon(item['icon'], color: item['iconColor'], size: 20),
                SizedBox(width: 6),
                Text(
                  item['text'],
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget titleDetail() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "The Aston Vill Hotel",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              Text.rich(
                TextSpan(
                  text: "\$250 ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  children: [
                    TextSpan(
                      text: "/night",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue, size: 20),
              const SizedBox(width: 5),
              Text(
                "Alice Springs NT 0870, Australia",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              // padding: EdgeInsets.all(5),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              // icon: Icon(Icons.home),
            ),
          ),

          Text(
            "Chi Tiết Phòng",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          // SizedBox(width: 48),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              // padding: EdgeInsets.all(5),
              onPressed: () {},
              icon: Icon(Icons.menu),
              // icon: Icon(Icons.home),
            ),
          ),
        ],
      ),
    );
  }
}
