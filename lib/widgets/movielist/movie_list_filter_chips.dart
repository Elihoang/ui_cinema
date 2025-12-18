import 'package:flutter/material.dart';

class MovieListFilterChips extends StatefulWidget {
  final Function(String) onFilterChanged;

  const MovieListFilterChips({super.key, required this.onFilterChanged});

  @override
  State<MovieListFilterChips> createState() => _MovieListFilterChipsState();
}

class _MovieListFilterChipsState extends State<MovieListFilterChips> {
  String selectedFilter = 'Tất cả';

  final List<String> filters = [
    'Tất cả',
    'Đánh giá cao',
    'Hành động',
    'Kinh dị',
  ];

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });
    widget.onFilterChanged(filter);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return Padding(
            padding: EdgeInsets.only(
              right: index < filters.length - 1 ? 12 : 0,
            ),
            child: GestureDetector(
              onTap: () => _onFilterSelected(filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFec1337)
                      : const Color(0xFF3a1c20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFec1337)
                        : Colors.white.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
