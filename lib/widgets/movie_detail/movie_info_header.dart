// widgets/movie_detail/movie_info_header.dart
import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../widgets/other/age_badge.dart'; // Widget badge độ tuổi
import '../../extensions/movie_category_extension.dart'; // Extension tiếng Việt cho category
import '../../utils/formatDate.dart'; // Helper format ngày

class MovieInfoHeader extends StatelessWidget {
  final Movie movie;

  const MovieInfoHeader({super.key, required this.movie});

  // Format thời lượng: 131 → "131 phút"
  String get formattedDuration {
    return '${movie.durationMinutes} phút';
  }

  // Năm phát hành (hoặc ngày đầy đủ nếu muốn)
  String get releaseYear {
    return formatDate(movie.releaseDate); // Ví dụ: 27/05/2022
    // Nếu chỉ muốn năm: DateFormat('yyyy').format(movie.releaseDate)
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
                        // Badge phân loại độ tuổi (P, T13, T16, T18)
                        AgeBadge(ageLimit: movie.ageLimit),

                        // Thời lượng
                        Text(
                          formattedDuration,
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                          ),
                        ),

                        // Dấu phân cách
                        Text(
                          '•',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                          ),
                        ),

                        // Năm phát hành
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

              // Có thể thêm IMDb rating sau này
              // Container(... IMDb box ...)
            ],
          ),

          const SizedBox(height: 20),

          // Thể loại phim - hiển thị tiếng Việt từ category
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildGenreChip(movie.category.vi),

                // Nếu backend sau này trả nhiều thể loại (List<String>)
                // thì dùng: movie.genres.map((g) => _buildGenreChip(g.vi)).toList()
              ],
            ),
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
