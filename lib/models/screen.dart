class Screen {
  final String id;
  final String cinemaId;
  final String name;
  final int totalSeats;
  final Map<String, dynamic>? seatMapLayout; // jsonb
  final DateTime createdAt;
  final DateTime updatedAt;

  Screen({
    required this.id,
    required this.cinemaId,
    required this.name,
    required this.totalSeats,
    this.seatMapLayout,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Screen.fromJson(Map<String, dynamic> json) {
    return Screen(
      id: json['id'] as String,
      cinemaId: json['cinemaId'] as String,
      name: json['name'] as String,
      totalSeats: json['totalSeats'] as int,
      seatMapLayout: json['seatMapLayout'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
