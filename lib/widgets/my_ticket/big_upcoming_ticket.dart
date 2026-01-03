// lib/widgets/my_ticket/big_upcoming_ticket.dart

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../extensions/movie_category_extension.dart';
import '../../models/ticket/my_ticket_dto.dart';
import 'dashed_divider.dart';

const kPrimary = Color(0xFFEC1337);
const kSurfaceDark = Color(0xFF33191E);
const kSurfaceBorder = Color(0xFF482329);
const kTextSecondary = Color(0xFFC9929B);

class BigUpcomingTicket extends StatelessWidget {
  final MyTicketDto ticket;
  final bool compact;
  const BigUpcomingTicket({
    super.key,
    required this.ticket,
    this.compact = false,
  });

  String get durationDisplay {
    final hours = ticket.movieDurationMinutes ~/ 60;
    final minutes = ticket.movieDurationMinutes % 60;
    return '${hours}h ${minutes > 0 ? '${minutes}m' : ''}'.trim();
  }

  @override
  Widget build(BuildContext context) {
    final imageHeight = compact ? 140.0 : 210.0;
    final imageWidth = compact ? 95.0 : 140.0;
    final contentPadding = compact ? 10.0 : 16.0;
    final titleFontSize = compact ? 15.0 : 19.0;
    final cinemaFontSize = compact ? 13.0 : 16.0;
    final timeFontSize = compact ? 13.0 : 15.0;
    final bottomPadding = compact ? 10.0 : 16.0;
    final ticketCodeFontSize = compact ? 14.0 : 18.0;
    final buttonPaddingH = compact ? 14.0 : 22.0;
    final buttonPaddingV = compact ? 10.0 : 14.0;

    return Container(
      margin: EdgeInsets.all(compact ? 8 : 16),
      decoration: BoxDecoration(
        color: kSurfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kSurfaceBorder),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: imageHeight,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                  child: Image.network(
                    ticket.moviePosterUrl ?? '',
                    width: imageWidth,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: CircularProgressIndicator(color: kPrimary),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.movie,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(contentPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.movieTitle,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: compact ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: compact ? 2 : 4),
                        Text(
                          '${ticket.category.vi} • $durationDisplay',
                          style: TextStyle(
                            color: kTextSecondary,
                            fontSize: compact ? 11.0 : 13.0,
                          ),
                        ),
                        if (!compact)
                          const Spacer()
                        else
                          const SizedBox(height: 6),
                        Text(
                          ticket.cinemaName,
                          style: TextStyle(
                            fontSize: cinemaFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${ticket.screenName} • Ghế ${ticket.seatCode}',
                          style: TextStyle(
                            color: kTextSecondary,
                            fontSize: compact ? 11.0 : 14.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${ticket.relativeDate}, ${ticket.timeDisplay}',
                          style: TextStyle(
                            color: kPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: timeFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DashedDivider(),
          Padding(
            padding: EdgeInsets.all(bottomPadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã vé',
                        style: TextStyle(
                          color: kTextSecondary,
                          fontSize: compact ? 10.0 : 12.0,
                        ),
                      ),
                      Text(
                        ticket.ticketCode,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: ticketCodeFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    if (ticket.ticketCode.isEmpty ||
                        ticket.ticketCode == 'CHƯA PHÁT HÀNH') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mã QR chưa được phát hành'),
                        ),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: kSurfaceDark,
                        title: const Text(
                          'Mã QR',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: SizedBox(
                          width: 260,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 220,
                                height: 220,
                                child: QrImageView(
                                  data: ticket.ticketCode,
                                  version: QrVersions.auto,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Mã vé: ${ticket.ticketCode}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Đóng',
                              style: TextStyle(color: kPrimary),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor:
                        Colors.white, // make label/icon visible on red
                    padding: EdgeInsets.symmetric(
                      horizontal: buttonPaddingH,
                      vertical: buttonPaddingV,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.qr_code_2, size: compact ? 20 : 24),
                  label: Text(
                    'Xem QR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: compact ? 12.0 : 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
