import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/member_tier.dart';
import '../models/member_point.dart';

class MembershipService {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'access_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Lấy danh sách tất cả cấp bậc hội viên
  static Future<List<MemberTierConfig>> getAllTiers() async {
    final response = await http.get(Uri.parse('$baseUrl/Membership/tiers'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];

      return data.map((item) => MemberTierConfig.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load member tiers');
    }
  }

  /// Lấy thông tin hội viên theo User ID
  static Future<MemberPoint?> getMemberProfile(String userId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/Membership/profile/$userId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) return null;

      return MemberPoint.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load member profile');
    }
  }

  /// Lấy lịch sử điểm của user
  static Future<List<PointHistory>> getPointHistory(
    String userId, {
    int? limit = 50,
  }) async {
    final headers = await _getHeaders();
    final uri = Uri.parse(
      '$baseUrl/Membership/point-history/$userId',
    ).replace(queryParameters: {'limit': limit?.toString()});

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];

      return data.map((item) => PointHistory.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load point history');
    }
  }

  /// Tạo MemberPoint cho user mới (thường được gọi sau khi đăng ký)
  static Future<MemberPoint> createMemberPoint(
    String userId, {
    int initialPoints = 0,
  }) async {
    final headers = await _getHeaders();
    final body = json.encode({
      'userId': userId,
      'initialPoints': initialPoints,
    });

    final response = await http.post(
      Uri.parse('$baseUrl/Membership/member-points'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) {
        throw Exception(jsonBody['message'] ?? 'Failed to create member point');
      }

      return MemberPoint.fromJson(data);
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Failed to create member point');
    }
  }
}
