import 'movie.dart';
import 'showtime.dart';

class MovieWithShowtimes {
  final Movie movie;
  final List<Showtime> showtimes;

  MovieWithShowtimes({required this.movie, required this.showtimes});

  factory MovieWithShowtimes.fromJson(Map<String, dynamic> json) {
    return MovieWithShowtimes(
      movie: Movie.fromJson(json['movie']),
      showtimes: (json['showtimes'] as List<dynamic>)
          .map((e) => Showtime.fromJson(e))
          .toList(),
    );
  }
}
