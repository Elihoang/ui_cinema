import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_stats.dart';
import '../widgets/profile/upcoming_tickets_section.dart';
import '../widgets/profile/account_menu_item.dart';
import '../widgets/profile/settings_menu_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User currentUser;
  late List<Ticket> upcomingTickets;
  bool biometricsEnabled = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    currentUser = User(
      id: '1',
      name: 'Nguyễn Văn A',
      avatar:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCtmMa2umFyDW5WXGVuez3Nwg08rR75xPFb5NDUkEeYCI_Wmn85pJlwXS1RZ24dZQrhkL3S3mOjt1QYrSI-s0xrdpAPAmP10T49Xzso3b24QVGT1S91TE2NaGdZseJpv7yGCk1nSZckBCZwb8g1aEkAbHokwvmUtllN4okciCUrSoEwlol37T8U1fcpYMerB4IFZ2-PV7B-52QVSkblXl-V9Anh6Pb6XgbzcMFjGQ6WIQaOP70dzxW05lyymTbpZZXQ9rWPXH1ZDwY',
      membershipLevel: 'THÀNH VIÊN VÀNG',
      watchedCount: 12,
      rewardPoints: 2400,
      voucherCount: 3,
    );

    upcomingTickets = [
      Ticket(
        id: '1',
        movieTitle: 'Dune: Hành tinh cát 2',
        moviePoster:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBMtVH9cwODQElViJMl-j2e-YYFUYh626Brl0rVXfjgWeeyJEApinXh4WyJecN1Bh2LqGYUX13fA8pi9o-ZpnmTgYPplu50iuM3XWS6MSbgi6iqhumH6PvkiL4QI-vszQukKcdwXBF5JGTA0dQRQ9LkrWdOa6Q6AVr-exu48yjHg3kLlHKddEb6Ld-mZIfPOApmH0H96UQf5vfgwXUGMa2mm9S_UV4Ob3V34EWA9EnHsk9M-mROhj8Naxp7qtXNSsktbzbeIKQjkXQ',
        format: 'IMAX 2D',
        audioType: 'Phụ đề',
        time: '19:00',
        date: 'Hôm nay',
        cinema: 'CGV Vincom Center',
        seats: 'F12, F13',
      ),
      Ticket(
        id: '2',
        movieTitle: 'Godzilla x Kong',
        moviePoster:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCowYKXKVFtj5Jb6MnD0bQnSrQp9sb-nRrRYOVeH4biE9BZrR5Yx3l4BQTj2apeaB5YuZOT3paPJOeIG1AdLNb7mSaRoLjsp0uSsRqVQuMRJaretkFktWrjhln5XjCaULsOBBrbQahBb3LTgr7WaOxkhJb9-72RRh-eI_PKzvJzeeWliNVsKJtqpYuyghNi_cb6-WMiA0tV3SvFes1DLsc3rxhNcc6OKv9ySFNIHTFPgyFIFWLd1_uYjCLNIzINe0P6a5KxZPVHbzM',
        format: '2D',
        audioType: 'Lồng tiếng',
        time: '14:30',
        date: 'Ngày mai',
        cinema: 'Lotte Cinema',
        seats: 'H05',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hồ sơ cá nhân',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ProfileHeader(user: currentUser),
            ),
            // Stats Section
            ProfileStats(user: currentUser),
            const SizedBox(height: 8),
            // Upcoming Tickets
            UpcomingTicketsSection(tickets: upcomingTickets),
            const SizedBox(height: 24),
            // Account Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tài khoản',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF351a1e),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        AccountMenuItem(
                          icon: Icons.person_outline,
                          iconColor: Colors.blue,
                          title: 'Chỉnh sửa thông tin',
                          onTap: () {},
                        ),
                        AccountMenuItem(
                          icon: Icons.history,
                          iconColor: Colors.green,
                          title: 'Lịch sử giao dịch',
                          onTap: () {},
                        ),
                        AccountMenuItem(
                          icon: Icons.credit_card_outlined,
                          iconColor: Colors.purple,
                          title: 'Phương thức thanh toán',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cài đặt',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF351a1e),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        SettingsMenuItem(
                          icon: Icons.language,
                          iconColor: Colors.grey,
                          title: 'Ngôn ngữ',
                          subtitle: 'Tiếng Việt',
                          onTap: () {},
                        ),
                        SettingsMenuItem(
                          icon: Icons.face,
                          iconColor: Colors.grey,
                          title: 'FaceID / TouchID',
                          trailing: Switch(
                            value: biometricsEnabled,
                            onChanged: (value) {
                              setState(() {
                                biometricsEnabled = value;
                              });
                            },
                            activeColor: const Color(0xFFec1337),
                          ),
                          onTap: () {},
                        ),
                        SettingsMenuItem(
                          icon: Icons.support_agent,
                          iconColor: Colors.grey,
                          title: 'Hỗ trợ & CSKH',
                          isLast: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFFec1337), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFec1337),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Version
            Text(
              'Phiên bản 1.0.2',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
