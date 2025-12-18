import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import '../models/movie_cinema_showtime_response.dart';
import '../services/movie_service.dart';
import '../services/cinema_service.dart';
import '../utils/distance_utils.dart';
import '../widgets/cinema_showtime/movie_showtime_header.dart';
import '../widgets/cinema_showtime/date_selector_strip.dart';
import '../widgets/cinema_showtime/cinema_brand_selector.dart';
import '../widgets/cinema_showtime/showtime_filter_chips.dart';
import '../widgets/cinema_showtime/cinema_showtime_card_widget.dart';
import '../widgets/cinema_showtime/showtime_format_section.dart';

class CinemaShowtimeListScreen extends StatefulWidget {
  final String movieId;
  final String movieTitle;
  final String movieInfo;

  const CinemaShowtimeListScreen({
    super.key,
    required this.movieId,
    required this.movieTitle,
    required this.movieInfo,
  });

  @override
  State<CinemaShowtimeListScreen> createState() =>
      _CinemaShowtimeListScreenState();
}

class _CinemaShowtimeListScreenState extends State<CinemaShowtimeListScreen> {
  int selectedDateIndex = 0;
  int selectedBrandIndex = 0;
  List<int> selectedFilterIndices = [0];

  MovieCinemaShowtimeResponse? _showtimeData;
  bool _isLoading = false;
  String? _errorMessage;

  // Generate dates for the next 7 days
  late List<DateItem> dates;
  late List<DateTime> dateObjects;
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    _generateDates();
    _fetchBrands();
    _getUserLocation();
    _fetchShowtimes();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userPosition = position;
      });
    } catch (e) {
      print('Error getting location: $e');
      // Silently fail - distance will show as '--'
    }
  }

  void _generateDates() {
    dates = [];
    dateObjects = [];
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      dateObjects.add(date);

      // Format day of week in Vietnamese
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

      dates.add(DateItem(dayOfWeek: dayOfWeek, dayNumber: date.day.toString()));
    }
  }

  Future<void> _fetchShowtimes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Format date as YYYY-MM-DD
      final selectedDate = dateObjects[selectedDateIndex];
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

      final response = await MovieService.fetchCinemaShowtimesByMovie(
        widget.movieId,
        dateStr,
      );

      setState(() {
        _showtimeData = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  List<CinemaBrand> brands = [];

  Future<void> _fetchBrands() async {
    try {
      final brandResponses = await CinemaService.fetchCinemaBrands();

      setState(() {
        brands = [
          CinemaBrand(name: 'Đề xuất', icon: Icons.star, isFeatured: true),
        ];

        // Add brands from API
        for (var brandResponse in brandResponses) {
          // Get first cinema's banner as brand image
          String? bannerUrl;
          if (brandResponse.cinemas.isNotEmpty) {
            bannerUrl = brandResponse.cinemas.first.bannerUrl;
          }

          brands.add(
            CinemaBrand(name: brandResponse.brandName, imageUrl: bannerUrl),
          );
        }
      });
    } catch (e) {
      print('Error fetching brands: $e');
      // Fallback to default brands
      setState(() {
        brands = [
          CinemaBrand(name: 'Đề xuất', icon: Icons.star, isFeatured: true),
        ];
      });
    }
  }

  final List<ShowtimeFilter> filters = [
    ShowtimeFilter(icon: Icons.location_on, label: 'Gần bạn nhất'),
  ];

  // Group showtimes by format and audio type
  List<ShowtimeFormat> _getFormatsForCinema(CinemaWithShowtimes cinema) {
    // For now, we'll create a simple 2D format with all showtimes
    // You can enhance this logic to group by actual format/audio type if available
    if (cinema.showtimes.isEmpty) {
      return [];
    }

    final showtimeSlots = cinema.showtimes.map((showtime) {
      final time = DateFormat('HH:mm').format(showtime.startTime.toLocal());
      final price = '${(showtime.basePrice / 1000).toStringAsFixed(0)}k';

      return ShowtimeSlot(
        time: time,
        price: price,
        isVip: showtime.basePrice > 100000,
      );
    }).toList();

    return [
      ShowtimeFormat(
        format: '2D',
        audioType: 'Phụ Đề',
        showtimes: showtimeSlots,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      body: SafeArea(
        child: Column(
          children: [
            // Sticky header area
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF221013).withOpacity(0.95),
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
              ),
              child: Column(
                children: [
                  MovieShowtimeHeader(
                    movieTitle: widget.movieTitle,
                    movieInfo: widget.movieInfo,
                  ),
                  DateSelectorStrip(
                    dates: dates,
                    selectedIndex: selectedDateIndex,
                    onDateSelected: (index) {
                      setState(() {
                        selectedDateIndex = index;
                      });
                      _fetchShowtimes();
                    },
                  ),
                  SafeArea(
                    bottom: false,
                    child: CinemaBrandSelector(
                      brands: brands,
                      selectedIndex: selectedBrandIndex,
                      onBrandSelected: (index) {
                        setState(() {
                          selectedBrandIndex = index;
                        });
                      },
                    ),
                  ),
                  ShowtimeFilterChips(
                    filters: filters,
                    selectedIndices: selectedFilterIndices,
                    onFilterToggled: (index) {
                      setState(() {
                        if (selectedFilterIndices.contains(index)) {
                          selectedFilterIndices.remove(index);
                        } else {
                          selectedFilterIndices.add(index);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            // Scrollable content
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFEC1337)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.grey.shade400, size: 64),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchShowtimes,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC1337),
                foregroundColor: Colors.white,
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_showtimeData == null || _showtimeData!.cinemas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, color: Colors.grey.shade400, size: 64),
            const SizedBox(height: 16),
            Text(
              'Không có suất chiếu nào',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Filter cinemas by selected brand
    List<CinemaWithShowtimes> filteredCinemas = _showtimeData!.cinemas;
    if (selectedBrandIndex > 0) {
      final selectedBrand = brands[selectedBrandIndex].name.toLowerCase();
      filteredCinemas = _showtimeData!.cinemas.where((cinema) {
        return cinema.cinemaName.toLowerCase().contains(selectedBrand);
      }).toList();
    }

    if (filteredCinemas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, color: Colors.grey.shade400, size: 64),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy rạp phù hợp',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredCinemas.length,
      itemBuilder: (context, index) {
        final cinema = filteredCinemas[index];
        final formats = _getFormatsForCinema(cinema);

        if (formats.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CinemaShowtimeCardWidget(
            cinemaName: cinema.cinemaName,
            address: cinema.address ?? 'Không có địa chỉ',
            distance: formatDistance(
              userPosition: _userPosition,
              targetLatitude: cinema.latitude,
              targetLongitude: cinema.longitude,
            ),
            bannerUrl: cinema.bannerUrl,
            formats: formats,
            onMapTap: () {
              // TODO: Handle map tap
            },
            onShowtimeSelected: (showtime) {
              // TODO: Handle showtime selection
              print('Selected: ${showtime.time}');
            },
          ),
        );
      },
    );
  }
}
