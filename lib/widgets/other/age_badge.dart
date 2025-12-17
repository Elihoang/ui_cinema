// widgets/age_badge.dart
import 'package:flutter/material.dart';

class AgeBadge extends StatelessWidget {
  final int ageLimit;

  const AgeBadge({super.key, required this.ageLimit});

  // Văn bản hiển thị theo chuẩn Việt Nam
  String get label {
    switch (ageLimit) {
      case 0:
        return 'P';
      case 13:
        return 'T13';
      case 16:
        return 'T16';
      case 18:
        return 'T18';
      default:
        if (ageLimit > 18) return 'K'; // Cấm trẻ em
        return 'P';
    }
  }

  // Màu nền chuẩn theo quy định rạp Việt Nam
  Color get backgroundColor {
    switch (ageLimit) {
      case 0:
        return const Color(0xFF4CAF50); // Xanh lá - Phổ biến
      case 13:
        return const Color(0xFFFF9800); // Cam - T13
      case 16:
        return const Color(0xFFEF6C00); // Cam đậm - T16
      case 18:
        return const Color(0xFFDC2626); // Đỏ - T18 / K
      default:
        return const Color(0xFFDC2626); // Đỏ cho các trường hợp khác
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8, // Tăng lên cho dễ đọc
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          height: 1.2,
        ),
      ),
    );
  }
}
