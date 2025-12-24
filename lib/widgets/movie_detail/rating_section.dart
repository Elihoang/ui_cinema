import 'package:flutter/material.dart';
import '../../models/review/movie_review.dart';
import './add_review_dialog.dart';

class RatingSection extends StatefulWidget {
  final String movieId;
  final List<MovieReview> reviews;
  final String? currentUserId;
  final bool canUserReview; // Người dùng đã đặt vé chưa
  final Function(int rating, String comment)? onAddReview;
  final Function(int rating, String comment)? onEditReview;

  const RatingSection({
    super.key,
    required this.movieId,
    required this.reviews,
    this.currentUserId,
    this.canUserReview = false,
    this.onAddReview,
    this.onEditReview,
  });

  @override
  State<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  bool _showAllComments = false;
  static const int _maxCommentsToShow = 3;

  @override
  Widget build(BuildContext context) {
    final int totalReviews = widget.reviews.length;

    // Tìm đánh giá của user hiện tại
    MovieReview? userReview;
    List<MovieReview> otherReviews = [];

    if (widget.currentUserId != null) {
      for (var review in widget.reviews) {
        if (review.userId == widget.currentUserId) {
          userReview = review;
        } else {
          otherReviews.add(review);
        }
      }
    } else {
      otherReviews = widget.reviews;
    }

    double averageRating = 0.0;
    List<double> ratingDistribution = List.filled(5, 0.0);

    if (totalReviews > 0) {
      double sum = 0;
      List<int> counts = List.filled(5, 0);

      for (var review in widget.reviews) {
        sum += review.rating;
        if (review.rating >= 1 && review.rating <= 5) {
          counts[review.rating - 1]++;
        }
      }
      averageRating = sum / totalReviews;

      for (int i = 0; i < 5; i++) {
        ratingDistribution[i] = counts[i] / totalReviews;
      }
    }

    // Danh sách comments cần hiển thị (không bao gồm review của user)
    final displayedOtherReviews = _showAllComments
        ? otherReviews
        : otherReviews.take(_maxCommentsToShow).toList();
    final hasMoreComments = otherReviews.length > _maxCommentsToShow;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Đánh giá & Review',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (totalReviews == 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chưa có đánh giá nào',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                // Nút đánh giá (chỉ hiện nếu user đã đăng nhập)
                if (widget.currentUserId != null) _buildReviewButton(null),
              ],
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Điểm trung bình lớn
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < averageRating.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFFEC1337),
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalReviews bài viết',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                // Biểu đồ phân bố sao
                Expanded(
                  child: Column(
                    children: List.generate(5, (i) {
                      final rating = 5 - i;
                      final fill = ratingDistribution[rating - 1];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              child: Text(
                                '$rating',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              color: Color(0xFFEC1337),
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: fill.clamp(0.0, 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEC1337),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Divider(color: Colors.grey, thickness: 0.5),
            const SizedBox(height: 16),

            // Header với nút đánh giá
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bình luận',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Nút đánh giá (chỉ hiện nếu user đã đăng nhập)
                if (widget.currentUserId != null)
                  _buildReviewButton(userReview),
              ],
            ),
            const SizedBox(height: 16),

            // Hiển thị đánh giá của user (nếu có)
            if (userReview != null) ...[
              _buildUserReviewCard(userReview),
              const SizedBox(height: 16),
              if (otherReviews.isNotEmpty) ...[
                const Divider(color: Colors.grey, thickness: 0.3),
                const SizedBox(height: 16),
              ],
            ],

            // Danh sách bình luận của người dùng khác
            ...displayedOtherReviews.map(
              (review) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ReviewCard(review: review),
              ),
            ),

            // Nút "Xem thêm" / "Thu gọn"
            if (hasMoreComments)
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showAllComments = !_showAllComments;
                    });
                  },
                  icon: Icon(
                    _showAllComments
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFFEC1337),
                  ),
                  label: Text(
                    _showAllComments
                        ? 'Thu gọn'
                        : 'Xem thêm ${otherReviews.length - _maxCommentsToShow} đánh giá',
                    style: const TextStyle(
                      color: Color(0xFFEC1337),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewButton(MovieReview? userReview) {
    final bool hasReviewed = userReview != null;
    final bool canReview = widget.canUserReview;

    return ElevatedButton.icon(
      onPressed: () {
        if (!canReview && !hasReviewed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bạn cần đặt vé phim này để có thể đánh giá'),
              backgroundColor: Color(0xFFEC1337),
            ),
          );
          return;
        }
        _showReviewDialog(userReview);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: hasReviewed
            ? Colors.grey.shade800
            : const Color(0xFFEC1337),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      icon: Icon(hasReviewed ? Icons.edit : Icons.rate_review, size: 18),
      label: Text(
        hasReviewed ? 'Chỉnh sửa' : 'Viết đánh giá',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildUserReviewCard(MovieReview review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEC1337).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEC1337), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFEC1337),
                child: Icon(Icons.person, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            review.userName ?? 'Bạn',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEC1337),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Đánh giá của bạn',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < review.rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFEC1337),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.comment != null && review.comment!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review.comment!.trim(),
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showReviewDialog(MovieReview? existingReview) {
    final bool isEditing = existingReview != null;

    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(
        initialRating: existingReview?.rating,
        initialComment: existingReview?.comment,
        isEditing: isEditing,
        onSubmit: (rating, comment) async {
          if (isEditing) {
            if (widget.onEditReview != null) {
              await widget.onEditReview!(rating, comment);
            }
          } else {
            if (widget.onAddReview != null) {
              await widget.onAddReview!(rating, comment);
            }
          }
        },
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final MovieReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFEC1337),
                child: Text(
                  (review.userName ?? 'U')[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName ?? 'Người dùng',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < review.rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFEC1337),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.comment != null && review.comment!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review.comment!.trim(),
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
