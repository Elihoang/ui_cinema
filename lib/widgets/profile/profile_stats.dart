import 'package:flutter/material.dart';
import '../../models/user.dart';

class ProfileStats extends StatelessWidget {
  final User user;

  const ProfileStats({super.key, required this.user});

  static const _card = Color(0xFF2A1014);
  static const _border = Color(0xFF351A1E);

  @override
  Widget build(BuildContext context) {
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
              value: '${user.rewardPoints ~/ 1000}k',
              label: 'Điểm thưởng',
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.08),
            ),
            _StatItem(value: user.voucherCount.toString(), label: 'Voucher'),
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
