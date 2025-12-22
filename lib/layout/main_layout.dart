import 'package:fe_cinema_mobile/screens/product_screen.dart';
import 'package:fe_cinema_mobile/widgets/qr/qr_scanner_page.dart';
import 'package:flutter/material.dart';
import '../widgets/home/bottom_nav_bar.dart';
import '../screens/home_screen.dart';
import '../screens/my_ticket_screen.dart';
import '../layout/sidebar_menu.dart';
import '../screens/cinema_list_screen.dart';
import '../screens/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // Tạo các screen riêng biệt để có thể truy cập _selectedIndex và setState
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      const MyTicketScreen(),
      const SizedBox(), // Placeholder cho nút QR giữa
      CinemaListScreen(
        onNavigateToHome: () {
          setState(() {
            _selectedIndex =
                0; // Bây giờ được phép dùng vì đang trong initState
          });
        },
      ),
      const ProfileScreen(),
      //const ProductScreen(),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Xử lý khi bấm nút QR Code ở giữa
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QrScannerPage()),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      drawer: const SidebarMenu(),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
