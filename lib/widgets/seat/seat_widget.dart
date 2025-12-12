import 'package:flutter/material.dart';
import '../../models/seat.dart';

class SeatWidget extends StatelessWidget {
  final Seat seat;
  final bool isSelected;
  final VoidCallback onTap;

  const SeatWidget({
    super.key,
    required this.seat,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBooked = seat.status == SeatStatus.booked;
    final isVip = seat.type == SeatType.vip;

    Color bg = isSelected
        ? const Color(0xFFec1337)
        : isBooked
        ? Colors.white.withOpacity(0.05)
        : isVip
        ? Colors.amber.shade900.withOpacity(0.2)
        : Colors.white.withOpacity(0.1);

    Color border = isSelected || isVip
        ? const Color(0xFFec1337)
        : Colors.white.withOpacity(0.2);

    return GestureDetector(
      onTap: isBooked ? null : onTap,
      child: Container(
        width: isVip ? 48 : 32,
        height: 32,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFec1337).withOpacity(0.4),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isSelected
              ? Text(
                  seat.id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : isBooked
              ? const Icon(Icons.close, size: 12, color: Colors.white30)
              : isVip
              ? const Icon(Icons.star, size: 12, color: Colors.amber)
              : null,
        ),
      ),
    );
  }
}
