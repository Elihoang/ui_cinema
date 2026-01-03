import 'package:flutter/material.dart';

/// Các loại filter cho trạng thái đơn hàng
enum OrderStatusFilter { all, confirmed, pending, cancelled }

/// Các loại filter cho loại đơn hàng
enum OrderTypeFilter { all, ticket, product }

/// Widget filter chips cho màn hình lịch sử giao dịch
class OrderFilterChips extends StatelessWidget {
  final OrderStatusFilter selectedStatus;
  final OrderTypeFilter selectedType;
  final Function(OrderStatusFilter) onStatusChanged;
  final Function(OrderTypeFilter) onTypeChanged;

  const OrderFilterChips({
    super.key,
    required this.selectedStatus,
    required this.selectedType,
    required this.onStatusChanged,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0C0E),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusChip(
                  label: 'Tất cả',
                  filter: OrderStatusFilter.all,
                  icon: Icons.all_inclusive,
                ),
                const SizedBox(width: 8),
                _buildStatusChip(
                  label: 'Thành công',
                  filter: OrderStatusFilter.confirmed,
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF22C55E),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(
                  label: 'Chờ thanh toán',
                  filter: OrderStatusFilter.pending,
                  icon: Icons.access_time,
                  color: const Color(0xFFFBBF24),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(
                  label: 'Đã hủy',
                  filter: OrderStatusFilter.cancelled,
                  icon: Icons.cancel_outlined,
                  color: const Color(0xFFEF4444),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Type filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTypeChip(
                  label: 'Tất cả',
                  filter: OrderTypeFilter.all,
                  icon: Icons.list_alt,
                ),
                const SizedBox(width: 8),
                _buildTypeChip(
                  label: 'Vé xem phim',
                  filter: OrderTypeFilter.ticket,
                  icon: Icons.confirmation_number_outlined,
                  color: const Color(0xFFEC1337),
                ),
                const SizedBox(width: 8),
                _buildTypeChip(
                  label: 'Đồ ăn & nước',
                  filter: OrderTypeFilter.product,
                  icon: Icons.fastfood_outlined,
                  color: const Color(0xFF60A5FA),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required OrderStatusFilter filter,
    required IconData icon,
    Color? color,
  }) {
    final isSelected = selectedStatus == filter;
    final chipColor = color ?? const Color(0xFFEC1337);

    return GestureDetector(
      onTap: () => onStatusChanged(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? chipColor : Colors.white.withOpacity(0.6),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? chipColor : Colors.white.withOpacity(0.6),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip({
    required String label,
    required OrderTypeFilter filter,
    required IconData icon,
    Color? color,
  }) {
    final isSelected = selectedType == filter;
    final chipColor = color ?? const Color(0xFFEC1337);

    return GestureDetector(
      onTap: () => onTypeChanged(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? chipColor : Colors.white.withOpacity(0.6),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? chipColor : Colors.white.withOpacity(0.6),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
