import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieReminderService {
  // Sử dụng BASE_URL từ dotenv để hoạt động trên cả emulator và điện thoại thật
  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';
  }

  final _storage = const FlutterSecureStorage();

  Future<String?> _getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<bool> subscribeToReminder(String movieId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/movie-reminders/$movieId/subscribe'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error subscribing: $e');
      return false;
    }
  }

  Future<bool> unsubscribeFromReminder(String movieId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/movie-reminders/$movieId/unsubscribe'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error unsubscribing: $e');
      return false;
    }
  }

  Future<bool> getReminderStatus(String movieId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/movie-reminders/$movieId/status'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['data'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error getting status: $e');
      return false;
    }
  }
}
