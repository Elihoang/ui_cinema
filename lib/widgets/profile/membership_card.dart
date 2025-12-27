import 'package:flutter/material.dart';
import '../../models/member_point.dart';
import '../../models/member_tier.dart';

class MembershipCard extends StatelessWidget {
  final MemberPoint? memberPoint;
  final VoidCallback? onTap;

  const MembershipCard({super.key, this.memberPoint, this.onTap});

  Color _getTierColor(MemberTier tier) {
    switch (tier) {
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

  IconData _getTierIcon(MemberTier tier) {
    switch (tier) {
      case MemberTier.bronze:
        return Icons.workspace_premium;
      case MemberTier.silver:
        return Icons.military_tech;
      case MemberTier.gold:
        return Icons.emoji_events;
      case MemberTier.diamond:
        return Icons.diamond;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (memberPoint == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF33191E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF67323B)),
        ),
        child: const Center(
          child: Text(
            'Chưa có thông tin hội viên',
            style: TextStyle(color: Color(0xFFC9929B)),
          ),
        ),
      );
    }

    final tierColor = _getTierColor(memberPoint!.currentTier);
    final tierIcon = _getTierIcon(memberPoint!.currentTier);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [tierColor.withOpacity(0.3), tierColor.withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tierColor.withOpacity(0.5), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tierColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(tierIcon, color: tierColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memberPoint!.currentTier.displayName,
                        style: TextStyle(
                          color: tierColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'Hạng thành viên',
                        style: TextStyle(
                          color: Color(0xFFC9929B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: tierColor),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Điểm hiện tại',
                    '${memberPoint!.currentPoints}',
                    tierColor,
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: tierColor.withOpacity(0.3),
                  ),
                  _buildStatItem(
                    'Tổng tích lũy',
                    '${memberPoint!.lifetimePoints}',
                    tierColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFC9929B), fontSize: 11),
        ),
      ],
    );
  }
}
