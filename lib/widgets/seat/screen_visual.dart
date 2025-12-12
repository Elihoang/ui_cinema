import 'package:flutter/material.dart';

class ScreenVisual extends StatelessWidget {
  const ScreenVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: 32,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.3), width: 4),
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.elliptical(200, 30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'MÀN HÌNH',
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
