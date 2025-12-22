import 'package:flutter/material.dart';
import '../widgets/cinemalist/cinema_header.dart';
import '../widgets/cinemalist/cinema_search_bar.dart';
import '../widgets/cinemalist/cinema_filter_chips.dart';
import '../widgets/cinemalist/cinema_card.dart';
import '../models/cinema.dart';
import '../services/cinema_service.dart';
import 'package:geolocator/geolocator.dart';

class CinemaListScreen extends StatefulWidget {
  final VoidCallback? onNavigateToHome;
  const CinemaListScreen({super.key, this.onNavigateToHome});

  @override
  State<CinemaListScreen> createState() => _CinemaListScreenState();
}

class _CinemaListScreenState extends State<CinemaListScreen> {
  List<Cinema> cinemas = [];
  List<Cinema> filteredCinemas = [];
  bool isLoading = true;
  String? errorMessage;
  Position? _userPosition;

  String _currentSearchQuery = '';
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    loadCinemas();
  }

  Future<void> loadCinemas() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetched = await CinemaService.fetchCinemasWithMovies();
      setState(() {
        cinemas = fetched;
        filteredCinemas = fetched;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void onSearchChanged(String query) {
    _currentSearchQuery = query.trim();
    applySearch(query);
  }

  void applySearch(String query) {
    setState(() {
      if (query.isEmpty) {
        onFilterSelected(_selectedFilterIndex);
      } else {
        final lowerQuery = query.toLowerCase();
        var baseList = cinemas;

        if (_selectedFilterIndex == 1) {
          baseList = cinemas.where((c) => c.city == 'Hồ Chí Minh').toList();
        }

        filteredCinemas = baseList.where((c) {
          return c.name.toLowerCase().contains(lowerQuery) ||
              (c.address?.toLowerCase().contains(lowerQuery) ?? false) ||
              (c.city?.toLowerCase().contains(lowerQuery) ?? false);
        }).toList();
      }
    });
  }

  // HÀM RIÊNG ĐỂ SẮP XẾP THEO KHOẢNG CÁCH GẦN NHẤT
  Future<void> _sortByNearest() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng bật dịch vụ định vị (GPS)')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cần cấp quyền vị trí để dùng tính năng này'),
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Quyền vị trí bị từ chối vĩnh viễn. Vui lòng vào cài đặt để bật',
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userPosition = position;
        filteredCinemas = List.from(cinemas)
          ..sort((a, b) {
            if (a.latitude == null || a.longitude == null) return 1;
            if (b.latitude == null || b.longitude == null) return -1;

            double distA = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              a.latitude!,
              a.longitude!,
            );

            double distB = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              b.latitude!,
              b.longitude!,
            );

            return distA.compareTo(distB);
          });

        isLoading = false;
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Đã sắp xếp theo khoảng cách gần nhất!')),
      // );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi lấy vị trí: $e')));
    }
  }

  void onFilterSelected(int index) {
    setState(() {
      _selectedFilterIndex = index;

      switch (index) {
        case 0: // Tất cả
          filteredCinemas = cinemas;
          break;

        case 1: // Hồ Chí Minh
          filteredCinemas = cinemas
              .where((c) => c.city == 'Hồ Chí Minh')
              .toList();
          break;

        case 2: // Gần nhất
          _sortByNearest(); // Gọi hàm async riêng
          return; // Không setState ở đây vì đã set trong _sortByNearest

        case 3: // Đánh giá cao
          filteredCinemas = List.from(cinemas);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tính năng "Đánh giá cao" sắp ra mắt!'),
            ),
          );
          break;

        default:
          filteredCinemas = cinemas;
      }

      // Áp dụng lại search nếu đang có query
      if (_currentSearchQuery.isNotEmpty) {
        applySearch(_currentSearchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      body: Column(
        children: [
          CinemaHeader(
            onBackPressed: () => Navigator.pop(context),
            onMapPressed: () {},
            onNavigateToHome: widget.onNavigateToHome,
          ),
          CinemaSearchBar(onSearchChanged: onSearchChanged),
          CinemaFilterChips(onFilterSelected: onFilterSelected),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFec1337)),
                  )
                : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        const Text(
                          'Lỗi kết nối',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: loadCinemas,
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
                  )
                : filteredCinemas.isEmpty
                ? const Center(
                    child: Text(
                      'Không tìm thấy rạp nào',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filteredCinemas.length,
                    itemBuilder: (context, index) {
                      final cinema = filteredCinemas[index];
                      final hasMovies =
                          cinema.currentlyShowingMovies.isNotEmpty;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CinemaCard(
                          cinema: cinema,
                          isAvailable: cinema.isActive,
                          userPosition: _userPosition,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
