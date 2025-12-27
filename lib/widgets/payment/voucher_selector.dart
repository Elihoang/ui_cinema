import 'package:flutter/material.dart';
import '../../models/user_voucher.dart';

class VoucherSelector extends StatelessWidget {
  final UserVoucher? selectedVoucher;
  final List<UserVoucher> availableVouchers;
  final Function(UserVoucher?) onVoucherSelected;
  final VoidCallback onViewAllVouchers;
  final bool isLoading;

  const VoucherSelector({
    super.key,
    this.selectedVoucher,
    required this.availableVouchers,
    required this.onVoucherSelected,
    required this.onViewAllVouchers,
    this.isLoading = false,
  });

  static const _accent = Color(0xFFEC1337);
  static const _surface = Color(0xFF33191E);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF67323B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.discount, color: _accent, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Voucher giảm giá',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (!isLoading)
                  TextButton(
                    onPressed: onViewAllVouchers,
                    child: const Text('Xem tất cả'),
                  ),
              ],
            ),
          ),

          const Divider(color: Color(0xFF67323B), height: 1),

          // Content
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator(color: _accent)),
            )
          else if (selectedVoucher != null)
            _buildSelectedVoucher()
          else if (availableVouchers.isEmpty)
            _buildNoVouchers()
          else
            _buildVoucherList(),
        ],
      ),
    );
  }

  Widget _buildSelectedVoucher() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF34D399).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF34D399)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF34D399), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedVoucher!.voucher?.name ?? 'Voucher',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedVoucher!.voucher?.code ?? '',
                    style: const TextStyle(
                      color: Color(0xFF34D399),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => onVoucherSelected(null),
              icon: const Icon(Icons.close, color: Color(0xFFC9929B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoVouchers() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(
        child: Text(
          'Không có voucher khả dụng',
          style: TextStyle(color: Color(0xFFC9929B)),
        ),
      ),
    );
  }

  Widget _buildVoucherList() {
    final displayVouchers = availableVouchers.take(2).toList();

    return Column(
      children: [
        ...displayVouchers.map((voucher) => _buildVoucherItem(voucher)),
        if (availableVouchers.length > 2)
          TextButton(
            onPressed: onViewAllVouchers,
            child: Text('Xem thêm ${availableVouchers.length - 2} voucher'),
          ),
      ],
    );
  }

  Widget _buildVoucherItem(UserVoucher voucher) {
    if (voucher.voucher == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () => onVoucherSelected(voucher),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF67323B), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.local_offer, color: _accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher.voucher!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    voucher.voucher!.description,
                    style: const TextStyle(
                      color: Color(0xFFC9929B),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFC9929B)),
          ],
        ),
      ),
    );
  }
}
