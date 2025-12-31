import 'package:flutter/material.dart';
import 'package:hotel_booking_app/data/model/accommodation/accommodationDetail.dart';
import 'package:hotel_booking_app/data/model/apiResponse.dart';
import 'package:hotel_booking_app/data/model/roomtype/roomTypeSummary.dart';
import 'package:hotel_booking_app/data/repositories/accommodationRepository.dart';
import 'package:hotel_booking_app/data/service/accommodationService.dart';
import 'package:hotel_booking_app/screens/detailCart.dart';
import 'package:readmore/readmore.dart';

class HotelUi extends StatefulWidget {
  final int accommodationId;

  const HotelUi({super.key, required this.accommodationId});

  @override
  _HotelUiState createState() => _HotelUiState();
}

class _HotelUiState extends State<HotelUi> {
  final AccommodationRepository accommodationRepository =
      AccommodationRepository(AccommodationService());

  late final Future<ApiResponse<AccommodationDetail>> _fetchById;

  bool isFavorite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchById = accommodationRepository.getAccommodationById(
      widget.accommodationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Hotel UI')),
      // body: const Center(child: Text('Hotel UI Content Goes Here')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: _fetchById,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              // if (!snapshot.hasData || snapshot.data!.data) {
              //   return const Text("No data");
              // }

              AccommodationDetail data = snapshot.data!.data!;

              // return Text(data.toString());
              return _createBody(data);
            },
          ),
        ),
      ),
    );
  }

  Widget _createBody(AccommodationDetail accommodationDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(),
        SizedBox(height: 20),

        (accommodationDetail.image == null)
            ? const Center(child: CircularProgressIndicator())
            : ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image(
                  image: NetworkImage(
                    // "https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=1080&auto=format&fit=crop",
                    // "http://10.0.2.2/images/",
                    "http://10.0.2.2:8080/api/images/${accommodationDetail.image}",
                  ),

                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),

        SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Text(
                // "The Aston Vill Hotel",
                accommodationDetail.accommodationName!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              // padding: EdgeInsets.all(10.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: BoxDecoration(
                // color: Colors.yellow.withOpacity(0.5),
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  // Icon(Icons.star, size: 16, color: Colors.yellow),
                  Icon(Icons.star, size: 16, color: Colors.amber),

                  SizedBox(width: 10),
                  Text(
                    // "5.0",
                    accommodationDetail.starRating!.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 10),
        Container(
          child: Row(
            children: [
              Container(
                // padding: EdgeInsets.all(10.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.hotel, size: 16, color: Colors.blueAccent),
                    SizedBox(width: 10),
                    Text(
                      // "Khách sạn",
                      accommodationDetail.type!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Container(
                // padding: EdgeInsets.all(10.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                decoration: BoxDecoration(
                  // color: Colors.yellow.withOpacity(0.5),
                  // color: Colors.amber.withOpacity(0.1),
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    // Icon(Icons.star, size: 16, color: Colors.yellow),
                    Icon(Icons.location_on, size: 16, color: Colors.green),

                    SizedBox(width: 10),
                    // Text("", style: TextStyle(fontSize: 16)),
                    Text("4.5 km", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                icon: Icon(
                  Icons.favorite,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        description(accommodationDetail.description!),
        SizedBox(height: 20),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Room Options",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              ...accommodationDetail.roomTypes!.map((roomType) {
                return createPopularCard(roomType);
              }),

              // SizedBox(height: 10),
              // createPopularCard(),
              // SizedBox(height: 10),
              // createPopularCard(),
              // SizedBox(height: 10),
              // createPopularCard(),
            ],
          ),
        ),
      ],
    );
    // ,
  }

  Widget createPopularCard(RoomTypeSummary roomTypeSummary) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailCart()),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
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
                // image: AssetImage("assets/images/anh.avif"),
                image: NetworkImage(
                  "http://10.0.2.2:8080/api/images/${roomTypeSummary.image}",
                ),
                width: 100,
                height: 100,
                // width: 50,
                // height: 50,
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
                          roomTypeSummary.name!,
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
                      Text(
                        // '5.0',
                        roomTypeSummary.star!.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),

                  Text("Alice Springs NT 0870, Australia"),

                  SizedBox(height: 15),

                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          // text: '\$200.7',
                          text: '${roomTypeSummary.getPriceToString()} VNĐ',
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
        // ],
        // ),
      ),
    );
  }

  Widget description(String accommodationDescription) {
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
            // "The Aston Vill Hotel is a luxurious and modern hotel located in the heart of the city. It offers comfortable rooms, top-notch amenities, and exceptional service to ensure a memorable stay for all guests. Whether you're traveling for business or leisure, The Aston Vill Hotel provides the perfect blend of convenience and elegance. ",
            accommodationDescription,
            textAlign: TextAlign.justify,

            trimMode: TrimMode.Line,

            // dùng để cắt theo dòng
            trimLines: 3,

            // số dòng hiển thị ban đầu
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
            "Chi Tiết Khách Sạn",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(width: 48),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.all(Radius.circular(10)),
          //     border: Border.all(color: Colors.grey.shade300),
          //   ),
          //   child: IconButton(
          //     // padding: EdgeInsets.all(5),
          //     onPressed: () {},
          //     icon: Icon(Icons.menu),
          //     // icon: Icon(Icons.home),
          //   ),
          // ),
        ],
      ),
    );
  }
}
