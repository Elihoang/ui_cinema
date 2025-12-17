import 'package:flutter/material.dart';

class CinemaShowtimeButton extends StatelessWidget {
  final String time;
  final String? price;
  final bool isVIP;
  final bool isSoldOut;
  final bool isSelected;
  final VoidCallback? onPressed;

  const CinemaShowtimeButton({
    super.key,
    required this.time,
    this.price,
    this.isVIP = false,
    this.isSoldOut = false,
    this.isSelected = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSoldOut ? null : onPressed,
      child: Container(
        height: 40,
        constraints: const BoxConstraints(minWidth: 72),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2D1519),
          border: Border.all(
            color: isSelected ? const Color(0xFFEC1337) : Colors.transparent,
            width: isSelected ? 1.5 : 0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Opacity(
          opacity: isSoldOut ? 0.5 : 1.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: isVIP || isSelected
                      ? const Color(0xFFEC1337)
                      : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isVIP
                    ? 'Ghế VIP'
                    : isSoldOut
                    ? 'Hết vé'
                    : price ?? '',
                style: TextStyle(
                  color: isVIP || isSelected
                      ? const Color(0xFFEC1337).withOpacity(0.8)
                      : Colors.white.withOpacity(0.4),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
