// // screens/showtime_selection/showtime_selection_screen.dart

// import 'package:flutter/material.dart';
// import '../../models/movie.dart';
// import '../../models/cinema.dart';
// import '../widgets/time/sticky_header.dart';
// import '../widgets/time/location_filter.dart';
// import '../widgets/time/cinema_card.dart';
// import '../../models/date_option.dart';

// class ShowtimeSelectionScreen extends StatefulWidget {
//   final Movie movie;
//   const ShowtimeSelectionScreen({super.key, required this.movie});

//   @override
//   State<ShowtimeSelectionScreen> createState() =>
//       _ShowtimeSelectionScreenState();
// }

// class _ShowtimeSelectionScreenState extends State<ShowtimeSelectionScreen> {
//   int selectedDateIndex = 0;
//   int selectedLocationIndex = 0;

//   // Danh sách ngày
//   final List<DateOption> dates = [
//     DateOption(label: 'H.Nay', day: 24, isToday: true),
//     DateOption(label: 'T7', day: 25),
//     DateOption(label: 'CN', day: 26),
//     DateOption(label: 'T2', day: 27),
//     DateOption(label: 'T3', day: 28),
//     DateOption(label: 'T4', day: 29),
//   ];

//   // Bộ lọc địa điểm
//   final List<String> locations = [
//     'Gần bạn',
//     'TP. Hồ Chí Minh',
//     'Hà Nội',
//     'Đà Nẵng',
//   ];

//   // Dữ liệu rạp chiếu – giữ nguyên như file gốc
//   final List<Cinema> cinemas = [
//     Cinema(
//       name: 'CGV Vincom Đồng Khởi',
//       address: '72 Lê Thánh Tôn, Bến Nghé, Quận 1, TP. HCM',
//       distance: 1.2,
//       formats: [
//         ShowtimeFormat(
//           format: '2D',
//           audioType: 'Phụ đề',
//           showtimes: [
//             ShowtimeSlot(time: '19:30'),
//             ShowtimeSlot(time: '20:15'),
//             ShowtimeSlot(time: '21:00'),
//           ],
//         ),
//         ShowtimeFormat(
//           format: 'IMAX',
//           audioType: 'Lồng tiếng',
//           showtimes: [
//             ShowtimeSlot(time: '18:45'),
//             ShowtimeSlot(time: '21:30'),
//           ],
//         ),
//       ],
//     ),
//     Cinema(
//       name: 'Lotte Cinema Diamond',
//       address: '34 Lê Duẩn, Bến Nghé, Quận 1, TP. HCM',
//       distance: 2.4,
//       formats: [
//         ShowtimeFormat(
//           format: '2D',
//           audioType: 'Thuyết minh',
//           showtimes: [
//             ShowtimeSlot(time: '17:15'),
//             ShowtimeSlot(time: '19:45'),
//             ShowtimeSlot(time: '22:00'),
//             ShowtimeSlot(time: '23:30', isAvailable: false),
//           ],
//         ),
//       ],
//     ),
//     Cinema(
//       name: 'BHD Star Bitexco',
//       address: 'Tầng 3, 4 - Bitexco Icon 68, 2 Hải Triều',
//       distance: 3.1,
//       formats: [
//         ShowtimeFormat(
//           format: '4DX',
//           audioType: 'Phụ đề',
//           showtimes: [ShowtimeSlot(time: '19:00')],
//         ),
//       ],
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF221013),
//       body: Column(
//         children: [
//           // Sticky Header (AppBar + Poster + Date Picker)
//           StickyHeader(
//             movie: widget.movie,
//             dates: dates,
//             selectedDateIndex: selectedDateIndex,
//             onDateSelected: (index) =>
//                 setState(() => selectedDateIndex = index),
//           ),

//           // Nội dung chính: bộ lọc + danh sách rạp
//           Expanded(
//             child: CustomScrollView(
//               slivers: [
//                 // Bộ lọc địa điểm
//                 LocationFilter(
//                   locations: locations,
//                   selectedIndex: selectedLocationIndex,
//                   onLocationSelected: (index) =>
//                       setState(() => selectedLocationIndex = index),
//                 ),

//                 // Danh sách rạp
//                 SliverList(
//                   delegate: SliverChildBuilderDelegate((context, index) {
//                     final cinema = cinemas[index];
//                     final displayDate =
//                         dates[selectedDateIndex].label == 'H.Nay'
//                         ? 'Hôm nay'
//                         : dates[selectedDateIndex].label;

//                     return Padding(
//                       padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                       child: CinemaCard(
//                         cinema: cinema,
//                         movie: widget.movie,
//                         selectedDate: displayDate,
//                       ),
//                     );
//                   }, childCount: cinemas.length),
//                 ),

//                 // Khoảng trống dưới cùng
//                 const SliverToBoxAdapter(child: SizedBox(height: 100)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
