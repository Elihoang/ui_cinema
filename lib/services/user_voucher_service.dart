import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_voucher.dart';

class UserVoucherService {
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

  /// Lấy danh sách voucher của user
  static Future<List<UserVoucher>> getUserVouchers(
    String userId, {
    bool onlyAvailable = false,
  }) async {
    final headers = await _getHeaders();
    final uri = Uri.parse(
      '$baseUrl/UserVouchers/user/$userId',
    ).replace(queryParameters: {'onlyAvailable': onlyAvailable.toString()});

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];

      return data.map((item) => UserVoucher.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load user vouchers');
    }
  }

  /// Lấy thông tin chi tiết user voucher
  static Future<UserVoucher?> getUserVoucherById(String userVoucherId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/UserVouchers/$userVoucherId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) return null;

      return UserVoucher.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load user voucher detail');
    }
  }

  /// Đổi điểm lấy voucher
  static Future<UserVoucher> redeemVoucher(
    String userId,
    String voucherId,
  ) async {
    final headers = await _getHeaders();
    final body = json.encode(RedeemVoucherDto(voucherId: voucherId).toJson());

    final uri = Uri.parse(
      '$baseUrl/UserVouchers/redeem',
    ).replace(queryParameters: {'userId': userId});

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) {
        throw Exception(jsonBody['message'] ?? 'Failed to redeem voucher');
      }

      return UserVoucher.fromJson(data);
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Failed to redeem voucher');
    }
  }

  /// Validate voucher trước khi sử dụng
  static Future<bool> validateVoucherUsage(
    String userVoucherId,
    double orderAmount,
  ) async {
    final headers = await _getHeaders();
    final uri = Uri.parse(
      '$baseUrl/UserVouchers/$userVoucherId/validate',
    ).replace(queryParameters: {'orderAmount': orderAmount.toString()});

    final response = await http.post(uri, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final bool? success = jsonBody['success'];

      if (success == true) {
        return true;
      } else {
        throw Exception(jsonBody['message'] ?? 'Voucher is not valid');
      }
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Failed to validate voucher');
    }
  }
}
