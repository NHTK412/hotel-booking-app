import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  final Widget child; // Đây là trang nội dung được GoRouter truyền vào

  const MainMenuScreen({super.key, required this.child});

  // Hàm tiện ích để xácq định index dựa trên path hiện tại
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == '/home') return 0;
    if (location == '/calendar') return 1;
    if (location == '/favorites') return 2;
    if (location == '/profile') return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/calendar');
        break;
      case 2:
        context.go('/favorites');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // Hiển thị nội dung trang con ở đây
      bottomNavigationBar: BottomCustom(
        selectedIndex: _calculateSelectedIndex(context),
        onItemTapped: (index) => _onItemTapped(index, context),
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
            );
          }),
        ),
      ),
    );
  }
}
