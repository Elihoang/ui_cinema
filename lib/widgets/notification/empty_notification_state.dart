
import 'package:flutter/material.dart';

class EmptyNotificationState extends StatelessWidget {
  final bool isUnreadFilter;

  const EmptyNotificationState({
    Key? key,
    this.isUnreadFilter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient background
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFec1337).withOpacity(0.2),
                  const Color(0xFFec1337).withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUnreadFilter
                  ? Icons.mark_email_read_outlined
                  : Icons.notifications_none_outlined,
              size: 60,
              color: const Color(0xFFec1337).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            isUnreadFilter
                ? 'Tất cả đã đọc!'
                : 'Chưa có thông báo',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              isUnreadFilter
                  ? 'Bạn đã đọc hết tất cả thông báo'
                  : 'Thông báo về đơn hàng, vé phim và ưu đãi sẽ hiển thị ở đây',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // Action button (optional)
          if (!isUnreadFilter)
            OutlinedButton.icon(
              onPressed: () {
                // Navigate to explore movies
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.movie_outlined,
                size: 18,
              ),
              label: const Text('Khám phá phim'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFec1337),
                side: const BorderSide(
                  color: Color(0xFFec1337),
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}