// // lib/widgets/seat/bottom_payment_bar.dart
// import 'package:flutter/material.dart';
// import 'package:fe_cinema_mobile/models/seat.dart';
// import 'package:fe_cinema_mobile/models/booking.dart';
// import 'package:fe_cinema_mobile/screens/payment_screen.dart';

// class BottomPaymentBar extends StatelessWidget {
//   final List<Seat> selectedSeats;
//   final String movieTitle;
//   final String cinemaName;
//   final String showtime;
//   final String date;

//   const BottomPaymentBar({
//     super.key,
//     required this.selectedSeats,
//     required this.movieTitle,
//     required this.cinemaName,
//     required this.showtime,
//     required this.date,
//   });

//   double get total => selectedSeats.fold(0, (sum, seat) => sum + seat.price);
//   List<String> get seatLabels =>
//       selectedSeats.map((s) => s.id).toList()..sort();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(
//         20,
//         16,
//         20,
//         MediaQuery.of(context).padding.bottom + 16,
//       ),
//       decoration: BoxDecoration(
//         color: const Color(0xFF221013),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//         border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.4),
//             blurRadius: 20,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Ghế đang chọn',
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     seatLabels.isEmpty
//                         ? Text(
//                             'Chưa chọn ghế',
//                             style: TextStyle(
//                               color: Colors.grey.shade700,
//                               fontSize: 14,
//                             ),
//                           )
//                         : Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: seatLabels
//                                 .map(
//                                   (label) => Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 6,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                     child: Text(
//                                       label,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     'Tổng cộng',
//                     style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.baseline,
//                     textBaseline: TextBaseline.alphabetic,
//                     children: [
//                       Text(
//                         '${total.toInt()}',
//                         style: const TextStyle(
//                           color: Color(0xFFec1337),
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Text(
//                         'đ',
//                         style: TextStyle(
//                           color: Color(0xFFec1337),
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: seatLabels.isEmpty
//                   ? null
//                   : () {
//                       final booking = BookingInfo(
//                         movieTitle: movieTitle,
//                         moviePoster: 'https://picsum.photos/300/450',
//                         cinema: cinemaName,
//                         hall: 'Rạp 5',
//                         showtime: showtime,
//                         date: date,
//                         seats: seatLabels,
//                         ticketPrice: total,
//                         comboPrice: 0,
//                         discount: 0,
//                       );

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => PaymentScreen(booking: booking),
//                         ),
//                       );
//                     },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFec1337),
//                 disabledBackgroundColor: Colors.grey.shade800,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 10,
//                 shadowColor: const Color(0xFFec1337).withOpacity(0.4),
//               ),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Thanh toán ngay',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Icon(Icons.arrow_forward, color: Colors.white),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
