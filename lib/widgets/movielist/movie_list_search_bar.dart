import 'package:flutter/material.dart';

class MovieListSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;

  const MovieListSearchBar({super.key, required this.onSearchChanged});

  @override
  State<MovieListSearchBar> createState() => _MovieListSearchBarState();
}

class _MovieListSearchBarState extends State<MovieListSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {}); // Rebuild to show/hide clear button
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF361b20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white),
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm phim',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500], size: 20),
                    onPressed: () {
                      _controller.clear();
                      widget.onSearchChanged('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}
