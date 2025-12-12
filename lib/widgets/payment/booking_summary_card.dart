import 'package:flutter/material.dart';
import '../../models/booking.dart';

class BookingSummaryCard extends StatelessWidget {
  final BookingInfo booking;

  const BookingSummaryCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF33191E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              booking.moviePoster,
              width: 96,
              height: 144,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 96,
                  height: 144,
                  color: const Color(0xFF482329),
                  child: const Icon(Icons.movie, color: Colors.white),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // Movie Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.movieTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.theaters,
                      size: 16,
                      color: Color(0xFFC9929B),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${booking.cinema} • ${booking.hall}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFC9929B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Color(0xFFC9929B),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${booking.showtime} - ${booking.date}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFC9929B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: booking.seats.map((seat) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEC1337).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Ghế $seat',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEC1337),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
