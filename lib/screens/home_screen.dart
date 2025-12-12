import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/home/top_app_bar.dart';
import '../widgets/home/search_bar_widget.dart';
import '../widgets/home/featured_movie_card.dart';
import '../widgets/home/genre_chips.dart';
import '../widgets/home/movie_card.dart';
import '../widgets/home/promo_banner.dart';
import '../widgets/home/upcoming_movie_item.dart';
import '../widgets/home/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Movie> nowShowingMovies = [
    Movie(
      title: 'Kung Fu Panda 4',
      duration: '1h 34m',
      genre: 'Hoạt hình',
      rating: 9.2,
      posterUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBY1IzgmxeBKswCTiVggpkRhc3kPIzRPelvKFQhQ2HaxjlJvi_MAlgkfN26gBk3h38Zln-Nds5j5kMvBFzEQXiwqf3Yc8yYc890YgMSH5s_ATikovdrsyqjlIGP7Sl4CMFvfupc9DXpBaeEyMKioM8xNMt51AA7rNheRIUznZh_dfv6S4J7QZNepT9YKti1ZzimljY62biu6E9DalDUrSEa62bYPNQNdsn5uW2tL-ScR8buMSYri3sHlBTXnEJz8sZ1R-yQp8oJc_k',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBY1IzgmxeBKswCTiVggpkRhc3kPIzRPelvKFQhQ2HaxjlJvi_MAlgkfN26gBk3h38Zln-Nds5j5kMvBFzEQXiwqf3Yc8yYc890YgMSH5s_ATikovdrsyqjlIGP7Sl4CMFvfupc9DXpBaeEyMKioM8xNMt51AA7rNheRIUznZh_dfv6S4J7QZNepT9YKti1ZzimljY62biu6E9DalDUrSEa62bYPNQNdsn5uW2tL-ScR8buMSYri3sHlBTXnEJz8sZ1R-yQp8oJc_k',
    ),
    Movie(
      title: 'Godzilla x Kong',
      duration: '1h 55m',
      genre: 'Hành động',
      rating: 8.8,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuClXHxBdCTAVRexx29mjKDb6IDrmlUxcLUBIKGnqNoE7C_2dDB2m6xAzJxp5S_gsnt4BzCXvtsHnKL6IDPCcQAgG92AolGNhv4J_yc-bmNByWfrfa0JGIgti-tU75DzblaxwWQNij2_fvCfAYVSBm5LKOnqwGlwQ0QIUQAiPvd9V1A9p-00BGiriZvJAf18k0Fsk94P5K5W46Tp3JU04HmAqYpPniuJ3hT2NzNNc_f3lyzdFXcCylaQLleXZlkmp0_pSm3AOiZZC1o',
      posterUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuClXHxBdCTAVRexx29mjKDb6IDrmlUxcLUBIKGnqNoE7C_2dDB2m6xAzJxp5S_gsnt4BzCXvtsHnKL6IDPCcQAgG92AolGNhv4J_yc-bmNByWfrfa0JGIgti-tU75DzblaxwWQNij2_fvCfAYVSBm5LKOnqwGlwQ0QIUQAiPvd9V1A9p-00BGiriZvJAf18k0Fsk94P5K5W46Tp3JU04HmAqYpPniuJ3hT2NzNNc_f3lyzdFXcCylaQLleXZlkmp0_pSm3AOiZZC1o',
    ),
    Movie(
      title: 'Ghostbusters',
      duration: '2h 10m',
      genre: 'Hài hước',
      rating: 8.5,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuACEmHCW2oVFa4KjrAGV7awfHnYxlOp0O0AJ9IFO8PM51MbOZSCidapitd5MLg1mC7DG4AldNqOb4bwGt7RxyK5J0DyRe8G83A_gXIuRZcjXIjo34GegZ12GKXRmjr56pgOmHXelVY5v5ZVphlwZdeqhuBH5SdIPsfaGxPijpOEkixzkGZeD4L_tQH2kKOoRVkrKAxsBi4rPM5rZd0Q8gscqnupaXc4lMu5mrXhtH7GC_Uf5tzXBLKQlS4exOQPxcO2a9BCvF2B_b4',
      posterUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuACEmHCW2oVFa4KjrAGV7awfHnYxlOp0O0AJ9IFO8PM51MbOZSCidapitd5MLg1mC7DG4AldNqOb4bwGt7RxyK5J0DyRe8G83A_gXIuRZcjXIjo34GegZ12GKXRmjr56pgOmHXelVY5v5ZVphlwZdeqhuBH5SdIPsfaGxPijpOEkixzkGZeD4L_tQH2kKOoRVkrKAxsBi4rPM5rZd0Q8gscqnupaXc4lMu5mrXhtH7GC_Uf5tzXBLKQlS4exOQPxcO2a9BCvF2B_b4',
    ),
    Movie(
      title: 'The First Omen',
      duration: '1h 59m',
      genre: 'Kinh dị',
      rating: 7.9,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDJgDCfdTUL6EplTiyCDVsnoKFfJPQopr0SyR0rc1XtR8Zq8hjiA5kXZzuV07CYOyDzh6r7SLi9rToiluxxAi_IqtVTs-vnNsyYWaWb-JaobC_lSgkSxAtHWM9eevJAw9-OMAQcCYUS1Yoh8MsME247Yqvd7I7AnRqy0-sBGoYu-XwTAgUYqt53RAAycdZSpog7tc-HzcIhMve4dMXr8LNU1ZAJmpLymAkyJoUAoo_h_-AG_XpAJsEnGav4JGOGE9aFUo1EoMQFYv0',
      posterUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDJgDCfdTUL6EplTiyCDVsnoKFfJPQopr0SyR0rc1XtR8Zq8hjiA5kXZzuV07CYOyDzh6r7SLi9rToiluxxAi_IqtVTs-vnNsyYWaWb-JaobC_lSgkSxAtHWM9eevJAw9-OMAQcCYUS1Yoh8MsME247Yqvd7I7AnRqy0-sBGoYu-XwTAgUYqt53RAAycdZSpog7tc-HzcIhMve4dMXr8LNU1ZAJmpLymAkyJoUAoo_h_-AG_XpAJsEnGav4JGOGE9aFUo1EoMQFYv0',
    ),
  ];

  final List<UpcomingMovie> upcomingMovies = [
    UpcomingMovie(
      title: 'Civil War: Nội Chiến Mỹ',
      releaseDate: '12/04',
      genre: 'Hành động, Chiến tranh',
      description:
          'Một hành trình đầy kịch tính xuyên suốt nước Mỹ đang bị chia cắt...',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAzs4wtZbcsoSK5c2SFFVutCPptOmcMLMCR9Y0KcLX5rFl1QeJGzqm_TwYT1SuThIX4UVNS_-quF0K39fEUSh07SBKvrkpcog5rq0k8YsqQFPVhuIsI7ZHTjHsdHFMVfu0NjzbmoLQEUpXv7l78UIw3WVZk33kw2EOXWZhgrWAkNOBy4EztAF0JjUamSc3kMLdZ1XG_i7_nb2CFsLpsUyhiqCqNFrpGuVmJo2lVXYxLswPbdeDFH8o4_lAtsJw2AI7tw19MYAc7n5w',
    ),
    UpcomingMovie(
      title: 'Abigail: Chơi Trốn Tìm',
      releaseDate: '19/04',
      genre: 'Kinh dị, Hồi hộp',
      description:
          'Sau khi bắt cóc cô con gái vũ công ba lê 12 tuổi của một nhân vật quyền lực...',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBfXCyTxX4YlMxVKDemij7bNn_IYnE3VfQdWC9CtwukCW6SiX-OCkHyQjrwiZBbPtzaptrLViGIoJVDGiRkx4F7C8J98l6PlGmn5jupGXSJxvrM9A8ir6uBunYDjiW3BYCBGFPoe4O8rhcRrB9XvdYih4XkQkmC-LCKovfhQ4ULKjoI-4Oq3dUhcLdYDm5BDRw0ylDjqTTDXEQudBPkQgogOs3r4riho2aVltq1CD2Qr5K2u1xTGIrlJgK-ccnf3NHy_5jN0XRJQxc',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Xóa Scaffold, chỉ trả về nội dung cuộn
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: TopAppBarWidget()),
          const SliverToBoxAdapter(child: SearchBarWidget()),
          const SliverToBoxAdapter(child: FeaturedMovieCard()),
          const SliverToBoxAdapter(child: GenreChips()),
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
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        TextButton(
                          onPressed: () {},
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: nowShowingMovies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < nowShowingMovies.length - 1 ? 16 : 0,
                          ),
                          child: MovieCard(movie: nowShowingMovies[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: PromoBanner()),
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
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        TextButton(
                          onPressed: () {},
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
                  const SizedBox(height: 100), // Khoảng trống cho BottomBar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
