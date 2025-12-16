import 'package:flutter/material.dart';

class CinemaSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;

  const CinemaSearchBar({super.key, required this.onSearchChanged});

  @override
  State<CinemaSearchBar> createState() => _CinemaSearchBarState();
}

class _CinemaSearchBarState extends State<CinemaSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Tìm rạp phim...',
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
          // suffixIcon: IconButton(
          //   icon: const Icon(Icons.mic, color: Color(0xFF9CA3AF)),
          //   onPressed: () {},
          // ),
          filled: true,
          fillColor: const Color(0xFF3a1c20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) => widget.onSearchChanged(value),
      ),
    );
  }
}
