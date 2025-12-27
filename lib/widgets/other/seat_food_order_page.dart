import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../models/seat_food_order.dart';
import '../../models/product.dart';
import '../../services/seat_food_order_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// Trang order đồ ăn/nước uống từ ghế ngồi trong rạp qua QR code
class SeatFoodOrderPage extends StatefulWidget {
  /// Mã QR ordering của ghế
  final String seatQrCode;

  const SeatFoodOrderPage({super.key, required this.seatQrCode});

  @override
  State<SeatFoodOrderPage> createState() => _SeatFoodOrderPageState();
}

class _SeatFoodOrderPageState extends State<SeatFoodOrderPage>
    with WidgetsBindingObserver {
  bool _isLoading = true;
  String? _errorMessage;
  SeatInfoResponseDto? _seatInfo;
  List<ProductItem> _products = [];

  // Giỏ hàng: productId -> quantity
  final Map<String, int> _cart = {};
  // Ghi chú cho từng sản phẩm: productId -> note
  final Map<String, String> _itemNotes = {};

  String _selectedPaymentMethod = 'MOMO';
  final TextEditingController _noteController = TextEditingController();

  bool _isOrdering = false;
  SeatFoodOrderResponseDto? _orderResult;

  // Polling trạng thái thanh toán
  Timer? _paymentCheckTimer;
  SeatFoodOrderStatusDto? _currentOrderStatus;
  bool _isCheckingPayment = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _noteController.dispose();
    _paymentCheckTimer?.cancel();
    super.dispose();
  }

  /// Khi app resume (quay lại từ MoMo), kiểm tra trạng thái thanh toán
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _orderResult != null) {
      // App vừa quay lại, kiểm tra trạng thái thanh toán ngay
      _checkPaymentStatus();
    }
  }

  /// Bắt đầu polling kiểm tra trạng thái thanh toán
  void _startPaymentPolling() {
    _paymentCheckTimer?.cancel();
    _paymentCheckTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _checkPaymentStatus();
    });
  }

  /// Dừng polling
  void _stopPaymentPolling() {
    _paymentCheckTimer?.cancel();
    _paymentCheckTimer = null;
  }

  /// Kiểm tra trạng thái thanh toán
  Future<void> _checkPaymentStatus() async {
    if (_orderResult == null || _isCheckingPayment) return;

    setState(() => _isCheckingPayment = true);

    try {
      final status = await SeatFoodOrderService.getOrderStatus(
        _orderResult!.orderId,
      );

      if (status != null && mounted) {
        setState(() {
          _currentOrderStatus = status;
          _isCheckingPayment = false;
        });

        // Nếu đã thanh toán thành công, dừng polling
        if (status.status == 'Confirmed' ||
            status.status == 'Paid' ||
            status.status == 'Preparing') {
          _stopPaymentPolling();

          // Cập nhật lại orderResult với trạng thái mới
          setState(() {
            _orderResult = SeatFoodOrderResponseDto(
              orderId: _orderResult!.orderId,
              orderCode: _orderResult!.orderCode,
              status: status.status,
              totalAmount: _orderResult!.totalAmount,
              estimatedDeliveryMinutes: _orderResult!.estimatedDeliveryMinutes,
              seatInfo: _orderResult!.seatInfo,
              showingMovie: _orderResult!.showingMovie,
              items: _orderResult!.items,
              paymentInfo: _orderResult!.paymentInfo != null
                  ? SeatFoodPaymentInfoDto(
                      paymentMethod: _orderResult!.paymentInfo!.paymentMethod,
                      paymentStatus: 'Completed',
                      payUrl: _orderResult!.paymentInfo!.payUrl,
                      deeplink: _orderResult!.paymentInfo!.deeplink,
                      qrCodeUrl: _orderResult!.paymentInfo!.qrCodeUrl,
                      transactionId: _orderResult!.paymentInfo!.transactionId,
                    )
                  : null,
              orderTime: _orderResult!.orderTime,
              message: 'Thanh toán thành công!',
            );
          });
        }
      }
    } catch (e) {
      debugPrint('Error checking payment status: $e');
      setState(() => _isCheckingPayment = false);
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load seat info và products song song
      final results = await Future.wait([
        SeatFoodOrderService.getSeatInfo(widget.seatQrCode),
        SeatFoodOrderService.getAvailableProducts(),
      ]);

      setState(() {
        _seatInfo = results[0] as SeatInfoResponseDto;
        _products = results[1] as List<ProductItem>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  int get _totalQuantity => _cart.values.fold(0, (sum, qty) => sum + qty);

  double get _totalAmount {
    double total = 0;
    _cart.forEach((productId, quantity) {
      final product = _products.firstWhere(
        (p) => p.id == productId,
        orElse: () => ProductItem(
          id: '',
          name: '',
          price: 0,
          category: '',
          isActive: false,
        ),
      );
      total += product.price * quantity;
    });
    return total;
  }

  void _updateCart(String productId, int delta) {
    setState(() {
      final currentQty = _cart[productId] ?? 0;
      final newQty = currentQty + delta;
      if (newQty <= 0) {
        _cart.remove(productId);
        _itemNotes.remove(productId);
      } else if (newQty <= 99) {
        _cart[productId] = newQty;
      }
    });
  }

  Future<void> _submitOrder() async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất 1 sản phẩm'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isOrdering = true);

    try {
      final items = _cart.entries.map((entry) {
        return SeatFoodOrderItemDto(
          productId: entry.key,
          quantity: entry.value,
          itemNote: _itemNotes[entry.key],
        );
      }).toList();

      final dto = SeatFoodOrderCreateDto(
        seatQrCode: widget.seatQrCode,
        items: items,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        paymentMethod: _selectedPaymentMethod,
      );

      final result = await SeatFoodOrderService.createOrder(dto);

      setState(() {
        _orderResult = result;
        _isOrdering = false;
      });

      // Nếu thanh toán MOMO, mở deeplink/payUrl và bắt đầu polling trạng thái
      if (_selectedPaymentMethod == 'MOMO' && result.paymentInfo != null) {
        final paymentInfo = result.paymentInfo!;
        final urlToOpen = paymentInfo.deeplink ?? paymentInfo.payUrl;

        // Bắt đầu polling kiểm tra trạng thái thanh toán
        _startPaymentPolling();

        if (urlToOpen != null && urlToOpen.isNotEmpty) {
          final uri = Uri.parse(urlToOpen);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      }
    } catch (e) {
      setState(() => _isOrdering = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Order Đồ Ăn'),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
      bottomNavigationBar:
          _orderResult == null && _seatInfo?.canOrderFood == true
          ? _buildBottomBar()
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Đang tải thông tin...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_orderResult != null) {
      return _buildOrderSuccess();
    }

    if (_seatInfo != null && !_seatInfo!.canOrderFood) {
      return _buildCannotOrder();
    }

    return _buildOrderForm();
  }

  Widget _buildCannotOrder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.block, color: Colors.orange, size: 64),
            const SizedBox(height: 16),
            Text(
              _seatInfo?.errorMessage ?? 'Không thể order đồ ăn lúc này',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (_seatInfo?.showingMovie != null) ...[
              const SizedBox(height: 24),
              _buildMovieInfo(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSuccess() {
    final result = _orderResult!;
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Success icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Đặt hàng thành công!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.message,
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Order info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mã đơn hàng',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      result.orderCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Giao đến',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Ghế ${result.seatInfo.seatCode}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Phòng',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      result.seatInfo.screenName,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Thời gian giao dự kiến',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '${result.estimatedDeliveryMinutes} phút',
                      style: const TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 24),

                // Items
                ...result.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.productName} x${item.quantity}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          currencyFormat.format(item.subTotal),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(color: Colors.white24, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng cộng',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currencyFormat.format(result.totalAmount),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Payment status
          if (result.paymentInfo != null) _buildPaymentStatusWidget(result),

          const SizedBox(height: 24),

          // Nút mở lại MoMo nếu đang chờ thanh toán
          if (result.paymentInfo != null &&
              result.paymentInfo!.paymentStatus != 'Completed' &&
              _selectedPaymentMethod == 'MOMO')
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final paymentInfo = result.paymentInfo!;
                    final urlToOpen =
                        paymentInfo.deeplink ?? paymentInfo.payUrl;
                    if (urlToOpen != null && urlToOpen.isNotEmpty) {
                      final uri = Uri.parse(urlToOpen);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.payment, color: Color(0xFFAE2070)),
                  label: const Text(
                    'Mở MoMo để thanh toán',
                    style: TextStyle(color: Color(0xFFAE2070)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFAE2070)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _stopPaymentPolling();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Quay lại', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget hiển thị trạng thái thanh toán với polling indicator
  Widget _buildPaymentStatusWidget(SeatFoodOrderResponseDto result) {
    final isCompleted = result.paymentInfo!.paymentStatus == 'Completed';
    final statusText =
        _currentOrderStatus?.statusDescription ??
        (isCompleted ? 'Đã thanh toán' : 'Đang chờ thanh toán...');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withOpacity(0.2)
            : Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (isCompleted)
            const Icon(Icons.check_circle, color: Colors.green)
          else if (_isCheckingPayment)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            )
          else
            const Icon(Icons.access_time, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Phương thức: ${result.paymentInfo!.paymentMethod}',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                if (!isCompleted)
                  Text(
                    'Đang kiểm tra trạng thái...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderForm() {
    return Column(
      children: [
        // Header với thông tin ghế và phim
        if (_seatInfo != null) _buildSeatHeader(),

        // Danh sách sản phẩm
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _products.length,
            itemBuilder: (context, index) =>
                _buildProductItem(_products[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildSeatHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.event_seat, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Ghế ${_seatInfo!.seatInfo?.seatCode ?? ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _seatInfo!.seatInfo?.screenName ?? '',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ),
            ],
          ),
          if (_seatInfo!.showingMovie != null) ...[
            const SizedBox(height: 12),
            _buildMovieInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildMovieInfo() {
    final movie = _seatInfo!.showingMovie!;
    final timeFormat = DateFormat('HH:mm');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.movie, color: Colors.amber, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.movieTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${timeFormat.format(movie.startTime)} - ${timeFormat.format(movie.endTime)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Còn ${movie.remainingMinutes} phút',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(ProductItem product) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final quantity = _cart[product.id] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: quantity > 0
            ? Border.all(color: Colors.red.withOpacity(0.5))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                ? Image.network(
                    product.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                  )
                : _buildPlaceholderImage(),
          ),
          const SizedBox(width: 12),

          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (product.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    product.description!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currencyFormat.format(product.price),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildQuantitySelector(product.id, quantity),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.white10,
      child: const Icon(Icons.fastfood, color: Colors.white30, size: 32),
    );
  }

  Widget _buildQuantitySelector(String productId, int quantity) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (quantity > 0)
            IconButton(
              onPressed: () => _updateCart(productId, -1),
              icon: const Icon(Icons.remove, color: Colors.white, size: 20),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
            ),
          if (quantity > 0)
            SizedBox(
              width: 32,
              child: Text(
                '$quantity',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          IconButton(
            onPressed: () => _updateCart(productId, 1),
            icon: Icon(
              quantity == 0 ? Icons.add_shopping_cart : Icons.add,
              color: quantity == 0 ? Colors.red : Colors.white,
              size: 20,
            ),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Payment method selector
            Row(
              children: [
                const Text(
                  'Thanh toán:',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 12),
                _buildPaymentMethodChip('MOMO', 'MoMo'),
                const SizedBox(width: 8),
                _buildPaymentMethodChip('CASH', 'Tiền mặt'),
              ],
            ),
            const SizedBox(height: 12),

            // Order button
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_totalQuantity sản phẩm',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      Text(
                        currencyFormat.format(_totalAmount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _cart.isEmpty || _isOrdering ? null : _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isOrdering
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Đặt hàng',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodChip(String value, String label) {
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
