/// Represents a seat type with associated surcharge rate
/// Matches BE_CinePass.Shared.DTOs.SeatType.SeatTypeResponseDto
class SeatType {
  final String code;
  final String? name;
  final double surchargeRate;

  SeatType({required this.code, this.name, required this.surchargeRate});

  factory SeatType.fromJson(Map<String, dynamic> json) {
    return SeatType(
      code: json['code'] as String,
      name: json['name'] as String?,
      surchargeRate: (json['surchargeRate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'surchargeRate': surchargeRate};
  }
}
