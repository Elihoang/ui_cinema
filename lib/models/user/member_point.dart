import 'member_tier.dart';

// Model cho MemberPoint (điểm hội viên của user)
class MemberPoint {
  final String id;
  final String userId;
  final MemberTier currentTier;
  final int currentPoints;
  final int lifetimePoints;
  final DateTime? lastPointEarned;
  final DateTime createdAt;
  final DateTime updatedAt;

  MemberPoint({
    required this.id,
    required this.userId,
    required this.currentTier,
    required this.currentPoints,
    required this.lifetimePoints,
    this.lastPointEarned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MemberPoint.fromJson(Map<String, dynamic> json) {
    return MemberPoint(
      id: json['id'] as String,
      userId: json['userId'] as String,
      // Backend returns 'tier' not 'currentTier'
      currentTier: parseMemberTier(
        json['tier'] as String? ?? json['currentTier'] as String? ?? 'Bronze',
      ),
      // Backend returns 'points' not 'currentPoints'
      currentPoints:
          (json['points'] as int? ?? json['currentPoints'] as int? ?? 0),
      lifetimePoints: json['lifetimePoints'] as int,
      lastPointEarned: json['lastPointEarned'] != null
          ? DateTime.parse(json['lastPointEarned'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'currentTier': currentTier.value,
      'currentPoints': currentPoints,
      'lifetimePoints': lifetimePoints,
      'lastPointEarned': lastPointEarned?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// Enum cho loại giao dịch điểm
enum PointTransactionType { earn, redeem, expire, adjust }

extension PointTransactionTypeExtension on PointTransactionType {
  String get value {
    switch (this) {
      case PointTransactionType.earn:
        return 'Earn';
      case PointTransactionType.redeem:
        return 'Redeem';
      case PointTransactionType.expire:
        return 'Expire';
      case PointTransactionType.adjust:
        return 'Adjust';
    }
  }

  String get displayName {
    switch (this) {
      case PointTransactionType.earn:
        return 'Tích điểm';
      case PointTransactionType.redeem:
        return 'Đổi điểm';
      case PointTransactionType.expire:
        return 'Hết hạn';
      case PointTransactionType.adjust:
        return 'Điều chỉnh';
    }
  }
}

PointTransactionType parsePointTransactionType(String type) {
  switch (type.toLowerCase()) {
    case 'earn':
      return PointTransactionType.earn;
    case 'redeem':
      return PointTransactionType.redeem;
    case 'expire':
      return PointTransactionType.expire;
    case 'adjust':
      return PointTransactionType.adjust;
    default:
      return PointTransactionType.earn;
  }
}

// Model cho lịch sử điểm
class PointHistory {
  final String id;
  final String userId;
  final PointTransactionType transactionType;
  final int pointsChanged;
  final int pointsAfter;
  final String? orderId;
  final String? voucherId;
  final String? description;
  final DateTime createdAt;

  PointHistory({
    required this.id,
    required this.userId,
    required this.transactionType,
    required this.pointsChanged,
    required this.pointsAfter,
    this.orderId,
    this.voucherId,
    this.description,
    required this.createdAt,
  });

  factory PointHistory.fromJson(Map<String, dynamic> json) {
    return PointHistory(
      id: json['id'] as String,
      userId: json['userId'] as String,
      transactionType: parsePointTransactionType(
        json['transactionType'] as String,
      ),
      pointsChanged: json['pointsChanged'] as int,
      pointsAfter: json['pointsAfter'] as int,
      orderId: json['orderId'] as String?,
      voucherId: json['voucherId'] as String?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'transactionType': transactionType.value,
      'pointsChanged': pointsChanged,
      'pointsAfter': pointsAfter,
      'orderId': orderId,
      'voucherId': voucherId,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
