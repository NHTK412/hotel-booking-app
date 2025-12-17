import 'package:flutter/material.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  String name = "Nguyễn Hữu Tuấn Khang";

  String phone = "0347063245";

  String email = "nguyenhuutuankhang412@gmail.com";

  String gender = "Nam";

  String birthday = "04/12/2005";

  String address = "Đường Na12, Thuận An, Hồ Chí Minh";

  Color colorTheme = Color(0xFF64BCE3);

  final TextEditingController _textNameController = TextEditingController();

  final TextEditingController _textPhoneController = TextEditingController();

  final TextEditingController _textEmailController = TextEditingController();

  final TextEditingController _textGenderController = TextEditingController();

  final TextEditingController _textBirthdayController = TextEditingController();

  final TextEditingController _textAddressController = TextEditingController();

  late int currentIndex;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _textAddressController.text = address;
    _textBirthdayController.text = birthday;
    _textEmailController.text = email;
    _textGenderController.text = gender;
    _textNameController.text = name;
    _textPhoneController.text = phone;

    currentIndex = 1; // Khởi tạo chỉ mục hiện tại
    // isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    // backgroundColor: Color.fromARGB(255, 238, 204, 246)
    // backgroundColor: Color.fromARGB(255, 240, 240, 243),
    // body:
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Thông Tin Cá Nhân',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),

            const CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),

            const SizedBox(height: 30),

            // Text(
            //   name,
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: colorTheme,
            //   ),
            // ),
            TextField(
              readOnly: !isEditing,
              controller: _textNameController,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorTheme,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thông tin tài khoản",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số điện thoại",
                          style: TextStyle(
                            color: Color(0xFFB3B0B1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   phone,
                        //   style: TextStyle(
                        //     color: colorTheme,
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        Expanded(
                          child: TextField(
                            // readOnly: true,
                            readOnly: !isEditing,

                            controller: _textPhoneController,
                            textAlign: TextAlign.right,

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              color: colorTheme,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            color: Color(0xFFB3B0B1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   email,
                        //   style: TextStyle(
                        //     color: colorTheme,
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        Expanded(
                          child: TextField(
                            // readOnly: true,
                            readOnly: !isEditing,

                            controller: _textEmailController,
                            textAlign: TextAlign.right,

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              color: colorTheme,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thông tin cá nhân",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Giới tính",
                          style: TextStyle(
                            color: Color(0xFFB3B0B1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   gender,
                        //   style: TextStyle(
                        //     color: colorTheme,
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        Expanded(
                          child: TextField(
                            // readOnly: true,
                            readOnly: !isEditing,

                            controller: _textGenderController,
                            textAlign: TextAlign.right,

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              color: colorTheme,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ngày sinh",
                          style: TextStyle(
                            color: Color(0xFFB3B0B1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   birthday,
                        //   style: TextStyle(
                        //     color: colorTheme,
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        Expanded(
                          child: TextField(
                            // readOnly: true,
                            readOnly: !isEditing,

                            controller: _textBirthdayController,
                            textAlign: TextAlign.right,

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              color: colorTheme,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Địa chỉ",
                          style: TextStyle(
                            color: Color(0xFFB3B0B1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   address,
                        //   style: TextStyle(
                        //     color: colorTheme,
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),

                        // Căn lề bên phải
                        Expanded(
                          child: TextField(
                            // readOnly: true,
                            readOnly: !isEditing,

                            controller: _textAddressController,
                            textAlign: TextAlign.right,

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              color: colorTheme,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = !isEditing;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorTheme,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Chỉnh sửa thông tin'),
            ),
          ],
        ),
      ),
    );
    // bottomNavigationBar: BottomNavigationBar(
    //   currentIndex: 3,
    //   type: BottomNavigationBarType.fixed,
    //   items: [
    //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.calculate),
    //       label: 'Calculate',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.card_travel),
    //       label: 'Orders',
    //     ),
    //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    //   ],
    // ),
    // bottomNavigationBar: BottomCustomer(
    //   selectedIndex: 1,
    //   onItemTapped: (index) {
    //     setState(() {

    //     });
    // bottomNavigationBar: BottomCustom(
    //   selectedIndex: currentIndex,
    //   onItemTapped: (index) {
    //     setState(() {
    //       currentIndex = index;
    //     });
    //   },
    // ),

    // backgroundColor: Colors.white,
    // );
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
                duration: Duration(milliseconds: 100),
                curve: Curves.bounceIn,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                // decoration: (selectedIndex == index)
                //     ? BoxDecoration(
                //         borderRadius: BorderRadius.circular(20),
                //         // color: Colors.grey[200],
                //         color: Color(0xFFFAF6FD),
                //         // cho
                //         // borderRadius: BorderRadiusGeometry.circular(10),
                //       )
                //     // : null,
                //     : BoxDecoration(color: Colors.transparent),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: Colors.grey[200],
                  color: (selectedIndex == index)
                      ? Color(0xFFFAF6FD)
                      : Colors.transparent,
                  // cho
                  // borderRadius: BorderRadiusGeometry.circular(10),
                ),

                // : null,
                child: Row(
                  children: [
                    // Icon(Icons.home, color: Color(0xFFF64BCE3)),
                    // Icon()
                    Icon(
                      item['icon'] as IconData,
                      color: (selectedIndex == index)
                          ? Color(0xFFF64BCE3)
                          : Colors.grey,
                    ),
                    if (selectedIndex == index) ...[
                      SizedBox(width: 5),
                      Text(
                        item['label'] as String,
                        style: TextStyle(color: Color(0xFFF64BCE3)),
                      ),
                    ],
                  ],
                ),
              ),
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
