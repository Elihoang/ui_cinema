import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth/token_storage.dart';
import '../models/review/movie_review.dart';

class MovieReviewService {
  final TokenStorage _tokenStorage = TokenStorage();
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';

  Future<MovieReview> createReview(
    String movieId,
    int rating,
    String comment,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/MovieReviews'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'movieId': movieId,
        'rating': rating,
        'comment': comment,
      }),
    );

    if (response.statusCode == 201) {
      final jsonBody = jsonDecode(response.body);
      final data = jsonBody['data'];
      return MovieReview.fromJson(data);
    } else if (response.statusCode == 401) {
      await _tokenStorage.clear();
      throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
    } else {
      final jsonBody = jsonDecode(response.body);
      throw Exception(jsonBody['message'] ?? 'Lỗi khi gửi đánh giá');
    }
  }

  Future<List<MovieReview>> getReviews(String movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/MovieReviews/movie/$movieId'),
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> data = jsonBody['data'];
      return data.map((e) => MovieReview.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}
