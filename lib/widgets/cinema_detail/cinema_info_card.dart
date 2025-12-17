import 'package:flutter/material.dart';

class CinemaInfoCard extends StatelessWidget {
  final String address;
  final String distance;
  final String openingHours;
  final VoidCallback? onMapPressed;

  const CinemaInfoCard({
    super.key,
    required this.address,
    required this.distance,
    required this.openingHours,
    this.onMapPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF482329),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.location_on,
              color: Color(0xFFEC1337),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Cách bạn $distance • $openingHours',
                  style: const TextStyle(
                    color: Color(0xFFC9929B),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onMapPressed,
            child: const Text(
              'Bản đồ',
              style: TextStyle(
                color: Color(0xFFEC1337),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
