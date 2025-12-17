import 'package:flutter/material.dart';

class ShowtimeFilterChips extends StatelessWidget {
  final List<ShowtimeFilter> filters;
  final List<int> selectedIndices;
  final Function(int) onFilterToggled;

  const ShowtimeFilterChips({
    super.key,
    required this.filters,
    required this.selectedIndices,
    required this.onFilterToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedIndices.contains(index);
          return ShowtimeFilterChipItem(
            filter: filter,
            isSelected: isSelected,
            onTap: () => onFilterToggled(index),
          );
        },
      ),
    );
  }
}

class ShowtimeFilter {
  final IconData icon;
  final String label;

  ShowtimeFilter({required this.icon, required this.label});
}

class ShowtimeFilterChipItem extends StatelessWidget {
  final ShowtimeFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  const ShowtimeFilterChipItem({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF482329) : const Color(0xFF2f1b1e),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(isSelected ? 0.1 : 0.05),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              filter.icon,
              color: isSelected
                  ? const Color(0xFFec1337)
                  : const Color(0xFFc9929b),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              filter.label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFc9929b),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
