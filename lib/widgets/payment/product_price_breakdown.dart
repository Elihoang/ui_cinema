import 'package:flutter/material.dart';
import '../../models/order/product_order.dart';

/// Widget hiển thị chi tiết giá tiền đơn hàng sản phẩm
class ProductPriceBreakdown extends StatelessWidget {
  final ProductOrderInfo order;
  final double voucherDiscount;
  final double? finalAmount;

  const ProductPriceBreakdown({
    super.key,
    required this.order,
    this.voucherDiscount = 0,
    this.finalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final totalDiscount = order.discount + voucherDiscount;
    final displayFinalAmount = finalAmount ?? order.total - voucherDiscount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF33191E), const Color(0xFF2A1518)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: Color(0xFFEC1337),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Chi tiết thanh toán',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Product items breakdown
          ...order.items.map(
            (item) => _buildPriceRow(
              '${item.product.name} x${item.quantity}',
              item.totalPrice,
            ),
          ),

          // Divider before discounts
          if (totalDiscount > 0) ...[
            const SizedBox(height: 12),
            Container(height: 1, color: Colors.white.withOpacity(0.1)),
            const SizedBox(height: 12),
          ],

          // Voucher discount
          if (voucherDiscount > 0)
            _buildPriceRow(
              'Giảm giá voucher',
              -voucherDiscount,
              isDiscount: true,
            ),

          // Divider before total
          const SizedBox(height: 12),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0),
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (order.originalTotal != null)
                    Text(
                      _formatPrice(order.originalTotal!),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    _formatPrice(displayFinalAmount),
                    style: const TextStyle(
                      color: Color(0xFFEC1337),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            isDiscount
                ? '-${_formatPrice(amount.abs())}'
                : _formatPrice(amount),
            style: TextStyle(
              color: isDiscount ? const Color(0xFF34D399) : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
  }
}
