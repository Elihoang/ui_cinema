import 'package:flutter/material.dart';
import '../../models/user.dart';

class ProfileStats extends StatelessWidget {
  final User user;

  const ProfileStats({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(value: user.watchedCount.toString(), label: 'Đã xem'),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.1),
              ),
              _StatItem(
                value: '${user.rewardPoints ~/ 1000}k',
                label: 'Điểm thưởng',
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.1),
              ),
              _StatItem(value: user.voucherCount.toString(), label: 'Voucher'),
            ],
          ),
        ),
        Container(
          height: 1,
          color: Colors.white.withOpacity(0.05),
          margin: const EdgeInsets.symmetric(horizontal: 24),
        ),
      ],
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
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
      ],
    );
  }
}
