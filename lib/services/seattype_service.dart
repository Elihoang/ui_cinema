import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/seattype.dart';

/// Service for managing seat types through the backend API
class SeatTypeService {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';

  /// Get all seat types with their surcharge rates
  /// Endpoint: GET /api/SeatTypes
  static Future<List<SeatType>> getAllSeatTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/SeatTypes'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];
      return data.map((e) => SeatType.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load seat types');
    }
  }

  /// Get seat type by code
  /// Endpoint: GET /api/SeatTypes/{code}
  static Future<SeatType?> getSeatTypeByCode(String code) async {
    final response = await http.get(Uri.parse('$baseUrl/SeatTypes/$code'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) return null;
      return SeatType.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load seat type $code');
    }
  }
}
