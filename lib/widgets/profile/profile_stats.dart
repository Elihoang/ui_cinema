import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/member_point.dart';

class ProfileStats extends StatelessWidget {
  final User user;
  final MemberPoint? memberPoint;
  final int availableVoucherCount;

  const ProfileStats({
    super.key,
    required this.user,
    this.memberPoint,
    this.availableVoucherCount = 0,
  });

  static const _card = Color(0xFF2A1014);
  static const _border = Color(0xFF351A1E);

  @override
  Widget build(BuildContext context) {
    // Format points (e.g., 1500 -> "1.5k", 700 -> "700")
    String formatPoints(int points) {
      if (points >= 1000) {
        return '${(points / 1000).toStringAsFixed(1)}k';
      }
      return points.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border.withOpacity(0.8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(value: user.watchedCount.toString(), label: 'Đã xem'),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.08),
            ),
            _StatItem(
              value: formatPoints(memberPoint?.lifetimePoints ?? 0),
              label: 'Điểm thưởng',
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.08),
            ),
            _StatItem(
              value: availableVoucherCount.toString(),
              label: 'Voucher',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
