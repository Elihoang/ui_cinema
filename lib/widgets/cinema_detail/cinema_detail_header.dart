import 'package:flutter/material.dart';

class CinemaDetailHeader extends StatelessWidget {
  final String cinemaName;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSearchPressed;

  const CinemaDetailHeader({
    super.key,
    required this.cinemaName,
    this.onBackPressed,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackPressed ?? () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            style: IconButton.styleFrom(foregroundColor: Colors.white),
          ),
          Expanded(
            child: Text(
              cinemaName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onSearchPressed,
            icon: const Icon(Icons.search, size: 24),
            style: IconButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
