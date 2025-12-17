import 'package:flutter/material.dart';
import '../widgets/cinema_showtime/movie_showtime_header.dart';
import '../widgets/cinema_showtime/date_selector_strip.dart';
import '../widgets/cinema_showtime/cinema_brand_selector.dart';
import '../widgets/cinema_showtime/showtime_filter_chips.dart';
import '../widgets/cinema_showtime/cinema_showtime_card_widget.dart';
import '../widgets/cinema_showtime/showtime_format_section.dart';

class CinemaShowtimeListScreen extends StatefulWidget {
  final String movieTitle;
  final String movieInfo;

  const CinemaShowtimeListScreen({
    super.key,
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

  // Sample data
  final List<DateItem> dates = [
    DateItem(dayOfWeek: 'T6', dayNumber: '20'),
    DateItem(dayOfWeek: 'T7', dayNumber: '21'),
    DateItem(dayOfWeek: 'CN', dayNumber: '22'),
    DateItem(dayOfWeek: 'T2', dayNumber: '23'),
    DateItem(dayOfWeek: 'T3', dayNumber: '24'),
    DateItem(dayOfWeek: 'T4', dayNumber: '25'),
    DateItem(dayOfWeek: 'T5', dayNumber: '26'),
  ];

  final List<CinemaBrand> brands = [
    CinemaBrand(name: 'Đề xuất', icon: Icons.star, isFeatured: true),
    CinemaBrand(name: 'CGV', icon: Icons.movie),
    CinemaBrand(name: 'Lotte', icon: Icons.movie),
    CinemaBrand(name: 'Galaxy', icon: Icons.movie),
    CinemaBrand(name: 'BHD', icon: Icons.movie),
  ];

  final List<ShowtimeFilter> filters = [
    ShowtimeFilter(icon: Icons.location_on, label: 'Gần bạn nhất'),
    ShowtimeFilter(icon: Icons.payments, label: 'Giá vé'),
    ShowtimeFilter(icon: Icons.schedule, label: 'Suất chiếu sớm'),
  ];

  List<ShowtimeFormat> getCinema1Formats() {
    return [
      ShowtimeFormat(
        format: '2D',
        audioType: 'Phụ Đề',
        showtimes: [
          ShowtimeSlot(time: '18:00', price: '145k'),
          ShowtimeSlot(time: '19:30', price: '160k'),
          ShowtimeSlot(time: '21:45', price: '145k'),
        ],
      ),
      ShowtimeFormat(
        format: 'IMAX 3D',
        audioType: 'Lồng Tiếng',
        isSpecialFormat: true,
        showtimes: [ShowtimeSlot(time: '20:15', price: '220k', isVip: true)],
      ),
    ];
  }

  List<ShowtimeFormat> getCinema2Formats() {
    return [
      ShowtimeFormat(
        format: '2D',
        audioType: 'Lồng Tiếng',
        showtimes: [
          ShowtimeSlot(time: '17:45', price: '0đ', isSoldOut: true),
          ShowtimeSlot(time: '19:15', price: '110k'),
          ShowtimeSlot(time: '21:00', price: '100k'),
        ],
      ),
    ];
  }

  List<ShowtimeFormat> getCinema3Formats() {
    return [
      ShowtimeFormat(
        format: '2D',
        audioType: 'Phụ Đề',
        showtimes: [
          ShowtimeSlot(time: '20:00', price: '120k'),
          ShowtimeSlot(time: '22:30', price: '110k'),
        ],
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
                    },
                  ),
                  CinemaBrandSelector(
                    brands: brands,
                    selectedIndex: selectedBrandIndex,
                    onBrandSelected: (index) {
                      setState(() {
                        selectedBrandIndex = index;
                      });
                    },
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  CinemaShowtimeCardWidget(
                    cinemaName: 'CGV Vincom Center',
                    address: '72 Lê Thánh Tôn, Bến Nghé, Q.1',
                    distance: '1.2km',
                    formats: getCinema1Formats(),
                    onMapTap: () {
                      // Handle map tap
                    },
                    onShowtimeSelected: (showtime) {
                      // Handle showtime selection
                      print('Selected: ${showtime.time}');
                    },
                  ),
                  CinemaShowtimeCardWidget(
                    cinemaName: 'Galaxy Nguyễn Du',
                    address: '116 Nguyễn Du, Bến Thành, Q.1',
                    distance: '2.4km',
                    formats: getCinema2Formats(),
                    onMapTap: () {
                      // Handle map tap
                    },
                    onShowtimeSelected: (showtime) {
                      // Handle showtime selection
                      print('Selected: ${showtime.time}');
                    },
                  ),
                  CinemaShowtimeCardWidget(
                    cinemaName: 'Lotte Cinema Nowzone',
                    address: '235 Nguyễn Văn Cừ, Q.1',
                    distance: '3.0km',
                    formats: getCinema3Formats(),
                    onMapTap: () {
                      // Handle map tap
                    },
                    onShowtimeSelected: (showtime) {
                      // Handle showtime selection
                      print('Selected: ${showtime.time}');
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
