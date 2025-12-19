import 'package:flutter/material.dart';

class FindUi extends StatefulWidget {
  const FindUi({super.key});

  @override
  State<StatefulWidget> createState() => _FindUiState();
}

class _FindUiState extends State<FindUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Find UI")),
      // body: Center(child: Text("This is the Find UI screen.")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              headerBooking(),
              const SizedBox(height: 30),
              findForm(),
              const SizedBox(height: 20),
              createPopularCard(),

              const SizedBox(height: 10),
              createPopularCard(),

              const SizedBox(height: 10),
              createPopularCard(),

              const SizedBox(height: 10),
              createPopularCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget findForm() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Icon(Icons.location_on, color: Colors.red),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Điểm đến, khách sạn"),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Khách sạn gần bạn",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Icon(Icons.calendar_today, color: Colors.green),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ngày nhận phòng"),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Thứ 4, 12/06/2024",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Số đêm nghỉ"),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "1 đêm",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Icon(Icons.hotel, color: Colors.blue),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Số phòng và khách"),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "1 phòng, 2 khách",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // backgroundColor: Colors.blue,
              backgroundColor: Color(0xFF64BCE3),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text("Tìm Phòng"),
            onPressed: () {},
          ),
        ],
      ),
    );
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

  Widget headerBooking() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),

          Text(
            "Tìm Phòng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
