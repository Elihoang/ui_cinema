import 'dart:convert';
import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';
import '../screens/my_ticket_screen.dart';

class NavigationHelper {
  /// Handle notification navigation with separate actionType and actionData
  /// @param actionType: Type of action (e.g., "OpenOrderDetail", "OpenMovieDetail")
  /// @param actionData: JSON string or null with action parameters
  static void handleNotificationAction(
    BuildContext context,
    String? actionType, {
    String? actionData,
  }) {
    // ✅ FIX: Handle null actionType
    if (actionType == null || actionType.isEmpty) {
      print('No action type provided');
      return;
    }

    print('Navigation - ActionType: $actionType');
    print('Navigation - ActionData: $actionData');

    // Parse actionData if exists
    Map<String, dynamic>? data;
    if (actionData != null && actionData.isNotEmpty) {
      try {
        data = jsonDecode(actionData) as Map<String, dynamic>;
      } catch (e) {
        print('Error parsing actionData: $e');
      }
    }

    // ✅ FIX: Match with backend NotificationActionType enum
    final actionTypeLower = actionType.toLowerCase();

    switch (actionTypeLower) {
      case 'openorderdetail':
      case '1':
        print('Navigating to My Tickets screen');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyTicketScreen()),
        );
        break;

      case 'openmoviedetail':
      case '2': // Enum value
        final movieId = data?['movieId'];
        if (movieId != null) {
          print('Navigating to movie detail: $movieId');
          Navigator.pushNamed(
            context,
            '/movie-detail',
            arguments: {'movieId': movieId},
          );
        } else {
          print('MovieId not found in actionData');
        }
        break;

      case 'openshowtime':
      case '3': // Enum value
        final showtimeId = data?['showtimeId'];
        if (showtimeId != null) {
          print('Navigating to showtime: $showtimeId');
          Navigator.pushNamed(
            context,
            '/showtime',
            arguments: {'showtimeId': showtimeId},
          );
        } else {
          print('ShowtimeId not found in actionData');
        }
        break;

      case 'openvoucherlist':
      case '4': // Enum value
        print('Navigating to voucher list');
        Navigator.pushNamed(context, '/vouchers');
        break;

      case 'openvoucherdetail':
      case '5': // Enum value
        final voucherId = data?['voucherId'];
        if (voucherId != null) {
          print('Navigating to voucher detail: $voucherId');
          Navigator.pushNamed(
            context,
            '/voucher-detail',
            arguments: {'voucherId': voucherId},
          );
        } else {
          print('VoucherId not found in actionData');
        }
        break;

      case 'openpointshistory':
      case '6':
        print('Navigating to Profile screen');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;

      case 'opennotificationcenter':
      case '7': // Enum value
        print('Navigating to notification center');
        Navigator.pushNamed(context, '/notifications');
        break;

      case 'openurl':
      case '8': // Enum value
        final url = data?['url'];
        if (url != null) {
          print('Opening URL: $url');
          // TODO: Implement URL launcher
          // await launchUrl(Uri.parse(url));
        } else {
          print('URL not found in actionData');
        }
        break;

      case 'openticket':
        final ticketId = data?['ticketId'];
        if (ticketId != null) {
          print('Navigating to ticket: $ticketId');
          Navigator.pushNamed(
            context,
            '/ticket-detail',
            arguments: {'ticketId': ticketId},
          );
        } else {
          print('TicketId not found in actionData');
        }
        break;

      case 'none':
      case '0':
        print('No action specified (None)');
        break;

      default:
        print('Unknown action type: $actionType');
    }
  }
}
