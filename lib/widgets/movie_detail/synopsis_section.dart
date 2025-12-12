// widgets/synopsis_section.dart
import 'package:flutter/material.dart';

class SynopsisSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const SynopsisSection({
    super.key,
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
        GestureDetector(
          onTap: onToggle,
          child: Text(
            'Paul Atreides hợp nhất với Chani và người Fremen trong khi trên đường trả thù những kẻ đã hủy diệt gia đình mình. Đối mặt với sự lựa chọn giữa tình yêu của đời mình và số phận của vũ trụ đã biết, anh nỗ lực ngăn chặn một tương lai tồi tệ mà chỉ anh mới có thể thấy trước.',
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        if (!isExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Xem thêm',
              style: TextStyle(
                color: Color(0xFFEC1337),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
