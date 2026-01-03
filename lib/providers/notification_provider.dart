import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/api_service.dart';

class NotificationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<AppNotification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  List<AppNotification> get notifications => _notifications;
  List<AppNotification> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load notifications
  Future<void> loadNotifications({bool unreadOnly = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await _apiService.getNotifications(
        limit: 50,
        unreadOnly: unreadOnly,
      );
      await _updateUnreadCount();
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await loadNotifications();
  }

  // Update unread count
  Future<void> _updateUnreadCount() async {
    try {
      _unreadCount = await _apiService.getUnreadCount();
      notifyListeners();
    } catch (e) {
      print('Error updating unread count: $e');
    }
  }

  // Mark as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final success = await _apiService.markAsRead(notificationId);

      if (success) {
        // Update local state
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(
            isRead: true,
            readAt: DateTime.now(),
          );
          _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
          notifyListeners();
        }
      }

      return success;
    } catch (e) {
      print('Error marking as read: $e');
      return false;
    }
  }

  // Mark all as read
  Future<bool> markAllAsRead() async {
    try {
      final success = await _apiService.markAllAsRead();

      if (success) {
        // Update local state
        _notifications = _notifications
            .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
            .toList();
        _unreadCount = 0;
        notifyListeners();
      }

      return success;
    } catch (e) {
      print('Error marking all as read: $e');
      return false;
    }
  }

  // Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final success = await _apiService.deleteNotification(notificationId);

      if (success) {
        // Update local state
        final notification = _notifications.firstWhere((n) => n.id == notificationId);
        _notifications.removeWhere((n) => n.id == notificationId);

        if (!notification.isRead) {
          _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
        }

        notifyListeners();
      }

      return success;
    } catch (e) {
      print('Error deleting notification: $e');
      return false;
    }
  }

  // Start polling for unread count (for web/background)
  void startPolling() {
    Future.delayed(const Duration(seconds: 30), () {
      _updateUnreadCount();
      startPolling(); // Recursive call
    });
  }

  // Stop polling
  void stopPolling() {
    // Implement if needed
  }
}