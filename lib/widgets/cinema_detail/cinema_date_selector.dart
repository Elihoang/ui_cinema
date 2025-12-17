import 'package:flutter/material.dart';

class DateItem {
  final String dayOfWeek;
  final String date;
  final bool isSelected;

  DateItem({
    required this.dayOfWeek,
    required this.date,
    this.isSelected = false,
  });
}

class CinemaDateSelector extends StatelessWidget {
  final List<DateItem> dates;
  final Function(int) onDateSelected;

  const CinemaDateSelector({
    super.key,
    required this.dates,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF67323B).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(dates.length, (index) {
            final date = dates[index];
            return GestureDetector(
              onTap: () => onDateSelected(index),
              child: Container(
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: date.isSelected
                          ? const Color(0xFFEC1337)
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      date.dayOfWeek,
                      style: TextStyle(
                        color: date.isSelected
                            ? const Color(0xFFC9929B)
                            : const Color(0xFFC9929B).withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date.date,
                      style: TextStyle(
                        color: date.isSelected
                            ? const Color(0xFFEC1337)
                            : Colors.white.withOpacity(0.8),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
