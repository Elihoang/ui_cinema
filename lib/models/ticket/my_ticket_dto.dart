import 'package:fe_cinema_mobile/enums/movie_category.dart';

/// DTO tối ưu cho danh sách vé từ API /my-tickets
class MyTicketDto {
  final String id;
  final String ticketCode;
  final String? qrData;
  final bool isUsed;
  final DateTime? usedAt;
  final DateTime createdAt;

  // Movie info
  final String movieTitle;
  final String? moviePosterUrl;
  final int movieDurationMinutes;
  final String? movieCategory;
  final int? movieAgeLimit;

  // Showtime info
  final DateTime showtimeStart;
  final DateTime? showtimeEnd;

  // Cinema & Screen info
  final String cinemaName;
  final String? cinemaAddress;
  final String screenName;

  // Seat info
  final String seatCode;
  final String? seatType;

  MyTicketDto({
    required this.id,
    required this.ticketCode,
    this.qrData,
    required this.isUsed,
    this.usedAt,
    required this.createdAt,
    required this.movieTitle,
    this.moviePosterUrl,
    required this.movieDurationMinutes,
    this.movieCategory,
    this.movieAgeLimit,
    required this.showtimeStart,
    this.showtimeEnd,
    required this.cinemaName,
    this.cinemaAddress,
    required this.screenName,
    required this.seatCode,
    this.seatType,
  });

  factory MyTicketDto.fromJson(Map<String, dynamic> json) {
    return MyTicketDto(
      id: json['id'] as String,
      ticketCode: json['ticketCode'] as String,
      qrData: json['qrData'] as String?,
      isUsed: json['isUsed'] as bool? ?? false,
      usedAt: json['usedAt'] != null
          ? DateTime.parse(json['usedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      movieTitle: json['movieTitle'] as String? ?? 'Không xác định',
      moviePosterUrl: json['moviePosterUrl'] as String?,
      movieDurationMinutes: json['movieDurationMinutes'] as int? ?? 0,
      movieCategory: json['movieCategory'] as String?,
      movieAgeLimit: json['movieAgeLimit'] as int?,
      showtimeStart: DateTime.parse(json['showtimeStart'] as String),
      showtimeEnd: json['showtimeEnd'] != null
          ? DateTime.parse(json['showtimeEnd'] as String)
          : null,
      cinemaName: json['cinemaName'] as String? ?? 'Không xác định',
      cinemaAddress: json['cinemaAddress'] as String?,
      screenName: json['screenName'] as String? ?? 'Không xác định',
      seatCode: json['seatCode'] as String? ?? 'N/A',
      seatType: json['seatType'] as String?,
    );
  }

  // ======================= Helper hiển thị =======================

  String get timeDisplay =>
      '${showtimeStart.hour.toString().padLeft(2, '0')}:${showtimeStart.minute.toString().padLeft(2, '0')}';

  String get dateDisplay =>
      '${showtimeStart.day.toString().padLeft(2, '0')}/${showtimeStart.month.toString().padLeft(2, '0')}/${showtimeStart.year}';

  String get relativeDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final ticketDay = DateTime(
      showtimeStart.year,
      showtimeStart.month,
      showtimeStart.day,
    );

    if (ticketDay == today) return 'Hôm nay';
    if (ticketDay == tomorrow) return 'Ngày mai';
    if (ticketDay.isBefore(today)) return 'Đã qua';
    return dateDisplay;
  }

  bool get isUpcoming => !isUsed && showtimeStart.isAfter(DateTime.now());

  /// QR data để quét - sử dụng ticketCode
  String get qrDataForScan => ticketCode;

  MovieCategory get category {
    if (movieCategory == null) return MovieCategory.action;
    return MovieCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == movieCategory!.toLowerCase(),
      orElse: () => MovieCategory.action,
    );
  }
}
