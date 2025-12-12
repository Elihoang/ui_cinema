// widgets/showtimes_section.dart
import 'package:flutter/material.dart';

class ShowtimesSection extends StatefulWidget {
  const ShowtimesSection({super.key});

  @override
  State<ShowtimesSection> createState() => _ShowtimesSectionState();
}

class _ShowtimesSectionState extends State<ShowtimesSection> {
  int _selectedDateIndex = 0;

  final List<Map<String, String>> _dates = [
    {'day': 'T6', 'date': '14'},
    {'day': 'T7', 'date': '15'},
    {'day': 'CN', 'date': '16'},
    {'day': 'T2', 'date': '17'},
    {'day': 'T3', 'date': '18'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2a1619),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lịch chiếu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: Color(0xFFEC1337),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: Color(0xFFEC1337), size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date Picker
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_dates.length, (i) {
                final selected = _selectedDateIndex == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDateIndex = i),
                  child: Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFEC1337)
                          : const Color(0xFF221013),
                      borderRadius: BorderRadius.circular(12),
                      border: selected
                          ? null
                          : Border.all(color: Colors.grey.shade700),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFEC1337).withOpacity(0.3),
                                blurRadius: 12,
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dates[i]['day']!,
                          style: TextStyle(
                            color: selected
                                ? Colors.white70
                                : Colors.grey.shade400,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _dates[i]['date']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 24),

          // Cinema & Times
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB4qQ1E2A7b2f7lCreheq9G2SlEPLHjDRUnZgKVd0_Od5Kxg0YjzqrsUc7H4Ru_WhhVDfhN443lKARP8tcf0yJiAo46qYLsW3oyxhmXbE4Qm3Ua7XXJikN89y3JRbIOko3kDhV0C4uC1XoqZwcFGBRh7Zsuavhs4UBqTAQZKELr9-VJQEdggVmcGMUFwjH1rw04Gfni6BuDpai8_NyZNxVAAIyxW2DM-p9WQ2mNXHTmwGlvlPAiw_CREfBSpwD4zfX8AJ8IpGUuhF0',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'CGV Vincom Center',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '2.5km',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ['19:30', '20:15', '22:45'].map((time) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      border: Border.all(color: Colors.grey.shade700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
