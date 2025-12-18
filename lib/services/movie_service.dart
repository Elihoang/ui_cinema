import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../models/movie_cinema_showtime_response.dart';

class MovieService {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';

  // Fetch danh sách phim now showing
  static Future<List<Movie>> fetchNowShowing() async {
    final response = await http.get(Uri.parse('$baseUrl/movies/now-showing'));
    print('API Status Code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);

      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return []; // tránh null

      return data.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Nếu muốn, có thể thêm fetchUpcoming tương tự
  static Future<List<Movie>> fetchUpcoming() async {
    final response = await http.get(Uri.parse('$baseUrl/Movies/coming-soon'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);

      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];

      return data.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  // Fetch movie detail by ID
  static Future<MovieDetail> fetchMovieDetail(String movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movies/$movieId'));
    print('Movie Detail API Status Code: ${response.statusCode}');
    print('Movie Detail Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      // If the API wraps response in 'data' field, use jsonBody['data']
      // Otherwise use jsonBody directly
      final movieData = jsonBody['data'] ?? jsonBody;

      return MovieDetail.fromJson(movieData);
    } else {
      throw Exception('Failed to load movie detail');
    }
  }

  // Fetch cinema showtimes for a specific movie and date
  static Future<MovieCinemaShowtimeResponse> fetchCinemaShowtimesByMovie(
    String movieId,
    String date,
  ) async {
    final url = '$baseUrl/Movies/$movieId/cinemas?date=$date';
    final response = await http.get(Uri.parse(url));

    print('Cinema Showtimes API Status Code: ${response.statusCode}');
    print('Cinema Showtimes Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return MovieCinemaShowtimeResponse.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load cinema showtimes for movie');
    }
  }
}
