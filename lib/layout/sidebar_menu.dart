import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF221013), // Màu nền giống app
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
                  'Cinemax Duy Hoàng',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Các mục Menu
          _buildMenuItem(context, Icons.home, 'Trang chủ', () {}),
          _buildMenuItem(
            context,
            Icons.confirmation_number,
            'Vé của tôi',
            () {},
          ),
          _buildMenuItem(context, Icons.location_on, 'Rạp chiếu', () {}),
          const Divider(color: Colors.white24),
          _buildMenuItem(context, Icons.settings, 'Cài đặt', () {}),
          _buildMenuItem(context, Icons.logout, 'Đăng xuất', () {}),
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
