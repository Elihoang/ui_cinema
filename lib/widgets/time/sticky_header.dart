import 'package:flutter/material.dart';
import '../../models/movie.dart';
import 'top_app_bar.dart';
import 'movie_context_card.dart';
import 'date_picker.dart';
import '../../models/date_option.dart';

class StickyHeader extends StatelessWidget {
  final Movie movie;
  final List<DateOption> dates;
  final int selectedDateIndex;
  final Function(int) onDateSelected;

  const StickyHeader({
    super.key,
    required this.movie,
    required this.dates,
    required this.selectedDateIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF221013).withOpacity(0.95),
        border: const Border(bottom: BorderSide(color: Color(0x0DFFFFFF))),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const TopAppBar(),
            MovieContextCard(movie: movie),
            DatePicker(
              dates: dates,
              selectedIndex: selectedDateIndex,
              onDateSelected: onDateSelected,
            ),
          ],
        ),
      ),
    );
  }
}
