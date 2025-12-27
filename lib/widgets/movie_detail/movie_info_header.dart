import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../widgets/other/age_badge.dart';
import '../../extensions/movie_category_extension.dart';
import '../../utils/formatDate.dart';

class MovieInfoHeader extends StatelessWidget {
  final Movie movie;

  const MovieInfoHeader({super.key, required this.movie});

  // Format thời lượng: 131 → "131 phút"
  String get formattedDuration {
    return '${movie.durationMinutes} phút';
  }

  // Năm phát hành
  String get releaseYear {
    return formatDate(movie.releaseDate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                    // Tiêu đề phim
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Thông tin phụ: độ tuổi + thời lượng + năm
                    Wrap(
                      spacing: 14,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: [
                        AgeBadge(ageLimit: movie.ageLimit),
                        // Thời lượng
                        Text(
                          formattedDuration,
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                          ),
                        ),

                        Text(
                          '•',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                          ),
                        ),

                        Text(
                          releaseYear,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),
            ],
          ),

          const SizedBox(height: 20),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [_buildGenreChip(movie.category.vi)]),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // Helper tạo chip thể loại
  Widget _buildGenreChip(String genre) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(
        backgroundColor: Colors.white.withOpacity(0.08),
        side: BorderSide(color: Colors.white.withOpacity(0.15)),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        label: Text(
          genre,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
