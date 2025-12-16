import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cinema.dart';

class CinemaService {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';

  // Fetch danh sách rạp kèm phim đang chiếu
  static Future<List<Cinema>> fetchCinemasWithMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/cinemas/with-movies'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);

      if (jsonBody['success'] != true) {
        throw Exception(jsonBody['message'] ?? 'Lỗi từ server');
      }

      final List<dynamic> data = jsonBody['data'] ?? [];
      return data.map((e) => Cinema.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load cinemas: ${response.statusCode}');
    }
  }
}
