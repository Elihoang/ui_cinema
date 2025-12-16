// movie_list_screen.dart (cập nhật)

import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/movielist/movie_list_search_bar.dart';
import '../widgets/movielist/movie_list_filter_chips.dart';
import '../widgets/movielist/featured_movies_carousel.dart';
import '../widgets/movielist/movie_list_item_card.dart';

enum MovieListType { nowShowing, upcoming }

class MovieListScreen extends StatefulWidget {
  final MovieListType listType; // Loại danh sách
  final String title; // Tiêu đề hiển thị

  const MovieListScreen({
    super.key,
    required this.listType,
    required this.title,
  });

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = widget.listType == MovieListType.nowShowing
        ? MovieService.fetchNowShowing()
        : MovieService.fetchUpcoming();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      appBar: AppBar(
        backgroundColor: const Color(0xFF221013),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const MovieListSearchBar(),
            const SizedBox(height: 16),
            const MovieListFilterChips(),
            const SizedBox(height: 24),

            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: futureMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Không có phim nào',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    );
                  }

                  final movies = snapshot.data!;

                  // Nếu là phim đang chiếu, có thể giữ carousel nổi bật
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.listType == MovieListType.nowShowing &&
                            movies.isNotEmpty)
                          FeaturedMoviesCarousel(
                            movies: movies.take(5).toList(),
                          ),

                        if (widget.listType == MovieListType.nowShowing)
                          const SizedBox(height: 24),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: movies.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  return MovieListItemCard(
                                    movie: movies[index],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
