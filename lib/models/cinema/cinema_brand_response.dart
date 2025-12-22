import '../cinema.dart';

class CinemaBrandResponse {
  final String brandName;
  final String? phone;
  final int totalCinemas;
  final List<Cinema> cinemas;

  CinemaBrandResponse({
    required this.brandName,
    this.phone,
    required this.totalCinemas,
    required this.cinemas,
  });

  factory CinemaBrandResponse.fromJson(Map<String, dynamic> json) {
    return CinemaBrandResponse(
      brandName: json['brandName'] as String,
      phone: json['phone'] as String?,
      totalCinemas: json['totalCinemas'] as int,
      cinemas: (json['cinemas'] as List<dynamic>? ?? [])
          .map((e) => Cinema.fromJson(e))
          .toList(),
    );
  }
}
