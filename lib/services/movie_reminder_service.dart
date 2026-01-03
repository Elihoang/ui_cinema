import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieReminderService {
  static const String baseUrl = 'http://10.0.2.2:5081';
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
        Uri.parse('$baseUrl/api/movie-reminders/$movieId/subscribe'),
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
        Uri.parse('$baseUrl/api/movie-reminders/$movieId/unsubscribe'),
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
        Uri.parse('$baseUrl/api/movie-reminders/$movieId/status'),
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