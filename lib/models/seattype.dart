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
}
