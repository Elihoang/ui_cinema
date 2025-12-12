import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../widgets/payment/booking_summary_card.dart';
import '../widgets/payment/countdown_timer_widget.dart';
import '../widgets/payment/promo_code_input.dart';
import '../widgets/payment/price_breakdown.dart';
import '../widgets/payment/payment_method_item.dart';

class PaymentScreen extends StatefulWidget {
  final BookingInfo booking;

  const PaymentScreen({super.key, required this.booking});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.momo;

  void _applyPromoCode(String code) {
    // Handle promo code application
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã áp dụng mã: $code'),
        backgroundColor: const Color(0xFFEC1337),
      ),
    );
  }

  void _processPayment() {
    // Handle payment processing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF33191E),
        title: const Text(
          'Xác nhận thanh toán',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Thanh toán ${_formatPrice(widget.booking.total)} qua ${_getPaymentMethodName()}?',
          style: const TextStyle(color: Color(0xFFC9929B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to success screen
              _showSuccessDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEC1337),
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF33191E),
        title: const Text(
          'Thanh toán thành công!',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFEC1337),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Vé của bạn đã được đặt thành công',
              style: TextStyle(color: Color(0xFFC9929B)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC1337),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Về trang chủ'),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName() {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.momo:
        return 'Ví MoMo';
      case PaymentMethod.card:
        return 'Thẻ ATM/Visa/Master';
      case PaymentMethod.applePay:
        return 'Apple Pay';
    }
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      appBar: AppBar(
        backgroundColor: const Color(0xFF221013),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.white.withOpacity(0.05)),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timer Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(child: CountdownTimerWidget()),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking Summary Card
                      BookingSummaryCard(booking: widget.booking),

                      const SizedBox(height: 24),

                      // Promo Code Input
                      PromoCodeInput(onApply: _applyPromoCode),

                      const SizedBox(height: 24),

                      // Price Breakdown
                      PriceBreakdown(booking: widget.booking),

                      const SizedBox(height: 32),

                      // Payment Methods Section
                      const Text(
                        'Phương thức thanh toán',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Payment Method Items
                      PaymentMethodItem(
                        method: PaymentMethod.momo,
                        selectedMethod: _selectedPaymentMethod,
                        title: 'Ví MoMo',
                        subtitle: 'Liên kết nhanh',
                        icon: Icons.account_balance_wallet,
                        iconColor: const Color(0xFFA50064),
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = PaymentMethod.momo;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      PaymentMethodItem(
                        method: PaymentMethod.card,
                        selectedMethod: _selectedPaymentMethod,
                        title: 'Thẻ ATM / Visa / Master',
                        subtitle: 'Thanh toán an toàn',
                        icon: Icons.credit_card,
                        iconColor: const Color(0xFF1E3A8A),
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = PaymentMethod.card;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      PaymentMethodItem(
                        method: PaymentMethod.applePay,
                        selectedMethod: _selectedPaymentMethod,
                        title: 'Apple Pay',
                        subtitle: 'Nhanh chóng & bảo mật',
                        icon: Icons.smartphone,
                        iconColor: Colors.black,
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = PaymentMethod.applePay;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Bottom Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF221013).withOpacity(0.95),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  onPressed: _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC1337),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFFEC1337).withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Thanh toán ${_formatPrice(widget.booking.total)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
