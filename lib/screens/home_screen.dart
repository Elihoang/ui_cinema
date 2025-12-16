import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../screens/movie_list_screen.dart';
import '../widgets/home/top_app_bar.dart';
import '../widgets/home/search_bar_widget.dart';
import '../widgets/home/featured_movie_card.dart';
import '../widgets/home/genre_chips.dart';
import '../widgets/home/movie_card.dart';
import '../widgets/home/promo_banner.dart';
import '../widgets/home/upcoming_movie_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> nowShowingMovies = [];
  List<Movie> upcomingMovies = [];
  List<Movie> filteredNowShowing = [];
  bool isLoading = true;
  String? errorMessage;

  String _searchQuery = '';
  String _selectedGenre = 'Tất cả';

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final nowShowing = await MovieService.fetchNowShowing();
      final upcoming = await MovieService.fetchUpcoming();

      setState(() {
        nowShowingMovies = nowShowing;
        upcomingMovies = upcoming;
        filteredNowShowing = nowShowing;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching movies: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Không thể tải dữ liệu phim. Vui lòng thử lại.';
      });
    }
  }

  // Hàm lọc phim theo search + genre
  void _applyFilters() {
    List<Movie> temp = nowShowingMovies;

    // Lọc theo thể loại
    if (_selectedGenre != 'Tất cả') {
      temp = temp.where((movie) => movie.category == _selectedGenre).toList();
    }

    // Lọc theo từ khóa tìm kiếm
    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      temp = temp
          .where((movie) => movie.title.toLowerCase().contains(lowerQuery))
          .toList();
    }

    setState(() {
      filteredNowShowing = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: fetchMovies,
        color: const Color(0xFFec1337),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: TopAppBarWidget()),
            SliverToBoxAdapter(
              child: SearchBarWidget(
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query.trim();
                  });
                  _applyFilters();
                },
              ),
            ),
            // Loading hoặc lỗi toàn màn hình
            if (isLoading)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFFec1337),
                  ),
                ),
              )
            else if (errorMessage != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchMovies,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFec1337),
                        ),
                        child: Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // Featured Movie
              if (nowShowingMovies.isNotEmpty)
                SliverToBoxAdapter(
                  child: FeaturedMovieCard(movie: nowShowingMovies.first),
                ),

              // Genre Chips – truyền callback để chọn thể loại
              SliverToBoxAdapter(
                child: GenreChips(
                  selectedGenre: _selectedGenre,
                  onGenreSelected: (genre) {
                    setState(() {
                      _selectedGenre = genre;
                    });
                    _applyFilters();
                  },
                ),
              ),

              // Đang chiếu – dùng filteredNowShowing thay vì nowShowingMovies
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Đang chiếu',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const MovieListScreen(
                                      listType: MovieListType.nowShowing,
                                      title: 'Phim đang chiếu',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Xem tất cả',
                                style: TextStyle(
                                  color: Color(0xFFec1337),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 240,
                        child: filteredNowShowing.isEmpty
                            ? Center(
                                child: Text(
                                  _searchQuery.isEmpty &&
                                          _selectedGenre == 'Tất cả'
                                      ? 'Không có phim đang chiếu'
                                      : 'Không tìm thấy phim phù hợp',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: filteredNowShowing.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right:
                                          index < filteredNowShowing.length - 1
                                          ? 16
                                          : 0,
                                    ),
                                    child: MovieCard(
                                      movie: filteredNowShowing[index],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: PromoBanner()),

              // Phần Sắp chiếu giữ nguyên (có thể thêm lọc sau nếu muốn)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sắp chiếu',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const MovieListScreen(
                                      listType: MovieListType.upcoming,
                                      title: 'Phim sắp chiếu',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Xem lịch',
                                style: TextStyle(
                                  color: Color(0xFFec1337),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (upcomingMovies.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'Chưa có phim sắp chiếu',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      else
                        ...upcomingMovies.map(
                          (movie) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16,
                              left: 16,
                              right: 16,
                            ),
                            child: UpcomingMovieItem(movie: movie),
                          ),
                        ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
