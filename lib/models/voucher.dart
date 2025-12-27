import 'member_tier.dart';

// Enum cho loại voucher
enum VoucherType { percentage, fixedAmount }

extension VoucherTypeExtension on VoucherType {
  String get value {
    switch (this) {
      case VoucherType.percentage:
        return 'Percentage';
      case VoucherType.fixedAmount:
        return 'FixedAmount';
    }
  }

  String get displayName {
    switch (this) {
      case VoucherType.percentage:
        return 'Phần trăm';
      case VoucherType.fixedAmount:
        return 'Số tiền cố định';
    }
  }
}

VoucherType parseVoucherType(String type) {
  switch (type.toLowerCase()) {
    case 'percentage':
      return VoucherType.percentage;
    case 'fixedamount':
      return VoucherType.fixedAmount;
    default:
      return VoucherType.fixedAmount;
  }
}

// Model cho Voucher
class Voucher {
  final String id;
  final String code;
  final String name;
  final String description;
  final VoucherType voucherType;
  final double discountValue;
  final double? maxDiscountAmount;
  final double? minOrderAmount;
  final int pointCost;
  final MemberTier? requiredTier;
  final DateTime validFrom;
  final DateTime validTo;
  final int? usageLimit;
  final int currentUsage;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Voucher({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.voucherType,
    required this.discountValue,
    this.maxDiscountAmount,
    this.minOrderAmount,
    required this.pointCost,
    this.requiredTier,
    required this.validFrom,
    required this.validTo,
    this.usageLimit,
    required this.currentUsage,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: (json['id'] as String?) ?? '',
      code: (json['code'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      // Backend uses 'type', frontend uses 'voucherType'
      voucherType: parseVoucherType(
        json['type'] as String? ??
            json['voucherType'] as String? ??
            'FixedAmount',
      ),
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0,
      maxDiscountAmount: json['maxDiscountAmount'] != null
          ? (json['maxDiscountAmount'] as num).toDouble()
          : null,
      minOrderAmount: json['minOrderAmount'] != null
          ? (json['minOrderAmount'] as num).toDouble()
          : null,
      // Backend uses 'pointsRequired', frontend uses 'pointCost'
      pointCost:
          json['pointsRequired'] as int? ?? json['pointCost'] as int? ?? 0,
      // Backend uses 'minTier', frontend uses 'requiredTier'
      requiredTier: (json['minTier'] ?? json['requiredTier']) != null
          ? parseMemberTier(
              json['minTier'] as String? ??
                  json['requiredTier'] as String? ??
                  'Bronze',
            )
          : null,
      validFrom: json['validFrom'] != null
          ? DateTime.parse(json['validFrom'] as String)
          : DateTime.now(),
      validTo: json['validTo'] != null
          ? DateTime.parse(json['validTo'] as String)
          : DateTime.now().add(const Duration(days: 30)),
      usageLimit: json['quantity'] as int? ?? json['usageLimit'] as int?,
      currentUsage:
          json['quantityRedeemed'] as int? ?? json['currentUsage'] as int? ?? 0,
      isActive:
          (json['status'] == 'Active') || (json['isActive'] as bool? ?? false),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'voucherType': voucherType.value,
      'discountValue': discountValue,
      'maxDiscountAmount': maxDiscountAmount,
      'minOrderAmount': minOrderAmount,
      'pointCost': pointCost,
      'requiredTier': requiredTier?.value,
      'validFrom': validFrom.toIso8601String(),
      'validTo': validTo.toIso8601String(),
      'usageLimit': usageLimit,
      'currentUsage': currentUsage,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper method để kiểm tra voucher còn hạn không
  bool get isValid {
    final now = DateTime.now();
    return isActive &&
        now.isAfter(validFrom) &&
        now.isBefore(validTo) &&
        (usageLimit == null || currentUsage < usageLimit!);
  }

  // Helper method để tính discount amount
  double calculateDiscount(double orderAmount) {
    if (voucherType == VoucherType.percentage) {
      final discount = orderAmount * (discountValue / 100);
      if (maxDiscountAmount != null && discount > maxDiscountAmount!) {
        return maxDiscountAmount!;
      }
      return discount;
    } else {
      return discountValue;
    }
  }
}
