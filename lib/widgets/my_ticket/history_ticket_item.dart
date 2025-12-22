// lib/widgets/my_ticket/history_ticket_item.dart

import 'package:flutter/material.dart';

import '../../models/eticket.dart';

const kSurfaceDark = Color(0xFF33191E);
const kSurfaceBorder = Color(0xFF482329);
const kTextSecondary = Color(0xFFC9929B);

class HistoryTicketItem extends StatelessWidget {
  final ETicket ticket;
  const HistoryTicketItem({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kSurfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kSurfaceBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ticket.movie.posterUrl ?? '',
                width: 80,
                height: 110,
                fit: BoxFit.cover,
                color: Colors.grey.withOpacity(0.6),
                colorBlendMode: BlendMode.multiply,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey[800], child: const Icon(Icons.movie, color: Colors.grey)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(ticket.movie.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text('Đã xem', style: TextStyle(color: kTextSecondary, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${ticket.timeDisplay}, ${ticket.dateDisplay} • ${ticket.cinema.name}',
                    style: TextStyle(color: kTextSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}