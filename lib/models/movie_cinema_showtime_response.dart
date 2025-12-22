import 'showtime.dart';

class MovieCinemaShowtimeResponse {
  final String movieId;
  final String movieTitle;
  final String? posterUrl;
  final List<CinemaWithShowtimes> cinemas;

  MovieCinemaShowtimeResponse({
    required this.movieId,
    required this.movieTitle,
    this.posterUrl,
    required this.cinemas,
  });

  factory MovieCinemaShowtimeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return MovieCinemaShowtimeResponse(
      movieId: data['movieId'] as String,
      movieTitle: data['movieTitle'] as String,
      posterUrl: data['posterUrl'] as String?,
      cinemas: (data['cinemas'] as List<dynamic>)
          .map((e) => CinemaWithShowtimes.fromJson(e))
          .toList(),
    );
  }
}

class CinemaWithShowtimes {
  final String cinemaId;
  final String cinemaName;
  final String slug;
  final String? address;
  final String? city;
  final String? phone;
  final String? bannerUrl;
  final int totalScreens;
  final double? latitude;
  final double? longitude;
  final List<Showtime> showtimes;

  CinemaWithShowtimes({
    required this.cinemaId,
    required this.cinemaName,
    required this.slug,
    this.address,
    this.city,
    this.phone,
    this.bannerUrl,
    required this.totalScreens,
    this.latitude,
    this.longitude,
    required this.showtimes,
  });

  factory CinemaWithShowtimes.fromJson(Map<String, dynamic> json) {
    return CinemaWithShowtimes(
      cinemaId: json['cinemaId'] as String,
      cinemaName: json['cinemaName'] as String,
      slug: json['slug'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
      phone: json['phone'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      totalScreens: json['totalScreens'] as int,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      showtimes: (json['showtimes'] as List<dynamic>)
          .map((e) => Showtime.fromJson(e))
          .toList(),
    );
  }
}
