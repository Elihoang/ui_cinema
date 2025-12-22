import 'package:flutter/material.dart';

import '../../models/eticket.dart';
import '../my_ticket/history_ticket_item.dart';
import 'big_upcoming_ticket.dart';
import 'compact_upcoming_ticket.dart';

class UpcomingTab extends StatelessWidget {
  final List<ETicket> tickets; // vé sắp tới
  final List<ETicket> recentHistory; // thêm danh sách gần đây

  const UpcomingTab({
    super.key,
    required this.tickets,
    this.recentHistory = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        // Phần sắp tới
        if (tickets.isEmpty)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Chưa có vé sắp tới', style: TextStyle(color: Colors.grey)),
          ))
        else ...[
          BigUpcomingTicket(ticket: tickets[0]),
          for (int i = 1; i < tickets.length; i++)
            CompactUpcomingTicket(ticket: tickets[i]),
        ],

        const SizedBox(height: 24),

        // Phần Gần đây
        if (recentHistory.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Gần đây',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          for (var ticket in recentHistory)
            HistoryTicketItem(ticket: ticket),
        ],
      ],
    );
  }
}
