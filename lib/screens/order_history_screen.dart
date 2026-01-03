import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../services/user_service.dart';
import '../services/auth/token_storage.dart';
import '../widgets/order/order_filter_chips.dart';
import '../widgets/order/order_history_card.dart';

/// Màn hình hiển thị lịch sử giao dịch của người dùng
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderResponseDto> _orders = [];
  bool _isLoading = true;
  String? _error;

  // Filter states
  OrderStatusFilter _selectedStatusFilter = OrderStatusFilter.all;
  OrderTypeFilter _selectedTypeFilter = OrderTypeFilter.all;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = await UserService.getUserId();
      final token = await TokenStorage().getAccessToken();

      if (userId == null || userId.isEmpty) {
        setState(() {
          _error = 'Vui lòng đăng nhập để xem lịch sử giao dịch';
          _isLoading = false;
        });
        return;
      }

      final orders = await OrderService.getUserOrders(userId, token: token);

      // Sort by createdAt descending (newest first)
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Lỗi khi tải lịch sử giao dịch: $e';
        _isLoading = false;
      });
    }
  }

  /// Lọc đơn hàng theo filter
  List<OrderResponseDto> get _filteredOrders {
    return _orders.where((order) {
      // Filter by status
      bool matchesStatus = true;
      switch (_selectedStatusFilter) {
        case OrderStatusFilter.confirmed:
          matchesStatus = order.status.toLowerCase() == 'confirmed';
          break;
        case OrderStatusFilter.pending:
          matchesStatus = order.status.toLowerCase() == 'pending';
          break;
        case OrderStatusFilter.cancelled:
          matchesStatus =
              order.status.toLowerCase() == 'cancelled' ||
              order.status.toLowerCase() == 'canceled' ||
              order.status.toLowerCase() == 'expired';
          break;
        case OrderStatusFilter.all:
          matchesStatus = true;
          break;
      }

      // Filter by type (based on note)
      bool matchesType = true;
      switch (_selectedTypeFilter) {
        case OrderTypeFilter.ticket:
          // [ORDER] hoặc [SEAT-ORDER] = đơn vé xem phim
          matchesType = order.note != null && (order.note!.contains('[ORDER]'));
          break;
        case OrderTypeFilter.product:
          // [PRO-ORDER] = đơn đồ ăn
          matchesType =
              order.note != null &&
              (order.note!.contains('[PRO-ORDER]') ||
                  order.note!.contains('[SEAT-ORDER]'));

          break;
        case OrderTypeFilter.all:
          matchesType = true;
          break;
      }

      return matchesStatus && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120709),
      appBar: AppBar(
        backgroundColor: const Color(0xFF120709),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lịch sử giao dịch',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          OrderFilterChips(
            selectedStatus: _selectedStatusFilter,
            selectedType: _selectedTypeFilter,
            onStatusChanged: (filter) {
              setState(() {
                _selectedStatusFilter = filter;
              });
            },
            onTypeChanged: (filter) {
              setState(() {
                _selectedTypeFilter = filter;
              });
            },
          ),
          // Order list
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFEC1337)),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadOrders,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC1337),
                ),
                child: const Text(
                  'Thử lại',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final filteredOrders = _filteredOrders;

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _orders.isEmpty
                  ? 'Chưa có giao dịch nào'
                  : 'Không có giao dịch phù hợp',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _orders.isEmpty
                  ? 'Các đơn hàng của bạn sẽ xuất hiện ở đây'
                  : 'Hãy thử thay đổi bộ lọc',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFEC1337),
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return OrderHistoryCard(order: order);
        },
      ),
    );
  }
}
