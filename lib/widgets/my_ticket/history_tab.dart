import 'package:flutter/material.dart';

import '../../models/ticket/my_ticket_dto.dart';
import 'history_ticket_item.dart';

class HistoryTab extends StatelessWidget {
  final List<MyTicketDto> tickets;
  final Future<void> Function()? onRefresh;

  const HistoryTab({super.key, required this.tickets, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      // Khi không có vé, vẫn cho phép kéo xuống để refresh
      return RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        color: const Color(0xFFEC1337),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            Center(
              child: Text(
                'Chưa có lịch sử xem phim',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      color: const Color(0xFFEC1337),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        itemCount: tickets.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: HistoryTicketItem(ticket: tickets[i]),
        ),
      ),
    );
  }
}
