import 'package:flutter/material.dart';
import 'showtime_format_section.dart';

class CinemaShowtimeCardWidget extends StatelessWidget {
  final String cinemaName;
  final String address;
  final String distance;
  final String? bannerUrl;
  final List<ShowtimeFormat> formats;
  final VoidCallback? onMapTap;
  final Function(ShowtimeSlot) onShowtimeSelected;

  const CinemaShowtimeCardWidget({
    super.key,
    required this.cinemaName,
    required this.address,
    required this.distance,
    this.bannerUrl,
    required this.formats,
    this.onMapTap,
    required this.onShowtimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2f1b1e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cinema Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Cinema Banner Thumbnail
                    if (bannerUrl != null && bannerUrl!.isNotEmpty)
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            bannerUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFF482329),
                                child: const Icon(
                                  Icons.movie,
                                  color: Color(0xFFc9929b),
                                  size: 24,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cinemaName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                color: Color(0xFFc9929b),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: distance,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' • ',
                                        style: TextStyle(
                                          color: Color(0xFFc9929b),
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: address,
                                        style: const TextStyle(
                                          color: Color(0xFFc9929b),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
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
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: IconButton(
                        onPressed: onMapTap,
                        icon: const Icon(
                          Icons.map_outlined,
                          color: Color(0xFFec1337),
                          size: 20,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFec1337,
                          ).withOpacity(0.1),
                          padding: EdgeInsets.zero,
                        ),
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
          ),
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
