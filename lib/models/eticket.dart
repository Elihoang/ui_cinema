import 'package:fe_cinema_mobile/enums/movie_category.dart';

import 'cinema.dart';
import 'movie.dart';

enum ETicketStatus { upcoming, history }

class ETicket {
  final String id;
  final String orderTicketId;
  final String ticketCode;
  final String? qrData;
  final bool isUsed;
  final DateTime? usedAt;
  final DateTime createdAt;

  // Nested data từ orderTicket
  final Movie movie;
  final Cinema cinema;
  final String screenName;
  final String seatCode;
  final DateTime showtime;

  ETicket({
    required this.id,
    required this.orderTicketId,
    required this.ticketCode,
    this.qrData,
    required this.isUsed,
    this.usedAt,
    required this.createdAt,
    required this.movie,
    required this.cinema,
    required this.screenName,
    required this.seatCode,
    required this.showtime,
  });

  factory ETicket.fromJson(Map<String, dynamic> json) {
    // Lấy data từ các nguồn khác nhau
    final orderTicket = json['orderTicket'] as Map<String, dynamic>?;
    final showtimeJson = orderTicket?['showtime'] as Map<String, dynamic>?;
    final movieJson = showtimeJson?['movie'] as Map<String, dynamic>?;
    
    // Cinema, screen, seat có thể ở top level (từ API detail) hoặc nested
    final cinemaJson = json['cinema'] as Map<String, dynamic>? 
        ?? showtimeJson?['screen']?['cinema'] as Map<String, dynamic>?;
    final screenJson = json['screen'] as Map<String, dynamic>? 
        ?? showtimeJson?['screen'] as Map<String, dynamic>?;
    final seatJson = json['seat'] as Map<String, dynamic>? 
        ?? orderTicket?['seat'] as Map<String, dynamic>?;

    // Parse startTime safely to avoid null cast errors
    final startTimeStr = showtimeJson?['startTime'] as String?;
    final parsedShowtime = startTimeStr != null
      ? DateTime.parse(startTimeStr)
      : DateTime.now();

    return ETicket(
      id: (json['id'] ?? '').toString(),
      orderTicketId: (json['orderTicketId'] ?? '').toString(),
      ticketCode: (json['ticketCode'] ?? '').toString(),
      qrData: json['qrData'] as String? ?? '',
      isUsed: json['isUsed'] as bool? ?? false,
      usedAt: json['usedAt'] != null
        ? DateTime.parse(json['usedAt'] as String)
        : null,
      createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now(),
      
      // Nested objects
      movie: movieJson != null
          ? Movie.fromJson(movieJson)
          : Movie(
              id: 'unknown',
              title: 'Phim không xác định',
              slug: 'unknown',
              durationMinutes: 0,
              releaseDate: DateTime.now(),
              category: MovieCategory.action,
              ageLimit: 0,
            ),
      cinema: cinemaJson != null
          ? _parseCinema(cinemaJson)
          : Cinema(
              id: 'unknown',
              name: 'Rạp không xác định',
              slug: 'unknown',
              totalScreens: 0,
              isActive: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              currentlyShowingMovies: const [],
            ),
      screenName: screenJson?['name'] as String? ?? 'Không xác định',
      seatCode: seatJson?['seatCode'] as String? ?? 'N/A',
      showtime: parsedShowtime,
    );
  }

  // Helper để parse Cinema an toàn (xử lý cả data đầy đủ và data rút gọn)
  static Cinema _parseCinema(Map<String, dynamic> json) {
    return Cinema(
      id: (json['id'] ?? 'unknown').toString(),
      name: (json['name'] ?? 'Rạp không xác định').toString(),
      slug: json['slug'] as String? ?? 'unknown',
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      bannerUrl: json['bannerUrl'] as String?,
      totalScreens: json['totalScreens'] as int? ?? 0,
      facilities: (json['facilities'] as List<dynamic>?)?.cast<String>(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      currentlyShowingMovies: const [],
    );
  }

  // ======================= Helper hiển thị =======================

  String get timeDisplay =>
      '${showtime.hour.toString().padLeft(2, '0')}:${showtime.minute.toString().padLeft(2, '0')}';

  String get dateDisplay =>
      '${showtime.day.toString().padLeft(2, '0')}/${showtime.month.toString().padLeft(2, '0')}/${showtime.year}';

  String get relativeDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final ticketDay = DateTime(showtime.year, showtime.month, showtime.day);

    if (ticketDay == today) return 'Hôm nay';
    if (ticketDay == tomorrow) return 'Ngày mai';
    if (ticketDay.isBefore(today)) return 'Đã qua';
    return dateDisplay;
  }

  ETicketStatus get status =>
      isUsed || showtime.isBefore(DateTime.now())
          ? ETicketStatus.history
          : ETicketStatus.upcoming;

  /// QR data để quét - sử dụng ticketCode
  String get qrDataForScan => ticketCode;
}
