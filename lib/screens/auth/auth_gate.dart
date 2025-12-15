import 'package:flutter/material.dart';
import '../../layout/main_layout.dart';
import '../../services/auth/token_storage.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: TokenStorage().getAccessToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data;
        if (token == null || token.isEmpty) {
          return const LoginScreen();
        }
        return const MainLayout();
      },
    );
  }
}
