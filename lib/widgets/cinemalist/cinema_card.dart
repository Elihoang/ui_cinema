import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/cinema.dart';
import '../../screens/cinema_detail_screen.dart';
import '../../utils/distance_utils.dart';
import '../cinemalist/cinema_movie_list.dart';

class CinemaCard extends StatelessWidget {
  final Cinema cinema;
  final double rating;
  final bool isAvailable;
  final Position? userPosition; // NEW: Vị trí user để tính khoảng cách

  const CinemaCard({
    super.key,
    required this.cinema,
    this.rating = 4.8,
    this.isAvailable = true,
    this.userPosition, // Có thể null
  });

  // Hàm tính khoảng cách (km) - trả về string hoặc null nếu không tính được
  String? getDistanceInKm() {
    return getDistanceValue(
      userPosition: userPosition,
      targetLatitude: cinema.latitude,
      targetLongitude: cinema.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    final moviesList = cinema.currentlyShowingMovies
        .map((m) => m.toMap())
        .toList();
    final String? distanceKm = getDistanceInKm();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CinemaDetailScreen(cinema: cinema),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3a1c20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(
                              cinema.bannerUrl ??
                                  'https://via.placeholder.com/300x100',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    cinema.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isAvailable)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            color: Colors.amber,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cinema.address ?? 'Chưa có địa chỉ',
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.near_me,
                                  color: Color(0xFFec1337),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                if (distanceKm != null) ...[
                                  Text(
                                    '$distanceKm km',
                                    style: const TextStyle(
                                      color: Color(0xFFec1337),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '•',
                                    style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ] else ...[
                                  const SizedBox(width: 8),
                                  const Text(
                                    '•',
                                    style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                if (isAvailable)
                                  const Text(
                                    'Đang mở cửa',
                                    style: TextStyle(
                                      color: Color(0xFF10b981),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                else
                                  const Text(
                                    'Đang bảo trì',
                                    style: TextStyle(
                                      color: Color(0xFFec1337),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isAvailable && moviesList.isNotEmpty)
              Column(
                children: [
                  Divider(color: Colors.white.withOpacity(0.05), height: 0),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: CinemaMovieList(movies: moviesList),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
