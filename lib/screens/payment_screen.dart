import 'package:flutter/material.dart';
import 'dart:async';
import '../models/booking.dart';
import '../models/user_voucher.dart';
import '../models/voucher.dart';
import '../widgets/payment/booking_summary_card.dart';
import '../widgets/payment/countdown_timer_widget.dart';
import '../widgets/payment/promo_code_input.dart';
import '../widgets/payment/price_breakdown.dart';
import '../widgets/payment/payment_method_item.dart';
import '../widgets/payment/voucher_bottom_sheet.dart';
import '../services/order_service.dart';
import '../services/payment_service.dart';
import '../services/auth/token_storage.dart';
import '../services/user_service.dart';
import '../services/user_voucher_service.dart';

class PaymentScreen extends StatefulWidget {
  final BookingInfo booking;

  const PaymentScreen({super.key, required this.booking});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.momo;
  bool _isProcessing = false;
  String? _orderId;
  final _tokenStorage = TokenStorage();
  Timer? _paymentPollingTimer;
  int _pollingAttempts = 0;
  static const int _maxPollingAttempts = 60; // 3 phút (60 x 3s)

  // Voucher state
  UserVoucher? _selectedVoucher;
  List<UserVoucher> _availableVouchers = [];
  bool _isLoadingVouchers = false;
  double _discountAmount = 0;
  double _finalAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadAvailableVouchers();
    _calculateFinalAmount();
  }

  @override
  void dispose() {
    _paymentPollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadAvailableVouchers() async {
    setState(() => _isLoadingVouchers = true);
    try {
      final userId = await UserService.getUserId();
      if (userId != null) {
        final vouchers = await UserVoucherService.getUserVouchers(
          userId,
          onlyAvailable: true,
        );
        setState(() {
          _availableVouchers = vouchers;
          _isLoadingVouchers = false;
        });
      }
    } catch (e) {
      print('[PaymentScreen] Error loading vouchers: $e');
      setState(() => _isLoadingVouchers = false);
    }
  }

  void _calculateFinalAmount() {
    setState(() {
      _finalAmount = widget.booking.total - _discountAmount;
    });
  }

  Future<void> _applyVoucherToOrder(UserVoucher voucher) async {
    if (_orderId == null) return;

    try {
      final order = await OrderService.applyVoucher(
        orderId: _orderId!,
        userVoucherId: voucher.id,
      );
      setState(() {
        _selectedVoucher = voucher;
        _discountAmount = order.discountAmount ?? 0;
        _finalAmount = order.finalAmount ?? widget.booking.total;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã áp dụng voucher!'),
            backgroundColor: Color(0xFF34D399),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: const Color(0xFFEC1337),
          ),
        );
      }
    }
  }

  Future<void> _removeVoucherFromOrder() async {
    if (_orderId == null) return;

    try {
      await OrderService.removeVoucher(orderId: _orderId!);
      setState(() {
        _selectedVoucher = null;
        _discountAmount = 0;
        _finalAmount = widget.booking.total;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa voucher'),
            backgroundColor: Color(0xFF64748B),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: const Color(0xFFEC1337),
          ),
        );
      }
    }
  }

  void _applyPromoCode(String code) {
    // Find voucher by code
    final voucher = _availableVouchers.cast<UserVoucher?>().firstWhere(
      (v) => v?.voucher?.code.toUpperCase() == code.toUpperCase(),
      orElse: () => null,
    );

    if (voucher != null && voucher.voucher != null) {
      // Calculate discount preview
      final voucherData = voucher.voucher!;
      double discountPreview = 0;

      if (voucherData.voucherType == VoucherType.percentage) {
        // Percentage discount
        discountPreview =
            widget.booking.total * (voucherData.discountValue / 100);
        // Apply max discount if specified
        if (voucherData.maxDiscountAmount != null &&
            discountPreview > voucherData.maxDiscountAmount!) {
          discountPreview = voucherData.maxDiscountAmount!;
        }
      } else {
        // Fixed amount discount
        discountPreview = voucherData.discountValue;
      }

      setState(() {
        _selectedVoucher = voucher;
        _discountAmount = discountPreview;
        _finalAmount = widget.booking.total - discountPreview;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã chọn voucher: ${voucherData.name}\nGiảm ${_formatPrice(discountPreview)}',
          ),
          backgroundColor: const Color(0xFF34D399),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không tìm thấy voucher: $code'),
          backgroundColor: const Color(0xFFEC1337),
        ),
      );
    }
  }

  Future<void> _processPayment() async {
    if (_isProcessing) return;

    // Xác nhận thanh toán
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF33191E),
        title: const Text(
          'Xác nhận thanh toán',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Thanh toán ${_formatPrice(_finalAmount > 0 ? _finalAmount : widget.booking.total)} qua ${_getPaymentMethodName()}?',
          style: const TextStyle(color: Color(0xFFC9929B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEC1337),
            ),
            child: const Text(
              'Xác nhận',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Lấy token và userId
      final token = await _tokenStorage.getAccessToken();
      final userId = await UserService.getUserId();
      debugPrint('===== AUTH DEBUG =====');
      debugPrint('UserId: $userId');
      debugPrint('Token: $token');
      debugPrint('Token length: ${token?.length}');
      debugPrint('======================');

      // Kiểm tra user đã đăng nhập
      if (userId == null || userId.isEmpty) {
        _showErrorDialog('Vui lòng đăng nhập để tiếp tục thanh toán');
        return;
      }

      // Bước 1: Tạo đơn hàng
      final tickets = widget.booking.seatIds
          .map(
            (seatId) => OrderTicketItemDto(
              showtimeId: widget.booking.showtimeId,
              seatId: seatId,
            ),
          )
          .toList();

      final products = widget.booking.products
          .map(
            (p) => OrderProductItemDto(
              productId: p.productId,
              quantity: p.quantity,
            ),
          )
          .toList();

      final order = await OrderService.createOrder(
        userId: userId, // Truyền userId từ token
        tickets: tickets,
        products: products,
        paymentMethod: _getPaymentMethodName(),
        token: token,
      );

      setState(() {
        _orderId = order.id;
      });

      // Bước 1.5: Apply voucher nếu có
      double finalAmount = order.totalAmount;
      if (_selectedVoucher != null) {
        try {
          final updatedOrder = await OrderService.applyVoucher(
            orderId: order.id,
            userVoucherId: _selectedVoucher!.id,
          );
          setState(() {
            _discountAmount = updatedOrder.discountAmount ?? 0;
            _finalAmount = updatedOrder.finalAmount ?? order.totalAmount;
          });
          finalAmount = updatedOrder.finalAmount ?? order.totalAmount;

          debugPrint('===== VOUCHER APPLIED =====');
          debugPrint('Discount: $_discountAmount');
          debugPrint('Final Amount: $finalAmount');
          debugPrint('==========================');
        } catch (e) {
          debugPrint('Error applying voucher: $e');
          // Continue with payment even if voucher fails
        }
      }

      // Bước 2: Tạo thanh toán dựa trên phương thức
      if (_selectedPaymentMethod == PaymentMethod.momo) {
        await _processMomoPayment(order.id, finalAmount, token);
      } else {
        // Các phương thức thanh toán khác
        _showErrorDialog('Phương thức thanh toán này chưa được hỗ trợ');
      }
    } catch (e) {
      _showErrorDialog('Lỗi khi xử lý thanh toán: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processMomoPayment(
    String orderId,
    double amount,
    String? token,
  ) async {
    try {
      final orderInfo =
          'Thanh toán vé ${widget.booking.movieTitle} - ${widget.booking.seats.join(", ")}';

      final momoResponse = await PaymentService.createMomoPayment(
        orderId: orderId,
        amount: amount,
        orderInfo: orderInfo,
        token: token,
      );

      if (!momoResponse.success) {
        _showErrorDialog(momoResponse.message);
        return;
      }

      // Mở ứng dụng Momo hoặc URL thanh toán
      final launched = await PaymentService.openPaymentUrl(
        momoResponse.deeplink,
        momoResponse.payUrl,
      );

      if (!launched) {
        _showErrorDialog('Không thể mở ứng dụng thanh toán');
        return;
      }

      // Show dialog và bắt đầu auto-polling
      if (mounted) {
        _showPaymentInProgressDialog();
        _startPaymentPolling();
      }
    } catch (e) {
      _showErrorDialog('Lỗi khi tạo thanh toán Momo: $e');
    }
  }

  void _showPaymentInProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF33191E),
        title: const Text(
          'Đang chờ thanh toán',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFFEC1337)),
            const SizedBox(height: 16),
            const Text(
              'Vui lòng hoàn tất thanh toán trên ứng dụng Momo',
              style: TextStyle(color: Color(0xFFC9929B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Mã đơn hàng: ${_orderId ?? ""}',
              style: const TextStyle(color: Color(0xFFC9929B), fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Kiểm tra trạng thái thanh toán
              _checkPaymentStatus();
            },
            child: const Text('Đã thanh toán'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Quay lại màn hình trước
            },
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  /// Bắt đầu polling để tự động kiểm tra trạng thái thanh toán
  void _startPaymentPolling() {
    _pollingAttempts = 0;
    _paymentPollingTimer?.cancel();

    _paymentPollingTimer = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) async {
      _pollingAttempts++;

      // Stop nếu đã quá số lần thử
      if (_pollingAttempts >= _maxPollingAttempts) {
        timer.cancel();
        return;
      }

      // Check payment status
      await _checkPaymentStatusAutomatically();
    });
  }

  /// Check payment status tự động (không hiển thị error dialog)
  Future<void> _checkPaymentStatusAutomatically() async {
    if (_orderId == null) return;

    try {
      final token = await _tokenStorage.getAccessToken();
      final queryResponse = await PaymentService.queryTransaction(
        _orderId!,
        token: token,
      );

      if (queryResponse.isSuccess) {
        // Stop polling
        _paymentPollingTimer?.cancel();

        // Close progress dialog và hiển thị success
        if (mounted) {
          Navigator.of(context).pop(); // Đóng dialog "Đang chờ thanh toán"
          _showSuccessDialog();
        }
      }
      // Nếu chưa success, tiếp tục polling
    } catch (e) {
      // Ignore errors during auto-polling, sẽ retry ở lần sau
      print('Auto-polling error: $e');
    }
  }

  Future<void> _checkPaymentStatus() async {
    if (_orderId == null) return;

    try {
      final token = await _tokenStorage.getAccessToken();
      final queryResponse = await PaymentService.queryTransaction(
        _orderId!,
        token: token,
      );

      if (queryResponse.isSuccess) {
        _showSuccessDialog();
      } else {
        _showErrorDialog('Thanh toán chưa hoàn tất: ${queryResponse.message}');
      }
    } catch (e) {
      _showErrorDialog('Không thể kiểm tra trạng thái thanh toán: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF33191E),
        title: const Text('Lỗi', style: TextStyle(color: Colors.white)),
        content: Text(
          message,
          style: const TextStyle(color: Color(0xFFC9929B)),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEC1337),
            ),
            child: const Text('Đóng'),
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

  void _showVoucherSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => VoucherBottomSheet(
        vouchers: _availableVouchers,
        booking: widget.booking,
        onVoucherSelected: (voucher) {
          if (voucher.voucher != null) {
            _applyPromoCode(voucher.voucher!.code);
          }
        },
      ),
    );
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

                      // Promo Code Input with Select Button
                      Row(
                        children: [
                          Expanded(
                            child: PromoCodeInput(onApply: _applyPromoCode),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _showVoucherSelector,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEC1337),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Chọn',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Selected Voucher Display
                      if (_selectedVoucher != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF34D399).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF34D399)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF34D399),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${_selectedVoucher!.voucher?.name ?? "Voucher"} - Giảm ${_formatPrice(_discountAmount)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white70,
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedVoucher = null;
                                    _discountAmount = 0;
                                    _finalAmount = 0;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Price Breakdown
                      PriceBreakdown(
                        booking: widget.booking,
                        voucherDiscount: _discountAmount,
                        finalAmount: _finalAmount > 0 ? _finalAmount : null,
                      ),

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
                        'Thanh toán ${_formatPrice(_finalAmount > 0 ? _finalAmount : widget.booking.total)}',
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
