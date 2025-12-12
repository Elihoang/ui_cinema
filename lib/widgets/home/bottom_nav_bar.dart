import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const BottomNavBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3a1c20),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home,
                    label: 'Trang chủ',
                    isSelected: selectedIndex == 0,
                    onTap: () => onItemSelected(0),
                  ),
                  _buildNavItem(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Vé của tôi',
                    isSelected: selectedIndex == 1,
                    onTap: () => onItemSelected(1),
                  ),
                  const SizedBox(width: 56), // Space for FAB
                  _buildNavItem(
                    icon: Icons.location_on_outlined,
                    label: 'Rạp chiếu',
                    isSelected: selectedIndex == 3,
                    onTap: () => onItemSelected(3),
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline,
                    label: 'Tài khoản',
                    isSelected: selectedIndex == 4,
                    onTap: () => onItemSelected(4),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                child: Transform.translate(
                  offset: const Offset(
                    0,
                    -20,
                  ), // giảm từ -32 xuống -20 để thấp hơn
                  child: SizedBox(
                    width: 80, // điều chỉnh kích thước tròn
                    height: 80,
                    child: FloatingActionButton(
                      onPressed: () => onItemSelected(2),
                      backgroundColor: const Color(0xFFec1337),
                      elevation: 8,
                      shape: const CircleBorder(), // chắc chắn hình tròn
                      child: const Icon(
                        Icons.qr_code_scanner,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected
                ? const Color(0xFFec1337)
                : const Color(0xFF6B7280),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFFec1337)
                  : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
