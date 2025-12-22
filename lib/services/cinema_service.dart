import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/cinema.dart';
import '../models/cinema_movies_with_showtimes_response.dart';
import '../models/cinema/cinema_brand_response.dart';

class CinemaService {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';

  /// Fetch danh sách rạp kèm phim đang chiếu
  static Future<List<Cinema>> fetchCinemasWithMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/Cinemas/with-movies'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load cinemas: ${response.statusCode}');
    }

    final Map<String, dynamic> jsonBody = json.decode(response.body);

    if (jsonBody['success'] != true) {
      throw Exception(jsonBody['message'] ?? 'Lỗi từ server');
    }

    final List<dynamic> data = jsonBody['data'] ?? [];
    return data.map((e) => Cinema.fromJson(e)).toList();
  }

  /// Fetch phim + suất chiếu theo ngày
  static Future<CinemaMoviesWithShowtimesResponse> getMoviesWithShowtimesByDate(
    String cinemaId,
    DateTime date,
  ) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final uri = Uri.parse(
      '$baseUrl/Cinemas/$cinemaId/movies-with-showtimes/by-date?date=$dateStr',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load showtimes: ${response.statusCode}');
    }

    final Map<String, dynamic> jsonBody = json.decode(response.body);

    if (jsonBody['success'] != true) {
      throw Exception(jsonBody['message'] ?? 'Lỗi từ server');
    }

    return CinemaMoviesWithShowtimesResponse.fromJson(jsonBody);
  }

  /// Fetch danh sách các hệ thống rạp (brands)
  static Future<List<CinemaBrandResponse>> fetchCinemaBrands() async {
    final response = await http.get(Uri.parse('$baseUrl/Cinemas/brands'));

    print('Cinema Brands API Status Code: ${response.statusCode}');
    print('Cinema Brands Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to load cinema brands: ${response.statusCode}');
    }

    final Map<String, dynamic> jsonBody = json.decode(response.body);

    if (jsonBody['success'] != true) {
      throw Exception(jsonBody['message'] ?? 'Lỗi từ server');
    }

    final List<dynamic> data = jsonBody['data'] ?? [];
    return data.map((e) => CinemaBrandResponse.fromJson(e)).toList();
  }
}
