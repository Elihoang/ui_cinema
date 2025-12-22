import 'movie_with_showtimes.dart';

class CinemaMoviesWithShowtimesResponse {
  final String cinemaId;
  final String cinemaName;
  final String slug;
  final List<MovieWithShowtimes> movies;

  CinemaMoviesWithShowtimesResponse({
    required this.cinemaId,
    required this.cinemaName,
    required this.slug,
    required this.movies,
  });

  factory CinemaMoviesWithShowtimesResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];

    return CinemaMoviesWithShowtimesResponse(
      cinemaId: data['cinemaId'],
      cinemaName: data['cinemaName'],
      slug: data['slug'],
      movies: (data['movies'] as List<dynamic>)
          .map((e) => MovieWithShowtimes.fromJson(e))
          .toList(),
    );
  }
}
