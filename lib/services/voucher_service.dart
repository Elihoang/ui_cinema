import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/voucher.dart';

class VoucherService {
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

  /// Lấy danh sách tất cả voucher đang hoạt động
  static Future<List<Voucher>> getAllVouchers() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/Vouchers'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];

      return data.map((item) => Voucher.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load vouchers');
    }
  }

  /// Lấy danh sách voucher có thể đổi cho user
  static Future<List<Voucher>> getAvailableVouchersForUser(
    String userId,
  ) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/Vouchers/available/$userId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];

      return data.map((item) => Voucher.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load available vouchers');
    }
  }

  /// Lấy thông tin chi tiết voucher
  static Future<Voucher?> getVoucherById(String voucherId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/Vouchers/$voucherId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) return null;

      return Voucher.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load voucher detail');
    }
  }
}
