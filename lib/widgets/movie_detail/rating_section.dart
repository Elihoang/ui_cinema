import 'package:flutter/material.dart';
import '../../models/movie_review.dart';

class RatingSection extends StatefulWidget {
  final List<MovieReview> reviews;

  const RatingSection({super.key, required this.reviews});

  @override
  State<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  bool _showAllComments = false;
  static const int _maxCommentsToShow = 3;

  @override
  Widget build(BuildContext context) {
    final int totalReviews = widget.reviews.length;

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

    // Danh sách comments cần hiển thị
    final displayedReviews = _showAllComments
        ? widget.reviews
        : widget.reviews.take(_maxCommentsToShow).toList();
    final hasMoreComments = totalReviews > _maxCommentsToShow;

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

          if (totalReviews == 0)
            const Text(
              'Chưa có đánh giá nào',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            )
          else ...[
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
            const Text(
              'Bình luận',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Danh sách bình luận (giới hạn hoặc full)
            ...displayedReviews.map(
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
                        : 'Xem thêm ${totalReviews - _maxCommentsToShow} đánh giá',
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
