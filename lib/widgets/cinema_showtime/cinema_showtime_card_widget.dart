import 'package:flutter/material.dart';
import 'showtime_format_section.dart';

class CinemaShowtimeCardWidget extends StatelessWidget {
  final String cinemaName;
  final String address;
  final String distance;
  final List<ShowtimeFormat> formats;
  final VoidCallback? onMapTap;
  final Function(ShowtimeSlot) onShowtimeSelected;

  const CinemaShowtimeCardWidget({
    super.key,
    required this.cinemaName,
    required this.address,
    required this.distance,
    required this.formats,
    this.onMapTap,
    required this.onShowtimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2f1b1e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cinemaName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          color: Color(0xFFc9929b),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '$address • $distance',
                            style: const TextStyle(
                              color: Color(0xFFc9929b),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onMapTap,
                icon: const Icon(Icons.map_outlined, color: Color(0xFFec1337)),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFec1337).withOpacity(0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
          const SizedBox(height: 16),
          ...formats.asMap().entries.map((entry) {
            final index = entry.key;
            final format = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < formats.length - 1 ? 16 : 0,
              ),
              child: ShowtimeFormatSection(
                format: format.format,
                audioType: format.audioType,
                showtimes: format.showtimes,
                isSpecialFormat: format.isSpecialFormat,
                onShowtimeSelected: onShowtimeSelected,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ShowtimeFormat {
  final String format;
  final String audioType;
  final List<ShowtimeSlot> showtimes;
  final bool isSpecialFormat;

  ShowtimeFormat({
    required this.format,
    required this.audioType,
    required this.showtimes,
    this.isSpecialFormat = false,
  });
}
