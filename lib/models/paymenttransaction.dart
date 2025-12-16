class PaymentTransaction {
  final String id;
  final String? orderId;
  final String? providerTransId;
  final double? amount;
  final String? status;
  final Map<String, dynamic>? responseJson;
  final DateTime createdAt;

  PaymentTransaction({
    required this.id,
    this.orderId,
    this.providerTransId,
    this.amount,
    this.status,
    this.responseJson,
    required this.createdAt,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'] as String,
      orderId: json['orderId'] as String?,
      providerTransId: json['providerTransId'] as String?,
      amount: json['amount'] != null
          ? (json['amount'] as num).toDouble()
          : null,
      status: json['status'] as String?,
      responseJson: json['responseJson'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
