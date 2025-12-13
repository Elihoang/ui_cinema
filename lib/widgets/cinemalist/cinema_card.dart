import 'package:flutter/material.dart';
import '../../models/cinema.dart';
import '../cinemalist/cinema_movie_list.dart';

class CinemaCard extends StatelessWidget {
  final Cinema cinema;
  final String imageUrl;
  final double rating;
  final List<Map<String, String>> moviesNowShowing;
  final bool isAvailable;

  const CinemaCard({
    super.key,
    required this.cinema,
    required this.imageUrl,
    required this.rating,
    required this.moviesNowShowing,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                // Cinema header with image and info
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
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
                                  style: Theme.of(context).textTheme.bodyMedium
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
                                        rating.toString(),
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
                            cinema.address,
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
                              Text(
                                '${cinema.distance.toStringAsFixed(1)} km',
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
          if (isAvailable)
            Column(
              children: [
                Divider(color: Colors.white.withOpacity(0.05), height: 0),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CinemaMovieList(movies: moviesNowShowing),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
