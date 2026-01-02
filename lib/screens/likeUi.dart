import 'package:flutter/material.dart';
import 'package:hotel_booking_app/config/appConfig.dart';
import 'package:hotel_booking_app/data/model/accommodation/accommodationSummary.dart';
import 'package:hotel_booking_app/data/repositories/accommodationRepository.dart';
import 'package:hotel_booking_app/data/service/accommodationService.dart';
import 'package:hotel_booking_app/screens/hotalUi.dart';

import '../data/model/apiResponse.dart';

class LikeUi extends StatefulWidget {
  const LikeUi({super.key});

  @override
  State<StatefulWidget> createState() => _LikeUiState();
}

class _LikeUiState extends State<LikeUi> {
  List<AccommodationSummary> accommodations = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchAccommodations();
  }

  Future<void> _fetchAccommodations() async {
    try {
      isLoading = false;
      ApiResponse<List<AccommodationSummary>> response =
          await AccommodationRepository(
            AccommodationService(),
          ).getAllAccommodationsByFavorite();
      accommodations = response.data ?? [];
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = true;

      // Update UI
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                "Danh Sách Yêu Thích",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              itemCount: accommodations.length,
              itemBuilder: (context, index) {
                return createPopularCard(accommodations[index], () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelUi(
                        accommodationId:
                            accommodations[index].accommodationId ?? 0,
                      ),
                    ),
                  );
                });
              },
            ),

            // createPopularCard(),
            // SizedBox(height: 20),
            // createPopularCard(),
            // SizedBox(height: 20),
            // createPopularCard(),
            // SizedBox(height: 20),
            // createPopularCard(),
            // SizedBox(height: 20),
            // createPopularCard(),
            // SizedBox(height: 20),
            // createPopularCard(),
            // SizedBox(height: 20),
            // createPopularCard(),
            // SizedBox(height: 20),
            // createPopularCard(),
            // SizedBox(height: 20),
            // createPopularCard(),
            // SizedBox(height: 20),
            // createPopularCard(),
            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget createPopularCard(
    AccommodationSummary accommodationSummary,
    Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                          accommodationSummary.accommodationName ?? "Not Found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
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

                  Text(accommodationSummary.address ?? "Not Found"),

                  SizedBox(height: 15),

                  Row(
                    children: [
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
                              text: ' /night',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(width: 10),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite, color: Colors.red),
                      ),
                    ],
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
