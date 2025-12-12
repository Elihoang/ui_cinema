import 'package:flutter/material.dart';

class PromoCodeInput extends StatefulWidget {
  final Function(String) onApply;

  const PromoCodeInput({super.key, required this.onApply});

  @override
  State<PromoCodeInput> createState() => _PromoCodeInputState();
}

class _PromoCodeInputState extends State<PromoCodeInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Nhập mã khuyến mãi',
              hintStyle: const TextStyle(
                color: Color(0xFFC9929B),
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.local_activity_outlined,
                color: Color(0xFFC9929B),
                size: 20,
              ),
              filled: true,
              fillColor: const Color(0xFF33191E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFEC1337)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onApply(_controller.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF482329),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Áp dụng',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
