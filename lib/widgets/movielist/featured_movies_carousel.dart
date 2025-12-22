import 'package:flutter/material.dart';
import '../../models/movie.dart';
import 'featured_movie_carousel_card.dart';

class FeaturedMoviesCarousel extends StatelessWidget {
  final List<Movie> movies;

  const FeaturedMoviesCarousel({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Phim đang HOT 🔥',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return FeaturedMovieCarouselCard(movie: movies[index]);
            },
          ),
        ),
      ],
    );
  }
}
