// widgets/top_navigation.dart
import 'package:flutter/material.dart';

class TopNavigation extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onFavoritePressed; // ← Đổi từ onFavoriteToggle
  final VoidCallback
  onBackPressed; // ← Đổi từ onBack thành onBackPressed (tùy chọn)

  const TopNavigation({
    super.key,
    required this.isFavorite,
    required this.onFavoritePressed, // ← Đổi ở đây
    required this.onBackPressed, // ← Có thể đổi thành onBackPressed cho rõ nghĩa
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIconButton(Icons.arrow_back_ios_new, onBackPressed),
            Row(
              children: [
                _buildIconButton(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  onFavoritePressed,
                  color: isFavorite ? const Color(0xFFEC1337) : Colors.white,
                ),
                const SizedBox(width: 12),
                _buildIconButton(Icons.ios_share, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color ?? Colors.white, size: 20),
      ),
    );
  }
}
