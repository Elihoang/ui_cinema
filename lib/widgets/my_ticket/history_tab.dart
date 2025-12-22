import 'package:flutter/material.dart';

import '../../models/eticket.dart';
import 'history_ticket_item.dart';

class HistoryTab extends StatelessWidget {
  final List<ETicket> tickets;
  const HistoryTab({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) return const Center(child: Text('Chưa có lịch sử xem phim', style: TextStyle(color: Colors.grey)));
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      itemCount: tickets.length,
      itemBuilder: (_, i) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: HistoryTicketItem(ticket: tickets[i])),
    );
  }
}