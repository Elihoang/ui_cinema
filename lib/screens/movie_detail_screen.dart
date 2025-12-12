import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int _selectedTabIndex = 0;
  int _selectedDateIndex = 0;
  bool _isFavorite = false;
  bool _isExpanded = false;

  final List<String> _tabs = ['Thông tin', 'Suất chiếu', 'Đánh giá (1.2k)'];

  final List<Map<String, dynamic>> _dates = [
    {'day': 'T6', 'date': '14'},
    {'day': 'T7', 'date': '15'},
    {'day': 'CN', 'date': '16'},
    {'day': 'T2', 'date': '17'},
    {'day': 'T3', 'date': '18'},
  ];

  final List<Map<String, dynamic>> _castMembers = [
    {
      'name': 'Denis V.',
      'role': 'Đạo diễn',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC2BUSdPdka7lPBFq-Ou8KjAkDT9lTSPNqJyUj5W0czhXya08lXwx_9Tb5hRMWHjVdHkewAeDQ8TuZbUG4VwdxYH-e3b75IIKkr_AQqE3ekVEsY-nmy6EXeR76VMO5tiqiE84AzarY715xqkkMCdE8H9NFIhFdIoXBAe3mvSRaHJLP-FGJILE-3_BldImPwz64_OvHmjTz6KnRcuq33IbaBBfxFa-LwKkpu1xvYvHwCJMHUidR84Wo-wP_wnADsJvjIHFMewf4vmf8',
      'isDirector': true,
    },
    {
      'name': 'Timothée C.',
      'role': 'Paul Atreides',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCH1tvBTmKmv489YPAP4hiQyDyL_MXGm6_uumyyF-_Xl92_5vWSqyDTv5VV9pPWvHd4amD3TKp320kRv7aHQwfBZaQubJROOVxJ_xWOHTHLKzdapxEaq5QdLaof6scLEwOY39mxa92PQjDk9L0d2VaWmc-sk3bQAKSy8BXbxuyUrhFEBBYCPPM_nomqlezcqKDfx9RfvCJXr34yWSTz6--AkO45jtg4NLqQFsavZhtwBHJPvcIGzUesstZ2GiORLNq3U5CC87qAnBA',
      'isDirector': false,
    },
    {
      'name': 'Zendaya',
      'role': 'Chani',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBBKyoy-aSibcdcuRUC6JfNQV7eEnGLglCgqueggwa7Rd_xx8R3RzRlgf2lQ1QONKr7pyGgoea9cQc37jy7YDwsU-Wnqyqscm_QEteJIJTYrI7FCu6mFb9HbUQ2SR35O06kvZiz3zwQI9RzJO7e6qL0f0Hm6Uk5D86xzQLzTmPObf_SEzpeQ8MLM8kxYb22qRFPqDOIW5fi7J_DrMP1sGiwgCJbfTB-M5xymU3yr0DpWbLd5LhdEQed_9xzu-ZD6wQppN62ouRPuhc',
      'isDirector': false,
    },
    {
      'name': 'Rebecca F.',
      'role': 'Lady Jessica',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAAiaQ1_oZRa02ZvzYf74tA3eiHUV2UoEncPSCnwbKA17agiJue7yDykTZJY7UNAkuFIdTvb-Wx15C5ZsiVwnUlDCvMM3cgFUj-SpENy_CR2qEbAVtAqMqD30DnN2zjBIUd8mpybXulCqDjcksbYaTcAamkVDWI1fhpps9JfsOBW1yStYfNivC8-OCagm8zDx8dmxFPHhnw3q2g8XzBxeqJLfhmSfUNlr3-n5OVjmxl7-Ids4o44Bb1xpqISiQuIrIblF43r9fDbeE',
      'isDirector': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero Section with Play Button
              SliverToBoxAdapter(child: _buildHeroSection()),
              // Movie Info Header
              SliverToBoxAdapter(child: _buildMovieInfoHeader()),
              // Tab Navigation
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  selectedIndex: _selectedTabIndex,
                  tabs: _tabs,
                  onTabSelected: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                ),
              ),
              // Content
              SliverToBoxAdapter(child: _buildContent()),
            ],
          ),
          // Top Navigation Overlay
          _buildTopNavigation(),
          // Bottom Booking Bar
          _buildBottomBookingBar(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        // Hero Image
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.movie.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Dark Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        const Color(0xFF221013),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
                // Play Button
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC1337).withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEC1337).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopNavigation() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            // Actions
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite
                          ? const Color(0xFFEC1337)
                          : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.ios_share,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfoHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Title and Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade600),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'T16',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Text(
                          widget.movie.duration,
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '•',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                          ),
                        ),
                        const Text('2024', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Rating Badge
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFEC1337),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.movie.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'IMDb',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Genre Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildGenreChip('Khoa học viễn tưởng'),
                const SizedBox(width: 8),
                _buildGenreChip('Hành động'),
                const SizedBox(width: 8),
                _buildGenreChip('Phiêu lưu'),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGenreChip(String label) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade200,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 100,
      ), // Giữ khoảng cách đáy cho nút đặt vé
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Phần Nội dung phim (Synopsis) cần padding 16
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSynopsisSection(),
          ),
          const SizedBox(height: 32),
          // Phần Diễn viên cần padding 16 (chỉ tiêu đề, list đã có padding riêng hoặc full width tùy ý, ở đây mình padding cả khối cho đẹp)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCastSection(),
          ),
          const SizedBox(height: 32),

          // Phần Lịch chiếu (Showtimes) -> KHÔNG BỌC PADDING để nó tràn viền
          _buildShowtimesSection(),

          const SizedBox(height: 32),
          // Phần Đánh giá cần padding 16
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildRatingSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSynopsisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nội dung',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            'Paul Atreides hợp nhất với Chani và người Fremen trong khi trên đường trả thù những kẻ đã hủy diệt gia đình mình. Đối mặt với sự lựa chọn giữa tình yêu của đời mình và số phận của vũ trụ đã biết, anh nỗ lực ngăn chặn một tương lai tồi tệ mà chỉ anh mới có thể thấy trước.',
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        if (!_isExpanded)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Xem thêm',
              style: TextStyle(
                color: Color(0xFFEC1337),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Diễn viên & Đoàn làm phim',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _castMembers.map((member) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: member['isDirector'] == false
                            ? Border.all(
                                color: const Color(0xFFEC1337).withOpacity(0.2),
                                width: 2,
                              )
                            : null,
                        image: DecorationImage(
                          image: NetworkImage(member['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 80,
                      child: Column(
                        children: [
                          Text(
                            member['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            member['role'],
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildShowtimesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2a1619),
      child: Column(
        children: [
          // ... (giữ nguyên nội dung bên trong)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lịch chiếu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: Color(0xFFEC1337),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: Color(0xFFEC1337), size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Date Picker
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_dates.length, (index) {
                final isSelected = _selectedDateIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDateIndex = index;
                    });
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFEC1337)
                          : const Color(0xFF221013),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? null
                          : Border.all(color: Colors.grey.shade700),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFEC1337).withOpacity(0.2),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dates[index]['day'],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey.shade400,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _dates[index]['date'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          // Cinema & Times
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB4qQ1E2A7b2f7lCreheq9G2SlEPLHjDRUnZgKVd0_Od5Kxg0YjzqrsUc7H4Ru_WhhVDfhN443lKARP8tcf0yJiAo46qYLsW3oyxhmXbE4Qm3Ua7XXJikN89y3JRbIOko3kDhV0C4uC1XoqZwcFGBRh7Zsuavhs4UBqTAQZKELr9-VJQEdggVmcGMUFwjH1rw04Gfni6BuDpai8_NyZNxVAAIyxW2DM-p9WQ2mNXHTmwGlvlPAiw_CREfBSpwD4zfX8AJ8IpGUuhF0',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'CGV Vincom Center',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '2.5km',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ['19:30', '20:15', '22:45'].map((time) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      border: Border.all(color: Colors.grey.shade700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Đánh giá & Review',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big Score
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.rating.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < 4 ? Icons.star : Icons.star_half,
                      color: const Color(0xFFEC1337),
                      size: 18,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '1,245 bài viết',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(width: 24),
            // Progress Bars
            Expanded(
              child: Column(
                children: List.generate(5, (index) {
                  final rating = 5 - index;
                  final widths = [0.8, 0.15, 0.03, 0.01, 0.01];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                          child: Text(
                            '$rating',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: widths[index],
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEC1337),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBookingBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF221013).withOpacity(0.95),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng cộng',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
                const Text(
                  '190.000đ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC1337),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFFEC1337).withOpacity(0.25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Đặt vé ngay',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.confirmation_number, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final int selectedIndex;
  final List<String> tabs;
  final Function(int) onTabSelected;

  _TabBarDelegate({
    required this.selectedIndex,
    required this.tabs,
    required this.onTabSelected,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: maxExtent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF221013).withOpacity(0.95),
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () => onTabSelected(index),
                child: Container(
                  margin: const EdgeInsets.only(right: 24),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected
                            ? const Color(0xFFEC1337)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFEC1337)
                          : Colors.grey.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return selectedIndex != oldDelegate.selectedIndex;
  }
}
