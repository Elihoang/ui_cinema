// // screens/seat_selection/seat_selection_screen.dart
// import 'package:flutter/material.dart';
// import '../../models/seat.dart';
// import '../widgets/seat/sticky_header.dart';
// import '../widgets/seat/screen_visual.dart';
// import '../widgets/seat/seat_grid.dart';
// import '../widgets/seat/legend.dart';
// import '../widgets/seat/bottom_payment_bar.dart';

// class SeatSelectionScreen extends StatefulWidget {
//   final String movieTitle;
//   final String cinemaName;
//   final String showtime;
//   final String date;

//   const SeatSelectionScreen({
//     super.key,
//     required this.movieTitle,
//     required this.cinemaName,
//     required this.showtime,
//     required this.date,
//   });

//   @override
//   State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
// }

// class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
//   late List<Seat> seats;
//   final Set<String> selectedSeats = {};

//   @override
//   void initState() {
//     super.initState();
//     seats = _generateSeats();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF180c0e),
//       body: SafeArea(
//         child: Column(
//           children: [
//             StickyHeader(
//               movieTitle: widget.movieTitle,
//               cinemaName: widget.cinemaName,
//               showtime: widget.showtime,
//               date: widget.date,
//               onBack: () => Navigator.pop(context),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 32),
//                     const ScreenVisual(),
//                     const SizedBox(height: 32),
//                     SeatGrid(
//                       seats: seats,
//                       selectedSeats: selectedSeats,
//                       onSeatTapped: (seat) {
//                         if (seat.status != SeatStatus.booked) {
//                           setState(() {
//                             selectedSeats.contains(seat.id)
//                                 ? selectedSeats.remove(seat.id)
//                                 : selectedSeats.add(seat.id);
//                           });
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 100),
//                   ],
//                 ),
//               ),
//             ),
//             const Legend(),
//             BottomPaymentBar(
//               selectedSeats: selectedSeats
//                   .map((id) => seats.firstWhere((s) => s.id == id))
//                   .toList(),
//               movieTitle: widget.movieTitle,
//               cinemaName: widget.cinemaName,
//               showtime: widget.showtime,
//               date: widget.date,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Seat> _generateSeats() {
//     final List<Seat> seats = [];

//     void addSeats() {
//       seats.addAll([
//         // Row A
//         Seat(
//           id: 'A1',
//           row: 'A',
//           number: 1,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'A2',
//           row: 'A',
//           number: 2,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'A3',
//           row: 'A',
//           number: 3,
//           status: SeatStatus.booked,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'A4',
//           row: 'A',
//           number: 4,
//           status: SeatStatus.booked,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'A5',
//           row: 'A',
//           number: 5,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'A6',
//           row: 'A',
//           number: 6,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'A7',
//           row: 'A',
//           number: 7,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'A8',
//           row: 'A',
//           number: 8,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//       ]);

//       // Row B
//       seats.addAll([
//         Seat(
//           id: 'B1',
//           row: 'B',
//           number: 1,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'B2',
//           row: 'B',
//           number: 2,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'B3',
//           row: 'B',
//           number: 3,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'B4',
//           row: 'B',
//           number: 4,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'B5',
//           row: 'B',
//           number: 5,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'B6',
//           row: 'B',
//           number: 6,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'B7',
//           row: 'B',
//           number: 7,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'B8',
//           row: 'B',
//           number: 8,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//       ]);

//       // Row C
//       seats.addAll([
//         Seat(
//           id: 'C1',
//           row: 'C',
//           number: 1,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'C2',
//           row: 'C',
//           number: 2,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'C3',
//           row: 'C',
//           number: 3,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'C4',
//           row: 'C',
//           number: 4,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'C5',
//           row: 'C',
//           number: 5,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'C6',
//           row: 'C',
//           number: 6,
//           status: SeatStatus.booked,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'C7',
//           row: 'C',
//           number: 7,
//           status: SeatStatus.booked,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'C8',
//           row: 'C',
//           number: 8,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//       ]);

//       // Row D
//       seats.addAll([
//         Seat(
//           id: 'D1',
//           row: 'D',
//           number: 1,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'D2',
//           row: 'D',
//           number: 2,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'D3',
//           row: 'D',
//           number: 3,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'D4',
//           row: 'D',
//           number: 4,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'D5',
//           row: 'D',
//           number: 5,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'D6',
//           row: 'D',
//           number: 6,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'D7',
//           row: 'D',
//           number: 7,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//         Seat(
//           id: 'D8',
//           row: 'D',
//           number: 8,
//           status: SeatStatus.available,
//           type: SeatType.standard,
//           price: 90000,
//         ),
//       ]);

//       // Row F (VIP)
//       seats.addAll([
//         Seat(
//           id: 'F1',
//           row: 'F',
//           number: 1,
//           status: SeatStatus.available,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//         Seat(
//           id: 'F2',
//           row: 'F',
//           number: 2,
//           status: SeatStatus.available,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//         Seat(
//           id: 'F3',
//           row: 'F',
//           number: 3,
//           status: SeatStatus.available,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//         Seat(
//           id: 'F4',
//           row: 'F',
//           number: 4,
//           status: SeatStatus.available,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//         Seat(
//           id: 'F5',
//           row: 'F',
//           number: 5,
//           status: SeatStatus.available,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//         Seat(
//           id: 'F6',
//           row: 'F',
//           number: 6,
//           status: SeatStatus.available,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//       ]);

//       // Row G (VIP)
//       seats.addAll([
//         Seat(
//           id: 'G1',
//           row: 'G',
//           number: 1,
//           status: SeatStatus.booked,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//         Seat(
//           id: 'G2',
//           row: 'G',
//           number: 2,
//           status: SeatStatus.booked,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//         Seat(
//           id: 'G3',
//           row: 'G',
//           number: 3,
//           status: SeatStatus.available,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//         Seat(
//           id: 'G4',
//           row: 'G',
//           number: 4,
//           status: SeatStatus.available,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//         Seat(
//           id: 'G5',
//           row: 'G',
//           number: 5,
//           status: SeatStatus.available,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//         Seat(
//           id: 'G6',
//           row: 'G',
//           number: 6,
//           status: SeatStatus.booked,
//           type: SeatType.vip,
//           price: 150000,
//         ),
//       ]);
//     }

//     addSeats(); // QUAN TRỌNG: phải gọi mới tạo ghế

//     return seats;
//   }
// }
