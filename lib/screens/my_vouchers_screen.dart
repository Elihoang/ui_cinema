import 'package:flutter/material.dart';
import '../models/user_voucher.dart';
import '../models/voucher.dart';
import '../services/user_voucher_service.dart';
import '../services/user_service.dart';

class MyVouchersScreen extends StatefulWidget {
  const MyVouchersScreen({super.key});

  @override
  State<MyVouchersScreen> createState() => _MyVouchersScreenState();
}

class _MyVouchersScreenState extends State<MyVouchersScreen>
    with SingleTickerProviderStateMixin {
  static const _bg = Color(0xFF120709);
  static const _accent = Color(0xFFEC1337);

  late TabController _tabController;
  List<UserVoucher> _availableVouchers = [];
  List<UserVoucher> _usedVouchers = [];
  List<UserVoucher> _expiredVouchers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadVouchers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadVouchers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = await UserService.getUserId();
      if (userId == null) {
        throw Exception('Chưa đăng nhập');
      }

      final allVouchers = await UserVoucherService.getUserVouchers(userId);

      setState(() {
        _availableVouchers = allVouchers
            .where((v) => v.status == VoucherStatus.available)
            .toList();
        _usedVouchers = allVouchers
            .where((v) => v.status == VoucherStatus.used)
            .toList();
        _expiredVouchers = allVouchers
            .where((v) => v.status == VoucherStatus.expired)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Voucher của tôi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _accent,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFFC9929B),
          labelStyle: const TextStyle(fontWeight: FontWeight.w800),
          tabs: [
            Tab(text: 'Được dùng(${_availableVouchers.length})'),
            Tab(text: 'Đã dùng(${_usedVouchers.length})'),
            Tab(text: 'Hết hạn(${_expiredVouchers.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _accent))
          : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadVouchers,
                    style: ElevatedButton.styleFrom(backgroundColor: _accent),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildVoucherList(_availableVouchers, true),
                _buildVoucherList(_usedVouchers, false),
                _buildVoucherList(_expiredVouchers, false),
              ],
            ),
    );
  }

  Widget _buildVoucherList(List<UserVoucher> vouchers, bool canUse) {
    if (vouchers.isEmpty) {
      return const Center(
        child: Text(
          'Không có voucher',
          style: TextStyle(color: Color(0xFFC9929B)),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadVouchers,
      color: _accent,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vouchers.length,
        itemBuilder: (context, index) {
          return _VoucherCard(userVoucher: vouchers[index], canUse: canUse);
        },
      ),
    );
  }
}

class _VoucherCard extends StatelessWidget {
  final UserVoucher userVoucher;
  final bool canUse;

  const _VoucherCard({required this.userVoucher, required this.canUse});

  Color get _getStatusColor {
    switch (userVoucher.status) {
      case VoucherStatus.available:
        return const Color(0xFF34D399);
      case VoucherStatus.used:
        return const Color(0xFF60A5FA);
      case VoucherStatus.expired:
        return const Color(0xFF9CA3AF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final voucher = userVoucher.voucher;
    if (voucher == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF33191E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getStatusColor.withOpacity(0.3), width: 1.5),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        voucher.code,
                        style: TextStyle(
                          color: _getStatusColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        userVoucher.status.displayName,
                        style: TextStyle(
                          color: _getStatusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  voucher.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  voucher.description,
                  style: const TextStyle(
                    color: Color(0xFFC9929B),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.discount, color: _getStatusColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      voucher.voucherType == VoucherType.percentage
                          ? 'Giảm ${voucher.discountValue.toStringAsFixed(0)}%'
                          : 'Giảm ${voucher.discountValue.toStringAsFixed(0)}đ',
                      style: TextStyle(
                        color: _getStatusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Color(0xFFC9929B),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'HSD: ${_formatDate(userVoucher.expiresAt)}',
                      style: const TextStyle(
                        color: Color(0xFFC9929B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!canUse)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
