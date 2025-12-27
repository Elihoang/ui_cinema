import 'package:flutter/material.dart';

import '../../models/eticket.dart';
import 'profile_upcoming_ticket.dart';

class UpcomingTicketsSection extends StatefulWidget {
  final List<ETicket> tickets;

  const UpcomingTicketsSection({super.key, required this.tickets});

  @override
  State<UpcomingTicketsSection> createState() => _UpcomingTicketsSectionState();
}

class _UpcomingTicketsSectionState extends State<UpcomingTicketsSection> {
  bool _isExpanded = false;

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
              if (widget.tickets.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() => _isExpanded = !_isExpanded);
                  },
                  child: Row(
                    children: [
                      Text(
                        _isExpanded ? 'Thu gọn' : 'Xem tất cả',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFec1337),
                        ),
                      ),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: const Color(0xFFec1337),
                        size: 20,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (widget.tickets.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 64,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Chưa có vé sắp chiếu',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (_isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: widget.tickets
                  .map((ticket) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProfileUpcomingTicket(ticket: ticket),
                      ))
                  .toList(),
            ),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: widget.tickets.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: index < widget.tickets.length - 1 ? 12 : 0),
                child: SizedBox(
                  width: 320,
                  child: ProfileUpcomingTicket(ticket: widget.tickets[index]),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
