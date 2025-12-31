import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/hotalUi.dart';

class SearchUi extends StatefulWidget {
  const SearchUi({super.key});

  @override
  _SearchUiState createState() => _SearchUiState();
}

class _SearchUiState extends State<SearchUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Search UI')),
      // body: const Center(child: Text('Search UI Content Goes Here')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildSearchBar(),
              const SizedBox(height: 25.0),
              Container(
                child: Column(
                  children: [
                    buildResultCard(),
                    const SizedBox(height: 16.0),
                    buildResultCard(),
                    const SizedBox(height: 16.0),
                    buildResultCard(),
                    const SizedBox(height: 16.0),
                    buildResultCard(),
                    const SizedBox(height: 16.0),
                    buildResultCard(),

                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // );
  }

  Widget buildResultCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HotelUi(accommodationId: 1,);
            },
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              // borderRadius: BorderRadius.circular(20),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: Image(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=1080&auto=format&fit=crop",
                ),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),

            // const SizedBox(height: 12.0),
            Container(
              // decoration: BoxDecoration(color: Colors.yellow),
              decoration: BoxDecoration(color: Colors.white),

              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Hotel ABC",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 16.0, color: Colors.amber),
                            // SizedBox(width: 4.0),
                            Text(
                              "4.5",
                              style: TextStyle(
                                fontSize: 16.0,
                                // color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.hotel,
                              size: 16.0,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(width: 4.0),
                            Text("Khách sạn"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16.0,
                              color: Colors.green,
                            ),
                            SizedBox(width: 4.0),
                            Text("3 km"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Thuận Giao, Thuận An",
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),

                  Divider(color: Colors.grey),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "500,000 VND / đêm",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        // contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        filled: true,
                        // fillColor: Colors.amber,
                        fillColor: Colors.grey[200],
                        isDense: true,
                      ),
                    ),
                  ),
                  // Text(
                  //   'Search...',
                  //   style: TextStyle(
                  //     color: Colors.grey,
                  //     fontSize: 16.0,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.0),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Hủy", style: TextStyle(fontSize: 16.0)),
          ),
        ],
      ),
    );
  }
}
