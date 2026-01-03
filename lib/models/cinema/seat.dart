/// Represents a seat in a cinema screen
/// Handles responses from both:
/// - Seats API (SeatResponseDto): includes screenId, qrOrderingCode, isActive
/// - Showtimes API (SeatWithStatusDto): includes status, price, heldByUserId
class Seat {
  final String id;
  final String? screenId; // Nullable - only from Seats API
  final String seatRow;
  final int seatNumber;
  final String seatCode;
  final String? seatTypeCode;
  final String? qrOrderingCode; // Nullable - only from Seats API
  final bool isActive; // From Seats API, default true for Showtimes API

  // Additional fields from showtime seats endpoint
  final int?
  status; // 0 = Available, 1 = Sold, 2 = Holding (from SeatStatus enum)
  final double? price;
  final String? heldByUserId;

  Seat({
    required this.id,
    this.screenId,
    required this.seatRow,
    required this.seatNumber,
    required this.seatCode,
    this.seatTypeCode,
    this.qrOrderingCode,
    this.isActive = true, // Default to true
    this.status,
    this.price,
    this.heldByUserId,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'] as String,
      screenId: json['screenId'] as String?,
      seatRow: json['seatRow'] as String,
      seatNumber: json['seatNumber'] as int,
      seatCode: json['seatCode'] as String,
      seatTypeCode: json['seatTypeCode'] as String?,
      qrOrderingCode: json['qrOrderingCode'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      status: json['status'] as int?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      heldByUserId: json['heldByUserId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (screenId != null) 'screenId': screenId,
      'seatRow': seatRow,
      'seatNumber': seatNumber,
      'seatCode': seatCode,
      'seatTypeCode': seatTypeCode,
      if (qrOrderingCode != null) 'qrOrderingCode': qrOrderingCode,
      'isActive': isActive,
      'status': status,
      'price': price,
      'heldByUserId': heldByUserId,
    };
  }

  /// Check if this seat is booked (Sold or Holding)
  /// Backend SeatStatus enum: 0 = Available, 1 = Sold, 2 = Holding
  bool get isBooked => status != null && status != 0;

  /// Check if this seat is available for selection
  /// Must be active AND available (not sold or held)
  bool get isAvailable => isActive && (status == null || status == 0);
}
