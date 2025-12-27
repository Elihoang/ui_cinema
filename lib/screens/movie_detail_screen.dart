import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../models/movie_detail.dart';
import '../../services/movie_service.dart';
import '../../services/movie_review_service.dart';
import '../../services/user_service.dart';
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
  String? _currentUserId;
  final MovieReviewService _movieReviewService = MovieReviewService();

  @override
  void initState() {
    super.initState();
    _fetchMovieDetail();
    _fetchCurrentUser();
  }

  // Lấy thông tin user hiện tại
  Future<void> _fetchCurrentUser() async {
    final userId = await UserService.getUserId();
    if (mounted) {
      setState(() {
        _currentUserId = userId;
      });
    }
  }

  // Lấy chi tiết phim
  Future<void> _fetchMovieDetail() async {
    try {
      final movieDetail = await MovieService.fetchMovieDetail(widget.movie.id);
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

  Future<void> _handleAddReview(int rating, String comment) async {
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để đánh giá'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Gọi API tạo review
      await _movieReviewService.createReview(widget.movie.id, rating, comment);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đánh giá của bạn đã được gửi thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh movie detail to get new review
        await _fetchMovieDetail();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleEditReview(int rating, String comment) async {
    // Backend chưa hỗ trợ update review
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng chỉnh sửa đánh giá đang được phát triển'),
        backgroundColor: Colors.orange,
      ),
    );
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
                    // WIDGET
                    SliverToBoxAdapter(child: HeroSection(movie: widget.movie)),
                    // WIDGET
                    SliverToBoxAdapter(
                      child: MovieInfoHeader(movie: widget.movie),
                    ),
                    // WIDGET
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: CustomTabBarDelegate(
                        selectedIndex: _selectedTabIndex,
                        onTabSelected: (index) =>
                            setState(() => _selectedTabIndex = index),
                        reviewCount: _movieDetail?.reviews.length ?? 0,
                      ),
                    ),
                    // WIDGET
                    SliverToBoxAdapter(
                      child: MovieDetailContent(
                        tabIndex: _selectedTabIndex,
                        movieDetail: _movieDetail!,
                        currentUserId: _currentUserId,
                        canUserReview: true,
                        onAddReview: _handleAddReview,
                        onEditReview: _handleEditReview,
                      ),
                    ),
                  ],
                ),
                // WIDGET
                TopNavigation(
                  isFavorite: _isFavorite,
                  onFavoritePressed: () =>
                      setState(() => _isFavorite = !_isFavorite),
                  onBackPressed: () => Navigator.pop(context),
                ),
                // WIDGET
                BottomBookingBar(movie: widget.movie),
              ],
            ),
    );
  }
}
