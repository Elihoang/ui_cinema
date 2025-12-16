class ETicket {
  final String id;
  final String orderTicketId;
  final String ticketCode;
  final String? qrData;
  final bool isUsed;
  final DateTime? usedAt;

  ETicket({
    required this.id,
    required this.orderTicketId,
    required this.ticketCode,
    this.qrData,
    required this.isUsed,
    this.usedAt,
  });

  factory ETicket.fromJson(Map<String, dynamic> json) {
    return ETicket(
      id: json['id'] as String,
      orderTicketId: json['orderTicketId'] as String,
      ticketCode: json['ticketCode'] as String,
      qrData: json['qrData'] as String?,
      isUsed: json['isUsed'] as bool,
      usedAt: json['usedAt'] != null
          ? DateTime.parse(json['usedAt'] as String)
          : null,
    );
  }
}
