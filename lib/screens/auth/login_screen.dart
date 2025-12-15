import 'package:flutter/material.dart';
import '../../services/auth/auth_service.dart';
import '../../services/auth/token_storage.dart';
import '../../layout/main_layout.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _primary = Color(0xFFec1337);
  static const _primaryDark = Color(0xFFc40f2d);
  static const _bgDark = Color(0xFF221013);
  static const _surface = Color(0xFF33191e);
  static const _border = Color(0xFF67323b);
  static const _textSecondary = Color(0xFFc9929b);

  // lấy từ login.html background-image :contentReference[oaicite:3]{index=3}
  static const _headerImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAlMp6h7YDtvl5HqHiWlPyRpv8X2bkf2TZPJy_zI2qU_WfM8xj02rXNqXuj2bs2rF4IMz8JpJYD_5oIAxLK9TW2LFG3QM-ZG3KKLIEhhE3ONH2CX5Wk1ornVOHzMOyCbhEbbcv0-tAwImbXj2OWa8SM01I7XzenVG3gowbD4UN0QFDpqlmdVOzHmocyGoJXUbTe4Dy_E9y-fl-vfEXO4-dUSNbonY3nzvxtXemFWmupQ65FPrbxG1yFzBwRR9zk2yRzLoVFmEtdrJc';

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final tokens = await AuthService().login(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      await TokenStorage().saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainLayout()));
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _decor({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0x66c9929b)),
      prefixIcon: Icon(icon, color: _textSecondary),
      suffixIcon: suffix,
      filled: true,
      fillColor: _surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary, width: 1.2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header (image + top bar + text)
              SizedBox(
                height: 280,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(_headerImageUrl, fit: BoxFit.cover),
                    // Gradient overlay :contentReference[oaicite:4]{index=4}
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x4D221013),
                            Color(0x99221013),
                            Color(0xFF221013),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _CircleIconButton(
                            icon: Icons.arrow_back,
                            onTap: () => Navigator.of(context).maybePop(),
                          ),
                          const Text(
                            'ĐĂNG NHẬP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 40, height: 40),
                        ],
                      ),
                    ),
                    const Positioned(
                      left: 24,
                      right: 24,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chào mừng trở lại',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Vui lòng đăng nhập để tiếp tục đặt vé.',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _LabeledField(
                        label: 'Tài khoản',
                        child: TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: _decor(
                            hint: 'Email hoặc Số điện thoại',
                            icon: Icons.person,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Nhập email'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'Mật khẩu',
                        child: TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          style: const TextStyle(color: Colors.white),
                          decoration: _decor(
                            hint: 'Mật khẩu',
                            icon: Icons.lock,
                            suffix: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: _textSecondary,
                              ),
                            ),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Nhập mật khẩu' : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: route forgot password nếu có
                          },
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              color: _textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],

                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            disabledBackgroundColor: _primary.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Đăng nhập',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.login,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      // Divider “Hoặc đăng nhập bằng” :contentReference[oaicite:5]{index=5}
                      const SizedBox(height: 24),
                      Row(
                        children: const [
                          Expanded(child: Divider(color: _border, height: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Hoặc đăng nhập bằng',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: _border, height: 1)),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Social buttons (UI only)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialCircleButton(
                            onTap: () {},
                            child: const Text(
                              'G',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(width: 16),
                          _SocialCircleButton(
                            onTap: () {},
                            child: const Icon(Icons.apple, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          _SocialCircleButton(
                            onTap: () {},
                            child: const Text(
                              'f',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 26),

                      // Footer link :contentReference[oaicite:6]{index=6}
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Bạn chưa có tài khoản? ',
                            style: TextStyle(color: _textSecondary),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Đăng ký ngay',
                              style: TextStyle(
                                color: _primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _SocialCircleButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: _LoginScreenState._surface,
          border: Border.all(color: _LoginScreenState._border),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(child: child),
      ),
    );
  }
}
