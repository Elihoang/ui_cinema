import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../models/seattype.dart';
import '../services/seat_service.dart';
import '../services/seattype_service.dart';
import '../widgets/seat/sticky_header.dart';
import '../widgets/seat/screen_visual.dart';
import '../widgets/seat/seat_grid.dart';
import '../widgets/seat/legend.dart';
import '../widgets/seat/bottom_payment_bar.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String screenId;
  final String showtimeId;
  final String movieTitle;
  final String? moviePoster;
  final String cinemaName;
  final String showtime;
  final String date;
  final double basePrice;

  const SeatSelectionScreen({
    super.key,
    required this.screenId,
    required this.showtimeId,
    required this.movieTitle,
    this.moviePoster,
    required this.cinemaName,
    required this.showtime,
    required this.date,
    required this.basePrice,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<Seat> seats = [];
  List<SeatType> seatTypes = [];
  final Set<String> selectedSeats = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.wait([_fetchSeats(), _fetchSeatTypes()]);
  }

  // Lấy danh sách loại ghế (VIP, Standard, Couple...)
  Future<void> _fetchSeatTypes() async {
    try {
      final fetchedSeatTypes = await SeatTypeService.getAllSeatTypes();
      setState(() {
        seatTypes = fetchedSeatTypes;
      });
    } catch (e) {
      // dùng mặc định phí
      print('Failed to fetch seat types: $e');
    }
  }

  // Lấy danh sách ghế theo suất chiếu
  Future<void> _fetchSeats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Gọi API SeatService.getSeatsByShowtimeId() - Lấy trạng thái ghế (available, booked, selected)
      final fetchedSeats = await SeatService.getSeatsByShowtimeId(
        widget.showtimeId,
      );
      setState(() {
        seats = fetchedSeats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải dữ liệu ghế: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF180c0e),
      body: SafeArea(
        child: Column(
          children: [
            // WIDGET
            StickyHeader(
              movieTitle: widget.movieTitle,
              cinemaName: widget.cinemaName,
              showtime: widget.showtime,
              date: widget.date,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(child: _buildContent()),
            // WIDGET
            const Legend(),
            // WIDGET
            BottomPaymentBar(
              selectedSeats: selectedSeats
                  .map((id) => seats.firstWhere((s) => s.id == id))
                  .toList(),
              seatTypes: seatTypes,
              movieTitle: widget.movieTitle,
              moviePoster: widget.moviePoster,
              cinemaName: widget.cinemaName,
              showtime: widget.showtime,
              date: widget.date,
              showtimeId: widget.showtimeId,
              basePrice: widget.basePrice, // Pass showtime base price
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFEC1337)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.grey.shade400, size: 64),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchSeats,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC1337),
                foregroundColor: Colors.white,
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (seats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_seat, color: Colors.grey.shade400, size: 64),
            const SizedBox(height: 16),
            Text(
              'Không có ghế nào',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 24),
        // WIDGET
        const ScreenVisual(),
        const SizedBox(height: 24),
        Expanded(
          // WIDGET
          child: SeatGrid(
            seats: seats,
            selectedSeats: selectedSeats,
            onSeatTapped: (seat) {
              setState(() {
                if (selectedSeats.contains(seat.id)) {
                  selectedSeats.remove(seat.id);
                } else {
                  selectedSeats.add(seat.id);
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
