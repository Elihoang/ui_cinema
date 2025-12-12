import 'package:flutter/material.dart';

class GenreChips extends StatefulWidget {
  const GenreChips({super.key});

  @override
  State<GenreChips> createState() => _GenreChipsState();
}

class _GenreChipsState extends State<GenreChips> {
  int _selectedIndex = 0;

  final List<String> genres = [
    'Tất cả',
    'Hành động',
    'Tình cảm',
    'Hài hước',
    'Kinh dị',
    'Hoạt hình',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: index < genres.length - 1 ? 12 : 0),
            child: ChoiceChip(
              label: Text(
                genres[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: const Color(0xFF3a1c20),
              selectedColor: const Color(0xFFec1337),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFFec1337)
                    : Colors.white.withOpacity(0.05),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
