import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import '../models/cinema.dart';
import '../models/cinema_movies_with_showtimes_response.dart';
import '../services/cinema_service.dart';
import '../widgets/cinema_detail/cinema_detail_header.dart';
import '../widgets/cinema_detail/cinema_info_card.dart';
import '../widgets/cinema_detail/cinema_date_selector.dart';
import '../widgets/cinema_detail/cinema_movie_showtime_item.dart';
import '../utils/movie_category_parser.dart';
import '../utils/distance_utils.dart';

class CinemaDetailScreen extends StatefulWidget {
  final Cinema cinema;

  const CinemaDetailScreen({super.key, required this.cinema});

  @override
  State<CinemaDetailScreen> createState() => _CinemaDetailScreenState();
}

class _CinemaDetailScreenState extends State<CinemaDetailScreen> {
  int selectedDateIndex = 0;
  List<DateTime> availableDates = [];

  bool isLoading = true;
  String? errorMessage;
  CinemaMoviesWithShowtimesResponse? cinemaData;
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    _generateDates();
    _getUserLocation();
    _loadMoviesWithShowtimes();
  }

  /// Generate today + next 6 days
  void _generateDates() {
    final now = DateTime.now();
    availableDates = List.generate(
      7,
      (index) =>
          DateTime(now.year, now.month, now.day).add(Duration(days: index)),
    );
  }

  /// Get user location for distance calculation
  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userPosition = position;
      });
    } catch (e) {
      // Silently fail - distance will show as '--'
    }
  }

  /// Calculate distance in km
  String _getDistanceString() {
    return formatDistance(
      userPosition: _userPosition,
      targetLatitude: widget.cinema.latitude,
      targetLongitude: widget.cinema.longitude,
    );
  }

  /// Fetch movies with showtimes for selected date
  Future<void> _loadMoviesWithShowtimes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final selectedDate = availableDates[selectedDateIndex];
      final data = await CinemaService.getMoviesWithShowtimesByDate(
        widget.cinema.id,
        selectedDate,
      );

      setState(() {
        cinemaData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate date items for UI
    final dates = availableDates.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value;

      String dayOfWeek;
      if (date.weekday == 7) {
        dayOfWeek = 'CN';
      } else {
        dayOfWeek = 'Th ${date.weekday + 1}';
      }

      return DateItem(
        dayOfWeek: dayOfWeek,
        date: date.day.toString(),
        isSelected: selectedDateIndex == index,
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            CinemaDetailHeader(
              cinemaName: widget.cinema.name,
              onSearchPressed: () {
                // Handle search
              },
            ),
            // Cinema info
            CinemaInfoCard(
              address: widget.cinema.address ?? 'Chưa có địa chỉ',
              distance: _getDistanceString(),
              openingHours: 'Đang mở cửa',
              onMapPressed: () {
                // Handle map navigation
              },
            ),
            // Date selector
            CinemaDateSelector(
              dates: dates,
              onDateSelected: (index) {
                setState(() {
                  selectedDateIndex = index;
                });
                _loadMoviesWithShowtimes();
              },
            ),
            // Movie list with showtimes
            Expanded(child: _buildMovieList()),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFec1337)),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Không thể tải dữ liệu',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadMoviesWithShowtimes,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFec1337),
              ),
              child: const Text(
                'Thử lại',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (cinemaData == null || cinemaData!.movies.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, color: Colors.white38, size: 60),
            SizedBox(height: 16),
            Text(
              'Không có suất chiếu nào',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Vui lòng chọn ngày khác',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cinemaData!.movies.length,
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        final movieWithShowtimes = cinemaData!.movies[index];
        final movie = movieWithShowtimes.movie;
        final showtimes = movieWithShowtimes.showtimes;

        // Convert showtimes to ShowtimeSlotData
        final showtimeSlots = showtimes.map((showtime) {
          final timeStr = DateFormat(
            'HH:mm',
          ).format(showtime.startTime.toLocal());
          final priceStr = '${showtime.basePrice.toInt()}đ';

          return ShowtimeSlotData(
            time: timeStr,
            price: priceStr,
            isVIP: false,
            isSoldOut: !showtime.isActive,
          );
        }).toList();

        // Format duration
        final hours = movie.durationMinutes ~/ 60;
        final minutes = movie.durationMinutes % 60;
        final durationStr = '${hours}h ${minutes}p';

        // Get rating and review count from database
        final rating = movie.averageRating ?? 0.0;
        final reviewCount = movie.totalReviews != null
            ? '${movie.totalReviews} đánh giá'
            : 'Chưa có đánh giá';

        return CinemaMovieShowtimeItem(
          posterUrl: movie.posterUrl ?? 'https://via.placeholder.com/192x288',
          title: movie.title,
          duration: durationStr,
          rating: rating,
          reviewCount: reviewCount,
          formatLabel: '2D Phụ đề',
          ageLimit: movie.ageLimit,
          category: movie.category.name,
          releaseDate: movie.releaseDate,
          showtimes: showtimeSlots,
          onShowtimeSelected: (time) {
            // TODO: Navigate to seat selection
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã chọn suất chiếu: $time - ${movie.title}'),
                backgroundColor: const Color(0xFFec1337),
              ),
            );
          },
        );
      },
    );
  }
}
