import 'package:flutter/material.dart';
import '../../services/auth/auth_service.dart';
import '../../services/auth/token_storage.dart';
import '../../layout/main_layout.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _primary = Color(0xFFec1337);
  static const _bgDark = Color(0xFF221013);
  static const _surface = Color(0xFF33191e);
  static const _border = Color(0xFF67323b);
  static const _textSecondary = Color(0xFFc9929b);

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _acceptedPolicy = false;

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedPolicy) {
      setState(
        () => _error = 'Bạn cần đồng ý Điều khoản & Chính sách bảo mật.',
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final tokens = await AuthService().register(
        fullName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      await TokenStorage().saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainLayout()),
        (_) => false,
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _decor({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0x66c9929b)),
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
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar (sticky style) :contentReference[oaicite:7]{index=7}
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: _bgDark.withOpacity(0.95)),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Đăng ký',
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Headline :contentReference[oaicite:8]{index=8}
                      const Text(
                        'Tạo tài khoản mới',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tham gia ngay để không bỏ lỡ các bom tấn điện ảnh.',
                        style: TextStyle(color: _textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 20),

                      // Full name :contentReference[oaicite:9]{index=9}
                      const _Label('Họ và tên'),
                      TextFormField(
                        controller: _nameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decor(hint: 'Nhập họ và tên của bạn'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nhập họ tên'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Email/phone :contentReference[oaicite:10]{index=10}
                      const _Label('Email hoặc số điện thoại'),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decor(hint: 'example@email.com'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nhập email'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Password + toggle :contentReference[oaicite:11]{index=11}
                      const _Label('Mật khẩu'),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscure1,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decor(
                          hint: '••••••••',
                          suffix: IconButton(
                            onPressed: () =>
                                setState(() => _obscure1 = !_obscure1),
                            icon: Icon(
                              _obscure1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: _textSecondary,
                            ),
                          ),
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Nhập mật khẩu' : null,
                      ),
                      const SizedBox(height: 16),

                      // Confirm password + toggle :contentReference[oaicite:12]{index=12}
                      const _Label('Nhập lại mật khẩu'),
                      TextFormField(
                        controller: _pass2Ctrl,
                        obscureText: _obscure2,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decor(
                          hint: '••••••••',
                          suffix: IconButton(
                            onPressed: () =>
                                setState(() => _obscure2 = !_obscure2),
                            icon: Icon(
                              _obscure2
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: _textSecondary,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Nhập lại mật khẩu';
                          if (v != _passCtrl.text) return 'Mật khẩu không khớp';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Policy checkbox :contentReference[oaicite:13]{index=13}
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptedPolicy,
                            onChanged: (v) =>
                                setState(() => _acceptedPolicy = v ?? false),
                            activeColor: _primary,
                            checkColor: Colors.white,
                            side: const BorderSide(color: _border),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 12,
                                  ),
                                  children: [
                                    TextSpan(text: 'Tôi đồng ý với '),
                                    TextSpan(
                                      text: 'Điều khoản sử dụng',
                                      style: TextStyle(
                                        color: _primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    TextSpan(text: ' & '),
                                    TextSpan(
                                      text: 'Chính sách bảo mật',
                                      style: TextStyle(
                                        color: _primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    TextSpan(text: ' của ứng dụng.'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ],

                      const SizedBox(height: 10),

                      // Main button :contentReference[oaicite:14]{index=14}
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
                              : const Text(
                                  'Đăng ký',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Divider “Hoặc đăng ký bằng” :contentReference[oaicite:15]{index=15}
                      Row(
                        children: const [
                          Expanded(child: Divider(color: _border, height: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Hoặc đăng ký bằng',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: _border, height: 1)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Social buttons (2 cột) :contentReference[oaicite:16]{index=16}
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: _surface,
                                side: const BorderSide(color: _border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              icon: const Text(
                                'G',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              label: const Text(
                                'Google',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: _surface,
                                side: const BorderSide(color: _border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              icon: const Icon(
                                Icons.apple,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Apple',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Login redirect :contentReference[oaicite:17]{index=17}
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Đã có tài khoản? ',
                              style: TextStyle(color: _textSecondary),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Đăng nhập ngay',
                                style: TextStyle(
                                  color: _primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
