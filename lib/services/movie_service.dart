import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String baseUrl = 'http://localhost:5081/api';

  // Fetch danh sách phim now showing
  static Future<List<Movie>> fetchNowShowing() async {
    final response = await http.get(Uri.parse('$baseUrl/movies'));
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
  // static Future<List<Movie>> fetchUpcoming() async {
  //   final response = await http.get(Uri.parse('$baseUrl/Movies/Upcoming'));

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonBody = json.decode(response.body);

  //     final List<dynamic>? data = jsonBody['data'];
  //     if (data == null) return [];

  //     return data.map((e) => Movie.fromJson(e)).toList();
  //   } else {
  //     throw Exception('Failed to load upcoming movies');
  //   }
  // }
}
