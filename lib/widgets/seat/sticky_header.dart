import 'package:flutter/material.dart';

class StickyHeader extends StatelessWidget {
  final String movieTitle;
  final String cinemaName;
  final String showtime;
  final String date;
  final VoidCallback onBack;

  const StickyHeader({
    super.key,
    required this.movieTitle,
    required this.cinemaName,
    required this.showtime,
    required this.date,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  movieTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$cinemaName • $showtime • $date',
                  style: const TextStyle(
                    color: Color(0xFFec1337),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.more_vert, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
