import 'package:flutter/material.dart';
import '../models/voucher.dart';
import '../models/member_point.dart';
import '../models/member_tier.dart';
import '../services/voucher_service.dart';
import '../services/membership_service.dart';
import '../services/user_voucher_service.dart';
import '../services/user_service.dart';
import '../widgets/voucher/voucher_store_card.dart';

class VoucherStoreScreen extends StatefulWidget {
  const VoucherStoreScreen({super.key});

  @override
  State<VoucherStoreScreen> createState() => _VoucherStoreScreenState();
}

class _VoucherStoreScreenState extends State<VoucherStoreScreen> {
  static const _bg = Color(0xFF120709);
  static const _accent = Color(0xFFEC1337);

  List<Voucher> _availableVouchers = [];
  MemberPoint? _memberPoint;
  bool _isLoading = true;
  String? _error;
  String? _redeemingVoucherId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = await UserService.getUserId();
      if (userId == null) {
        throw Exception('Chưa đăng nhập');
      }

      // Load vouchers and member profile in parallel
      final results = await Future.wait([
        VoucherService.getAvailableVouchersForUser(userId),
        MembershipService.getMemberProfile(userId),
      ]);

      setState(() {
        _availableVouchers = results[0] as List<Voucher>;
        _memberPoint = results[1] as MemberPoint?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _redeemVoucher(Voucher voucher) async {
    final userId = await UserService.getUserId();
    if (userId == null) return;

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF33191E),
        title: const Text(
          'Xác nhận đổi voucher',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              voucher.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.stars, color: _accent, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Chi phí: ${voucher.pointCost} điểm',
                  style: const TextStyle(color: Color(0xFFC9929B)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: _accent,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Điểm hiện tại: ${_memberPoint?.currentPoints ?? 0}',
                  style: const TextStyle(color: Color(0xFFC9929B)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.trending_down, color: Colors.orange, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Còn lại: ${(_memberPoint?.currentPoints ?? 0) - voucher.pointCost} điểm',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: _accent),
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
      _redeemingVoucherId = voucher.id;
    });

    try {
      await UserVoucherService.redeemVoucher(userId, voucher.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đổi voucher thành công!'),
            backgroundColor: Color(0xFF34D399),
          ),
        );

        // Reload data
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: _accent),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _redeemingVoucherId = null;
        });
      }
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
          'Cửa hàng Voucher',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Points header
          if (_memberPoint != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_accent.withOpacity(0.3), _accent.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _accent.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: _accent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Điểm của bạn',
                          style: TextStyle(
                            color: Color(0xFFC9929B),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_memberPoint!.currentPoints} điểm',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _memberPoint!.currentTier.displayName,
                      style: TextStyle(
                        color: _accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Voucher list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: _accent))
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                          ),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  )
                : _availableVouchers.isEmpty
                ? const Center(
                    child: Text(
                      'Không có voucher',
                      style: TextStyle(color: Color(0xFFC9929B)),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadData,
                    color: _accent,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _availableVouchers.length,
                      itemBuilder: (context, index) {
                        final voucher = _availableVouchers[index];
                        return VoucherStoreCard(
                          voucher: voucher,
                          userPoints: _memberPoint?.currentPoints ?? 0,
                          userTier: _memberPoint?.currentTier,
                          onRedeem: () => _redeemVoucher(voucher),
                          isRedeeming: _redeemingVoucherId == voucher.id,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
