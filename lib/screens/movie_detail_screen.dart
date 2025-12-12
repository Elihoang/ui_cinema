// screens/movie_detail/movie_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../widgets/movie_detail/hero_section.dart';
import '../widgets/movie_detail/top_navigation.dart';
import '../widgets/movie_detail/movie_info_header.dart';
import '../widgets/movie_detail/custom_tab_bar.dart';
import '../widgets/movie_detail/movie_detail_content.dart';
import '../widgets/movie_detail/bottom_booking_bar.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int _selectedTabIndex = 0;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: HeroSection(movie: widget.movie)),
              SliverToBoxAdapter(child: MovieInfoHeader(movie: widget.movie)),
              SliverPersistentHeader(
                pinned: true,
                delegate: CustomTabBarDelegate(
                  selectedIndex: _selectedTabIndex,
                  onTabSelected: (index) =>
                      setState(() => _selectedTabIndex = index),
                ),
              ),
              SliverToBoxAdapter(
                child: MovieDetailContent(tabIndex: _selectedTabIndex),
              ),
            ],
          ),
          TopNavigation(
            isFavorite: _isFavorite,
            onFavoritePressed: () => setState(() => _isFavorite = !_isFavorite),
            onBackPressed: () => Navigator.pop(context),
          ),
          const BottomBookingBar(),
        ],
      ),
    );
  }
}
