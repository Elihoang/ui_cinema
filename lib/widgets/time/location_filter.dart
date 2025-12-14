import 'package:flutter/material.dart';

class LocationFilter extends StatelessWidget {
  final List<String> locations;
  final int selectedIndex;
  final Function(int) onLocationSelected;

  const LocationFilter({
    super.key,
    required this.locations,
    required this.selectedIndex,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: locations.asMap().entries.map((e) {
              final i = e.key;
              final label = e.value;
              final selected = i == selectedIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => onLocationSelected(i),
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : const Color(0xFF2F181B),
                      borderRadius: BorderRadius.circular(24),
                      border: selected
                          ? null
                          : Border.all(color: const Color(0x1AFFFFFF)),
                    ),
                    child: Row(
                      children: [
                        if (i == 0)
                          const Padding(padding: EdgeInsets.only(right: 8)),
                        Text(
                          label,
                          style: TextStyle(
                            color: selected
                                ? const Color(0xFF221013)
                                : Colors.white,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
