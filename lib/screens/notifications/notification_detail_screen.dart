import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../models/notification.dart';
import '../../providers/notification_provider.dart';
import '../../utils/navigation_helper.dart';

class NotificationDetailScreen extends StatefulWidget {
  final AppNotification notification;

  const NotificationDetailScreen({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.notification.isRead) {
        context
            .read<NotificationProvider>()
            .markAsRead(widget.notification.id);
      }
    });
  }

  Color _getPriorityColor() {
    switch (widget.notification.priority) {
      case 2:
        return const Color(0xFFec1337);
      case 1:
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF2196F3);
    }
  }

  IconData _getIcon() {
    final key = (widget.notification.actionType ??
        widget.notification.type).toLowerCase();

    switch (key) {
      case 'openorderdetail':
      case '1':
        return Icons.receipt_long_outlined;
      case 'openmoviedetail':
      case '2':
        return Icons.movie_outlined;
      case 'openshowtime':
      case '3':
        return Icons.access_time_outlined;
      case 'openvoucherlist':
      case 'openvoucherdetail':
      case '4':
      case '5':
        return Icons.local_offer_outlined;
      case 'openpointshistory':
      case '6':
        return Icons.stars_outlined;
      case 'opennotificationcenter':
      case '7':
        return Icons.notifications_outlined;
      case 'openurl':
      case '8':
        return Icons.link_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _getTypeLabel() {
    final key = (widget.notification.actionType ??
        widget.notification.type).toLowerCase();

    switch (key) {
      case 'openorderdetail':
      case '1':
        return 'Đơn hàng';
      case 'openmoviedetail':
      case '2':
        return 'Phim';
      case 'openshowtime':
      case '3':
        return 'Lịch chiếu';
      case 'openvoucherlist':
      case 'openvoucherdetail':
      case '4':
      case '5':
        return 'Ưu đãi';
      case 'openpointshistory':
      case '6':
        return 'Thành viên';
      case 'opennotificationcenter':
      case '7':
        return 'Hệ thống';
      case 'openurl':
      case '8':
        return 'Liên kết';
      default:
        return 'Thông báo';
    }
  }

  String _getActionButtonText() {
    if (widget.notification.actionType == null) {
      return 'Xem chi tiết';
    }

    final key = widget.notification.actionType!.toLowerCase();

    switch (key) {
      case 'openorderdetail':
      case '1':
        return 'Xem đơn hàng';
      case 'openmoviedetail':
      case '2':
        return 'Xem phim';
      case 'openshowtime':
      case '3':
        return 'Xem lịch chiếu';
      case 'openvoucherlist':
      case '4':
        return 'Xem ưu đãi';
      case 'openvoucherdetail':
      case '5':
        return 'Xem ưu đãi';
      case 'openpointshistory':
      case '6':
        return 'Xem điểm';
      case 'openurl':
      case '8':
        return 'Mở liên kết';
      default:
        return 'Xem chi tiết';
    }
  }

  // ✅ FIX: Correct data parsing
  Map<String, dynamic>? _parsedData() {
    final data = widget.notification.data;
    if (data == null) return null;

    // data is ALREADY Map<String, dynamic> from the model
    // Just return it directly!
    if (data is Map<String, dynamic>) {
      return data;
    }

    // If somehow it's an untyped Map, convert it
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    // This case should never happen since model defines data as Map<String, dynamic>?
    return null;
  }

  void _handleAction() {
    if (widget.notification.actionType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không có hành động'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    NavigationHelper.handleNotificationAction(
      context,
      widget.notification.actionType,
      actionData: widget.notification.actionData,
    );
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF3a1c20),
        title: const Text(
          'Xác nhận xóa',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Bạn có chắc muốn xóa thông báo này?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Hủy', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFec1337),
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await context
          .read<NotificationProvider>()
          .deleteNotification(widget.notification.id);

      if (!mounted) return;

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa thông báo'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xóa thất bại'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailData = _parsedData();

    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3a1c20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chi tiết thông báo',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF3a1c20),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getPriorityColor().withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getPriorityColor().withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: widget.notification.imageUrl != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.notification.imageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          _getIcon(),
                          color: _getPriorityColor(),
                          size: 40,
                        ),
                      ),
                    )
                        : Icon(
                      _getIcon(),
                      color: _getPriorityColor(),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getTypeLabel(),
                      style: TextStyle(
                        color: _getPriorityColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.notification.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.notification.formattedDate,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.notification.message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[300],
                      height: 1.6,
                    ),
                  ),
                  if (detailData != null && detailData.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text(
                      'Thông tin chi tiết',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3a1c20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: detailData.entries
                            .map(
                              (e) => Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${e.key}: ',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    e.value.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ],
                  if (widget.notification.actionType != null) ...[
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handleAction,
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(_getActionButtonText()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFec1337),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}