import 'package:fe_cinema_mobile/widgets/qr/qr_scanner_page.dart';
import 'package:flutter/material.dart';

import '../layout/sidebar_menu.dart';
import '../screens/cinema_list_screen.dart';
import '../screens/home_screen.dart';
import '../screens/my_ticket_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/home/bottom_nav_bar.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;
  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;

  // Tạo các screen riêng biệt để có thể truy cập _selectedIndex và setState
  late final List<Widget> _screens;
  
  // GlobalKey để access ProfileScreen state
  final GlobalKey<State<ProfileScreen>> _profileKey = GlobalKey<State<ProfileScreen>>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _screens = [
      HomeScreen(),
      MyTicketScreen(
        onNavigateToHome: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
      const SizedBox(), // Placeholder cho nút QR giữa
      CinemaListScreen(
        onNavigateToHome: () {
          setState(() {
            _selectedIndex =
                0; // Bây giờ được phép dùng vì đang trong initState
          });
        },
      ),
      ProfileScreen(key: _profileKey),
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
    
    // Nếu chuyển sang tab Profile (index 4), reload vé sắp chiếu
    if (index == 4 && _selectedIndex != 4) {
      print('[MainLayout] Switching to Profile tab, reloading tickets...');
      try {
        final profileState = _profileKey.currentState as dynamic;
        if (profileState != null) {
          profileState.reloadTickets();
          print('[MainLayout] Called reloadTickets() successfully');
        } else {
          print('[MainLayout] ProfileState is null');
        }
      } catch (e) {
        print('[MainLayout] Error calling reloadTickets: $e');
      }
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
