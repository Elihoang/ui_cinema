import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final hasItems = quantity > 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decrease button
        IconButton(
          onPressed: hasItems ? onDecrease : null,
          icon: const Icon(Icons.remove, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.1),
            foregroundColor: hasItems
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            minimumSize: const Size(32, 32),
            maximumSize: const Size(32, 32),
          ),
        ),
        // Quantity
        SizedBox(
          width: 16,
          child: Text(
            quantity.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: hasItems ? Colors.white : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
        // Increase button
        IconButton(
          onPressed: onIncrease,
          icon: const Icon(Icons.add, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: hasItems
                ? const Color(0xFFEC1337)
                : Colors.white.withOpacity(0.1),
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            minimumSize: const Size(32, 32),
            maximumSize: const Size(32, 32),
          ),
        ),
      ],
    );
  }
}
