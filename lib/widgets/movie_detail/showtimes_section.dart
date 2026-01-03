// widgets/showtimes_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/movie_cinema_showtime_response.dart';
import '../../screens/cinema_showtime_list_screen.dart';
import '../../screens/seat_selection_screen.dart';
import '../../services/movie_service.dart';

class ShowtimesSection extends StatefulWidget {
  final String movieId;
  final String movieTitle;
  final String? moviePoster;
  final int? durationMinutes;
  final String? category;
  final int? ageLimit;

  const ShowtimesSection({
    super.key,
    required this.movieId,
    required this.movieTitle,
    this.moviePoster,
    this.durationMinutes,
    this.category,
    this.ageLimit,
  });

  @override
  State<ShowtimesSection> createState() => _ShowtimesSectionState();
}

class _ShowtimesSectionState extends State<ShowtimesSection> {
  int _selectedDateIndex = 0;
  List<DateTime> _dateObjects = [];
  List<Map<String, String>> _dates = [];
  MovieCinemaShowtimeResponse? _showtimeData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _generateDates();
    _fetchShowtimes();
  }

  void _generateDates() {
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      _dateObjects.add(date);

      String dayOfWeek;
      switch (date.weekday) {
        case 1:
          dayOfWeek = 'T2';
          break;
        case 2:
          dayOfWeek = 'T3';
          break;
        case 3:
          dayOfWeek = 'T4';
          break;
        case 4:
          dayOfWeek = 'T5';
          break;
        case 5:
          dayOfWeek = 'T6';
          break;
        case 6:
          dayOfWeek = 'T7';
          break;
        case 7:
          dayOfWeek = 'CN';
          break;
        default:
          dayOfWeek = '';
      }

      _dates.add({
        'day': dayOfWeek,
        'date': date.day.toString(),
      });
    }
  }

  Future<void> _fetchShowtimes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final selectedDate = _dateObjects[_selectedDateIndex];
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

      print('Fetching showtimes for movieId: ${widget.movieId}, date: $dateStr');

      final response = await MovieService.fetchCinemaShowtimesByMovie(
        widget.movieId,
        dateStr,
      );

      print('Showtimes response: ${response.cinemas.length} cinemas');
      if (response.cinemas.isNotEmpty) {
        print('First cinema: ${response.cinemas.first.cinemaName}');
        print('Showtimes count: ${response.cinemas.first.showtimes.length}');
        if (response.cinemas.first.showtimes.isNotEmpty) {
          print('First showtime: ${response.cinemas.first.showtimes.first.startTime}');
        }
      }

      setState(() {
        _showtimeData = response;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching showtimes: $e');
      setState(() {
        _errorMessage = 'Không thể tải suất chiếu: $e';
        _isLoading = false;
      });
    }
  }

  String _getMovieInfo() {
    final parts = <String>[];
    if (widget.category != null) parts.add(widget.category!);
    if (widget.durationMinutes != null) {
      final hours = widget.durationMinutes! ~/ 60;
      final minutes = widget.durationMinutes! % 60;
      parts.add('${hours}h ${minutes}p');
    }
    if (widget.ageLimit != null) parts.add('T${widget.ageLimit}');
    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF2a1619),
        height: 300,
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFFEC1337)),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF2a1619),
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchShowtimes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC1337),
                ),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2a1619),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lịch chiếu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CinemaShowtimeListScreen(
                        movieId: widget.movieId,
                        movieTitle: widget.movieTitle,
                        movieInfo: _getMovieInfo(),
                        moviePoster: widget.moviePoster,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: const [
                    Text(
                      'Xem tất cả',
                      style: TextStyle(
                        color: Color(0xFFEC1337),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, color: Color(0xFFEC1337), size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date Picker
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_dates.length, (i) {
                final selected = _selectedDateIndex == i;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedDateIndex = i);
                    _fetchShowtimes();
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFEC1337)
                          : const Color(0xFF221013),
                      borderRadius: BorderRadius.circular(12),
                      border: selected
                          ? null
                          : Border.all(color: Colors.grey.shade700),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFEC1337).withOpacity(0.3),
                                blurRadius: 12,
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dates[i]['day']!,
                          style: TextStyle(
                            color: selected
                                ? Colors.white70
                                : Colors.grey.shade400,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _dates[i]['date']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 24),

          // Cinema & Times
          if (_showtimeData == null || _showtimeData!.cinemas.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Không có suất chiếu nào',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ..._showtimeData!.cinemas.take(2).map((cinema) {
              final showtimes = cinema.showtimes.take(6).toList();
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (cinema.bannerUrl != null)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Image.network(
                              cinema.bannerUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.local_movies, size: 16),
                            ),
                          )
                        else
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.local_movies,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cinema.cinemaName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (cinema.city != null)
                          Text(
                            cinema.city ?? '',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: showtimes.map((showtime) {
                        final time = DateFormat('HH:mm')
                            .format(showtime.startTime.toLocal());
                        final date = DateFormat('dd/MM/yyyy')
                            .format(showtime.startTime.toLocal());
                        
                        return GestureDetector(
                          onTap: showtime.isActive
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SeatSelectionScreen(
                                        screenId: showtime.screenId,
                                        showtimeId: showtime.id,
                                        movieTitle: widget.movieTitle,
                                        moviePoster: widget.moviePoster,
                                        cinemaName: cinema.cinemaName,
                                        showtime: time,
                                        date: date,
                                        basePrice: showtime.basePrice,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: showtime.isActive
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade900,
                              border: Border.all(
                                color: showtime.isActive
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade800,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              time,
                              style: TextStyle(
                                color: showtime.isActive
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }).toList(),
          
          // Add bottom padding for scrolling
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
