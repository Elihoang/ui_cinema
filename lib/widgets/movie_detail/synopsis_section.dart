import 'package:flutter/material.dart';

class SynopsisSection extends StatelessWidget {
  final String synopsis;
  final bool isExpanded;
  final VoidCallback onToggle;
  static const int trimLines = 3; // Số dòng thu gọn

  const SynopsisSection({
    super.key,
    required this.synopsis,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nội dung',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Sử dụng LayoutBuilder để kiểm tra số dòng
        LayoutBuilder(
          builder: (context, constraints) {
            // Tạo TextPainter để đo text
            final textPainter = TextPainter(
              text: TextSpan(
                text: synopsis,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              maxLines: trimLines,
              textDirection: TextDirection.ltr,
            );

            // Layout với width thực tế
            textPainter.layout(maxWidth: constraints.maxWidth);
            final exceedsMaxLines = textPainter.didExceedMaxLines;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text với maxLines
                Text(
                  synopsis,
                  maxLines: isExpanded ? null : trimLines,
                  overflow: isExpanded ? null : TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                // Nút "Xem thêm / Thu gọn"
                if (exceedsMaxLines)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GestureDetector(
                      onTap: onToggle,
                      child: Text(
                        isExpanded ? 'Thu gọn' : 'Xem thêm',
                        style: const TextStyle(
                          color: Color(0xFFEC1337),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
