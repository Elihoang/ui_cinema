import 'package:flutter/material.dart';
import '../../models/movie.dart';

class HeroSection extends StatelessWidget {
  final Movie movie;
  const HeroSection({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(movie.posterUrl ?? ''),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        const Color(0xFF221013),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
                const Center(
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFEC1337),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
