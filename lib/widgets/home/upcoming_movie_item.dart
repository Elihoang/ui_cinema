import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../screens/movie_detail_screen.dart';

class UpcomingMovieItem extends StatelessWidget {
  final UpcomingMovie movie;

  const UpcomingMovieItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Create a Movie object from UpcomingMovie for detail screen
        final movieDetail = Movie(
          title: movie.title,
          imageUrl: movie.imageUrl,
          duration: '2h 30m',
          genre: movie.genre,
          rating: 4.5,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movieDetail),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF3a1c20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(movie.imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          movie.releaseDate,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          movie.genre,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF6B7280),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        size: 14,
                        color: Color(0xFFec1337),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Nhắc tôi',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFec1337),
                          ),
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
    );
  }
}
