import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/calendar_screen.dart';
import 'package:hotel_booking_app/screens/home_screen.dart';
import 'package:hotel_booking_app/screens/favorite_hotel_screen.dart';
import 'package:hotel_booking_app/screens/profile_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainMenuScreenState();
  }
}

// ______________________________________________________

class _MainMenuScreenState extends State<MainMenuScreen> {
  final List<Widget> page = [
    // const Center(child: Text("Home Page")),
    const HomeScreen(),
    // const Center(child: Text("Calendar Page")),
    const CalendarScreen(),
    // const Center(child: Text("Gifts Page")),
    const FavoriteHotelScreen(),
    const ProfileScreen(),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[selectedIndex],

      bottomNavigationBar: BottomCustom(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

class BottomCustom extends StatelessWidget {
  final int selectedIndex;

  final Function(int) onItemTapped;

  // const BottomCustom({super.key, required this.selectedIndex, required this.onItemTapped});
  const BottomCustom({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.calendar_today, 'label': 'Calendar'},
      {'icon': Icons.card_giftcard, 'label': 'Gifts'},
      {'icon': Icons.person, 'label': 'Profile'},
    ];

    // final selectedIndex = 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // children: [
          children: List.generate(items.length, (index) {
            final item = items[index];

            return GestureDetector(
              onTap: () => onItemTapped(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: selectedIndex == index
                      ? const Color(0xFFFAF6FD)
                      : Colors.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        item['icon'] as IconData,
                        key: ValueKey(selectedIndex == index),
                        color: selectedIndex == index
                            ? const Color(0xFFF64BCE3)
                            : Colors.grey,
                      ),
                    ),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: selectedIndex == index
                          ? Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                item['label'] as String,
                                style: const TextStyle(
                                  color: Color(0xFFF64BCE3),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              // child: AnimatedContainer(
              //   duration: Duration(milliseconds: 100),
              //   curve: Curves.bounceIn,
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              //   // decoration: (selectedIndex == index)
              //   //     ? BoxDecoration(
              //   //         borderRadius: BorderRadius.circular(20),
              //   //         // color: Colors.grey[200],
              //   //         color: Color(0xFFFAF6FD),
              //   //         // cho
              //   //         // borderRadius: BorderRadiusGeometry.circular(10),
              //   //       )
              //   //     // : null,
              //   //     : BoxDecoration(color: Colors.transparent),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20),
              //     // color: Colors.grey[200],
              //     color: (selectedIndex == index)
              //         ? Color(0xFFFAF6FD)
              //         : Colors.transparent,
              //     // cho
              //     // borderRadius: BorderRadiusGeometry.circular(10),
              //   ),

              //   // : null,
              //   child: Row(
              //     children: [
              //       // Icon(Icons.home, color: Color(0xFFF64BCE3)),
              //       // Icon()
              //       Icon(
              //         item['icon'] as IconData,
              //         color: (selectedIndex == index)
              //             ? Color(0xFFF64BCE3)
              //             : Colors.grey,
              //       ),
              //       if (selectedIndex == index) ...[
              //         SizedBox(width: 5),
              //         Text(
              //           item['label'] as String,
              //           style: TextStyle(color: Color(0xFFF64BCE3)),
              //         ),
              //       ],
              //     ],
              //   ),
              // ),
            );
          }),
          // Container(child: ,)
          // GestureDetector(
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20),
          //       // color: Colors.grey[200],
          //       color: Color(0xFFFAF6FD),
          //       // cho
          //       // borderRadius: BorderRadiusGeometry.circular(10),
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(Icons.home, color: Color(0xFFF64BCE3)),
          //         SizedBox(width: 5),
          //         Text('Home', style: TextStyle(color: Color(0xFFF64BCE3))),
          //       ],
          //     ),
          //   ),
          // ),

          // GestureDetector(
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //     decoration: BoxDecoration(
          //       // borderRadius: BorderRadius.circular(20),
          //       // color: Colors.grey[200],
          //       // color: Color(0xFFFAF6FD),
          //       // cho
          //       // borderRadius: BorderRadiusGeometry.circular(10),
          //     ),
          //     child: Row(
          //       children: [
          //         // Icon(Icons.home, color: Color(0xFFF64BCE3)),
          //         Icon(Icons.calendar_today, color: Colors.grey),
          //         // SizedBox(width: 5),
          //         // Text('Home', style: TextStyle(color: Color(0xFFF64BCE3))),
          //       ],
          //     ),
          //   ),
          // ),

          // GestureDetector(
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //     decoration: BoxDecoration(
          //       // borderRadius: BorderRadius.circular(20),
          //       // color: Colors.grey[200],
          //       // color: Color(0xFFFAF6FD),
          //       // cho
          //       // borderRadius: BorderRadiusGeometry.circular(10),
          //     ),
          //     child: Row(
          //       children: [
          //         // Icon(Icons.home, color: Color(0xFFF64BCE3)),
          //         Icon(Icons.card_giftcard, color: Colors.grey),

          //         // SizedBox(width: 5),
          //         // Text('Home', style: TextStyle(color: Color(0xFFF64BCE3))),
          //       ],
          //     ),
          //   ),
          // ),

          // GestureDetector(
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //     decoration: BoxDecoration(
          //       // borderRadius: BorderRadius.circular(20),
          //       // color: Colors.grey[200],
          //       // color: Color(0xFFFAF6FD),
          //       // cho
          //       // borderRadius: BorderRadiusGeometry.circular(10),
          //     ),
          //     child: Row(
          //       children: [
          //         // Icon(Icons.home, color: Color(0xFFF64BCE3)),
          //         Icon(Icons.person, color: Colors.grey),

          //         // SizedBox(width: 5),
          //         // Text('Home', style: Te/xtStyle(color: Color(0xFFF64BCE3))),
          //       ],
          //     ),
          //   ),
          // ),
          // ],
        ),
      ),
    );
  }
}
