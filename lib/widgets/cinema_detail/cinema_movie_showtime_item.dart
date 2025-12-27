import 'package:flutter/material.dart';
import 'cinema_showtime_button.dart';
import '../other/age_badge.dart';
import '../../utils/movie_category_parser.dart';
import '../../utils/formatDate.dart';
import '../../extensions/movie_category_extension.dart'; // Import extension .vi

class ShowtimeSlotData {
  final String time;
  final String? price;
  final bool isVIP;
  final bool isSoldOut;

  ShowtimeSlotData({
    required this.time,
    this.price,
    this.isVIP = false,
    this.isSoldOut = false,
  });
}

class CinemaMovieShowtimeItem extends StatelessWidget {
  final String posterUrl;
  final String title;
  final String duration;
  final double rating;
  final String reviewCount;
  final String? format;
  final String formatLabel;
  final List<ShowtimeSlotData> showtimes;
  final Function(String)? onShowtimeSelected;
  final VoidCallback? onMovieTap;
  final int? ageLimit;
  final String? category;
  final DateTime? releaseDate;

  const CinemaMovieShowtimeItem({
    super.key,
    required this.posterUrl,
    required this.title,

    required this.duration,
    required this.rating,
    required this.reviewCount,
    this.format,
    required this.formatLabel,
    required this.showtimes,
    this.onShowtimeSelected,
    this.onMovieTap,
    this.ageLimit,
    this.category,
    this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF67323B).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie info section
          GestureDetector(
            onTap: onMovieTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster
                Container(
                  width: 96,
                  height: 144,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          posterUrl,
                          width: 96,
                          height: 144,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (format != null)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              format!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Movie details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height:
                                  43.2, // 18 (fontSize) * 1.2 (height) * 2 (lines)
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          if (ageLimit != null) const SizedBox(width: 8),
                          if (ageLimit != null) AgeBadge(ageLimit: ageLimit!),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Category tags
                      if (category != null && category!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: _buildCategoryTags(),
                          ),
                        ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Color(0xFFC9929B),
                              ),
                            ],
                          ),
                          Text(
                            duration,
                            style: const TextStyle(
                              color: Color(0xFFC9929B),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (releaseDate != null) ...[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Color(0xFFC9929B),
                                ),
                              ],
                            ),
                            Text(
                              formatDate(releaseDate),
                              style: const TextStyle(
                                color: Color(0xFFC9929B),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFC107),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '($reviewCount)',
                            style: const TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Format label
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              formatLabel.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFFC9929B),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Showtimes
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: showtimes.map((showtime) {
              return CinemaShowtimeButton(
                time: showtime.time,
                price: showtime.price,
                isVIP: showtime.isVIP,
                isSoldOut: showtime.isSoldOut,
                onPressed: () => onShowtimeSelected?.call(showtime.time),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryTags() {
    if (category == null || category!.isEmpty) return [];

    // Split categories by comma or pipe
    final categories = category!
        .split(RegExp(r'[,|]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return categories.map((cat) {
      final movieCategory = parseMovieCategory(cat);
      final displayName = movieCategory.vi; // Dùng extension .vi

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF67323B).withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFC9929B).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          displayName,
          style: const TextStyle(
            color: Color(0xFFC9929B),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }).toList();
  }
}
