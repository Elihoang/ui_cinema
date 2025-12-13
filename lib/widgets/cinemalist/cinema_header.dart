import 'package:flutter/material.dart';

class CinemaHeader extends StatelessWidget {
  final VoidCallback onBackPressed; // Giữ lại nếu cần pop
  final VoidCallback onMapPressed;
  final VoidCallback? onNavigateToHome; // NEW: Callback để chuyển về tab Home

  const CinemaHeader({
    super.key,
    required this.onBackPressed,
    required this.onMapPressed,
    this.onNavigateToHome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (onNavigateToHome != null) {
                onNavigateToHome!(); // Ưu tiên chuyển về Home
              } else {
                onBackPressed(); // Nếu không có thì mới pop
              }
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                'Danh sách rạp phim',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.map, color: Color(0xFFec1337)),
            onPressed: onMapPressed,
          ),
        ],
      ),
    );
  }
}
