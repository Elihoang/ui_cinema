// lib/widgets/my_ticket/compact_upcoming_ticket.dart

import 'package:flutter/material.dart';

import '../../models/eticket.dart';

const kPrimary = Color(0xFFEC1337);
const kSurfaceDark = Color(0xFF33191E);
const kSurfaceBorder = Color(0xFF482329);
const kTextSecondary = Color(0xFFC9929B);

class CompactUpcomingTicket extends StatelessWidget {
  final ETicket ticket;
  const CompactUpcomingTicket({super.key, required this.ticket});

  String get durationDisplay {
    final hours = ticket.movie.durationMinutes ~/ 60;
    final minutes = ticket.movie.durationMinutes % 60;
    return '${hours}h ${minutes > 0 ? '${minutes}m' : ''}'.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.92,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: kSurfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kSurfaceBorder),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      ticket.movie.posterUrl ?? '',
                      width: 90,
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey[800], child: const Icon(Icons.movie, color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ticket.movie.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Text('${ticket.movie.category.toString().split('.').last} • $durationDisplay',
                            style: TextStyle(color: kTextSecondary, fontSize: 12)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: kPrimary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Sắp chiếu', style: TextStyle(color: kPrimary, fontSize: 11)),
                            ),
                            const Spacer(),
                            Text('${ticket.relativeDate}, ${ticket.timeDisplay}',
                                style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kSurfaceBorder, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to ticket detail screen
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimary.withOpacity(0.1),
                    foregroundColor: kPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Xem chi tiết', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}