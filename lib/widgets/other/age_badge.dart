import 'package:flutter/material.dart';

class AgeBadge extends StatelessWidget {
  final int ageLimit;

  const AgeBadge({super.key, required this.ageLimit});

  String get _text {
    if (ageLimit == 0) return 'P';
    if (ageLimit == 13) return 'T13';
    if (ageLimit == 16) return 'T16';
    if (ageLimit == 18) return 'T18';
    return 'T$ageLimit+';
  }

  Color get _color {
    if (ageLimit == 0) return Colors.green.shade700;
    if (ageLimit == 13) return Colors.orange.shade700;
    if (ageLimit == 16) return Colors.deepOrange.shade700;
    if (ageLimit == 18) return const Color(0xFFdc2626);
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        _text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 7,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
