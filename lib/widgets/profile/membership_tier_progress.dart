import 'package:flutter/material.dart';
import '../../models/member_tier.dart';
import '../../models/member_point.dart';
import '../../services/membership_service.dart';

class MembershipTierProgress extends StatefulWidget {
  final MemberPoint memberPoint;

  const MembershipTierProgress({super.key, required this.memberPoint});

  @override
  State<MembershipTierProgress> createState() => _MembershipTierProgressState();
}

class _MembershipTierProgressState extends State<MembershipTierProgress> {
  List<MemberTierConfig> _tierConfigs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print(
      '[MembershipTierProgress] Widget initialized for tier: ${widget.memberPoint.currentTier.displayName}',
    );
    _loadTierConfigs();
  }

  Future<void> _loadTierConfigs() async {
    try {
      print('[MembershipTierProgress] Loading tier configs...');
      final configs = await MembershipService.getAllTiers();
      print('[MembershipTierProgress] Loaded ${configs.length} tier configs');
      // Sort by minPoints ascending
      configs.sort((a, b) => a.minPoints.compareTo(b.minPoints));
      setState(() {
        _tierConfigs = configs;
        _isLoading = false;
      });
    } catch (e) {
      print('[MembershipTierProgress] Error loading tier configs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Tier colors
  Color _getTierColor(MemberTier tier) {
    switch (tier) {
      case MemberTier.bronze:
        return const Color(0xFFCD7F32);
      case MemberTier.silver:
        return const Color(0xFFC0C0C0);
      case MemberTier.gold:
        return const Color(0xFFFFD700);
      case MemberTier.diamond:
        return const Color(0xFF00D9FF);
    }
  }

  // Get tier config by tier
  MemberTierConfig? _getTierConfig(MemberTier tier) {
    try {
      return _tierConfigs.firstWhere((config) => config.tier == tier);
    } catch (e) {
      return null;
    }
  }

  // Calculate progress percentage
  double _calculateProgress() {
    if (_tierConfigs.isEmpty) return 0;

    final currentTier = widget.memberPoint.currentTier;
    final currentPoints = widget.memberPoint.lifetimePoints;

    // Find current tier index
    final currentTierIndex = _tierConfigs.indexWhere(
      (c) => c.tier == currentTier,
    );
    if (currentTierIndex == -1) return 0;

    // If already at max tier
    if (currentTierIndex >= _tierConfigs.length - 1) {
      return 1.0;
    }

    final currentThreshold = _tierConfigs[currentTierIndex].minPoints;
    final nextThreshold = _tierConfigs[currentTierIndex + 1].minPoints;

    final progress =
        (currentPoints - currentThreshold) / (nextThreshold - currentThreshold);
    return progress.clamp(0.0, 1.0);
  }

  // Get next tier info
  Map<String, dynamic> _getNextTierInfo() {
    if (_tierConfigs.isEmpty) {
      return {
        'tier': widget.memberPoint.currentTier,
        'pointsNeeded': 0,
        'isMax': true,
      };
    }

    final currentTier = widget.memberPoint.currentTier;
    final currentPoints = widget.memberPoint.lifetimePoints;

    final currentTierIndex = _tierConfigs.indexWhere(
      (c) => c.tier == currentTier,
    );
    if (currentTierIndex == -1 || currentTierIndex >= _tierConfigs.length - 1) {
      return {'tier': currentTier, 'pointsNeeded': 0, 'isMax': true};
    }

    final nextTier = _tierConfigs[currentTierIndex + 1];
    final pointsNeeded = nextTier.minPoints - currentPoints;

    return {
      'tier': nextTier.tier,
      'pointsNeeded': pointsNeeded > 0 ? pointsNeeded : 0,
      'isMax': false,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFFEC1337)),
        ),
      );
    }

    if (_tierConfigs.isEmpty) {
      return const SizedBox.shrink();
    }

    final progress = _calculateProgress();
    final nextTierInfo = _getNextTierInfo();
    final currentTierIndex = _tierConfigs.indexWhere(
      (c) => c.tier == widget.memberPoint.currentTier,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF33191E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hạng thành viên',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getTierColor(
                    widget.memberPoint.currentTier,
                  ).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getTierColor(widget.memberPoint.currentTier),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  widget.memberPoint.currentTier.displayName,
                  style: TextStyle(
                    color: _getTierColor(widget.memberPoint.currentTier),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Tier progression bar
          Stack(
            children: [
              // Background track
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              // Progress bar
              FractionallySizedBox(
                widthFactor:
                    ((currentTierIndex + progress) / (_tierConfigs.length - 1))
                        .clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getTierColor(widget.memberPoint.currentTier),
                        _getTierColor(
                          widget.memberPoint.currentTier,
                        ).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: _getTierColor(
                          widget.memberPoint.currentTier,
                        ).withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tier nodes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _tierConfigs.map((config) {
              final tierIndex = _tierConfigs.indexOf(config);
              final isAchieved = tierIndex <= currentTierIndex;
              final isCurrent = config.tier == widget.memberPoint.currentTier;

              return Expanded(
                child: Column(
                  children: [
                    // Node
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isAchieved
                            ? _getTierColor(config.tier)
                            : Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent
                              ? _getTierColor(config.tier)
                              : (isAchieved
                                    ? _getTierColor(
                                        config.tier,
                                      ).withOpacity(0.5)
                                    : Colors.white.withOpacity(0.3)),
                          width: isCurrent ? 3 : 2,
                        ),
                        boxShadow: isAchieved
                            ? [
                                BoxShadow(
                                  color: _getTierColor(
                                    config.tier,
                                  ).withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: isAchieved
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            )
                          : null,
                    ),

                    const SizedBox(height: 8),

                    // Tier name
                    Text(
                      config.tier.displayName.toUpperCase(),
                      style: TextStyle(
                        color: isAchieved
                            ? _getTierColor(config.tier)
                            : Colors.white.withOpacity(0.5),
                        fontSize: 10,
                        fontWeight: isCurrent
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 4),

                    // Points threshold
                    Text(
                      '${config.minPoints.toInt()}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Current points and next tier info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.stars,
                  color: _getTierColor(widget.memberPoint.currentTier),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Điểm tích lũy: ${widget.memberPoint.lifetimePoints.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nextTierInfo['isMax']
                            ? 'Bạn đã đạt hạng cao nhất! 🎉'
                            : 'Cần thêm ${nextTierInfo['pointsNeeded']} điểm để lên ${(nextTierInfo['tier'] as MemberTier).displayName}',
                        style: TextStyle(
                          color: nextTierInfo['isMax']
                              ? const Color(0xFF34D399)
                              : const Color(0xFFC9929B),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
