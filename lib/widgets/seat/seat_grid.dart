import 'package:flutter/material.dart';
import '../../models/seat.dart';
import 'seat_widget.dart';

class SeatGrid extends StatelessWidget {
  final List<Seat> seats;
  final Set<String> selectedSeats;
  final Function(Seat) onSeatTapped;

  const SeatGrid({
    super.key,
    required this.seats,
    required this.selectedSeats,
    required this.onSeatTapped,
  });

  @override
  Widget build(BuildContext context) {
    final rows = seats.map((s) => s.row).toSet();

    return Column(
      children: rows.map((row) {
        final rowSeats = seats.where((s) => s.row == row).toList()
          ..sort((a, b) => a.number.compareTo(b.number));
        final isVip = rowSeats.first.type == SeatType.vip;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  row,
                  style: TextStyle(
                    color: isVip ? Colors.amber.shade600 : Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ...rowSeats.map(
                (seat) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SeatWidget(
                    seat: seat,
                    isSelected: selectedSeats.contains(seat.id),
                    onTap: () => onSeatTapped(seat),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 24,
                child: Text(
                  row,
                  style: TextStyle(
                    color: isVip ? Colors.amber.shade600 : Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
