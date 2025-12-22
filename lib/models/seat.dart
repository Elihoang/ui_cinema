/// Represents a seat in a cinema screen
/// Matches BE_CinePass.Shared.DTOs.Seat.SeatResponseDto
class Seat {
  final String id;
  final String screenId;
  final String seatRow;
  final int seatNumber;
  final String seatCode;
  final String? seatTypeCode;
  final String qrOrderingCode;
  final bool isActive;

  Seat({
    required this.id,
    required this.screenId,
    required this.seatRow,
    required this.seatNumber,
    required this.seatCode,
    this.seatTypeCode,
    required this.qrOrderingCode,
    required this.isActive,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'] as String,
      screenId: json['screenId'] as String,
      seatRow: json['seatRow'] as String,
      seatNumber: json['seatNumber'] as int,
      seatCode: json['seatCode'] as String,
      seatTypeCode: json['seatTypeCode'] as String?,
      qrOrderingCode: json['qrOrderingCode'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'screenId': screenId,
      'seatRow': seatRow,
      'seatNumber': seatNumber,
      'seatCode': seatCode,
      'seatTypeCode': seatTypeCode,
      'qrOrderingCode': qrOrderingCode,
      'isActive': isActive,
    };
  }
}
