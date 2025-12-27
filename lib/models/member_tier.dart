// Enum cho các cấp bậc hội viên
enum MemberTier { bronze, silver, gold, diamond }

// Extension để map từ string sang enum
extension MemberTierExtension on MemberTier {
  String get value {
    switch (this) {
      case MemberTier.bronze:
        return 'Bronze';
      case MemberTier.silver:
        return 'Silver';
      case MemberTier.gold:
        return 'Gold';
      case MemberTier.diamond:
        return 'Diamond';
    }
  }

  String get displayName {
    switch (this) {
      case MemberTier.bronze:
        return 'Đồng';
      case MemberTier.silver:
        return 'Bạc';
      case MemberTier.gold:
        return 'Vàng';
      case MemberTier.diamond:
        return 'Kim Cương';
    }
  }
}

// Parse từ string sang enum
MemberTier parseMemberTier(String tier) {
  switch (tier.toLowerCase()) {
    case 'bronze':
      return MemberTier.bronze;
    case 'silver':
      return MemberTier.silver;
    case 'gold':
      return MemberTier.gold;
    case 'diamond':
      return MemberTier.diamond;
    default:
      return MemberTier.bronze;
  }
}

// Model cho cấu hình tier
class MemberTierConfig {
  final String id;
  final MemberTier tier;
  final String name;
  final double minPoints;
  final double maxPoints;
  final double pointMultiplier;
  final double discountPercentage;
  final String? color;
  final String? iconUrl;
  final String? description;
  final List<String> benefits;
  final DateTime createdAt;
  final DateTime updatedAt;

  MemberTierConfig({
    required this.id,
    required this.tier,
    required this.name,
    required this.minPoints,
    required this.maxPoints,
    required this.pointMultiplier,
    required this.discountPercentage,
    this.color,
    this.iconUrl,
    this.description,
    required this.benefits,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MemberTierConfig.fromJson(Map<String, dynamic> json) {
    return MemberTierConfig(
      id: json['id'] as String? ?? '',
      tier: parseMemberTier((json['tier'] as String?) ?? 'Bronze'),
      name: json['name'] as String? ?? '',
      minPoints: (json['minPoints'] as num?)?.toDouble() ?? 0,
      maxPoints: (json['maxPoints'] as num?)?.toDouble() ?? 999999,
      pointMultiplier: (json['pointMultiplier'] as num?)?.toDouble() ?? 1.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String?,
      iconUrl: json['iconUrl'] as String?,
      description: json['description'] as String?,
      benefits:
          (json['benefits'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
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
      'tier': tier.value,
      'name': name,
      'minPoints': minPoints,
      'maxPoints': maxPoints,
      'pointMultiplier': pointMultiplier,
      'discountPercentage': discountPercentage,
      'color': color,
      'iconUrl': iconUrl,
      'description': description,
      'benefits': benefits,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
