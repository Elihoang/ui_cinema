import 'package:flutter/material.dart';
import '../../models/seat.dart';

class BottomPaymentBar extends StatelessWidget {
  final List<Seat> selectedSeats;
  final String movieTitle;
  final String cinemaName;
  final String showtime;
  final String date;

  const BottomPaymentBar({
    super.key,
    required this.selectedSeats,
    required this.movieTitle,
    required this.cinemaName,
    required this.showtime,
    required this.date,
  });

  // For now, using fixed prices - will be updated when we have actual pricing from backend
  double get total {
    double sum = 0;
    for (var seat in selectedSeats) {
      final seatType = seat.seatTypeCode?.toUpperCase() ?? 'NORMAL';
      switch (seatType) {
        case 'VIP':
          sum += 150000;
          break;
        case 'COUPLE':
          sum += 200000;
          break;
        default:
          sum += 90000;
      }
    }
    return sum;
  }

  // Format money with dots as thousand separators (10.000, 90.000, 150.000...)
  String formatMoney(double amount) {
    final intAmount = amount.toInt();
    final str = intAmount.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }

    return buffer.toString();
  }

  List<String> get seatLabels =>
      selectedSeats.map((s) => s.seatCode).toList()..sort();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF221013),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ghế đang chọn',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    seatLabels.isEmpty
                        ? Text(
                            'Chưa chọn ghế',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: seatLabels
                                .map(
                                  (label) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      label,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tổng cộng',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formatMoney(total),
                        style: const TextStyle(
                          color: Color(0xFFec1337),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'đ',
                        style: TextStyle(
                          color: Color(0xFFec1337),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: seatLabels.isEmpty
                  ? null
                  : () {
                      // TODO: Navigate to payment/combo selection screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Đã chọn ${seatLabels.length} ghế: ${seatLabels.join(", ")}',
                          ),
                          backgroundColor: const Color(0xFFec1337),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFec1337),
                disabledBackgroundColor: Colors.grey.shade800,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 10,
                shadowColor: const Color(0xFFec1337).withOpacity(0.4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tiếp tục',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
