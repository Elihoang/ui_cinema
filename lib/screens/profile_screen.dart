import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth/token_storage.dart';
import '../screens/auth/login_screen.dart';

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
  User? user;
  String? email;
  bool isLoading = true;
  String? error;
  bool biometricsEnabled = true;

  static const _bg = Color(0xFF120709);
  static const _accent = Color(0xFFEC1337);

  @override
  void initState() {
    super.initState();
    _loadProfileFromToken();
  }

  Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Access token không đúng định dạng JWT');
    }
    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final map = json.decode(decoded);
    if (map is! Map<String, dynamic>) {
      throw Exception('JWT payload không hợp lệ');
    }
    return map;
  }

  String _pickString(
    Map<String, dynamic> m,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final k in keys) {
      final v = m[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return fallback;
  }

  Future<void> _loadProfileFromToken() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final tokenStorage = TokenStorage();
      final token = await tokenStorage.getAccessToken();

      if (!mounted) return;

      if (token == null || token.isEmpty) {
        _goToLogin();
        return;
      }

      final payload = _decodeJwtPayload(token);

      final id = _pickString(payload, [
        'sub',
        'id',
        'userId',
        'nameid',
        'uid',
      ], fallback: 'unknown');
      final name = _pickString(payload, [
        'fullName',
        'fullname',
        'name',
        'username',
        'preferred_username',
        'given_name',
      ], fallback: 'Người dùng');
      final avatar = _pickString(payload, [
        'avatar',
        'picture',
        'photoUrl',
        'image',
      ], fallback: '');
      final mail = _pickString(payload, ['email', 'mail', 'upn'], fallback: '');

      setState(() {
        user = User(id: id, name: name, avatar: avatar);
        email = mail;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Future<void> _logout() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.clear();
    if (!mounted) return;
    _goToLogin();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Hồ sơ',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A1014), Color(0xFF120709)],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _loadProfileFromToken,
          tooltip: 'Tải lại',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: _bg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: _bg,
        appBar: _buildAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Không tải được thông tin người dùng',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  error!,
                  style: TextStyle(color: Colors.white.withOpacity(0.75)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onPressed: _loadProfileFromToken,
                  child: const Text('Thử lại'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _logout,
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(color: _accent),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final u = user;
    if (u == null) {
      return Scaffold(
        backgroundColor: _bg,
        appBar: _buildAppBar(),
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
            ),
            onPressed: _goToLogin,
            child: const Text('Đăng nhập lại'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: _accent,
        onRefresh: _loadProfileFromToken,
        child: ListView(
          padding: const EdgeInsets.only(top: 14, bottom: 24),
          children: [
            ProfileHeader(
              user: u,
              subtitle: (email ?? '').isEmpty ? null : email,
            ),
            const SizedBox(height: 12),
            ProfileStats(user: u),
            const SizedBox(height: 16),
            const UpcomingTicketsSection(tickets: []),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tài khoản',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  AccountMenuItem(
                    icon: Icons.person_outline,
                    iconColor: _accent,
                    title: u.name,
                    onTap: () {},
                  ),
                  if ((email ?? '').trim().isNotEmpty)
                    AccountMenuItem(
                      icon: Icons.email_outlined,
                      iconColor: const Color(0xFF60A5FA),
                      title: email!,
                      onTap: () {},
                    ),
                  AccountMenuItem(
                    icon: Icons.badge_outlined,
                    iconColor: const Color(0xFF34D399),
                    title: 'ID: ${u.id}',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Cài đặt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SettingsMenuItem(
                    icon: Icons.fingerprint,
                    iconColor: const Color(0xFF60A5FA),
                    title: 'Đăng nhập sinh trắc học',
                    trailing: Switch(
                      value: biometricsEnabled,
                      onChanged: (v) => setState(() => biometricsEnabled = v),
                      activeColor: _accent,
                    ),
                    onTap: () {},
                  ),
                  SettingsMenuItem(
                    icon: Icons.logout,
                    iconColor: _accent,
                    title: 'Đăng xuất',
                    onTap: _logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
