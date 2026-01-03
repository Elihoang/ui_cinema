import 'package:intl/intl.dart';

class AppNotification {
  final String id;
  final String? userId;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final bool isRead;
  final String? imageUrl;
  final String? actionType;
  final String? actionData;
  final int priority;
  final DateTime createdAt;
  final DateTime? readAt;

  AppNotification({
    required this.id,
    this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    required this.isRead,
    this.imageUrl,
    this.actionType,
    this.actionData,
    required this.priority,
    required this.createdAt,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] ?? false,
      imageUrl: json['imageUrl'],
      actionType: json['actionType'],
      actionData: json['actionData'],
      priority: json['priority'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'message': message,
      'data': data,
      'isRead': isRead,
      'imageUrl': imageUrl,
      'actionType': actionType,
      'actionData': actionData,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }

  // ✅ FIX: Add formattedDate getter
  String get formattedDate {
    return DateFormat('dd/MM/yyyy HH:mm').format(createdAt);
  }

  // Vietnamese time ago
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years năm trước';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months tháng trước';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks tuần trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  AppNotification copyWith({
    bool? isRead,
    DateTime? readAt,
  }) {
    return AppNotification(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      data: data,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl,
      actionType: actionType,
      actionData: actionData,
      priority: priority,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
    );
  }
}

class NotificationResponse {
  final bool success;
  final String? message;
  final List<AppNotification> data;

  NotificationResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((item) => AppNotification.fromJson(item))
          .toList() ??
          [],
    );
  }
}