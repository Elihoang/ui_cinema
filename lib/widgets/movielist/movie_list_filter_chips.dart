import 'package:flutter/material.dart';

class MovieListFilterChips extends StatefulWidget {
  const MovieListFilterChips({super.key});

  @override
  State<MovieListFilterChips> createState() => _MovieListFilterChipsState();
}

class _MovieListFilterChipsState extends State<MovieListFilterChips> {
  String selectedFilter = 'Tất cả';

  final List<String> filters = [
    'Tất cả',
    'Sắp chiếu',
    'Đánh giá cao',
    'Hành động',
    'Kinh dị',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFec1337)
                    : const Color(0xFF361b20),
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[400],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
