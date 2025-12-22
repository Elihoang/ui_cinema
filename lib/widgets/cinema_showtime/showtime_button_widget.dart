import 'package:flutter/material.dart';

class ShowtimeButtonWidget extends StatelessWidget {
  final String time;
  final String price;
  final bool isSoldOut;
  final bool isVip;
  final VoidCallback? onTap;

  const ShowtimeButtonWidget({
    super.key,
    required this.time,
    required this.price,
    this.isSoldOut = false,
    this.isVip = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSoldOut ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSoldOut ? Colors.transparent : const Color(0xFF482329),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSoldOut
                ? Colors.white.withOpacity(0.05)
                : isVip
                ? const Color(0xFFec1337)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(
                color: isSoldOut ? Colors.white.withOpacity(0.5) : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isSoldOut ? 'Hết vé' : price,
              style: TextStyle(
                color: isSoldOut
                    ? Colors.white.withOpacity(0.3)
                    : const Color(0xFFc9929b),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
