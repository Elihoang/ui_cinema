import 'package:flutter/material.dart';
import '../../models/user_voucher.dart';
import '../../models/booking.dart';
import '../../models/voucher.dart';

class VoucherBottomSheet extends StatelessWidget {
  final List<UserVoucher> vouchers;
  final BookingInfo booking;
  final Function(UserVoucher) onVoucherSelected;

  const VoucherBottomSheet({
    super.key,
    required this.vouchers,
    required this.booking,
    required this.onVoucherSelected,
  });

  static const _accent = Color(0xFFEC1337);

  bool _canUseVoucher(UserVoucher userVoucher) {
    if (userVoucher.voucher == null) return false;

    final voucher = userVoucher.voucher!;

    // Check min order amount
    if (voucher.minOrderAmount != null &&
        booking.total < voucher.minOrderAmount!) {
      return false;
    }

    // Check if valid and not used
    if (!userVoucher.canUse) return false;

    return true;
  }

  String _getReasonCannotUse(UserVoucher userVoucher) {
    if (userVoucher.voucher == null) return 'Voucher không hợp lệ';

    final voucher = userVoucher.voucher!;

    if (voucher.minOrderAmount != null &&
        booking.total < voucher.minOrderAmount!) {
      return 'Đơn tối thiểu ${voucher.minOrderAmount!.toStringAsFixed(0)}đ';
    }

    if (!userVoucher.canUse) {
      return 'Voucher không khả dụng';
    }

    return '';
  }

  String _calculateDiscount(UserVoucher userVoucher) {
    if (userVoucher.voucher == null) return '0đ';

    final voucher = userVoucher.voucher!;
    double discount = 0;

    if (voucher.voucherType.value == 'Percentage') {
      discount = booking.total * (voucher.discountValue / 100);
      if (voucher.maxDiscountAmount != null &&
          discount > voucher.maxDiscountAmount!) {
        discount = voucher.maxDiscountAmount!;
      }
    } else {
      discount = voucher.discountValue;
    }

    return '${discount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
  }

  @override
  Widget build(BuildContext context) {
    final usableVouchers = vouchers.where(_canUseVoucher).toList();
    final unusableVouchers = vouchers.where((v) => !_canUseVoucher(v)).toList();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF120709),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.discount, color: _accent),
                const SizedBox(width: 12),
                const Text(
                  'Chọn voucher',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Voucher list
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                // Usable vouchers
                if (usableVouchers.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Có thể sử dụng (${usableVouchers.length})',
                      style: const TextStyle(
                        color: Color(0xFF34D399),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...usableVouchers.map(
                    (v) => _buildVoucherItem(context, v, true),
                  ),
                ],

                // Unusable vouchers
                if (unusableVouchers.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Không đủ điều kiện (${unusableVouchers.length})',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...unusableVouchers.map(
                    (v) => _buildVoucherItem(context, v, false),
                  ),
                ],

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherItem(
    BuildContext context,
    UserVoucher userVoucher,
    bool canUse,
  ) {
    if (userVoucher.voucher == null) return const SizedBox.shrink();

    final voucher = userVoucher.voucher!;

    return Opacity(
      opacity: canUse ? 1.0 : 0.5,
      child: InkWell(
        onTap: canUse
            ? () {
                Navigator.pop(context);
                onVoucherSelected(userVoucher);
              }
            : null,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF33191E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: canUse
                  ? const Color(0xFF34D399).withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_offer,
                  color: canUse ? _accent : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      voucher.code,
                      style: TextStyle(
                        color: canUse ? _accent : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      voucher.description,
                      style: const TextStyle(
                        color: Color(0xFFC9929B),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Discount amount
                    Text(
                      'Giảm: ${_calculateDiscount(userVoucher)}',
                      style: TextStyle(
                        color: canUse ? const Color(0xFF34D399) : Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (!canUse) ...[
                      const SizedBox(height: 8),
                      Text(
                        _getReasonCannotUse(userVoucher),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (canUse)
                const Icon(Icons.chevron_right, color: Color(0xFFC9929B)),
            ],
          ),
        ),
      ),
    );
  }
}
