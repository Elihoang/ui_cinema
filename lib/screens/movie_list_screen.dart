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
  String searchQuery = '';
  String selectedFilter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    futureMovies = widget.listType == MovieListType.nowShowing
        ? MovieService.fetchNowShowing()
        : MovieService.fetchUpcoming();
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  List<Movie> _filterMovies(List<Movie> movies) {
    List<Movie> filtered = movies;

    // Lọc theo tìm kiếm
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((movie) {
        return movie.title.toLowerCase().contains(searchQuery);
      }).toList();
    }

    // Lọc theo filter
    if (selectedFilter != 'Tất cả') {
      filtered = filtered.where((movie) {
        switch (selectedFilter) {
          // case 'Sắp chiếu':
          //   // Phim sắp chiếu có status = 'upcoming' hoặc releaseDate trong tương lai
          //   return movie.status?.toLowerCase() == 'upcoming' ||
          //       movie.releaseDate.isAfter(DateTime.now());
          case 'Đánh giá cao':
            // Lọc phim có averageRating >= 4.0
            return (movie.averageRating ?? 0) >= 4.0;
          case 'Hành động':
            // Lọc theo category
            final categoryName = movie.category.toString().toLowerCase();
            return categoryName.contains('action') ||
                categoryName.contains('hành động');
          case 'Kinh dị':
            // Lọc theo category
            final categoryName = movie.category.toString().toLowerCase();
            return categoryName.contains('horror') ||
                categoryName.contains('kinh dị');
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
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
            MovieListSearchBar(onSearchChanged: _onSearchChanged),
            const SizedBox(height: 16),
            MovieListFilterChips(onFilterChanged: _onFilterChanged),
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

                  final allMovies = snapshot.data!;
                  final filteredMovies = _filterMovies(allMovies);

                  // Nếu là phim đang chiếu, có thể giữ carousel nổi bật
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.listType == MovieListType.nowShowing &&
                            allMovies.isNotEmpty &&
                            searchQuery.isEmpty &&
                            selectedFilter == 'Tất cả')
                          FeaturedMoviesCarousel(
                            movies: allMovies.take(5).toList(),
                          ),

                        if (widget.listType == MovieListType.nowShowing &&
                            searchQuery.isEmpty &&
                            selectedFilter == 'Tất cả')
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
                              filteredMovies.isEmpty
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(32.0),
                                        child: Text(
                                          'Không tìm thấy phim nào',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: filteredMovies.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 16),
                                      itemBuilder: (context, index) {
                                        return MovieListItemCard(
                                          movie: filteredMovies[index],
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
