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
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.2),
            ),
            const SizedBox(width: 20),
            _legendItem(
              'Đã đặt',
              Colors.white.withOpacity(0.05),
              Colors.transparent,
              icon: Icons.close,
            ),
            const SizedBox(width: 20),
            _legendItem(
              'Đang chọn',
              const Color(0xFFec1337),
              const Color(0xFFec1337),
            ),
            const SizedBox(width: 20),
            _legendItem(
              'VIP',
              Colors.amber.shade900.withOpacity(0.4),
              Colors.amber.shade600.withOpacity(0.6),
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
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(4),
          ),
          child: icon != null
              ? Icon(icon, size: 12, color: Colors.white.withOpacity(0.5))
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
