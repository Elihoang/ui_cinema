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
    // Group seats by row
    final Map<String, List<Seat>> seatsByRow = {};
    for (var seat in seats) {
      if (!seatsByRow.containsKey(seat.seatRow)) {
        seatsByRow[seat.seatRow] = [];
      }
      seatsByRow[seat.seatRow]!.add(seat);
    }

    // Sort rows alphabetically
    final sortedRows = seatsByRow.keys.toList()..sort();

    return Center(
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 3.0,
        panEnabled: true,
        scaleEnabled: true,
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: sortedRows.map((row) {
                  final rowSeats = seatsByRow[row]!
                    ..sort((a, b) => a.seatNumber.compareTo(b.seatNumber));

                  // Check if this row has VIP or COUPLE seats
                  final hasVipSeats = rowSeats.any(
                    (s) => s.seatTypeCode?.toUpperCase() == 'VIP',
                  );
                  final hasCoupleSeats = rowSeats.any(
                    (s) => s.seatTypeCode?.toUpperCase() == 'COUPLE',
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Left row label
                        SizedBox(
                          width: 32,
                          child: Text(
                            row,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: hasVipSeats
                                  ? Colors.amber.shade600
                                  : hasCoupleSeats
                                  ? Colors.pink.shade400
                                  : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Seats
                        ...rowSeats.map(
                          (seat) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: SeatWidget(
                              seat: seat,
                              isSelected: selectedSeats.contains(seat.id),
                              onTap: () => onSeatTapped(seat),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Right row label
                        SizedBox(
                          width: 32,
                          child: Text(
                            row,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: hasVipSeats
                                  ? Colors.amber.shade600
                                  : hasCoupleSeats
                                  ? Colors.pink.shade400
                                  : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
