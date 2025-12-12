enum SeatStatus { available, booked, selected }

enum SeatType { standard, vip }

class Seat {
  final String id;
  final String row;
  final int number;
  final SeatStatus status;
  final SeatType type;
  final double price;

  Seat({
    required this.id,
    required this.row,
    required this.number,
    required this.status,
    required this.type,
    required this.price,
  });

  Seat copyWith({
    String? id,
    String? row,
    int? number,
    SeatStatus? status,
    SeatType? type,
    double? price,
  }) {
    return Seat(
      id: id ?? this.id,
      row: row ?? this.row,
      number: number ?? this.number,
      status: status ?? this.status,
      type: type ?? this.type,
      price: price ?? this.price,
    );
  }
}
