// lib/widgets/my_ticket/big_upcoming_ticket.dart (nhỏ sửa để hiển thị tốt hơn khi thiếu dữ liệu)

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/eticket.dart';
import 'dashed_divider.dart';

const kPrimary = Color(0xFFEC1337);
const kSurfaceDark = Color(0xFF33191E);
const kSurfaceBorder = Color(0xFF482329);
const kTextSecondary = Color(0xFFC9929B);

class BigUpcomingTicket extends StatelessWidget {
  final ETicket ticket;
  const BigUpcomingTicket({super.key, required this.ticket});

  String get durationDisplay {
    final hours = ticket.movie.durationMinutes ~/ 60;
    final minutes = ticket.movie.durationMinutes % 60;
    return '${hours}h ${minutes > 0 ? '${minutes}m' : ''}'.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kSurfaceBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 6))
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 210,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                  child: Image.network(
                    ticket.movie.posterUrl ?? '',
                    width: 140,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                          color: Colors.grey[800],
                          child: const Center(child: CircularProgressIndicator(color: kPrimary)));
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.movie, color: Colors.grey, size: 50),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.movie.title,
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${ticket.movie.category.toString().split('.').last.isEmpty ? 'Phim' : ticket.movie.category.toString().split('.').last} • $durationDisplay',
                          style: TextStyle(color: kTextSecondary, fontSize: 13),
                        ),
                        const Spacer(),
                        Text(
                          ticket.cinema.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ' ${ticket.screenName} • Ghế ${ticket.seatCode}',
                          style: TextStyle(color: kTextSecondary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${ticket.relativeDate}, ${ticket.timeDisplay}',
                          style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold, fontSize: 15),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mã vé', style: TextStyle(color: kTextSecondary, fontSize: 12)),
                    Text(
                      ticket.ticketCode,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    final data = (ticket.qrData ?? '').trim();
                    if (data.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mã QR chưa được phát hành')),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: kSurfaceDark,
                        title: const Text('Mã QR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        content: SizedBox(
                          width: 260,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 220,
                                height: 220,
                                child: QrImageView(
                                  data: data,
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
                            child: const Text('Đóng', style: TextStyle(color: kPrimary)),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white, // make label/icon visible on red
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.qr_code_2, size: 24),
                  label: const Text('Xem QR', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}