import 'package:flutter/material.dart';

const kSurfaceBorder = Color(0xFF482329);
const kBgDark = Color(0xFF221013);

class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(children: [
        CustomPaint(painter: DashedLinePainter(), size: Size.infinite),
        const Positioned(left: -10, child: SizedBox(width: 20, height: 40, child: ColoredBox(color: kBgDark))),
        const Positioned(right: -10, child: SizedBox(width: 20, height: 40, child: ColoredBox(color: kBgDark))),
      ]),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = kSurfaceBorder..strokeWidth = 1.5;
    const dashWidth = 9.0;
    const dashSpace = 5.0;
    double x = 30;
    while (x < size.width - 30) {
      canvas.drawLine(Offset(x, size.height / 2), Offset(x + dashWidth, size.height / 2), paint);
      x += dashWidth + dashSpace;
    }
  }
  @override
  bool shouldRepaint(_) => false;
}