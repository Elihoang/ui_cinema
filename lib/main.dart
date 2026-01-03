import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './layout/main_layout.dart';
import 'screens/auth/auth_gate.dart';
import 'providers/notification_provider.dart';
import 'services/push_notification_service.dart';

// Global navigator key for push navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  // Initialize Firebase
  await Firebase.initializeApp();

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
    return MultiProvider(
      providers: [
        // Notification Provider
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'Cinemax HÃ  Ná»™i',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey, // For push notification navigation
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
          fontFamily: 'DuyHoang',
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
        home: const AppInitializer(),
      ),
    );
  }
}

// Initialize app with notification setup
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  final PushNotificationService _pushService = PushNotificationService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Initialize push notifications
      await _pushService.initialize();

      // Load initial notifications if user is logged in
      // You can add authentication check here
      // if (userIsLoggedIn) {
      //   await context.read<NotificationProvider>().loadNotifications();
      //   context.read<NotificationProvider>().startPolling();
      // }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing app: $e');
      setState(() {
        _isInitialized = true; // Continue anyway
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF221013),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFec1337),
          ),
        ),
      );
    }

    return const AuthGate();
  }
}