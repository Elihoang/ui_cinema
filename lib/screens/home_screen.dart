import 'package:fe_cinema_mobile/extensions/movie_category_extension.dart';
import 'package:flutter/material.dart';
import '../models/movie/movie.dart';
import 'package:provider/provider.dart';
import '../services/movie_service.dart';
import '../screens/movie_list_screen.dart';
import '../screens/notifications/notification_list_screen.dart';
import '../widgets/home/search_bar_widget.dart';
import '../widgets/home/featured_movie_card.dart';
import '../widgets/home/genre_chips.dart';
import '../widgets/home/movie_card.dart';
import '../widgets/home/promo_banner.dart';
import '../widgets/home/upcoming_movie_item.dart';
import '../widgets/home/featured_movies_carousel.dart';
import '../widgets/notification/notification_badge.dart';
import '../providers/notification_provider.dart';

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

    // ✅ FIX: Use addPostFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  Future<void> _loadNotifications() async {
    try {
      await context.read<NotificationProvider>().loadNotifications();
    } catch (e) {
      print('Error loading notifications: $e');
      // Don't throw - notifications are not critical for home screen
    }
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
      temp = temp
          .where((movie) => movie.category.vi == _selectedGenre)
          .toList();
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
        onRefresh: () async {
          await Future.wait([fetchMovies(), _loadNotifications()]);
        },
        color: const Color(0xFFec1337),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with Notification Badge
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo + Greeting
                    Row(
                      children: [
                        // Logo (clickable to open sidebar)
                        InkWell(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/cropped_circle_image.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFec1337),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.movie,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Greeting (not clickable)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chào mừng',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Cinemax MHH',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: const Color(0xFFec1337),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Notification Bell with Badge
                    NotificationBadge(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NotificationListScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3a1c20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
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

            // Loading or Error
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
              // Featured Movies Carousel
              if (nowShowingMovies.isNotEmpty)
                SliverToBoxAdapter(
                  child: FeaturedMoviesCarousel(
                    movies: nowShowingMovies,
                    interval: const Duration(seconds: 5),
                  ),
                ),

              // Genre Chips
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

              // Now Showing
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

              // Upcoming Movies
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
