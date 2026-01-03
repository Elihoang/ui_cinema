import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/notification.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5081';
    } else {
      return 'http://10.0.2.2:5081';
    }
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

  // Get notifications
  Future<List<AppNotification>> getNotifications({
    int limit = 50,
    bool unreadOnly = false,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/notifications?limit=$limit&unreadOnly=$unreadOnly',
        ),
        headers: headers,
      );

      print('Notifications API Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Handle different response formats
        List<dynamic> notificationsList;
        if (jsonData is Map && jsonData.containsKey('data')) {
          notificationsList = jsonData['data'] as List? ?? [];
        } else if (jsonData is List) {
          notificationsList = jsonData;
        } else {
          return [];
        }

        return notificationsList
            .map((item) => AppNotification.fromJson(item))
            .toList();
      } else if (response.statusCode == 401) {
        print('Unauthorized - token may be expired');
        return [];
      } else {
        print('Failed to load notifications: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting notifications: $e');
      // Return empty list instead of throwing
      return [];
    }
  }

  // Get unread count
  Future<int> getUnreadCount() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/notifications/unread-count'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Handle different response formats
        if (jsonData is Map && jsonData.containsKey('data')) {
          return jsonData['data'] as int? ?? 0;
        } else if (jsonData is int) {
          return jsonData;
        }
        return 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  // Mark as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/notifications/$notificationId/read'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error marking as read: $e');
      return false;
    }
  }

  // Mark all as read
  Future<bool> markAllAsRead() async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/notifications/mark-all-read'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error marking all as read: $e');
      return false;
    }
  }

  // Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/notifications/$notificationId'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting notification: $e');
      return false;
    }
  }

  // Register device token
  Future<bool> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceModel,
    String? appVersion,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/device-tokens'),
        headers: headers,
        body: json.encode({
          'token': token,
          'platform': platform,
          'deviceModel': deviceModel,
          'appVersion': appVersion,
        }),
      );

      print('Register token status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error registering device token: $e');
      return false;
    }
  }

  // Unregister device token
  Future<bool> unregisterDeviceToken(String token) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/device-tokens/$token'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error unregistering device token: $e');
      return false;
    }
  }
}
