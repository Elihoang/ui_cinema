import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service for Order management
/// Matches endpoints from BE_CinePass.API.Controllers.OrderController
class OrderService {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5081/api';

  /// Tạo đơn hàng mới từ ghế đã chọn
  /// Endpoint: POST /api/Order
  static Future<OrderResponseDto> createOrder({
    required String? userId,
    required List<OrderTicketItemDto> tickets,
    List<OrderProductItemDto> products = const [],
    String? paymentMethod,
    String? token,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'userId': userId,
      'tickets': tickets.map((t) => t.toJson()).toList(),
      'products': products.map((p) => p.toJson()).toList(),
      'paymentMethod': paymentMethod,
    });

    // Debug log
    print('===== ORDER SERVICE DEBUG =====');
    print('UserId param: $userId');
    print('Request body: $body');
    print('===============================');

    final response = await http.post(
      Uri.parse('$baseUrl/Orders'), // Changed from /Order to /Orders
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) {
        throw Exception(jsonBody['message'] ?? 'Lỗi khi tạo đơn hàng');
      }
      return OrderResponseDto.fromJson(data);
    } else {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      throw Exception(jsonBody['message'] ?? 'Lỗi khi tạo đơn hàng');
    }
  }

  /// Lấy thông tin đơn hàng theo ID
  /// Endpoint: GET /api/Orders/{id}
  static Future<OrderDetailDto?> getOrderById(
    String orderId, {
    String? token,
  }) async {
    final headers = {if (token != null) 'Authorization': 'Bearer $token'};

    final response = await http.get(
      Uri.parse('$baseUrl/Orders/$orderId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final dynamic data = jsonBody['data'];
      if (data == null) return null;
      return OrderDetailDto.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Lỗi khi lấy thông tin đơn hàng');
    }
  }

  /// Lấy danh sách đơn hàng của người dùng
  /// Endpoint: GET /api/Orders/user/{userId}
  static Future<List<OrderResponseDto>> getUserOrders(
    String userId, {
    String? token,
  }) async {
    final headers = {if (token != null) 'Authorization': 'Bearer $token'};

    final response = await http.get(
      Uri.parse('$baseUrl/Orders/user/$userId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic>? data = jsonBody['data'];
      if (data == null) return [];
      return data.map((e) => OrderResponseDto.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi khi lấy danh sách đơn hàng');
    }
  }

  /// Hủy đơn hàng
  /// Endpoint: DELETE /api/Orders/{id}
  static Future<bool> cancelOrder(String orderId, {String? token}) async {
    final headers = {if (token != null) 'Authorization': 'Bearer $token'};

    final response = await http.delete(
      Uri.parse('$baseUrl/Orders/$orderId'),
      headers: headers,
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}

/// DTO cho việc tạo đơn hàng - Tickets
class OrderTicketItemDto {
  final String showtimeId;
  final String seatId;

  OrderTicketItemDto({required this.showtimeId, required this.seatId});

  Map<String, dynamic> toJson() => {'showtimeId': showtimeId, 'seatId': seatId};
}

/// DTO cho việc tạo đơn hàng - Products
class OrderProductItemDto {
  final String productId;
  final int quantity;

  OrderProductItemDto({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
  };
}

/// Response DTO khi tạo đơn hàng thành công
class OrderResponseDto {
  final String id;
  final String? userId;
  final double totalAmount;
  final String status;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime? expireAt;

  OrderResponseDto({
    required this.id,
    this.userId,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    required this.createdAt,
    this.expireAt,
  });

  factory OrderResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderResponseDto(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expireAt: json['expireAt'] != null
          ? DateTime.parse(json['expireAt'] as String)
          : null,
    );
  }
}

/// Detail DTO cho đơn hàng (bao gồm tickets và products)
class OrderDetailDto {
  final String id;
  final String? userId;
  final double totalAmount;
  final String status;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime? expireAt;
  final List<OrderTicketDto> tickets;
  final List<OrderProductDto> products;

  OrderDetailDto({
    required this.id,
    this.userId,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    required this.createdAt,
    this.expireAt,
    this.tickets = const [],
    this.products = const [],
  });

  factory OrderDetailDto.fromJson(Map<String, dynamic> json) {
    return OrderDetailDto(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expireAt: json['expireAt'] != null
          ? DateTime.parse(json['expireAt'] as String)
          : null,
      tickets:
          (json['tickets'] as List<dynamic>?)
              ?.map((e) => OrderTicketDto.fromJson(e))
              .toList() ??
          [],
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => OrderProductDto.fromJson(e))
              .toList() ??
          [],
    );
  }
}

/// Ticket trong đơn hàng
class OrderTicketDto {
  final String id;
  final String orderId;
  final String showtimeId;
  final String seatId;
  final double price;

  OrderTicketDto({
    required this.id,
    required this.orderId,
    required this.showtimeId,
    required this.seatId,
    required this.price,
  });

  factory OrderTicketDto.fromJson(Map<String, dynamic> json) {
    return OrderTicketDto(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      showtimeId: json['showtimeId'] as String,
      seatId: json['seatId'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}

/// Product trong đơn hàng
class OrderProductDto {
  final String id;
  final String orderId;
  final String productId;
  final int quantity;
  final double unitPrice;

  OrderProductDto({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderProductDto.fromJson(Map<String, dynamic> json) {
    return OrderProductDto(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );
  }
}
