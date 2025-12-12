import 'package:flutter/material.dart';

class ShowtimeChip extends StatelessWidget {
  final String time;
  final bool isAvailable;
  final VoidCallback? onTap;

  const ShowtimeChip({
    super.key,
    required this.time,
    this.isAvailable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF2F181B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isAvailable
                ? const Color(0x33FFFFFF)
                : const Color(0x1AFFFFFF),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              color: isAvailable ? Colors.white : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: isAvailable ? null : TextDecoration.lineThrough,
            ),
          ),
        ),
      ),
    );
  }
}
