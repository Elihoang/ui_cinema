import 'package:flutter/material.dart';
import '../../models/movie_detail.dart';

class CustomTabBarDelegate extends SliverPersistentHeaderDelegate {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final int reviewCount;
  List<String> get tabs => [
    'Thông tin',
    'Suất chiếu',
    'Đánh giá${reviewCount > 0 ? ' ($reviewCount)' : ''}',
  ];

  CustomTabBarDelegate({
    required this.selectedIndex,
    required this.onTabSelected,
    required this.reviewCount,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: maxExtent,
      color: const Color(0xFF221013).withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            int index = entry.key;
            String tab = entry.value;
            bool isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                margin: const EdgeInsets.only(right: 24),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? const Color(0xFFEC1337)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFFEC1337)
                        : Colors.grey.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 48;
  @override
  double get minExtent => 48;
  @override
  bool shouldRebuild(covariant CustomTabBarDelegate old) =>
      selectedIndex != old.selectedIndex;
}
