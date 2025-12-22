import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/movie.dart';

class HeroSection extends StatelessWidget {
  final Movie movie;
  const HeroSection({super.key, required this.movie});

  Future<void> _openTrailer(BuildContext context) async {
    final trailerUrl = movie.trailerUrl;

    if (trailerUrl == null || trailerUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Phim chưa có trailer')));
      return;
    }

    final uri = Uri.parse(trailerUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không mở được trailer')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background (poster fallback)
          Image.network(
            movie.posterUrl ?? '',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.black),
          ),

          // Gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(80, 0, 0, 0), Color(0xFF221013)],
              ),
            ),
          ),

          // Play button
          Center(
            child: GestureDetector(
              onTap: () => _openTrailer(context),
              child: const CircleAvatar(
                radius: 36,
                backgroundColor: Color(0xFFEC1337),
                child: Icon(Icons.play_arrow, color: Colors.white, size: 36),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
