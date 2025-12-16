class Showtime {
  final String id;
  final String movieId;
  final String screenId;
  final DateTime startTime;
  final DateTime endTime;
  final double basePrice;
  final bool isActive;

  Showtime({
    required this.id,
    required this.movieId,
    required this.screenId,
    required this.startTime,
    required this.endTime,
    required this.basePrice,
    required this.isActive,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json['id'] as String,
      movieId: json['movieId'] as String,
      screenId: json['screenId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      basePrice: (json['basePrice'] as num).toDouble(),
      isActive: json['isActive'] as bool,
    );
  }
}
