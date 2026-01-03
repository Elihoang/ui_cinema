import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushEnabled = true;
  bool _orderStatusEnabled = true;
  bool _upcomingShowtimeEnabled = true;
  bool _promotionEnabled = true;
  bool _systemEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushEnabled = prefs.getBool('push_enabled') ?? true;
      _orderStatusEnabled = prefs.getBool('order_status_enabled') ?? true;
      _upcomingShowtimeEnabled = prefs.getBool('upcoming_showtime_enabled') ?? true;
      _promotionEnabled = prefs.getBool('promotion_enabled') ?? true;
      _systemEnabled = prefs.getBool('system_enabled') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);

    // TODO: Call API to update settings on server
    // await apiService.updateNotificationSettings(...)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: ListView(
        children: [
          // Push Notifications
          SwitchListTile(
            title: const Text(
              'Push Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Receive notifications on this device'),
            value: _pushEnabled,
            onChanged: (value) {
              setState(() {
                _pushEnabled = value;
              });
              _saveSetting('push_enabled', value);
            },
          ),
          const Divider(),

          // Category Settings
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Notification Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SwitchListTile(
            title: const Text('Order Status'),
            subtitle: const Text('Order confirmations, payment updates'),
            value: _orderStatusEnabled,
            onChanged: (value) {
              setState(() {
                _orderStatusEnabled = value;
              });
              _saveSetting('order_status_enabled', value);
            },
          ),

          SwitchListTile(
            title: const Text('Upcoming Showtimes'),
            subtitle: const Text('Reminders for booked movies'),
            value: _upcomingShowtimeEnabled,
            onChanged: (value) {
              setState(() {
                _upcomingShowtimeEnabled = value;
              });
              _saveSetting('upcoming_showtime_enabled', value);
            },
          ),

          SwitchListTile(
            title: const Text('Promotions & Offers'),
            subtitle: const Text('Special deals, vouchers, discounts'),
            value: _promotionEnabled,
            onChanged: (value) {
              setState(() {
                _promotionEnabled = value;
              });
              _saveSetting('promotion_enabled', value);
            },
          ),

          SwitchListTile(
            title: const Text('System Notifications'),
            subtitle: const Text('App updates, maintenance notices'),
            value: _systemEnabled,
            onChanged: (value) {
              setState(() {
                _systemEnabled = value;
              });
              _saveSetting('system_enabled', value);
            },
          ),
        ],
      ),
    );
  }
}