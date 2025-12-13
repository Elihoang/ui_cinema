import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './layout/main_layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // load file .env

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF3a1c20),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const CinemaxApp());
}

class CinemaxApp extends StatelessWidget {
  const CinemaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinemax Hà Nội',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFec1337),
        scaffoldBackgroundColor: const Color(0xFF221013),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFec1337),
          surface: Color(0xFF3a1c20),
          onSurface: Colors.white,
        ),
        fontFamily: 'DuyHoang', // Font chữ từ file gốc của bạn
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
          bodySmall: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        ),
      ),
      // Thay đổi quan trọng nhất ở đây: trỏ về MainLayout thay vì HomeScreen
      home: const MainLayout(),
    );
  }
}
