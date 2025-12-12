import 'package:flutter/material.dart';
import '../widgets/home/bottom_nav_bar.dart';
import '../screens/home_screen.dart';
import '../screens/my_ticket_screen.dart';
import '../layout/main_layout.dart';
import '../layout/sidebar_menu.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với các tab
  final List<Widget> _screens = [
    const HomeScreen(), // Index 0: Trang chủ
    const MyTicketScreen(), // Index 1: Vé của tôi
    const SizedBox(), // Index 2: Nút Scan (QR) - Xử lý riêng
    const Center(
      child: Text("Rạp chiếu", style: TextStyle(color: Colors.white)),
    ), // Index 3: Placeholder
    const Center(
      child: Text("Tài khoản", style: TextStyle(color: Colors.white)),
    ), // Index 4: Placeholder
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Xử lý khi bấm nút QR Code ở giữa
      print("Open QR Scanner");
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221013), // Màu nền từ main.dart cũ
      drawer: const SidebarMenu(),
      // Sử dụng IndexedStack để giữ trạng thái của các màn hình khi chuyển tab
      body: IndexedStack(index: _selectedIndex, children: _screens),
      // Bottom Navigation Bar nằm ở đây
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
