// lib/models/my_ticket.dart

import 'package:fe_cinema_mobile/enums/movie_category.dart';

import 'cinema.dart';
import 'movie.dart';

enum MyTicketStatus { upcoming, history }

class MyTicket {
  final String id;                  // ETicket.Id
  final Movie movie;                // từ showtime.movie
  final Cinema cinema;              // từ showtime.screen.cinema
  final String screenName;          // từ showtime.screen.name
  final String seatCode;            // một ghế duy nhất (vì mỗi ETicket là 1 vé riêng)
  final DateTime showtime;          // showtime.startTime
  final String ticketCode;          // ETicket.ticketCode
  final String qrData;              // ETicket.qrData (base64 để generate QR)
  final bool isUsed;                // ETicket.isUsed
  final DateTime? usedAt;           // ETicket.usedAt
  final DateTime createdAt;         // ETicket.createdAt

  const MyTicket({
    required this.id,
    required this.movie,
    required this.cinema,
    required this.screenName,
    required this.seatCode,
    required this.showtime,
    required this.ticketCode,
    required this.qrData,
    this.isUsed = false,
    this.usedAt,
    required this.createdAt,
  });

  factory MyTicket.fromJson(Map<String, dynamic> json) {
    // Lấy nested data an toàn
    final orderTicket = json['orderTicket'] as Map<String, dynamic>?;
    final showtimeJson = orderTicket?['showtime'] as Map<String, dynamic>?;
    final movieJson = showtimeJson?['movie'] as Map<String, dynamic>?;
    final screenJson = showtimeJson?['screen'] as Map<String, dynamic>?;
    final cinemaJson = screenJson?['cinema'] as Map<String, dynamic>?;
    final seatJson = orderTicket?['seat'] as Map<String, dynamic>?;

    final startTimeStr = showtimeJson?['startTime'] as String?;
    final parsedShowtime = startTimeStr != null
      ? DateTime.parse(startTimeStr)
      : DateTime.now();

    return MyTicket(
      id: (json['id'] ?? '').toString(),
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
            ? Cinema.fromJson(cinemaJson)
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

  MyTicketStatus get status =>
      isUsed || showtime.isBefore(DateTime.now())
          ? MyTicketStatus.history
          : MyTicketStatus.upcoming;
}