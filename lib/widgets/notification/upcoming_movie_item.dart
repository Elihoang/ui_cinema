import 'package:fe_cinema_mobile/utils/formatDate.dart';
import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../screens/movie_detail_screen.dart';
import '../../extensions/movie_category_extension.dart';
import '../../services/movie_reminder_service.dart';

class UpcomingMovieItem extends StatefulWidget {
  final Movie movie;

  const UpcomingMovieItem({super.key, required this.movie});

  @override
  State<UpcomingMovieItem> createState() => _UpcomingMovieItemState();
}

class _UpcomingMovieItemState extends State<UpcomingMovieItem> {
  final MovieReminderService _reminderService = MovieReminderService();
  bool _isSubscribed = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkReminderStatus();
  }

  Future<void> _checkReminderStatus() async {
    try {
      final isSubscribed = await _reminderService.getReminderStatus(widget.movie.id);
      if (mounted) {
        setState(() {
          _isSubscribed = isSubscribed;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error checking reminder status: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleReminder() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool success;
      String message;

      if (_isSubscribed) {
        success = await _reminderService.unsubscribeFromReminder(widget.movie.id);
        message = success ? 'Đã hủy nhắc nhở' : 'Lỗi khi hủy nhắc nhở';
      } else {
        success = await _reminderService.subscribeToReminder(widget.movie.id);
        message = success ? 'Chúng tôi sẽ nhắc bạn khi phim ra mắt' : 'Lỗi khi đăng ký nhắc nhở';
      }

      if (mounted) {
        setState(() {
          if (success) {
            _isSubscribed = !_isSubscribed;
          }
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error toggling reminder: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xảy ra lỗi. Vui lòng thử lại'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: widget.movie),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF3a1c20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.movie.posterUrl != null && widget.movie.posterUrl!.isNotEmpty
                    ? Image.network(widget.movie.posterUrl!, fit: BoxFit.cover)
                    : Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Category
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          formatDate(widget.movie.releaseDate),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.movie.category.vi,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Description
                  Text(
                    widget.movie.description ?? 'No description available.',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Reminder Button
                  Row(
                    children: [
                      Icon(
                        _isSubscribed ? Icons.notifications_active : Icons.notifications_outlined,
                        size: 14,
                        color: _isSubscribed ? const Color(0xFFec1337) : const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: _isLoading ? null : _toggleReminder,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFec1337),
                          ),
                        )
                            : Text(
                          _isSubscribed ? 'Đã nhắc' : 'Nhắc tôi',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _isSubscribed ? const Color(0xFF4ADE80) : const Color(0xFFec1337),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}