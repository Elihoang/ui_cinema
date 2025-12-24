

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/eticket.dart';

class TicketService {
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

  static String? _decodeUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      return payload['sub']?.toString() ??
          payload['nameidentifier']?.toString() ??
          payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']
              ?.toString();
    } catch (e) {
      print('Lỗi decode token: $e');
      return null;
    }
  }

  static Future<String?> _getUserId() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null || token.isEmpty) return null;
    return _decodeUserIdFromToken(token);
  }

  /// LẤY TẤT CẢ VÉ CỦA USER TỪ ORDER DETAIL (Confirmed)
  /// Không còn gọi API ETickets riêng nữa vì backend chưa generate ETicket ngay
  static Future<List<ETicket>> fetchMyTickets() async {
    final userId = await _getUserId();
    if (userId == null) {
      throw Exception('Chưa đăng nhập hoặc token hết hạn');
    }

    final headers = await _getHeaders();

    // 1. Lấy danh sách orders Confirmed của user
    final ordersResponse = await http.get(
      Uri.parse('$baseUrl/Orders/user/$userId?status=Confirmed'),
      headers: headers,
    );

    if (ordersResponse.statusCode != 200) {
      throw Exception('Không tải được đơn hàng: ${ordersResponse.statusCode}');
    }

    final ordersJson = json.decode(ordersResponse.body);
    if (!(ordersJson['success'] as bool? ?? false)) {
      throw Exception(ordersJson['message'] ?? 'Lỗi lấy đơn hàng');
    }

    final List<dynamic> orders = ordersJson['data'] ?? [];
    final List<ETicket> allTickets = [];

    // 2. Duyệt từng order → lấy detail
    for (var order in orders) {
      final orderId = order['id'].toString();

      final detailResponse = await http.get(
        Uri.parse('$baseUrl/Orders/$orderId/detail'),
        headers: headers,
      );

      if (detailResponse.statusCode != 200) continue;

      final detailJson = json.decode(detailResponse.body);
      if (!(detailJson['success'] as bool? ?? false) ||
          detailJson['data'] == null)
        continue;

      final orderData = detailJson['data'];
      final List<dynamic> orderTickets = orderData['tickets'] ?? [];

      // 3. Tạo ETicket từ mỗi orderTicket
      for (var ot in orderTickets) {
        final showtimeJson = ot['showtime'] as Map<String, dynamic>?;
        final movieJson = showtimeJson?['movie'] as Map<String, dynamic>?;
        final seatJson = ot['seat'] as Map<String, dynamic>?;
        final screenJson = showtimeJson?['screen'] as Map<String, dynamic>?;
        final cinemaJson = screenJson?['cinema'] as Map<String, dynamic>?;

        // Thử gọi API ETickets trước
        final orderTicketId = ot['id'].toString();
        bool addedReal = false;
        final ticketResponse = await http.get(
          Uri.parse('$baseUrl/ETickets/order-ticket/$orderTicketId'),
          headers: headers,
        );
        if (ticketResponse.statusCode == 200) {
          final ticketJson = json.decode(ticketResponse.body);
          if (ticketJson['success'] == true && ticketJson['data'] != null) {
            final List<dynamic> eTickets = ticketJson['data'];
            for (final j in eTickets) {
              final Map<String, dynamic> et = j as Map<String, dynamic>;
              final combined = {...et, 'orderTicket': ot};
              allTickets.add(ETicket.fromJson(combined));
              addedReal = true;
            }
          }
        }

        if (addedReal) continue; // đã có ETicket thật

        // Fallback: tạo stub từ dữ liệu orderTicket để vẫn có vé hiển thị
        if (movieJson == null || seatJson == null || showtimeJson == null) {
          continue;
        }
        final startStr = showtimeJson['startTime'] as String?;
        final startTime = startStr != null
            ? DateTime.parse(startStr)
            : DateTime.now();

        final createdStr = orderData['createdAt'] as String?;
        final createdAt = createdStr != null
            ? DateTime.parse(createdStr)
            : DateTime.now();

        final Map<String, dynamic> combinedStub = {
          'id': '${orderTicketId}-stub',
          'orderTicketId': orderTicketId,
          'ticketCode': 'CHƯA PHÁT HÀNH',
          'qrData': null,
          'isUsed': false,
          'usedAt': null,
          'createdAt': createdStr ?? DateTime.now().toIso8601String(),
          'orderTicket': ot,
        };
        allTickets.add(ETicket.fromJson(combinedStub));
      }
    }

    // Sort tổng: mới nhất trước
    allTickets.sort((a, b) => b.showtime.compareTo(a.showtime));

    return allTickets;
  }
}
