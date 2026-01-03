class User {
  final String id;
  final String name;
  final String avatar;
  final String membershipLevel;
  final int watchedCount;
  final int rewardPoints;
  final int voucherCount;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    this.membershipLevel = 'THÀNH VIÊN VÀNG',
    this.watchedCount = 0,
    this.rewardPoints = 0,
    this.voucherCount = 0,
  });
}

class Ticket {
  final String id;
  final String movieTitle;
  final String moviePoster;
  final String format;
  final String audioType;
  final String time;
  final String date;
  final String cinema;
  final String seats;

  Ticket({
    required this.id,
    required this.movieTitle,
    required this.moviePoster,
    required this.format,
    required this.audioType,
    required this.time,
    required this.date,
    required this.cinema,
    required this.seats,
  });
}
