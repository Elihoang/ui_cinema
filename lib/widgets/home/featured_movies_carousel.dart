import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/movie.dart';
import 'featured_movie_card.dart';

class FeaturedMoviesCarousel extends StatefulWidget {
  final List<Movie> movies;
  final Duration interval;

  const FeaturedMoviesCarousel({
    super.key,
    required this.movies,
    this.interval = const Duration(seconds: 5),
  });

  @override
  State<FeaturedMoviesCarousel> createState() => _FeaturedMoviesCarouselState();
}

class _FeaturedMoviesCarouselState extends State<FeaturedMoviesCarousel> {
  late PageController _controller;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1.0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (timer) {
      if (widget.movies.isEmpty) return;

      _currentPage = (_currentPage + 1) % widget.movies.length;
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox();

    return SizedBox(
      height: 270,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          return FeaturedMovieCard(movie: widget.movies[index]);
        },
      ),
    );
  }
}
