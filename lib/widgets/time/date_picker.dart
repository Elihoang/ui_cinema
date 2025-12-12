import 'package:flutter/material.dart';
import '../../models/date_option.dart';

class DatePicker extends StatelessWidget {
  final List<DateOption> dates;
  final int selectedIndex;
  final Function(int) onDateSelected;

  const DatePicker({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final date = dates[i];
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onDateSelected(i),
            child: Container(
              width: 56,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFEC1337)
                    : const Color(0xFF2F181B),
                borderRadius: BorderRadius.circular(12),
                border: selected
                    ? null
                    : Border.all(color: const Color(0x0DFFFFFF)),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFEC1337).withOpacity(0.3),
                          blurRadius: 16,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date.label,
                    style: TextStyle(
                      color: selected ? Colors.white70 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
