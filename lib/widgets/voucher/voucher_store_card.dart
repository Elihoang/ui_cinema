import 'package:flutter/material.dart';
import '../../models/voucher.dart';
import '../../models/member_tier.dart';

class VoucherStoreCard extends StatelessWidget {
  final Voucher voucher;
  final int userPoints;
  final MemberTier? userTier;
  final VoidCallback onRedeem;
  final bool isRedeeming;

  const VoucherStoreCard({
    super.key,
    required this.voucher,
    required this.userPoints,
    this.userTier,
    required this.onRedeem,
    this.isRedeeming = false,
  });

  static const _accent = Color(0xFFEC1337);
  static const _surface = Color(0xFF33191E);

  bool get canRedeem {
    // Check if user has enough points
    if (userPoints < voucher.pointCost) return false;

    // Check if user meets tier requirement
    if (voucher.requiredTier != null && userTier != null) {
      final tierOrder = [
        MemberTier.bronze,
        MemberTier.silver,
        MemberTier.gold,
        MemberTier.diamond,
      ];
      final userTierIndex = tierOrder.indexOf(userTier!);
      final requiredTierIndex = tierOrder.indexOf(voucher.requiredTier!);
      if (userTierIndex < requiredTierIndex) return false;
    }

    // Check if voucher is still available
    if (!voucher.isActive) return false;
    if (voucher.usageLimit != null &&
        voucher.currentUsage >= voucher.usageLimit!)
      return false;

    return true;
  }

  String get reasonCannotRedeem {
    if (userPoints < voucher.pointCost) {
      return 'Không đủ điểm (cần ${voucher.pointCost} điểm)';
    }
    if (voucher.requiredTier != null && userTier != null) {
      final tierOrder = [
        MemberTier.bronze,
        MemberTier.silver,
        MemberTier.gold,
        MemberTier.diamond,
      ];
      final userTierIndex = tierOrder.indexOf(userTier!);
      final requiredTierIndex = tierOrder.indexOf(voucher.requiredTier!);
      if (userTierIndex < requiredTierIndex) {
        return 'Yêu cầu hạng ${voucher.requiredTier!.displayName}';
      }
    }
    if (!voucher.isActive) return 'Voucher không còn hoạt động';
    if (voucher.usageLimit != null &&
        voucher.currentUsage >= voucher.usageLimit!) {
      return 'Đã hết lượt đổi';
    }
    return '';
  }

  Color get _getTierColor {
    if (voucher.requiredTier == null) return _accent;
    switch (voucher.requiredTier!) {
      case MemberTier.bronze:
        return const Color(0xFFCD7F32);
      case MemberTier.silver:
        return const Color(0xFFC0C0C0);
      case MemberTier.gold:
        return const Color(0xFFFFD700);
      case MemberTier.diamond:
        return const Color(0xFFB9F2FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canRedeem
              ? _getTierColor.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getTierColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        voucher.code,
                        style: TextStyle(
                          color: _getTierColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (voucher.requiredTier != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getTierColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.workspace_premium,
                              size: 14,
                              color: _getTierColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              voucher.requiredTier!.displayName,
                              style: TextStyle(
                                color: _getTierColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Name
                Text(
                  voucher.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),

                // Description
                Text(
                  voucher.description,
                  style: const TextStyle(
                    color: Color(0xFFC9929B),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Discount info
                Row(
                  children: [
                    Icon(Icons.discount, color: _getTierColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      voucher.voucherType == VoucherType.percentage
                          ? 'Giảm ${voucher.discountValue.toStringAsFixed(0)}%'
                          : 'Giảm ${voucher.discountValue.toStringAsFixed(0)}đ',
                      style: TextStyle(
                        color: _getTierColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    if (voucher.maxDiscountAmount != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Tối đa ${voucher.maxDiscountAmount!.toStringAsFixed(0)}đ',
                        style: const TextStyle(
                          color: Color(0xFFC9929B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),

                // Min order
                if (voucher.minOrderAmount != null &&
                    voucher.minOrderAmount! > 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        color: Color(0xFFC9929B),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Đơn tối thiểu: ${voucher.minOrderAmount!.toStringAsFixed(0)}đ',
                        style: const TextStyle(
                          color: Color(0xFFC9929B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 12),
                const Divider(color: Color(0xFF67323B), height: 1),
                const SizedBox(height: 12),

                // Point cost and redeem button
                Row(
                  children: [
                    Icon(Icons.stars, color: _accent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${voucher.pointCost} điểm',
                      style: TextStyle(
                        color: canRedeem ? _accent : Colors.grey,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (canRedeem)
                      ElevatedButton(
                        onPressed: isRedeeming ? null : onRedeem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isRedeeming
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Đổi ngay',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          reasonCannotRedeem,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Overlay if cannot redeem
          if (!canRedeem)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
