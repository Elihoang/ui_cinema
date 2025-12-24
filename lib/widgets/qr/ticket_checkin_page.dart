import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/ticket_checkin_service.dart';

/// Trang hiển thị kết quả checkin vé cho staff/admin
class TicketCheckinPage extends StatefulWidget {
  final String ticketCode;

  const TicketCheckinPage({super.key, required this.ticketCode});

  @override
  State<TicketCheckinPage> createState() => _TicketCheckinPageState();
}

class _TicketCheckinPageState extends State<TicketCheckinPage> {
  bool _isLoading = true;
  TicketVerificationResult? _verificationResult;
  bool _hasCheckedIn = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTicketInfo();
  }

  Future<void> _loadTicketInfo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Sử dụng validate API để kiểm tra thông tin vé
      final result = await TicketCheckinService.getTicketInfoForDisplay(
        widget.ticketCode,
      );

      setState(() {
        _verificationResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _performCheckin() async {
    if (_hasCheckedIn) return;

    setState(() => _isLoading = true);

    try {
      final response = await TicketCheckinService.checkinTicket(
        widget.ticketCode,
      );

      if (response.success) {
        setState(() {
          _hasCheckedIn = true;
          _isLoading = false;
          // Cập nhật result nếu có
          if (response.result != null) {
            _verificationResult = response.result;
          }
        });
        _showSuccessDialog();
      } else {
        setState(() => _isLoading = false);
        _showErrorSnackBar(response.message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Lỗi kết nối: ${e.toString()}');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Check-in thành công!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Khách hàng có thể vào rạp',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                  Navigator.of(context).pop(); // Quay lại màn hình quét
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Tiếp tục quét',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Check-in Vé'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTicketInfo,
            tooltip: 'Tải lại',
          ),
        ],
      ),
      body: _isLoading ? _buildLoading() : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Đang tải thông tin vé...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_errorMessage != null) {
      return _buildError(_errorMessage!);
    }

    if (_verificationResult == null) {
      return _buildError('Không thể tải thông tin vé');
    }

    // Nếu không tìm thấy vé hoặc có lỗi
    if (_verificationResult!.status == TicketStatus.notFound ||
        _verificationResult!.status == TicketStatus.unknown) {
      return _buildError(_verificationResult!.message);
    }

    return _buildTicketInfo();
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Không thể xác minh vé',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _loadTicketInfo,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Quét lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
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

  Widget _buildTicketInfo() {
    final result = _verificationResult!;
    final ticket = result.ticketDetail;
    final dateFormat = DateFormat('HH:mm - dd/MM/yyyy');
    final priceFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final isUsed = result.status == TicketStatus.used;
    final isExpired = result.status == TicketStatus.expired;
    final canCheckin =
        result.isValid && !isUsed && !isExpired && !_hasCheckedIn;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status Header
          _buildStatusHeader(result),

          const SizedBox(height: 24),

          // Ticket Code với giá vé
          if (ticket != null) ...[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getGradientColors(result.status),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.confirmation_number,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ticket.ticketCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  if (ticket.ticketPrice > 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        priceFormat.format(ticket.ticketPrice),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Movie Info Header (với poster nếu có)
            _buildMovieHeader(ticket),

            const SizedBox(height: 16),

            // Showtime Status (thời gian còn lại)
            _buildShowtimeStatus(ticket),

            const SizedBox(height: 16),

            // Cinema & Screen
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.location_on,
                    iconColor: Colors.blue,
                    title: 'Rạp',
                    content: ticket.cinemaName,
                    subtitle: ticket.cinemaAddress,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.tv,
                    iconColor: Colors.purple,
                    title: 'Phòng chiếu',
                    content: ticket.screenName ?? 'N/A',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Seat Info (với loại ghế)
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.event_seat,
                    iconColor: _getSeatTypeColor(ticket.seatType),
                    title: 'Ghế',
                    content: ticket.seatCode,
                    subtitle: ticket.seatType != null
                        ? 'Loại: ${_getSeatTypeName(ticket.seatType!)}'
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.access_time,
                    iconColor: Colors.green,
                    title: 'Suất chiếu',
                    content: dateFormat.format(ticket.showtime),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Customer Info (mở rộng với số điện thoại)
            if (ticket.customerName != null ||
                ticket.customerEmail != null ||
                ticket.customerPhone != null)
              _buildInfoCard(
                icon: Icons.person,
                iconColor: Colors.teal,
                title: 'Khách hàng',
                content: ticket.customerName ?? 'N/A',
                subtitle: _buildCustomerSubtitle(ticket),
              ),

            // Order progress (số vé đã check-in)
            if (ticket.totalTicketsInOrder != null &&
                ticket.totalTicketsInOrder! > 1) ...[
              const SizedBox(height: 12),
              _buildOrderProgress(ticket),
            ],

            // Products (đồ ăn/uống đi kèm)
            if (ticket.products != null && ticket.products!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildProductsSection(ticket.products!),
            ],
          ],

          const SizedBox(height: 32),

          // Action Buttons
          if (canCheckin)
            ElevatedButton(
              onPressed: _performCheckin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'XÁC NHẬN CHECK-IN',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

          if (isUsed && !_hasCheckedIn)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Vé này đã được sử dụng trước đó',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (result.checkinAt != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Check-in lúc: ${DateFormat('HH:mm:ss - dd/MM/yyyy').format(result.checkinAt!.toLocal())}',
                      style: TextStyle(color: Colors.orange[300], fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),

          if (isExpired)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Vé đã hết hạn',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: BorderSide(color: Colors.grey[600]!),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner),
                SizedBox(width: 8),
                Text('Quét vé khác'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Header phim với poster và thông tin mở rộng
  Widget _buildMovieHeader(TicketDetail ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Poster
          if (ticket.moviePosterUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ticket.moviePosterUrl!,
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.movie, color: Colors.grey, size: 40),
                ),
              ),
            )
          else
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.movie, color: Colors.red, size: 40),
            ),
          const SizedBox(width: 16),
          // Movie Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.movieTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (ticket.movieDurationMinutes > 0)
                  _buildMovieInfoChip(
                    Icons.timer,
                    '${ticket.movieDurationMinutes} phút',
                  ),
                if (ticket.movieRating != null) ...[
                  const SizedBox(height: 4),
                  _buildMovieInfoChip(
                    Icons.person_outline,
                    ticket.movieRating!,
                    color: Colors.orange,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieInfoChip(IconData icon, String text, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? Colors.grey[400]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: color ?? Colors.grey[400], fontSize: 12),
        ),
      ],
    );
  }

  /// Hiển thị thời gian còn lại đến suất chiếu
  Widget _buildShowtimeStatus(TicketDetail ticket) {
    final minutes = ticket.minutesUntilShowtime;
    final isStarted = ticket.isShowtimeStarted;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isStarted) {
      final minutesPassed = -minutes;
      if (minutesPassed > 30) {
        statusColor = Colors.red;
        statusText = 'Suất chiếu đã bắt đầu $minutesPassed phút trước';
        statusIcon = Icons.warning;
      } else {
        statusColor = Colors.orange;
        statusText = 'Suất chiếu đã bắt đầu $minutesPassed phút trước';
        statusIcon = Icons.play_circle;
      }
    } else if (minutes <= 15) {
      statusColor = Colors.green;
      statusText = 'Sắp chiếu - còn $minutes phút';
      statusIcon = Icons.timer;
    } else if (minutes <= 60) {
      statusColor = Colors.blue;
      statusText = 'Còn $minutes phút đến suất chiếu';
      statusIcon = Icons.schedule;
    } else {
      final hours = (minutes / 60).floor();
      final remainingMinutes = minutes % 60;
      statusColor = Colors.grey;
      statusText =
          'Còn ${hours}h${remainingMinutes > 0 ? ' $remainingMinutes phút' : ''} đến suất chiếu';
      statusIcon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  /// Tiến trình check-in của đơn hàng
  Widget _buildOrderProgress(TicketDetail ticket) {
    final total = ticket.totalTicketsInOrder ?? 1;
    final checkedIn = ticket.checkedInTicketsInOrder ?? 0;
    final progress = checkedIn / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.group, color: Colors.blue[300], size: 20),
              const SizedBox(width: 8),
              Text(
                'Tiến trình check-in đơn hàng',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? Colors.green : Colors.blue,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$checkedIn / $total vé',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section hiển thị sản phẩm đi kèm (đồ ăn/uống)
  Widget _buildProductsSection(List<OrderProductInfo> products) {
    final priceFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.fastfood, color: Colors.orange[300], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Đồ ăn & đồ uống đi kèm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  _getProductIcon(product.category),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      product.productName,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    'x${product.quantity}',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    priceFormat.format(product.unitPrice * product.quantity),
                    style: TextStyle(
                      color: Colors.green[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProductIcon(String? category) {
    IconData icon;
    Color color;

    switch (category?.toLowerCase()) {
      case 'food':
        icon = Icons.fastfood;
        color = Colors.orange;
        break;
      case 'drink':
        icon = Icons.local_drink;
        color = Colors.blue;
        break;
      case 'combo':
        icon = Icons.local_dining;
        color = Colors.purple;
        break;
      default:
        icon = Icons.shopping_basket;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }

  /// Lấy màu theo loại ghế
  Color _getSeatTypeColor(String? seatType) {
    switch (seatType?.toUpperCase()) {
      case 'VIP':
        return Colors.amber;
      case 'COUPLE':
        return Colors.pink;
      case 'PREMIUM':
        return Colors.purple;
      default:
        return Colors.amber;
    }
  }

  /// Lấy tên loại ghế hiển thị
  String _getSeatTypeName(String seatType) {
    switch (seatType.toUpperCase()) {
      case 'VIP':
        return 'VIP';
      case 'COUPLE':
        return 'Ghế đôi';
      case 'PREMIUM':
        return 'Premium';
      case 'STANDARD':
        return 'Thường';
      default:
        return seatType;
    }
  }

  /// Xây dựng subtitle cho thông tin khách hàng
  String? _buildCustomerSubtitle(TicketDetail ticket) {
    final parts = <String>[];
    if (ticket.customerEmail != null) {
      parts.add(ticket.customerEmail!);
    }
    if (ticket.customerPhone != null) {
      parts.add(ticket.customerPhone!);
    }
    return parts.isNotEmpty ? parts.join(' • ') : null;
  }

  Widget _buildStatusHeader(TicketVerificationResult result) {
    final statusConfig = _getStatusConfig(result.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusConfig['color'].withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusConfig['color'].withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusConfig['color'].withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusConfig['icon'],
              color: statusConfig['color'],
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusConfig['title'],
                  style: TextStyle(
                    color: statusConfig['color'],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.message.isNotEmpty
                      ? result.message
                      : statusConfig['subtitle'],
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(TicketStatus status) {
    switch (status) {
      case TicketStatus.valid:
        return {
          'color': Colors.green,
          'icon': Icons.check_circle,
          'title': 'Vé hợp lệ',
          'subtitle': 'Có thể check-in',
        };
      case TicketStatus.used:
        return {
          'color': Colors.orange,
          'icon': Icons.warning,
          'title': 'Đã sử dụng',
          'subtitle': 'Vé đã được check-in trước đó',
        };
      case TicketStatus.expired:
        return {
          'color': Colors.red,
          'icon': Icons.schedule,
          'title': 'Hết hạn',
          'subtitle': 'Vé đã quá hạn sử dụng',
        };
      case TicketStatus.notFound:
        return {
          'color': Colors.grey,
          'icon': Icons.search_off,
          'title': 'Không tìm thấy',
          'subtitle': 'Mã vé không tồn tại',
        };
      case TicketStatus.unknown:
        return {
          'color': Colors.blueGrey,
          'icon': Icons.help_outline,
          'title': 'Không xác định',
          'subtitle': 'Không thể xác minh trạng thái',
        };
    }
  }

  List<Color> _getGradientColors(TicketStatus status) {
    switch (status) {
      case TicketStatus.valid:
        return [const Color(0xFF4CAF50), const Color(0xFF2E7D32)];
      case TicketStatus.used:
        return [Colors.grey[700]!, Colors.grey[900]!];
      case TicketStatus.expired:
        return [Colors.red[700]!, Colors.red[900]!];
      default:
        return [const Color(0xFFE53935), const Color(0xFFC62828)];
    }
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
