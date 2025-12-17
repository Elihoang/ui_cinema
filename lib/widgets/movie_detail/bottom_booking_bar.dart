// widgets/bottom_booking_bar.dart
import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../screens/cinema_showtime_list_screen.dart';

class BottomBookingBar extends StatelessWidget {
  final Movie movie;

  const BottomBookingBar({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF221013).withOpacity(0.98),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.08)),
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng cộng',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
                const Text(
                  '190.000đ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CinemaShowtimeListScreen(
                        movieTitle: movie.title,
                        movieInfo:
                            'T${movie.ageLimit} • ${movie.category.name} • ${movie.durationMinutes}p',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.confirmation_number, size: 20),
                label: const Text(
                  'Đặt vé ngay',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC1337),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFFEC1337).withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
