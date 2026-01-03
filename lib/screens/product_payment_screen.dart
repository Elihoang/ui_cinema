import 'package:flutter/material.dart';
import 'dart:async';
import '../models/ticket/booking.dart';
import '../models/order/product_order.dart';
import '../models/user/user_voucher.dart';
import '../models/user/voucher.dart';
import '../widgets/payment/product_order_summary_card.dart';
import '../widgets/payment/product_price_breakdown.dart';
import '../widgets/payment/promo_code_input.dart';
import '../widgets/payment/payment_method_item.dart';
import '../widgets/payment/voucher_bottom_sheet.dart';
import '../services/order_service.dart';
import '../services/payment_service.dart';
import '../services/auth/token_storage.dart';
import '../services/user_service.dart';
import '../services/user_voucher_service.dart';

/// Màn hình thanh toán cho đơn hàng chỉ có sản phẩm (không có vé)
class ProductPaymentScreen extends StatefulWidget {
  final ProductOrderInfo order;

  const ProductPaymentScreen({super.key, required this.order});

  @override
  State<ProductPaymentScreen> createState() => _ProductPaymentScreenState();
}

class _ProductPaymentScreenState extends State<ProductPaymentScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.momo;
  bool _isProcessing = false;
  String? _orderId;
  String? _requestId;
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
      print('[ProductPaymentScreen] Error loading vouchers: $e');
      setState(() => _isLoadingVouchers = false);
    }
  }

  void _calculateFinalAmount() {
    setState(() {
      _finalAmount = widget.order.total - _discountAmount;
    });
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
            widget.order.subtotal * (voucherData.discountValue / 100);
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
        _finalAmount = widget.order.subtotal - discountPreview;
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

  void _showVoucherSelector() {
    // Create a fake BookingInfo for voucher selection
    // We use the order total for voucher calculation
    final fakeBooking = BookingInfo(
      movieTitle: 'Đơn hàng sản phẩm',
      moviePoster: '',
      cinema: '',
      hall: '',
      showtime: '',
      date: '',
      seats: [],
      ticketPrice: 0,
      comboPrice: widget.order.subtotal,
      discount: 0,
      showtimeId: '',
      seatIds: [],
      products: [],
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => VoucherBottomSheet(
        vouchers: _availableVouchers,
        booking: fakeBooking,
        onVoucherSelected: (voucher) {
          if (voucher.voucher != null) {
            _applyPromoCode(voucher.voucher!.code);
          }
        },
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_isProcessing) return;

    // Validate cart
    if (widget.order.items.isEmpty) {
      _showErrorDialog('Giỏ hàng trống');
      return;
    }

    // Calculate final amount
    final paymentAmount = _finalAmount > 0 ? _finalAmount : widget.order.total;

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
          'Thanh toán ${_formatPrice(paymentAmount)} qua ${_getPaymentMethodName()}?',
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
      debugPrint('======================');

      // Kiểm tra user đã đăng nhập
      if (userId == null || userId.isEmpty) {
        _showErrorDialog('Vui lòng đăng nhập để tiếp tục thanh toán');
        return;
      }

      // Bước 1: Tạo đơn hàng (chỉ có products, không có tickets)
      final products = widget.order.items
          .map(
            (item) => OrderProductItemDto(
              productId: item.product.id,
              quantity: item.quantity,
            ),
          )
          .toList();

      // Tạo note cho đơn hàng sản phẩm
      final productNames = widget.order.items
          .map((item) => '${item.product.name} x${item.quantity}')
          .join(', ');
      final orderNote = '[PRO-ORDER] $productNames';

      final order = await OrderService.createOrder(
        userId: userId,
        tickets: [], // Không có vé
        products: products,
        paymentMethod: _getPaymentMethodName(),
        note: orderNote,
        token: token,
      );

      setState(() {
        _orderId = order.id;
      });

      // Bước 2: Apply voucher nếu có
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

      // Bước 3: Tạo thanh toán dựa trên phương thức
      if (_selectedPaymentMethod == PaymentMethod.momo) {
        await _processMomoPayment(order.id, finalAmount, token);
      } else if (_selectedPaymentMethod == PaymentMethod.cash) {
        await _processCashPayment(order.id, finalAmount);
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
      // Build order info for Momo
      final productNames = widget.order.items
          .map((item) => '${item.product.name} x${item.quantity}')
          .join(', ');
      final orderInfo = 'Thanh toán đồ ăn: $productNames';

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

      setState(() {
        _requestId = momoResponse.requestId;
      });

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

  /// Xử lý thanh toán tiền mặt - hiển thị mã đơn hàng để khách thanh toán tại quầy
  Future<void> _processCashPayment(String orderId, double amount) async {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF33191E),
          title: const Text(
            'Đơn hàng đã được tạo!',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: Color(0xFF34D399),
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Vui lòng đến quầy thanh toán',
                style: TextStyle(color: Color(0xFFC9929B), fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF221013),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFEC1337)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Mã đơn hàng',
                      style: TextStyle(color: Color(0xFFC9929B), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      orderId.length > 8
                          ? orderId.substring(0, 8).toUpperCase()
                          : orderId.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFEC1337),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Số tiền: ${_formatPrice(amount)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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
                child: const Text(
                  'Về trang chủ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
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
              _checkPaymentStatus();
            },
            child: const Text('Đã thanh toán'),
          ),
          TextButton(
            onPressed: () {
              _paymentPollingTimer?.cancel();
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
      if (_requestId == null) return;

      final queryResponse = await PaymentService.queryTransaction(
        _orderId!,
        requestId: _requestId!,
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
      if (_requestId == null) {
        _showErrorDialog('Thiếu thông tin giao dịch (RequestId)');
        return;
      }

      final queryResponse = await PaymentService.queryTransaction(
        _orderId!,
        requestId: _requestId!,
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
            child: const Text('Đóng', style: TextStyle(color: Colors.white)),
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
                color: Color(0xFF34D399),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Đơn hàng của bạn đã được xác nhận',
              style: TextStyle(color: Color(0xFFC9929B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Vui lòng đến quầy để nhận đồ ăn',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
              ),
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
              child: const Text(
                'Về trang chủ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName() {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.momo:
        return 'MOMO';
      case PaymentMethod.cash:
        return 'CASH';
    }
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
  }

  @override
  Widget build(BuildContext context) {
    final paymentAmount = _finalAmount > 0 ? _finalAmount : widget.order.total;

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
                // Header info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFEC1337).withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag,
                        color: Color(0xFFEC1337),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Đơn hàng đồ ăn & thức uống',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary Card
                      ProductOrderSummaryCard(order: widget.order),

                      const SizedBox(height: 24),

                      // Promo Code Input with Select Button
                      Row(
                        children: [
                          Expanded(
                            child: PromoCodeInput(onApply: _applyPromoCode),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _availableVouchers.isNotEmpty
                                ? _showVoucherSelector
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEC1337),
                              disabledBackgroundColor: Colors.grey.shade800,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoadingVouchers
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
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
                      ProductPriceBreakdown(
                        order: widget.order,
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

                      // Payment Method Items - MOMO
                      PaymentMethodItem(
                        method: PaymentMethod.momo,
                        selectedMethod: _selectedPaymentMethod,
                        title: 'Ví MoMo',
                        subtitle: 'Thanh toán qua ứng dụng',
                        icon: Icons.account_balance_wallet,
                        iconColor: const Color(0xFFA50064),
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = PaymentMethod.momo;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // Payment Method Items - CASH (chỉ có ở Product Payment)
                      PaymentMethodItem(
                        method: PaymentMethod.cash,
                        selectedMethod: _selectedPaymentMethod,
                        title: 'Tiền mặt',
                        subtitle: 'Thanh toán tại chỗ',
                        icon: Icons.payments_outlined,
                        iconColor: const Color(0xFF22C55E),
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = PaymentMethod.cash;
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
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC1337),
                    disabledBackgroundColor: Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFFEC1337).withOpacity(0.3),
                  ),
                  child: _isProcessing
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Đang xử lý...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_outline, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Thanh toán ${_formatPrice(paymentAmount)}',
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
