import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service xử lý Deep Links cho payment callbacks
/// Hỗ trợ scheme: cinepass://
class DeepLinkService {
  static const MethodChannel _channel = MethodChannel(
    'app.channel.shared.data',
  );

  /// Stream controller để broadcast deep link events
  static final StreamController<Uri> _deepLinkController =
      StreamController<Uri>.broadcast();

  /// Stream để lắng nghe deep links
  static Stream<Uri> get deepLinkStream => _deepLinkController.stream;

  /// Uri của deep link ban đầu (khi app được mở từ deep link)
  static Uri? _initialUri;
  static Uri? get initialUri => _initialUri;

  /// Callback function khi nhận được payment result
  static Function(PaymentDeepLinkResult)? onPaymentResult;

  /// Khởi tạo service
  static Future<void> init() async {
    // Lắng nghe deep links khi app đang chạy
    try {
      // Sử dụng uni_links hoặc app_links package nếu đã cài
      // Hiện tại dùng MethodChannel cơ bản
      _channel.setMethodCallHandler(_handleMethodCall);
    } catch (e) {
      debugPrint('DeepLinkService init error: $e');
    }
  }

  /// Xử lý method calls từ native
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onDeepLink':
        final String? link = call.arguments as String?;
        if (link != null) {
          _handleDeepLink(link);
        }
        break;
    }
  }

  /// Xử lý deep link URL
  static void _handleDeepLink(String link) {
    try {
      final uri = Uri.parse(link);
      debugPrint('Deep link received: $uri');

      // Broadcast to stream
      _deepLinkController.add(uri);

      // Kiểm tra nếu là payment callback
      if (uri.scheme == 'cinepass' && uri.host == 'payment') {
        _handlePaymentDeepLink(uri);
      }
    } catch (e) {
      debugPrint('Error parsing deep link: $e');
    }
  }

  /// Xử lý payment deep link
  static void _handlePaymentDeepLink(Uri uri) {
    final path = uri.path; // /success, /failed, /error
    final queryParams = uri.queryParameters;

    final result = PaymentDeepLinkResult(
      isSuccess: path == '/success',
      isFailed: path == '/failed',
      isError: path == '/error',
      orderId: queryParams['orderId'],
      resultCode: int.tryParse(queryParams['resultCode'] ?? ''),
      message: queryParams['message'],
    );

    debugPrint(
      'Payment result: isSuccess=${result.isSuccess}, orderId=${result.orderId}',
    );

    // Gọi callback nếu có
    if (onPaymentResult != null) {
      onPaymentResult!(result);
    }
  }

  /// Đóng stream khi không cần nữa
  static void dispose() {
    _deepLinkController.close();
  }
}

/// Kết quả payment từ deep link
class PaymentDeepLinkResult {
  final bool isSuccess;
  final bool isFailed;
  final bool isError;
  final String? orderId;
  final int? resultCode;
  final String? message;

  PaymentDeepLinkResult({
    required this.isSuccess,
    required this.isFailed,
    required this.isError,
    this.orderId,
    this.resultCode,
    this.message,
  });

  @override
  String toString() {
    return 'PaymentDeepLinkResult(isSuccess: $isSuccess, orderId: $orderId, resultCode: $resultCode)';
  }
}
