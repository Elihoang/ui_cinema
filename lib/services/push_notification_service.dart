import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import '../utils/navigation_helper.dart';
import '../providers/notification_provider.dart';
import 'package:provider/provider.dart';

// Top-level function for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.messageId}');
  print('Background data: ${message.data}');
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final ApiService _apiService = ApiService();

  String? _fcmToken;

  Future<void> initialize() async {
    // Request permissions
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted push notification permission');

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token
      _fcmToken = await _fcm.getToken();
      print('✅ FCM Token: $_fcmToken');

      // Register with backend
      if (_fcmToken != null) {
        await _registerToken(_fcmToken!);
      }

      // Setup handlers
      _setupNotificationHandlers();

      // Listen for token refresh
      _fcm.onTokenRefresh.listen(_onTokenRefresh);

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    } else {
      print('❌ User declined push notification permission');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'cinepass_notifications',
      'CinePass Notifications',
      description: 'Notifications from CinePass app',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  void _setupNotificationHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background/terminated - notification tapped
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from notification
    _fcm.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('📱 Foreground notification received');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');

    // Show local notification
    _showLocalNotification(message);

    // ✅ UPDATE: Refresh notification list in app
    try {
      final context = navigatorKey.currentContext;
      if (context != null) {
        context.read<NotificationProvider>().refreshNotifications();
      }
    } catch (e) {
      print('Error refreshing notifications: $e');
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    print('🔔 Notification tapped!');
    print('Data: ${message.data}');

    // ✅ FIX: Extract actionType and actionData from message.data
    final actionType = message.data['actionType'];
    final actionData = message.data['actionData'];

    print('ActionType: $actionType');
    print('ActionData: $actionData');

    if (actionType != null && actionType.isNotEmpty) {
      // Get navigator from global context
      final context = navigatorKey.currentContext;
      if (context != null) {
        // ✅ FIX: Pass actionType and actionData correctly
        NavigationHelper.handleNotificationAction(
          context,
          actionType,
          actionData: actionData,
        );

        // Refresh notifications
        try {
          context.read<NotificationProvider>().refreshNotifications();
        } catch (e) {
          print('Error refreshing after tap: $e');
        }
      } else {
        print('❌ Navigator context not available');
      }
    } else {
      print('⚠️ No actionType in notification data');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'cinepass_notifications',
            'CinePass Notifications',
            channelDescription: 'Notifications from CinePass app',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            color: const Color(0xFFec1337), // Cinemax red
            playSound: true,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );

      print('✅ Local notification shown');
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('📍 Local notification tapped');

    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        final actionType = data['actionType'];
        final actionData = data['actionData'];

        print('Payload ActionType: $actionType');
        print('Payload ActionData: $actionData');

        if (actionType != null) {
          final context = navigatorKey.currentContext;
          if (context != null) {
            NavigationHelper.handleNotificationAction(
              context,
              actionType,
              actionData: actionData,
            );
          }
        }
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      final success = await _apiService.registerDeviceToken(
        token: token,
        platform: Platform.isIOS ? 'ios' : 'android',
        deviceModel: '', // TODO: Get from device_info_plus
        appVersion: '', // TODO: Get from package_info_plus
      );

      if (success) {
        print('✅ Device token registered with backend');
      } else {
        print('❌ Failed to register device token with backend');
      }
    } catch (e) {
      print('❌ Error registering device token: $e');
    }
  }

  void _onTokenRefresh(String newToken) {
    print('🔄 FCM token refreshed: $newToken');
    _fcmToken = newToken;
    _registerToken(newToken);
  }

  Future<void> unregisterToken() async {
    if (_fcmToken != null) {
      await _apiService.unregisterDeviceToken(_fcmToken!);
      _fcmToken = null;
    }
  }

  /// Đăng ký lại device token với backend (gọi sau khi đăng nhập)
  Future<void> registerTokenWithBackend() async {
    if (_fcmToken == null) {
      // Lấy lại token nếu chưa có
      _fcmToken = await _fcm.getToken();
    }

    if (_fcmToken != null) {
      await _registerToken(_fcmToken!);
    }
  }

  String? get fcmToken => _fcmToken;
}

// Global navigator key for navigation from background
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
