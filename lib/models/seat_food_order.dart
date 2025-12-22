/// DTO để tạo đơn hàng đồ ăn/nước uống từ ghế ngồi trong rạp qua QR code
class SeatFoodOrderCreateDto {
  /// Mã QR ordering của ghế (6 ký tự, được in trên ghế)
  final String seatQrCode;

  /// Danh sách sản phẩm (đồ ăn, nước uống) cần order
  final List<SeatFoodOrderItemDto> items;

  /// Ghi chú đặc biệt (ít đá, không đường, v.v.)
  final String? note;

  /// User ID (nếu đã đăng nhập)
  final String? userId;

  /// Phương thức thanh toán: MOMO, CASH, CARD
  final String paymentMethod;

  SeatFoodOrderCreateDto({
    required this.seatQrCode,
    required this.items,
    this.note,
    this.userId,
    this.paymentMethod = 'MOMO',
  });

  Map<String, dynamic> toJson() {
    return {
      'seatQrCode': seatQrCode,
      'items': items.map((e) => e.toJson()).toList(),
      'note': note,
      'userId': userId,
      'paymentMethod': paymentMethod,
    };
  }
}

/// Chi tiết sản phẩm trong đơn hàng đồ ăn
class SeatFoodOrderItemDto {
  /// ID sản phẩm
  final String productId;

  /// Số lượng
  final int quantity;

  /// Ghi chú riêng cho sản phẩm này
  final String? itemNote;

  SeatFoodOrderItemDto({
    required this.productId,
    required this.quantity,
    this.itemNote,
  });

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity, 'itemNote': itemNote};
  }

  factory SeatFoodOrderItemDto.fromJson(Map<String, dynamic> json) {
    return SeatFoodOrderItemDto(
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      itemNote: json['itemNote'] as String?,
    );
  }
}

/// Response khi tạo đơn hàng đồ ăn từ ghế thành công
class SeatFoodOrderResponseDto {
  final String orderId;
  final String orderCode;
  final String status;
  final double totalAmount;
  final int estimatedDeliveryMinutes;
  final SeatDeliveryInfoDto seatInfo;
  final ShowingMovieInfoDto showingMovie;
  final List<SeatFoodOrderItemDetailDto> items;
  final SeatFoodPaymentInfoDto? paymentInfo;
  final DateTime orderTime;
  final String message;

  SeatFoodOrderResponseDto({
    required this.orderId,
    required this.orderCode,
    required this.status,
    required this.totalAmount,
    required this.estimatedDeliveryMinutes,
    required this.seatInfo,
    required this.showingMovie,
    required this.items,
    this.paymentInfo,
    required this.orderTime,
    required this.message,
  });

  factory SeatFoodOrderResponseDto.fromJson(Map<String, dynamic> json) {
    return SeatFoodOrderResponseDto(
      orderId: json['orderId'] as String,
      orderCode: json['orderCode'] as String,
      status: json['status'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      estimatedDeliveryMinutes: json['estimatedDeliveryMinutes'] as int,
      seatInfo: SeatDeliveryInfoDto.fromJson(json['seatInfo']),
      showingMovie: ShowingMovieInfoDto.fromJson(json['showingMovie']),
      items: (json['items'] as List)
          .map((e) => SeatFoodOrderItemDetailDto.fromJson(e))
          .toList(),
      paymentInfo: json['paymentInfo'] != null
          ? SeatFoodPaymentInfoDto.fromJson(json['paymentInfo'])
          : null,
      orderTime: DateTime.parse(json['orderTime']),
      message: json['message'] as String,
    );
  }
}

/// Thông tin ghế để giao hàng
class SeatDeliveryInfoDto {
  final String seatCode;
  final String seatRow;
  final int seatNumber;
  final String screenName;
  final String cinemaName;

  SeatDeliveryInfoDto({
    required this.seatCode,
    required this.seatRow,
    required this.seatNumber,
    required this.screenName,
    required this.cinemaName,
  });

  factory SeatDeliveryInfoDto.fromJson(Map<String, dynamic> json) {
    return SeatDeliveryInfoDto(
      seatCode: json['seatCode'] as String,
      seatRow: json['seatRow'] as String,
      seatNumber: json['seatNumber'] as int,
      screenName: json['screenName'] as String,
      cinemaName: json['cinemaName'] as String,
    );
  }
}

/// Thông tin phim đang chiếu
class ShowingMovieInfoDto {
  final String showtimeId;
  final String movieTitle;
  final DateTime startTime;
  final DateTime endTime;
  final int remainingMinutes;

  ShowingMovieInfoDto({
    required this.showtimeId,
    required this.movieTitle,
    required this.startTime,
    required this.endTime,
    required this.remainingMinutes,
  });

  factory ShowingMovieInfoDto.fromJson(Map<String, dynamic> json) {
    return ShowingMovieInfoDto(
      showtimeId: json['showtimeId'] as String,
      movieTitle: json['movieTitle'] as String,
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      remainingMinutes: json['remainingMinutes'] as int,
    );
  }
}

/// Chi tiết từng sản phẩm đã order
class SeatFoodOrderItemDetailDto {
  final String productId;
  final String productName;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;
  final double subTotal;
  final String? itemNote;

  SeatFoodOrderItemDetailDto({
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.subTotal,
    this.itemNote,
  });

  factory SeatFoodOrderItemDetailDto.fromJson(Map<String, dynamic> json) {
    return SeatFoodOrderItemDetailDto(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      imageUrl: json['imageUrl'] as String?,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      subTotal: (json['subTotal'] as num).toDouble(),
      itemNote: json['itemNote'] as String?,
    );
  }
}

/// Thông tin thanh toán
class SeatFoodPaymentInfoDto {
  final String paymentMethod;
  final String paymentStatus;
  final String? payUrl;
  final String? deeplink;
  final String? qrCodeUrl;
  final String? transactionId;

  SeatFoodPaymentInfoDto({
    required this.paymentMethod,
    required this.paymentStatus,
    this.payUrl,
    this.deeplink,
    this.qrCodeUrl,
    this.transactionId,
  });

  factory SeatFoodPaymentInfoDto.fromJson(Map<String, dynamic> json) {
    return SeatFoodPaymentInfoDto(
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: json['paymentStatus'] as String,
      payUrl: json['payUrl'] as String?,
      deeplink: json['deeplink'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      transactionId: json['transactionId'] as String?,
    );
  }
}

/// Response khi kiểm tra thông tin ghế
class SeatInfoResponseDto {
  final bool isValid;
  final String? errorMessage;
  final SeatDeliveryInfoDto? seatInfo;
  final ShowingMovieInfoDto? showingMovie;
  final bool canOrderFood;
  final int minRemainingMinutesToOrder;

  SeatInfoResponseDto({
    required this.isValid,
    this.errorMessage,
    this.seatInfo,
    this.showingMovie,
    required this.canOrderFood,
    this.minRemainingMinutesToOrder = 15,
  });

  factory SeatInfoResponseDto.fromJson(Map<String, dynamic> json) {
    return SeatInfoResponseDto(
      isValid: json['isValid'] as bool,
      errorMessage: json['errorMessage'] as String?,
      seatInfo: json['seatInfo'] != null
          ? SeatDeliveryInfoDto.fromJson(json['seatInfo'])
          : null,
      showingMovie: json['showingMovie'] != null
          ? ShowingMovieInfoDto.fromJson(json['showingMovie'])
          : null,
      canOrderFood: json['canOrderFood'] as bool,
      minRemainingMinutesToOrder:
          json['minRemainingMinutesToOrder'] as int? ?? 15,
    );
  }
}

/// DTO để theo dõi trạng thái đơn hàng đồ ăn
class SeatFoodOrderStatusDto {
  final String orderId;
  final String orderCode;
  final String status;
  final String statusDescription;
  final int? estimatedMinutesRemaining;
  final DateTime lastUpdated;

  SeatFoodOrderStatusDto({
    required this.orderId,
    required this.orderCode,
    required this.status,
    required this.statusDescription,
    this.estimatedMinutesRemaining,
    required this.lastUpdated,
  });

  factory SeatFoodOrderStatusDto.fromJson(Map<String, dynamic> json) {
    return SeatFoodOrderStatusDto(
      orderId: json['orderId'] as String,
      orderCode: json['orderCode'] as String,
      status: json['status'] as String,
      statusDescription: json['statusDescription'] as String,
      estimatedMinutesRemaining: json['estimatedMinutesRemaining'] as int?,
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
