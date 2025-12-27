import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Trạng thái vé
enum TicketStatus { valid, used, expired, notFound, unknown }

extension TicketStatusExtension on TicketStatus {
  String get displayName {
    switch (this) {
      case TicketStatus.valid:
        return 'Hợp lệ';
      case TicketStatus.used:
        return 'Đã sử dụng';
      case TicketStatus.expired:
        return 'Hết hạn';
      case TicketStatus.notFound:
        return 'Không tìm thấy';
      case TicketStatus.unknown:
        return 'Không xác định';
    }
  }

  static TicketStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'valid':
        return TicketStatus.valid;
      case 'used':
        return TicketStatus.used;
      case 'expired':
        return TicketStatus.expired;
      case 'notfound':
        return TicketStatus.notFound;
      default:
        return TicketStatus.unknown;
    }
  }
}

/// Thông tin sản phẩm đi kèm đơn hàng
class OrderProductInfo {
  final String productName;
  final int quantity;
  final double unitPrice;
  final String? category;

  OrderProductInfo({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.category,
  });

  factory OrderProductInfo.fromJson(Map<String, dynamic> json) {
    return OrderProductInfo(
      productName: json['productName'] as String? ?? 'N/A',
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      category: json['category'] as String?,
    );
  }
}

/// Chi tiết vé mở rộng (từ Summary API)
class TicketDetail {
  // Thông tin vé
  final String ticketCode;
  final double ticketPrice;

  // Thông tin phim
  final String movieTitle;
  final String? moviePosterUrl;
  final int movieDurationMinutes;
  final String? movieRating; // Phân loại độ tuổi

  // Thông tin suất chiếu
  final DateTime showtime;
  final DateTime? showtimeEnd;
  final int minutesUntilShowtime;
  final bool isShowtimeStarted;

  // Thông tin rạp & phòng chiếu
  final String cinemaName;
  final String? cinemaAddress;
  final String? screenName;

  // Thông tin ghế
  final String seatCode;
  final String? seatRow;
  final int? seatNumber;
  final String? seatType; // VIP, Standard, Couple, etc.

  // Thông tin khách hàng
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;

  // Thông tin đơn hàng
  final String? orderId;
  final double? orderTotalAmount;
  final int? totalTicketsInOrder;
  final int? checkedInTicketsInOrder;

  // Sản phẩm đi kèm
  final List<OrderProductInfo>? products;

  TicketDetail({
    required this.ticketCode,
    this.ticketPrice = 0,
    required this.movieTitle,
    this.moviePosterUrl,
    this.movieDurationMinutes = 0,
    this.movieRating,
    required this.showtime,
    this.showtimeEnd,
    this.minutesUntilShowtime = 0,
    this.isShowtimeStarted = false,
    required this.cinemaName,
    this.cinemaAddress,
    this.screenName,
    required this.seatCode,
    this.seatRow,
    this.seatNumber,
    this.seatType,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.orderId,
    this.orderTotalAmount,
    this.totalTicketsInOrder,
    this.checkedInTicketsInOrder,
    this.products,
  });

  /// Parse từ ticketDetail cũ (backward compatible)
  factory TicketDetail.fromJson(Map<String, dynamic> json) {
    return TicketDetail(
      ticketCode: json['ticketCode'] as String? ?? '',
      movieTitle: json['movieTitle'] as String? ?? 'N/A',
      cinemaName: json['cinemaName'] as String? ?? 'N/A',
      showtime: json['showtime'] != null
          ? DateTime.parse(json['showtime'] as String)
          : DateTime.now(),
      seatCode: json['seatCode'] as String? ?? 'N/A',
      screenName: json['screenName'] as String?,
      customerName: json['customerName'] as String?,
      customerEmail: json['customerEmail'] as String?,
    );
  }

  /// Parse từ summary mới (expanded data)
  factory TicketDetail.fromSummaryJson(Map<String, dynamic> json) {
    // Parse products
    List<OrderProductInfo>? products;
    if (json['products'] != null) {
      products = (json['products'] as List<dynamic>)
          .map((p) => OrderProductInfo.fromJson(p as Map<String, dynamic>))
          .toList();
    }

    return TicketDetail(
      // Thông tin vé
      ticketCode: json['ticketCode'] as String? ?? '',
      ticketPrice: (json['ticketPrice'] as num?)?.toDouble() ?? 0,

      // Thông tin phim
      movieTitle: json['movieTitle'] as String? ?? 'N/A',
      moviePosterUrl: json['moviePosterUrl'] as String?,
      movieDurationMinutes: json['movieDurationMinutes'] as int? ?? 0,
      movieRating: json['movieRating'] as String?,

      // Thông tin suất chiếu
      showtime: json['showtimeStart'] != null
          ? DateTime.parse(json['showtimeStart'] as String)
          : DateTime.now(),
      showtimeEnd: json['showtimeEnd'] != null
          ? DateTime.parse(json['showtimeEnd'] as String)
          : null,
      minutesUntilShowtime: json['minutesUntilShowtime'] as int? ?? 0,
      isShowtimeStarted: json['isShowtimeStarted'] as bool? ?? false,

      // Thông tin rạp & phòng chiếu
      cinemaName: json['cinemaName'] as String? ?? 'N/A',
      cinemaAddress: json['cinemaAddress'] as String?,
      screenName: json['screenName'] as String?,

      // Thông tin ghế
      seatCode: json['seatCode'] as String? ?? 'N/A',
      seatRow: json['seatRow'] as String?,
      seatNumber: json['seatNumber'] as int?,
      seatType: json['seatType'] as String?,

      // Thông tin khách hàng
      customerName: json['customerName'] as String?,
      customerEmail: json['customerEmail'] as String?,
      customerPhone: json['customerPhone'] as String?,

      // Thông tin đơn hàng
      orderId: json['orderId'] as String?,
      orderTotalAmount: (json['orderTotalAmount'] as num?)?.toDouble(),
      totalTicketsInOrder: json['totalTicketsInOrder'] as int?,
      checkedInTicketsInOrder: json['checkedInTicketsInOrder'] as int?,

      // Sản phẩm
      products: products,
    );
  }
}

/// Kết quả xác thực vé
class TicketVerificationResult {
  final bool isValid;
  final TicketStatus status;
  final String message;
  final DateTime? checkinAt; // Thời gian check-in
  final TicketDetail? ticketDetail;

  TicketVerificationResult({
    required this.isValid,
    required this.status,
    required this.message,
    this.checkinAt,
    this.ticketDetail,
  });

  factory TicketVerificationResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    if (data == null) {
      return TicketVerificationResult(
        isValid: false,
        status: TicketStatus.unknown,
        message: json['message'] as String? ?? 'Không có dữ liệu',
      );
    }

    // Parse checkinAt
    DateTime? checkinAt;
    if (data['checkinAt'] != null) {
      checkinAt = DateTime.parse(data['checkinAt'] as String);
    }

    // Ưu tiên sử dụng summary nếu có (expanded data)
    TicketDetail? ticketDetail;
    if (data['summary'] != null) {
      ticketDetail = TicketDetail.fromSummaryJson(
        data['summary'] as Map<String, dynamic>,
      );
    } else if (data['ticketDetail'] != null) {
      ticketDetail = TicketDetail.fromJson(
        data['ticketDetail'] as Map<String, dynamic>,
      );
    }

    return TicketVerificationResult(
      isValid: data['isValid'] as bool? ?? false,
      status: TicketStatusExtension.fromString(data['status'] as String?),
      message: data['message'] as String? ?? '',
      checkinAt: checkinAt,
      ticketDetail: ticketDetail,
    );
  }

  factory TicketVerificationResult.error(String message) {
    return TicketVerificationResult(
      isValid: false,
      status: TicketStatus.unknown,
      message: message,
    );
  }
}

/// Response khi checkin vé
class CheckinResponse {
  final bool success;
  final String message;
  final TicketVerificationResult? result;

  CheckinResponse({required this.success, required this.message, this.result});

  factory CheckinResponse.fromJson(Map<String, dynamic> json) {
    final success = json['success'] as bool? ?? false;
    final data = json['data'];

    // Xử lý trường hợp data là String (thông báo thành công) hoặc Map (chi tiết vé)
    String message;
    TicketVerificationResult? result;

    if (data is String) {
      // API trả về data là message string khi check-in thành công
      message = data;
      result = null;
    } else if (data is Map<String, dynamic>) {
      // API trả về data là object chi tiết khi cần thêm thông tin
      message = json['message'] as String? ?? '';
      result = TicketVerificationResult.fromJson(json);
    } else {
      message = json['message'] as String? ?? '';
      result = null;
    }

    return CheckinResponse(success: success, message: message, result: result);
  }

  factory CheckinResponse.error(String message) {
    return CheckinResponse(success: false, message: message);
  }
}

/// Thông tin vé điện tử đầy đủ
class ETicketInfo {
  final String id;
  final String ticketCode;
  final String? qrData;
  final bool isUsed;
  final DateTime? usedAt;
  final DateTime createdAt;
  final String orderTicketId;

  // Thông tin bổ sung từ orderTicket
  final String? movieTitle;
  final String? cinemaName;
  final String? screenName;
  final String? seatCode;
  final DateTime? showtime;
  final String? customerName;
  final String? customerEmail;

  ETicketInfo({
    required this.id,
    required this.ticketCode,
    this.qrData,
    required this.isUsed,
    this.usedAt,
    required this.createdAt,
    required this.orderTicketId,
    this.movieTitle,
    this.cinemaName,
    this.screenName,
    this.seatCode,
    this.showtime,
    this.customerName,
    this.customerEmail,
  });

  factory ETicketInfo.fromJson(Map<String, dynamic> json) {
    // Parse nested data from orderTicket
    final orderTicket = json['orderTicket'] as Map<String, dynamic>?;
    final showtimeData = orderTicket?['showtime'] as Map<String, dynamic>?;
    final movie = showtimeData?['movie'] as Map<String, dynamic>?;
    final screen = showtimeData?['screen'] as Map<String, dynamic>?;
    final cinema = screen?['cinema'] as Map<String, dynamic>?;
    final seat = orderTicket?['seat'] as Map<String, dynamic>?;
    final order = orderTicket?['order'] as Map<String, dynamic>?;
    final user = order?['user'] as Map<String, dynamic>?;

    return ETicketInfo(
      id: json['id']?.toString() ?? '',
      ticketCode: json['ticketCode'] as String? ?? '',
      qrData: json['qrData'] as String?,
      isUsed: json['isUsed'] as bool? ?? false,
      usedAt: json['usedAt'] != null
          ? DateTime.parse(json['usedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      orderTicketId: json['orderTicketId']?.toString() ?? '',
      movieTitle: movie?['title'] as String?,
      cinemaName: cinema?['name'] as String?,
      screenName: screen?['name'] as String?,
      seatCode: seat?['code'] as String?,
      showtime: showtimeData?['startTime'] != null
          ? DateTime.parse(showtimeData!['startTime'] as String)
          : null,
      customerName: user?['fullName'] as String?,
      customerEmail: user?['email'] as String?,
    );
  }
}

/// Service xử lý vé điện tử và checkin cho staff/admin
class TicketCheckinService {
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

  // ==================== GET ENDPOINTS ====================

  /// Lấy thông tin vé theo ID
  /// GET /ETickets/{id}
  static Future<ETicketInfo?> getTicketById(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/ETickets/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          return ETicketInfo.fromJson(jsonBody['data'] as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      print('Error getTicketById: $e');
      return null;
    }
  }

  /// Lấy thông tin vé theo mã vé
  /// GET /ETickets/code/{ticketCode}
  static Future<ETicketInfo?> getTicketByCode(String ticketCode) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/ETickets/code/$ticketCode'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          return ETicketInfo.fromJson(jsonBody['data'] as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      print('Error getTicketByCode: $e');
      return null;
    }
  }

  /// Lấy chi tiết vé theo mã vé (bao gồm thông tin đầy đủ)
  /// GET /ETickets/code/{ticketCode}/detail
  static Future<ETicketInfo?> getTicketDetailByCode(String ticketCode) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/ETickets/code/$ticketCode/detail'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          return ETicketInfo.fromJson(jsonBody['data'] as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      print('Error getTicketDetailByCode: $e');
      return null;
    }
  }

  /// Lấy danh sách vé theo order ticket ID
  /// GET /ETickets/order-ticket/{orderTicketId}
  static Future<List<ETicketInfo>> getTicketsByOrderTicketId(
    String orderTicketId,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/ETickets/order-ticket/$orderTicketId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          final List<dynamic> data = jsonBody['data'] as List<dynamic>;
          return data
              .map((e) => ETicketInfo.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getTicketsByOrderTicketId: $e');
      return [];
    }
  }

  /// Xác thực vé điện tử (kiểm tra vé có hợp lệ không)
  /// GET /ETickets/validate/{ticketCode}
  static Future<TicketVerificationResult> validateTicket(
    String ticketCode,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/ETickets/validate/$ticketCode'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        return TicketVerificationResult.fromJson(jsonBody);
      } else if (response.statusCode == 404) {
        return TicketVerificationResult.error('Không tìm thấy vé với mã này');
      } else {
        return TicketVerificationResult.error(
          'Lỗi kết nối: ${response.statusCode}',
        );
      }
    } catch (e) {
      return TicketVerificationResult.error('Lỗi: ${e.toString()}');
    }
  }

  // ==================== POST ENDPOINTS ====================

  /// Tạo vé điện tử (sau thanh toán thành công)
  /// POST /ETickets/generate/{orderTicketId}
  static Future<ETicketInfo?> generateTicket(String orderTicketId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/ETickets/generate/$orderTicketId'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          return ETicketInfo.fromJson(jsonBody['data'] as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      print('Error generateTicket: $e');
      return null;
    }
  }

  /// Sử dụng vé (check-in) bằng ticketCode
  /// POST /ETickets/use/{ticketCode}
  static Future<CheckinResponse> useTicket(String ticketCode) async {
    try {
      final headers = await _getHeaders();
      final url = '$baseUrl/ETickets/use/$ticketCode';
      print('📤 [useTicket] POST: $url');

      final response = await http.post(Uri.parse(url), headers: headers);

      print('📥 [useTicket] Status: ${response.statusCode}');
      print('📥 [useTicket] Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        return CheckinResponse.fromJson(jsonBody);
      } else if (response.statusCode == 404) {
        return CheckinResponse.error('Không tìm thấy vé với mã này');
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        return CheckinResponse.error(
          jsonBody['message'] as String? ?? 'Vé không hợp lệ',
        );
      } else {
        return CheckinResponse.error('Lỗi kết nối: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [useTicket] Error: $e');
      return CheckinResponse.error('Lỗi: ${e.toString()}');
    }
  }

  /// Check-in vé bằng mã QR
  /// POST /ETickets/checkin với body VerifyTicketDto
  static Future<CheckinResponse> checkinByQr(String qrData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/ETickets/checkin'),
        headers: headers,
        body: json.encode({'qrData': qrData}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        return CheckinResponse.fromJson(jsonBody);
      } else if (response.statusCode == 404) {
        return CheckinResponse.error('Không tìm thấy vé với mã QR này');
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        return CheckinResponse.error(
          jsonBody['message'] as String? ?? 'Mã QR không hợp lệ',
        );
      } else {
        return CheckinResponse.error('Lỗi kết nối: ${response.statusCode}');
      }
    } catch (e) {
      return CheckinResponse.error('Lỗi: ${e.toString()}');
    }
  }

  // ==================== HELPER METHODS ====================

  /// Checkin vé - tự động detect là ticketCode hay qrData
  /// Nếu là mã ticket (dạng alphanumeric ngắn) -> dùng useTicket
  /// Nếu là QR data (dạng dài, có thể là JSON hoặc URL) -> dùng checkinByQr
  static Future<CheckinResponse> checkinTicket(String code) async {
    // Nếu code ngắn và chỉ chứa chữ/số -> coi là ticketCode
    // Nếu code dài hoặc chứa ký tự đặc biệt -> coi là qrData
    final isTicketCode =
        code.length <= 20 && RegExp(r'^[A-Za-z0-9-]+$').hasMatch(code);

    if (isTicketCode) {
      return useTicket(code);
    } else {
      return checkinByQr(code);
    }
  }

  /// Lấy thông tin chi tiết vé để hiển thị (không checkin)
  static Future<TicketVerificationResult> getTicketInfoForDisplay(
    String code,
  ) async {
    // Đầu tiên thử validate
    final result = await validateTicket(code);
    if (result.ticketDetail != null) {
      return result;
    }

    // Nếu validate không trả về detail, thử lấy từ getTicketDetailByCode
    final ticketInfo = await getTicketDetailByCode(code);
    if (ticketInfo != null) {
      return TicketVerificationResult(
        isValid: !ticketInfo.isUsed,
        status: ticketInfo.isUsed ? TicketStatus.used : TicketStatus.valid,
        message: ticketInfo.isUsed ? 'Vé đã được sử dụng' : 'Vé hợp lệ',
        ticketDetail: TicketDetail(
          ticketCode: ticketInfo.ticketCode,
          movieTitle: ticketInfo.movieTitle ?? 'N/A',
          cinemaName: ticketInfo.cinemaName ?? 'N/A',
          showtime: ticketInfo.showtime ?? DateTime.now(),
          seatCode: ticketInfo.seatCode ?? 'N/A',
          screenName: ticketInfo.screenName,
          customerName: ticketInfo.customerName,
          customerEmail: ticketInfo.customerEmail,
        ),
      );
    }

    return TicketVerificationResult.error('Không tìm thấy thông tin vé');
  }
}
