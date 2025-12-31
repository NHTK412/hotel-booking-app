import 'package:flutter/material.dart';

class LikeUi extends StatefulWidget {
  const LikeUi({super.key});

  @override
  State<StatefulWidget> createState() => _LikeUiState();
}

class _LikeUiState extends State<LikeUi> {
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

            createPopularCard(),
            SizedBox(height: 20),
            createPopularCard(),
            SizedBox(height: 20),
            createPopularCard(),
            SizedBox(height: 20),
            createPopularCard(),
            SizedBox(height: 20),
            createPopularCard(),
            SizedBox(height: 20),
            createPopularCard(),
            SizedBox(height: 20),
            createPopularCard(),
            SizedBox(height: 20),
            createPopularCard(),
            SizedBox(height: 20),
            createPopularCard(),
            SizedBox(height: 20),
            createPopularCard(),
            SizedBox(height: 20),
          ],
        ),
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

                Row(
                  children: [
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
    );
  }
}
