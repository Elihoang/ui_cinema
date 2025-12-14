import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const ProductHeader({super.key, required this.onBack, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF221013).withOpacity(0.85),
        border: const Border(
          bottom: BorderSide(color: Color(0x0DFFFFFF), width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  shape: const CircleBorder(),
                ),
              ),
              const Expanded(
                child: Text(
                  'Chọn đồ ăn nhẹ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                onPressed: onSkip,
                child: const Text(
                  'Bỏ qua',
                  style: TextStyle(
                    color: Color(0xFFEC1337),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
