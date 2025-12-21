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
    final isActive = seat.isActive;
    final seatType = seat.seatTypeCode?.toUpperCase() ?? 'NORMAL';
    final isVip = seatType == 'VIP';
    final isCouple = seatType == 'COUPLE';

    // Determine seat colors
    Color mainColor; // Main seat body color
    Color armrestColor; // Armrest color (darker)
    double width;
    double height = 34;

    if (isSelected) {
      mainColor = const Color(0xFFec1337);
      armrestColor = const Color(0xFFBB0A27);
    } else if (!isActive) {
      mainColor = const Color(0xFF4A4A4A);
      armrestColor = const Color(0xFF2A2A2A);
    } else if (isVip) {
      mainColor = const Color(0xFFFFD700); // VIP: vàng gold
      armrestColor = const Color(0xFFB8860B);
    } else if (isCouple) {
      mainColor = const Color(0xFFFF69B4); // COUPLE: hồng
      armrestColor = const Color(0xFFDB5A8F);
    } else {
      mainColor = const Color.fromARGB(255, 247, 228, 228);
      armrestColor = const Color.fromARGB(255, 247, 228, 228);
    }

    // NORMAL & VIP: same size, only COUPLE is wider
    width = isCouple ? 72 : 40;

    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: TopViewSeatPainter(
            mainColor: mainColor,
            armrestColor: armrestColor,
            isSelected: isSelected,
            isActive: isActive,
            isCouple: isCouple,
          ),
          child: Center(child: _buildSeatContent(isActive, seatType)),
        ),
      ),
    );
  }

  Widget? _buildSeatContent(bool isActive, String seatType) {
    if (isSelected) {
      return Text(
        seat.seatCode,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    if (!isActive) {
      return Icon(Icons.close, size: 12, color: Colors.white.withOpacity(0.5));
    }

    // Show icons for VIP and Couple seats
    switch (seatType) {
      case 'VIP':
        return const Icon(Icons.star, size: 11, color: Color(0xFFB8860B));
      case 'COUPLE':
        return const Icon(Icons.favorite, size: 11, color: Colors.white);
      default:
        return null; // NORMAL has no icon
    }
  }
}

/// Painter for top-view cinema seat (like the UI image)
class TopViewSeatPainter extends CustomPainter {
  final Color mainColor;
  final Color armrestColor;
  final bool isSelected;
  final bool isActive;
  final bool isCouple;

  TopViewSeatPainter({
    required this.mainColor,
    required this.armrestColor,
    required this.isSelected,
    required this.isActive,
    required this.isCouple,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final width = size.width;
    final height = size.height;

    if (isCouple) {
      _drawDoubleSeat(canvas, width, height);
    } else {
      _drawSingleSeat(canvas, width, height);
    }
  }

  void _drawSingleSeat(Canvas canvas, double width, double height) {
    final armrestPaint = Paint()
      ..color = armrestColor
      ..style = PaintingStyle.fill;

    final mainPaint = Paint()
      ..color = mainColor
      ..style = PaintingStyle.fill;

    // Base/background (armrests + bottom)
    final basePath = Path();

    // Bottom rounded rectangle (full width)
    basePath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, height * 0.28, width, height * 0.72),
        Radius.circular(width * 0.2),
      ),
    );

    canvas.drawPath(basePath, armrestPaint);

    // Main seat body (center, lighter color)
    final mainSeat = RRect.fromRectAndRadius(
      Rect.fromLTWH(width * 0.15, 0, width * 0.7, height * 0.85),
      Radius.circular(width * 0.18),
    );
    canvas.drawShadow(basePath, Colors.black26, 2, false);
    canvas.drawRRect(mainSeat, mainPaint);

    // Add subtle inner shadow/border
    if (isActive && !isSelected) {
      final borderPaint = Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRRect(mainSeat, borderPaint);
    }

    // Add glow if selected
    if (isSelected) {
      final glowPaint = Paint()
        ..color = const Color(0xFFec1337).withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawRRect(mainSeat, glowPaint);
    }
  }

  void _drawDoubleSeat(Canvas canvas, double width, double height) {
    final armrestPaint = Paint()
      ..color = armrestColor
      ..style = PaintingStyle.fill;

    final mainPaint = Paint()
      ..color = mainColor
      ..style = PaintingStyle.fill;

    // Base/background (armrests + bottom) - wider
    final basePath = Path();
    basePath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, height * 0.15, width, height * 0.85),
        Radius.circular(width * 0.12),
      ),
    );
    canvas.drawPath(basePath, armrestPaint);

    // Main seat body (center, lighter color) - wider
    final mainSeat = RRect.fromRectAndRadius(
      Rect.fromLTWH(width * 0.08, 0, width * 0.84, height * 0.85),
      Radius.circular(width * 0.1),
    );
    canvas.drawShadow(basePath, Colors.black26, 2, false);
    canvas.drawRRect(mainSeat, mainPaint);

    // Center divider to show 2 seats
    final dividerPaint = Paint()
      ..color = armrestColor.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(width * 0.47, height * 0.05, width * 0.06, height * 0.75),
        Radius.circular(width * 0.02),
      ),
      dividerPaint,
    );

    // Add glow if selected
    if (isSelected) {
      final glowPaint = Paint()
        ..color = const Color(0xFFec1337).withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawRRect(mainSeat, glowPaint);
    }
  }

  @override
  bool shouldRepaint(TopViewSeatPainter oldDelegate) {
    return oldDelegate.mainColor != mainColor ||
        oldDelegate.armrestColor != armrestColor ||
        oldDelegate.isSelected != isSelected ||
        oldDelegate.isActive != isActive ||
        oldDelegate.isCouple != isCouple;
  }
}
