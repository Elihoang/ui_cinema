class Order {
  final String id;
  final String? userId;
  final double totalAmount;
  final String status; // enum string: Pending, Paid, Cancelled,...
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime? expireAt;

  Order({
    required this.id,
    this.userId,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    required this.createdAt,
    this.expireAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expireAt: json['expireAt'] != null
          ? DateTime.parse(json['expireAt'] as String)
          : null,
    );
  }
}
