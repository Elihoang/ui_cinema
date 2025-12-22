import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  const Legend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF180c0e).withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem(
              'Trống',
              const Color.fromARGB(255, 247, 228, 228), // NORMAL seat color
              const Color.fromARGB(255, 247, 228, 228),
            ),
            const SizedBox(width: 20),
            _legendItem(
              'Đã đặt',
              const Color(0xFF4A4A4A), // Booked seat color
              const Color(0xFF2A2A2A),
              icon: Icons.close,
            ),
            const SizedBox(width: 20),
            _legendItem(
              'Đang chọn',
              const Color(0xFFec1337), // Selected seat color
              const Color(0xFFBB0A27),
            ),
            const SizedBox(width: 20),
            _legendItem(
              'VIP',
              const Color(0xFFFFD700), // VIP seat color (gold)
              const Color(0xFFB8860B),
              icon: Icons.star,
            ),
            const SizedBox(width: 20),
            _legendItem(
              'Couple',
              const Color(0xFFFF69B4), // Couple seat color (pink)
              const Color(0xFFDB5A8F),
              icon: Icons.favorite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color bg, Color border, {IconData? icon}) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 20,
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(4),
          ),
          child: icon != null
              ? Icon(
                  icon,
                  size: 12,
                  color: icon == Icons.close
                      ? Colors.white.withOpacity(0.5)
                      : (icon == Icons.star
                            ? const Color(0xFFB8860B) // VIP star: dark gold
                            : Colors.white), // Couple heart: white
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
      ],
    );
  }
}
