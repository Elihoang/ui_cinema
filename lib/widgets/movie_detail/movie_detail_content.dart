// widgets/movie_detail_content.dart
import 'package:flutter/material.dart';
import 'synopsis_section.dart';
import 'cast_section.dart';
import 'showtimes_section.dart';
import 'rating_section.dart';
import '../../models/movie_detail.dart';

class MovieDetailContent extends StatelessWidget {
  final int tabIndex;
  final MovieDetail movieDetail;
  final String? currentUserId;
  final bool canUserReview;
  final Function(int rating, String comment)? onAddReview;
  final Function(int rating, String comment)? onEditReview;

  const MovieDetailContent({
    super.key,
    required this.tabIndex,
    required this.movieDetail,
    this.currentUserId,
    this.canUserReview = false,
    this.onAddReview,
    this.onEditReview,
  });

  @override
  Widget build(BuildContext context) {
    if (tabIndex == 0) {
      return InfoTabContent(movieDetail: movieDetail);
    } else if (tabIndex == 1) {
      return const ShowtimesSection();
    } else {
      // Tab Đánh giá: dùng RatingSection với ListView riêng → scroll thoải mái
      return RatingSection(
        movieId: movieDetail.id,
        reviews: movieDetail.reviews,
        currentUserId: currentUserId,
        canUserReview: canUserReview,
        onAddReview: onAddReview,
        onEditReview: onEditReview,
      );
    }
  }
}

class InfoTabContent extends StatefulWidget {
  final MovieDetail movieDetail;
  const InfoTabContent({super.key, required this.movieDetail});

  @override
  State<InfoTabContent> createState() => _InfoTabContentState();
}

class _InfoTabContentState extends State<InfoTabContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SynopsisSection(
              synopsis: widget.movieDetail.description ?? '',
              isExpanded: _isExpanded,
              onToggle: () => setState(() => _isExpanded = !_isExpanded),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CastSection(actors: widget.movieDetail.actors),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
