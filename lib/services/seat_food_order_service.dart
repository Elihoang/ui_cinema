import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/seat_food_order.dart';
import '../models/product.dart';

/// Service for seat food ordering through QR code
/// Matches endpoints from BE_CinePass.API.Controllers.SeatFoodOrderController
class SeatFoodOrderService {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';

  /// Kiểm tra thông tin ghế từ mã QR
  /// Endpoint: GET /api/SeatFoodOrder/seat-info/{seatQrCode}
  static Future<SeatInfoResponseDto> getSeatInfo(String seatQrCode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/SeatFoodOrder/seat-info/$seatQrCode'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) {
        throw Exception(jsonBody['message'] ?? 'Không tìm thấy thông tin ghế');
      }
      return SeatInfoResponseDto.fromJson(data);
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Lỗi khi kiểm tra thông tin ghế');
    }
  }

  /// Lấy danh sách sản phẩm có thể order (đồ ăn, nước uống đang hoạt động)
  /// Endpoint: GET /api/SeatFoodOrder/products
  static Future<List<ProductItem>> getAvailableProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/SeatFoodOrder/products'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];
      return data.map((e) => ProductItem.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi khi tải danh sách sản phẩm');
    }
  }

  /// Tạo đơn hàng đồ ăn/nước uống từ ghế ngồi
  /// Endpoint: POST /api/SeatFoodOrder/order
  static Future<SeatFoodOrderResponseDto> createOrder(
    SeatFoodOrderCreateDto dto,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/SeatFoodOrder/order'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) {
        throw Exception(jsonBody['message'] ?? 'Lỗi khi tạo đơn hàng');
      }
      return SeatFoodOrderResponseDto.fromJson(data);
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Lỗi khi tạo đơn hàng');
    }
  }

  /// Lấy trạng thái đơn hàng đồ ăn
  /// Endpoint: GET /api/SeatFoodOrder/order/{orderId}/status
  static Future<SeatFoodOrderStatusDto?> getOrderStatus(String orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/SeatFoodOrder/order/$orderId/status'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) return null;
      return SeatFoodOrderStatusDto.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Lỗi khi lấy trạng thái đơn hàng');
    }
  }

  /// Hủy đơn hàng đồ ăn (chỉ khi chưa thanh toán)
  /// Endpoint: POST /api/SeatFoodOrder/order/{orderId}/cancel
  static Future<bool> cancelOrder(String orderId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/SeatFoodOrder/order/$orderId/cancel'),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Không thể hủy đơn hàng');
    } else {
      throw Exception('Lỗi khi hủy đơn hàng');
    }
  }

  /// Xác nhận thanh toán tiền mặt (dành cho nhân viên)
  /// Endpoint: POST /api/SeatFoodOrder/order/{orderId}/confirm-cash
  static Future<SeatFoodOrderResponseDto> confirmCashPayment(
    String orderId,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/SeatFoodOrder/order/$orderId/confirm-cash'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) {
        throw Exception(jsonBody['message'] ?? 'Lỗi xác nhận thanh toán');
      }
      return SeatFoodOrderResponseDto.fromJson(data);
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Lỗi xác nhận thanh toán');
    }
  }

  /// Lấy lịch sử đơn hàng của ghế trong ngày
  /// Endpoint: GET /api/SeatFoodOrder/seat/{seatQrCode}/orders
  static Future<List<SeatFoodOrderStatusDto>> getOrdersBySeat(
    String seatQrCode,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/SeatFoodOrder/seat/$seatQrCode/orders'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];
      return data.map((e) => SeatFoodOrderStatusDto.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi khi lấy danh sách đơn hàng');
    }
  }
}
