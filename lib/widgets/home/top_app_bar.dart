import 'package:flutter/material.dart';

class TopAppBarWidget extends StatelessWidget {
  const TopAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // --- SỬA ĐOẠN NÀY ---
                // Nút mở Menu
                InkWell(
                  onTap: () {
                    // Lệnh mở Drawer từ Scaffold cha
                    Scaffold.of(context).openDrawer();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFec1337).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // Đổi icon thành Menu cho hợp lý, hoặc giữ nguyên movie_outlined
                    child: const Icon(
                      Icons.movie_outlined,
                      color: Color(0xFFec1337),
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Chào buổi tối đầy mê hoặc',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Cinemax Duy Hoàng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Phần bên phải giữ nguyên...
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFec1337).withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBofbyUlmZmt8pld0Z6SoAQtjquEAIPDrhfvkA2FUpoAxqVDyGCImscj9KkcHqy7K_mXlz14DyPyCCOHt1pns2xSrmFdkHJTyyaAQzjBe5fIEmlbTh7pXNcQeZP9noRCrfaGMDJFN48DDmDJjON6XfGQ6odbSFT8ZVislYadvcPK2tOkp1sDVZzlI7ypU2-CmMJ3yQwOxDhq0Nj2hkibPvU3iAWZj57ViefEj9dqF7uKG_I8ePHV_n83F9ZvUEMnI3yNSoDozV4Oys',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
