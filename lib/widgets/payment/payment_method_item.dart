import 'package:flutter/material.dart';
import '../../models/booking.dart';

class PaymentMethodItem extends StatelessWidget {
  final PaymentMethod method;
  final PaymentMethod? selectedMethod;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const PaymentMethodItem({
    super.key,
    required this.method,
    required this.selectedMethod,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = method == selectedMethod;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF33191E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFEC1337) : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFEC1337).withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(8),
                border: iconColor == Colors.black
                    ? Border.all(color: Colors.white.withOpacity(0.2))
                    : null,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFC9929B),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFEC1337) : Colors.grey,
                  width: 2,
                ),
                color: isSelected
                    ? const Color(0xFFEC1337)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
