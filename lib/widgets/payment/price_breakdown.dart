import 'package:flutter/material.dart';
import '../../models/booking.dart';

class PriceBreakdown extends StatelessWidget {
  final BookingInfo booking;

  const PriceBreakdown({super.key, required this.booking});

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF33191E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _buildPriceRow('Tạm tính', booking.subtotal, false),
          const SizedBox(height: 12),
          _buildPriceRow('Combo bắp nước', booking.comboPrice, false),
          const SizedBox(height: 12),
          _buildPriceRow(
            'Giảm giá',
            -booking.discount,
            false,
            isDiscount: true,
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 12),
          _buildPriceRow('Tổng cộng', booking.total, true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount,
    bool isTotal, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.white : const Color(0xFFC9929B),
          ),
        ),
        Text(
          _formatPrice(amount),
          style: TextStyle(
            fontSize: isTotal ? 20 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal
                ? const Color(0xFFEC1337)
                : isDiscount
                ? Colors.greenAccent
                : Colors.white,
          ),
        ),
      ],
    );
  }
}
