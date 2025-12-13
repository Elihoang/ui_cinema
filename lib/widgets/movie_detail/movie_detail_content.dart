import 'package:flutter/material.dart';
import 'synopsis_section.dart';
import 'cast_section.dart';
import 'showtimes_section.dart';
import 'rating_section.dart';

class MovieDetailContent extends StatelessWidget {
  final int tabIndex;
  const MovieDetailContent({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      const InfoTabContent(),
      const ShowtimesSection(),
      const RatingSection(),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 120),
      child: tabs[tabIndex],
    );
  }
}

class InfoTabContent extends StatefulWidget {
  const InfoTabContent({super.key});
  @override
  State<InfoTabContent> createState() => _InfoTabContentState();
}

class _InfoTabContentState extends State<InfoTabContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SynopsisSection(
            isExpanded: _isExpanded,
            onToggle: () => setState(() => _isExpanded = !_isExpanded),
          ),
        ),
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: CastSection(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
