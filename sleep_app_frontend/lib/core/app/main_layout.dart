import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/home/presentation/home_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
      ),
      child: Scaffold(
        backgroundColor: Colors.yellow,
        body: Stack(
          children: [
            // Lớp 1: Nội dung chính (các màn hình)
            _screens[_currentIndex],

            // Lớp 2: Bottom navigation cố định ở dưới
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(27, 54, 86, 60),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: _onTabTapped,

                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: Color(0xFFDFBBE4),
                  unselectedItemColor: Colors.grey,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Trang chủ',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.explore),
                      label: 'Khám phá',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
