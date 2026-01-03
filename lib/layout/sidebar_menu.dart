import 'package:flutter/material.dart';

import '../screens/my_ticket_screen.dart';
import '../screens/cinema_list_screen.dart';
import '../screens/product_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/auth/login_screen.dart';
import '../services/user_service.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF221013),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Phần Header của Menu
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF3a1c20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFFec1337),
                      width: 2,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBofbyUlmZmt8pld0Z6SoAQtjquEAIPDrhfvkA2FUpoAxqVDyGCImscj9KkcHqy7K_mXlz14DyPyCCOHt1pns2xSrmFdkHJTyyaAQzjBe5fIEmlbTh7pXNcQeZP9noRCrfaGMDJFN48DDmDJjON6XfGQ6odbSFT8ZVislYadvcPK2tOkp1sDVZzlI7ypU2-CmMJ3yQwOxDhq0Nj2hkibPvU3iAWZj57ViefEj9dqF7uKG_I8ePHV_n83F9ZvUEMnI3yNSoDozV4Oys',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Cinemax',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Các mục Menu
          _buildMenuItem(context, Icons.home, 'Trang chủ', () {
            Navigator.pop(context); // Đóng drawer
            // Nếu không phải đang ở HomeScreen thì push HomeScreen (hoặc xử lý tùy logic app)
            // Hiện tại Sidebar thường chỉ gọi từ Home nên pop là đủ.
          }),
          _buildMenuItem(context, Icons.confirmation_number, 'Vé của tôi', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyTicketScreen()),
            );
          }),
          _buildMenuItem(context, Icons.location_on, 'Rạp chiếu', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CinemaListScreen()),
            );
          }),
          _buildMenuItem(context, Icons.fastfood, 'Combo & Đồ ăn', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductScreen()),
            );
          }),
          const Divider(color: Colors.white24),
          _buildMenuItem(context, Icons.person, 'Tài khoản', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }),
          _buildMenuItem(context, Icons.logout, 'Đăng xuất', () async {
            // Confirm dialog
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: const Color(0xFF221013),
                title: const Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  'Bạn có chắc muốn đăng xuất?',
                  style: TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text(
                      'Hủy',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text(
                      'Đăng xuất',
                      style: TextStyle(color: Color(0xFFec1337)),
                    ),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await UserService.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            }
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFec1337)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
