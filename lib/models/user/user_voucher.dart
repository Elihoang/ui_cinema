import 'voucher.dart';

// Enum cho trạng thái user voucher
enum VoucherStatus { available, used, expired }

extension VoucherStatusExtension on VoucherStatus {
  String get value {
    switch (this) {
      case VoucherStatus.available:
        return 'Available';
      case VoucherStatus.used:
        return 'Used';
      case VoucherStatus.expired:
        return 'Expired';
    }
  }

  String get displayName {
    switch (this) {
      case VoucherStatus.available:
        return 'Có thể sử dụng';
      case VoucherStatus.used:
        return 'Đã sử dụng';
      case VoucherStatus.expired:
        return 'Đã hết hạn';
    }
  }
}

VoucherStatus parseVoucherStatus(String status) {
  switch (status.toLowerCase()) {
    case 'available':
      return VoucherStatus.available;
    case 'used':
      return VoucherStatus.used;
    case 'expired':
      return VoucherStatus.expired;
    default:
      return VoucherStatus.available;
  }
}

// Model cho UserVoucher (voucher mà user đã đổi)
class UserVoucher {
  final String id;
  final String userId;
  final String voucherId;
  final Voucher? voucher; // Populated từ API nếu có include
  final VoucherStatus status;
  final DateTime? redeemedAt;
  final DateTime? usedAt;
  final String? orderId;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserVoucher({
    required this.id,
    required this.userId,
    required this.voucherId,
    this.voucher,
    required this.status,
    this.redeemedAt,
    this.usedAt,
    this.orderId,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserVoucher.fromJson(Map<String, dynamic> json) {
    // Calculate status from isUsed and isExpired
    VoucherStatus calculateStatus() {
      final isUsed = json['isUsed'] as bool? ?? false;
      final isExpired = json['isExpired'] as bool? ?? false;

      if (isUsed) return VoucherStatus.used;
      if (isExpired) return VoucherStatus.expired;
      return VoucherStatus.available;
    }

    // Build voucher object from flat fields if voucher object not present
    Voucher? buildVoucher() {
      // If voucher object exists, use it
      if (json['voucher'] != null) {
        return Voucher.fromJson(json['voucher'] as Map<String, dynamic>);
      }

      // Otherwise build from flat fields
      if (json['voucherCode'] != null) {
        return Voucher.fromJson({
          'id': json['voucherId'],
          'code': json['voucherCode'],
          'name': json['voucherName'] ?? '',
          'description': json['voucherDescription'] ?? '',
          'voucherType': json['voucherType'] ?? 'FixedAmount',
          'discountValue': json['discountValue'] ?? 0,
          'maxDiscountAmount': json['maxDiscountAmount'],
          'minOrderAmount': json['minOrderAmount'] ?? 0,
          'pointCost': 0, // Not provided in this response
          'requiredTier': null,
          'validFrom': json['redeemedAt'] ?? DateTime.now().toIso8601String(),
          'validTo':
              json['voucherValidTo'] ??
              json['expiresAt'] ??
              DateTime.now().add(Duration(days: 30)).toIso8601String(),
          'usageLimit': null,
          'currentUsage': 0,
          'isActive': !(json['isExpired'] as bool? ?? false),
          'createdAt': json['createdAt'] ?? DateTime.now().toIso8601String(),
          'updatedAt': json['createdAt'] ?? DateTime.now().toIso8601String(),
        });
      }

      return null;
    }

    return UserVoucher(
      id: (json['id'] as String?) ?? '',
      userId: (json['userId'] as String?) ?? '',
      voucherId: (json['voucherId'] as String?) ?? '',
      voucher: buildVoucher(),
      status: calculateStatus(),
      redeemedAt: json['redeemedAt'] != null
          ? DateTime.parse(json['redeemedAt'] as String)
          : null,
      usedAt: json['usedAt'] != null
          ? DateTime.parse(json['usedAt'] as String)
          : null,
      orderId: json['orderId'] as String?,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : DateTime.now().add(const Duration(days: 30)),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : (json['createdAt'] != null
                ? DateTime.parse(json['createdAt'] as String)
                : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'voucherId': voucherId,
      'voucher': voucher?.toJson(),
      'status': status.value,
      'redeemedAt': redeemedAt?.toIso8601String(),
      'usedAt': usedAt?.toIso8601String(),
      'orderId': orderId,
      'expiresAt': expiresAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper method để kiểm tra có thể dùng không
  bool get canUse {
    final now = DateTime.now();
    return status == VoucherStatus.available && now.isBefore(expiresAt);
  }
}

// DTO cho việc redeem voucher
class RedeemVoucherDto {
  final String voucherId;

  RedeemVoucherDto({required this.voucherId});

  Map<String, dynamic> toJson() {
    return {'voucherId': voucherId};
  }
}
