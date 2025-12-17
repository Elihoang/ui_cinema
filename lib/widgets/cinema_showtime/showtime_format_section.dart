import 'package:flutter/material.dart';
import 'showtime_button_widget.dart';

class ShowtimeFormatSection extends StatelessWidget {
  final String format;
  final String audioType;
  final List<ShowtimeSlot> showtimes;
  final bool isSpecialFormat;
  final Function(ShowtimeSlot) onShowtimeSelected;

  const ShowtimeFormatSection({
    super.key,
    required this.format,
    required this.audioType,
    required this.showtimes,
    this.isSpecialFormat = false,
    required this.onShowtimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: isSpecialFormat ? null : Colors.white.withOpacity(0.1),
                gradient: isSpecialFormat
                    ? const LinearGradient(
                        colors: [Color(0xFF2563eb), Color(0xFF9333ea)],
                      )
                    : null,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSpecialFormat
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Text(
                format,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              audioType,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: showtimes.length,
          itemBuilder: (context, index) {
            final showtime = showtimes[index];
            return ShowtimeButtonWidget(
              time: showtime.time,
              price: showtime.price,
              isSoldOut: showtime.isSoldOut,
              isVip: showtime.isVip,
              onTap: () => onShowtimeSelected(showtime),
            );
          },
        ),
      ],
    );
  }
}

class ShowtimeSlot {
  final String time;
  final String price;
  final bool isSoldOut;
  final bool isVip;

  ShowtimeSlot({
    required this.time,
    required this.price,
    this.isSoldOut = false,
    this.isVip = false,
  });
}
