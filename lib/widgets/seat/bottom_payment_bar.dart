import 'package:flutter/material.dart';
import '../../models/seat.dart';
import '../../models/seattype.dart';
import '../../models/booking.dart';
import '../../screens/payment_screen.dart';

class BottomPaymentBar extends StatelessWidget {
  final List<Seat> selectedSeats;
  final List<SeatType> seatTypes;
  final String movieTitle;
  final String? moviePoster;
  final String cinemaName;
  final String showtime;
  final String date;
  final String showtimeId; // Added for API integration
  final double basePrice; // Base price from showtime

  const BottomPaymentBar({
    super.key,
    required this.selectedSeats,
    required this.seatTypes,
    required this.movieTitle,
    this.moviePoster,
    required this.cinemaName,
    required this.showtime,
    required this.date,
    required this.showtimeId,
    required this.basePrice,
  });

  // Get surcharge rate from API data, fallback to defaults if not found
  double _getSurchargeRate(String? seatTypeCode) {
    if (seatTypeCode == null) return 1.0;

    // Try to find seat type in fetched data
    try {
      final seatType = seatTypes.firstWhere(
        (st) => st.code.toUpperCase() == seatTypeCode.toUpperCase(),
      );
      return seatType.surchargeRate;
    } catch (e) {
      // Fallback to default values if not found in API data
      final type = seatTypeCode.toUpperCase();
      switch (type) {
        case 'VIP':
          return 1.2; // Default +20%
        case 'COUPLE':
          return 1.5; // Default +50%
        case 'NORMAL':
        default:
          return 1.0; // Default normal price
      }
    }
  }

  // Calculate price for individual seat based on type
  // Formula: seatPrice = basePrice × surchargeRate
  double _getSeatPrice(Seat seat) {
    final surchargeRate = _getSurchargeRate(seat.seatTypeCode);
    return basePrice * surchargeRate;
  }

  // Calculate total price for all selected seats
  double get total {
    double sum = 0;
    for (var seat in selectedSeats) {
      sum += _getSeatPrice(seat);
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
                      // Navigate to payment screen with booking info
                      final booking = BookingInfo(
                        movieTitle: movieTitle,
                        moviePoster: moviePoster ?? '',
                        cinema: cinemaName,
                        hall: '', // TODO: Pass from parent if needed
                        showtime: showtime,
                        date: date,
                        seats: seatLabels,
                        ticketPrice: total,
                        comboPrice: 0, // Will be updated after combo selection
                        discount: 0,
                        showtimeId: showtimeId,
                        seatIds: selectedSeats.map((s) => s.id).toList(),
                        products: [], // Will be added in combo selection screen
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(booking: booking),
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
