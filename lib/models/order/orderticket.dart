class OrderTicket {
  final String id;
  final String orderId;
  final String showtimeId;
  final String seatId;
  final double price;

  OrderTicket({
    required this.id,
    required this.orderId,
    required this.showtimeId,
    required this.seatId,
    required this.price,
  });

  factory OrderTicket.fromJson(Map<String, dynamic> json) {
    return OrderTicket(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      showtimeId: json['showtimeId'] as String,
      seatId: json['seatId'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}
