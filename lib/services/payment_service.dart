import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for Momo Payment
/// Matches endpoints from BE_CinePass.API.Controllers.MomoPaymentController
class PaymentService {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';

  /// Tạo thanh toán Momo
  /// Endpoint: POST /api/MomoPayment/create
  static Future<CreateMomoPaymentResponse> createMomoPayment({
    required String orderId,
    required double amount,
    required String orderInfo,
    String? extraData,
    String? token,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'orderId': orderId,
      'amount': amount,
      'orderInfo': orderInfo,
      'lang': 'vi',
      'extraData': extraData,
    });

    final response = await http.post(
      Uri.parse('$baseUrl/MomoPayment/create'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data != null) {
        return CreateMomoPaymentResponse.fromJson(data);
      } else {
        // Nếu không có data, parse trực tiếp từ jsonBody
        return CreateMomoPaymentResponse.fromJson(jsonBody);
      }
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Lỗi khi tạo thanh toán');
    }
  }

  /// Truy vấn trạng thái giao dịch
  /// Endpoint: GET /api/MomoPayment/query/{orderId}
  static Future<MomoQueryResponse> queryTransaction(
    String orderId, {
    String? token,
  }) async {
    final headers = {if (token != null) 'Authorization': 'Bearer $token'};

    final response = await http.get(
      Uri.parse('$baseUrl/MomoPayment/query/$orderId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) {
        throw Exception(jsonBody['message'] ?? 'Không thể truy vấn giao dịch');
      }
      return MomoQueryResponse.fromJson(data);
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Lỗi khi truy vấn giao dịch');
    }
  }

  /// Mở ứng dụng Momo hoặc URL thanh toán
  static Future<bool> openPaymentUrl(String? deeplink, String? payUrl) async {
    // Ưu tiên mở deeplink (Momo app)
    if (deeplink != null && deeplink.isNotEmpty) {
      final Uri uri = Uri.parse(deeplink);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }

    // Fallback: Mở PayUrl trong browser
    if (payUrl != null && payUrl.isNotEmpty) {
      final Uri uri = Uri.parse(payUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }

    return false;
  }
}

/// Response khi tạo thanh toán Momo
class CreateMomoPaymentResponse {
  final bool success;
  final String message;
  final String? payUrl;
  final String? deeplink;
  final String? qrCodeUrl;
  final String? orderId;
  final String? requestId;
  final int? resultCode;

  CreateMomoPaymentResponse({
    required this.success,
    required this.message,
    this.payUrl,
    this.deeplink,
    this.qrCodeUrl,
    this.orderId,
    this.requestId,
    this.resultCode,
  });

  factory CreateMomoPaymentResponse.fromJson(Map<String, dynamic> json) {
    return CreateMomoPaymentResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      payUrl: json['payUrl'] as String?,
      deeplink: json['deeplink'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      orderId: json['orderId'] as String?,
      requestId: json['requestId'] as String?,
      resultCode: json['resultCode'] as int?,
    );
  }
}

/// Response khi truy vấn trạng thái giao dịch
class MomoQueryResponse {
  final int resultCode;
  final String message;
  final String? orderId;
  final String? requestId;
  final String? transId;
  final double? amount;

  MomoQueryResponse({
    required this.resultCode,
    required this.message,
    this.orderId,
    this.requestId,
    this.transId,
    this.amount,
  });

  factory MomoQueryResponse.fromJson(Map<String, dynamic> json) {
    return MomoQueryResponse(
      resultCode: json['resultCode'] as int,
      message: json['message'] as String,
      orderId: json['orderId'] as String?,
      requestId: json['requestId'] as String?,
      transId: json['transId'] as String?,
      amount: json['amount'] != null
          ? (json['amount'] as num).toDouble()
          : null,
    );
  }

  bool get isSuccess => resultCode == 0;
}
