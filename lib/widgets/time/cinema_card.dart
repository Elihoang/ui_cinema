import 'package:flutter/material.dart';
import '../../models/cinema.dart';
import '../../models/movie.dart';
import '../../screens/seat_selection_screen.dart';
import 'showtime_chip.dart';

class CinemaCard extends StatelessWidget {
  final Cinema cinema;
  final Movie movie;
  final String selectedDate;

  const CinemaCard({
    super.key,
    required this.cinema,
    required this.movie,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final isNearby = cinema.distance < 2.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x66002F181B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x0DFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: tên rạp + khoảng cách
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cinema.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cinema.address,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isNearby
                      ? const Color(0xFFEC1337).withOpacity(0.1)
                      : const Color(0x0DFFFFFF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: isNearby ? const Color(0xFFEC1337) : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${cinema.distance.toStringAsFixed(1)}km',
                      style: TextStyle(
                        color: isNearby ? const Color(0xFFEC1337) : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: Color(0x0DFFFFFF)),
          const SizedBox(height: 16),

          // Danh sách định dạng (2D, IMAX, 4DX...)
          ...cinema.formats.map((format) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildFormatBadge(format.format),
                      const SizedBox(width: 8),
                      Text(
                        format.audioType,
                        style: const TextStyle(
                          color: Color(0xFFC9929B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: format.showtimes.map((slot) {
                      return ShowtimeChip(
                        time: slot.time,
                        isAvailable: slot.isAvailable,
                        onTap: slot.isAvailable
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SeatSelectionScreen(
                                      movieTitle: movie.title,
                                      cinemaName: cinema.name, // ĐÚNG
                                      showtime: slot.time,
                                      date: selectedDate == 'H.Nay'
                                          ? 'Hôm nay'
                                          : selectedDate,
                                    ),
                                  ),
                                );
                              }
                            : null,
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFormatBadge(String format) {
    switch (format) {
      case 'IMAX':
        return _gradientBadge(format, [
          const Color(0xFF006AC1),
          const Color(0xFF0091FF),
        ]);
      case '4DX':
        return _gradientBadge(format, [
          const Color(0xFFC10000),
          const Color(0xFFFF4800),
        ]);
      default:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0x1AFFFFFF),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            format,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  Widget _gradientBadge(String text, List<Color> colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
