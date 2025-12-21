import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/seat.dart';

/// Service for managing seats through the backend API
/// Matches endpoints from BE_CinePass.API.Controllers.SeatsController
class SeatService {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';

  /// Get all seats for a specific screen
  /// Endpoint: GET /api/Seats/screen/{screenId}
  static Future<List<Seat>> getSeatsByScreenId(String screenId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Seats/screen/$screenId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];
      return data.map((e) => Seat.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load seats for screen $screenId');
    }
  }

  /// Get active seats for a specific screen
  /// Endpoint: GET /api/Seats/screen/{screenId}/active
  static Future<List<Seat>> getActiveSeatsByScreenId(String screenId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Seats/screen/$screenId/active'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];
      return data.map((e) => Seat.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load active seats for screen $screenId');
    }
  }

  /// Get seat by ID
  /// Endpoint: GET /api/Seats/{id}
  static Future<Seat?> getSeatById(String seatId) async {
    final response = await http.get(Uri.parse('$baseUrl/Seats/$seatId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) return null;
      return Seat.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load seat $seatId');
    }
  }

  /// Check if a seat is available for a specific showtime
  /// Endpoint: GET /api/Seats/{seatId}/available?showtimeId={showtimeId}
  static Future<bool> isSeatAvailable(String seatId, String showtimeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Seats/$seatId/available?showtimeId=$showtimeId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      return data as bool? ?? false;
    } else {
      throw Exception('Failed to check seat availability');
    }
  }

  /// Create a new seat
  /// Endpoint: POST /api/Seats
  static Future<Seat> createSeat(Map<String, dynamic> seatData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Seats'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(seatData),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      return Seat.fromJson(data);
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Failed to create seat');
    }
  }

  /// Update an existing seat
  /// Endpoint: PUT /api/Seats/{id}
  static Future<Seat> updateSeat(
    String seatId,
    Map<String, dynamic> seatData,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Seats/$seatId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(seatData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      return Seat.fromJson(data);
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Failed to update seat');
    }
  }

  /// Generate seats automatically for a screen
  /// Endpoint: POST /api/Seats/generate
  static Future<List<Seat>> generateSeats({
    required String screenId,
    required int rows,
    required int seatsPerRow,
    String? defaultSeatTypeCode,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Seats/generate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'screenId': screenId,
        'rows': rows,
        'seatsPerRow': seatsPerRow,
        'defaultSeatTypeCode': defaultSeatTypeCode,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];
      return data.map((e) => Seat.fromJson(e)).toList();
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Failed to generate seats');
    }
  }

  /// Delete a seat
  /// Endpoint: DELETE /api/Seats/{id}
  static Future<bool> deleteSeat(String seatId) async {
    final response = await http.delete(Uri.parse('$baseUrl/Seats/$seatId'));

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Failed to delete seat');
    }
  }
}
