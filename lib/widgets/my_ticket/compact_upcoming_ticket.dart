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
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: kSurfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kSurfaceBorder),
        ),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        ticket.movie.posterUrl ?? '',
                        width: 75,
                        height: 105,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 75,
                          height: 105,
                          color: Colors.grey[800], 
                          child: const Icon(Icons.movie, color: Colors.grey, size: 40)
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(ticket.movie.title,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 3),
                          Text('${ticket.movie.category.toString().split('.').last} • $durationDisplay',
                              style: TextStyle(color: kTextSecondary, fontSize: 10)),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: kPrimary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text('Sắp chiếu', style: TextStyle(color: kPrimary, fontSize: 9)),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text('${ticket.relativeDate}, ${ticket.timeDisplay}',
                                    style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold, fontSize: 10),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ),
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
                padding: const EdgeInsets.fromLTRB(12, 5, 12, 6),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to ticket detail screen
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimary.withOpacity(0.15),
                      foregroundColor: kPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: kPrimary.withOpacity(0.3), width: 1),
                      ),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Xem chi tiết', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}