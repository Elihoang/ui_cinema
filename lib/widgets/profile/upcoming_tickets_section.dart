import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'ticket_card.dart';

class UpcomingTicketsSection extends StatelessWidget {
  final List<Ticket> tickets;

  const UpcomingTicketsSection({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vé sắp chiếu',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Xem tất cả',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFec1337),
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: List.generate(
              tickets.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TicketCard(ticket: tickets[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
