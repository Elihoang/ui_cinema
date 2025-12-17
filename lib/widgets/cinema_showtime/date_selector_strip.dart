import 'package:flutter/material.dart';

class DateSelectorStrip extends StatelessWidget {
  final List<DateItem> dates;
  final int selectedIndex;
  final Function(int) onDateSelected;

  const DateSelectorStrip({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = index == selectedIndex;
          return DateItemWidget(
            date: date,
            isSelected: isSelected,
            onTap: () => onDateSelected(index),
          );
        },
      ),
    );
  }
}

class DateItem {
  final String dayOfWeek;
  final String dayNumber;

  DateItem({required this.dayOfWeek, required this.dayNumber});
}

class DateItemWidget extends StatelessWidget {
  final DateItem date;
  final bool isSelected;
  final VoidCallback onTap;

  const DateItemWidget({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 72,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFec1337) : const Color(0xFF482329),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.transparent,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFec1337).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.dayOfWeek,
              style: TextStyle(
                color: isSelected
                    ? Colors.white.withOpacity(0.9)
                    : const Color(0xFFc9929b),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              date.dayNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
