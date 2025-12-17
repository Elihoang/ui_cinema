import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../models/movie_detail.dart';
import '../../services/movie_service.dart';
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
  MovieDetail? _movieDetail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetail();
  }

  Future<void> _fetchMovieDetail() async {
    try {
      final movieDetail = await MovieService.fetchMovieDetail(widget.movie.id);
      print(movieDetail.id);
      if (mounted) {
        setState(() {
          _movieDetail = movieDetail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Không thể tải thông tin phim. Vui lòng kiểm tra kết nối.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFEC1337)),
            )
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchMovieDetail,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: HeroSection(movie: widget.movie)),
                    SliverToBoxAdapter(
                      child: MovieInfoHeader(movie: widget.movie),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: CustomTabBarDelegate(
                        selectedIndex: _selectedTabIndex,
                        onTabSelected: (index) =>
                            setState(() => _selectedTabIndex = index),
                        reviewCount: _movieDetail?.reviews.length ?? 0,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: MovieDetailContent(
                        tabIndex: _selectedTabIndex,
                        movieDetail: _movieDetail!,
                      ),
                    ),
                  ],
                ),
                TopNavigation(
                  isFavorite: _isFavorite,
                  onFavoritePressed: () =>
                      setState(() => _isFavorite = !_isFavorite),
                  onBackPressed: () => Navigator.pop(context),
                ),
                BottomBookingBar(movie: widget.movie),
              ],
            ),
    );
  }
}
