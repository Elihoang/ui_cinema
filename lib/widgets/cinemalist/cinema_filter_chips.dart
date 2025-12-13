import 'package:flutter/material.dart';

class CinemaFilterChips extends StatefulWidget {
  final Function(int) onFilterSelected;

  const CinemaFilterChips({super.key, required this.onFilterSelected});

  @override
  State<CinemaFilterChips> createState() => _CinemaFilterChipsState();
}

class _CinemaFilterChipsState extends State<CinemaFilterChips> {
  int _selectedIndex = 0;
  final List<String> filters = ['Hồ Chí Minh', 'Gần nhất', 'Đánh giá cao'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(
          filters.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              selected: _selectedIndex == index,
              onSelected: (selected) {
                setState(() => _selectedIndex = index);
                widget.onFilterSelected(index);
              },
              label: Text(filters[index]),
              backgroundColor: const Color(0xFF3a1c20),
              selectedColor: const Color(0xFFec1337),
              labelStyle: TextStyle(
                color: _selectedIndex == index ? Colors.white : Colors.white,
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide(
                color: _selectedIndex == index
                    ? Colors.transparent
                    : Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
