import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            iconSize: 24,
          ),
          const Expanded(
            child: Text(
              'Chọn suất chiếu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign:
                  TextAlign.center, // ← Sửa ở đây: textAlign: TextAlign.center
            ),
          ),
          const SizedBox(width: 48), // Để cân bằng với nút back bên trái
        ],
      ),
    );
  }
}
