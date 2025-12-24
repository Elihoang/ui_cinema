import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/seat.dart';

class SeatService {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';

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

  static Future<List<Seat>> getSeatsByShowtimeId(String showtimeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Showtimes/$showtimeId/seats'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);

      final List<dynamic>? seats = jsonBody['data']?['seats'];
      if (seats == null) return [];

      return seats.map((e) => Seat.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load seats for showtime $showtimeId');
    }
  }

  /// Get seat by ID
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
