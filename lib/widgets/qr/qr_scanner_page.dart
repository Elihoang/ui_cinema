import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import '../other/seat_food_order_page.dart';
import 'ticket_checkin_page.dart';
import '../../services/user_service.dart';
import '../../enums/user_role.dart';

/// Chế độ quét QR
enum QrScanMode {
  /// Quét mã ghế để order đồ ăn (dành cho Customer)
  seatOrder,

  /// Quét mã vé để checkin (dành cho Staff/Admin)
  ticketCheckin,
}

class QrScannerPage extends StatefulWidget {
  /// Cho phép chỉ định mode cố định, nếu null sẽ tự động detect theo role
  final QrScanMode? forcedMode;

  const QrScannerPage({super.key, this.forcedMode});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController controller = MobileScannerController();
  bool _isScanned = false;
  bool _isLoadingRole = true;
  QrScanMode _scanMode = QrScanMode.seatOrder;
  UserRole _userRole = UserRole.unknown;

  // Kích thước vùng quét QR
  static const double scanAreaSize = 250.0;

  @override
  void initState() {
    super.initState();
    // Khóa màn hình ở chế độ dọc (Portrait)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initializeScanMode();
  }

  /// Khởi tạo chế độ quét dựa trên role của user
  Future<void> _initializeScanMode() async {
    if (widget.forcedMode != null) {
      setState(() {
        _scanMode = widget.forcedMode!;
        _isLoadingRole = false;
      });
      return;
    }

    try {
      final role = await UserService.getUserRole();
      setState(() {
        _userRole = role;
        // Staff và Admin sẽ quét mã checkin vé
        // Customer sẽ quét mã order đồ ăn theo ghế
        _scanMode = role.isStaff
            ? QrScanMode.ticketCheckin
            : QrScanMode.seatOrder;
        _isLoadingRole = false;
      });
    } catch (e) {
      debugPrint('Error getting user role: $e');
      setState(() {
        _scanMode = QrScanMode.seatOrder;
        _isLoadingRole = false;
      });
    }
  }

  /// Xử lý khi quét được mã QR
  void _handleQrDetected(String value) {
    if (_isScanned) return;

    _isScanned = true;
    controller.stop();

    // Rung nhẹ khi quét thành công
    HapticFeedback.mediumImpact();

    debugPrint('QR Value: $value (Mode: $_scanMode)');

    // Điều hướng dựa theo chế độ quét
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      switch (_scanMode) {
        case QrScanMode.seatOrder:
          // Customer: Chuyển sang trang order đồ ăn
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => SeatFoodOrderPage(seatQrCode: value),
            ),
          );
          break;

        case QrScanMode.ticketCheckin:
          // Staff/Admin: Chuyển sang trang checkin vé
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => TicketCheckinPage(ticketCode: value),
                ),
              )
              .then((_) {
                // Khi quay lại, cho phép quét lại
                if (mounted) {
                  setState(() => _isScanned = false);
                  controller.start();
                }
              });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingRole) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Đang tải...',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Hiển thị role nếu là staff/admin
          if (_userRole.isStaff)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user, size: 16, color: Colors.red),
                  const SizedBox(width: 4),
                  Text(
                    _userRole.displayName,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // Nền tối
          Container(color: Colors.black),

          // Mode indicator
          Positioned(
            left: 0,
            right: 0,
            top: 16,
            child: Center(child: _buildModeIndicator()),
          ),

          // Camera preview ở giữa màn hình
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.25,
            child: Center(
              child: SizedBox(
                width: scanAreaSize,
                height: scanAreaSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: MobileScanner(
                      controller: controller,
                      fit: BoxFit.cover,
                      onDetect: (barcodeCapture) {
                        final barcode = barcodeCapture.barcodes.first;
                        final String? value = barcode.rawValue;
                        if (value != null) {
                          _handleQrDetected(value);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Overlay khung viền quét
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.25 - 10,
            child: Center(
              child: CustomPaint(
                size: const Size(scanAreaSize + 20, scanAreaSize + 20),
                painter: ScanFramePainter(
                  color: _scanMode == QrScanMode.ticketCheckin
                      ? Colors.green
                      : const Color(0xFFE53935),
                ),
              ),
            ),
          ),

          // Hướng dẫn quét
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Icon(
                  _getScanModeIcon(),
                  size: 48,
                  color: Colors.white.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  _getScanModeTitle(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _getScanModeDescription(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Nút đèn flash
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                onPressed: () => controller.toggleTorch(),
                icon: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, state, child) {
                    return Icon(
                      state.torchState == TorchState.on
                          ? Icons.flash_on
                          : Icons.flash_off,
                      color: state.torchState == TorchState.on
                          ? Colors.amber
                          : Colors.white,
                      size: 32,
                    );
                  },
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tạo widget hiển thị chế độ quét hiện tại
  Widget _buildModeIndicator() {
    final isCheckinMode = _scanMode == QrScanMode.ticketCheckin;
    final color = isCheckinMode ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCheckinMode ? Icons.check_circle : Icons.fastfood,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isCheckinMode ? 'CHẾ ĐỘ CHECK-IN VÉ' : 'CHẾ ĐỘ ORDER ĐỒ ĂN',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    return _scanMode == QrScanMode.ticketCheckin
        ? 'Quét vé Check-in'
        : 'Quét mã QR';
  }

  IconData _getScanModeIcon() {
    return _scanMode == QrScanMode.ticketCheckin
        ? Icons.confirmation_number
        : Icons.qr_code_scanner;
  }

  String _getScanModeTitle() {
    return _scanMode == QrScanMode.ticketCheckin
        ? 'Quét mã vé để check-in'
        : 'Đưa mã QR vào khung để quét';
  }

  String _getScanModeDescription() {
    return _scanMode == QrScanMode.ticketCheckin
        ? 'Quét mã QR trên vé của khách hàng'
        : 'Quét mã QR trên ghế để đặt đồ ăn';
  }

  @override
  void dispose() {
    controller.dispose();
    // Khôi phục lại các hướng xoay
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
}

/// Custom painter để vẽ khung quét QR
class ScanFramePainter extends CustomPainter {
  final Color color;

  ScanFramePainter({this.color = const Color(0xFFE53935)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cornerLength = 30.0;
    final rect = Rect.fromLTWH(10, 10, size.width - 20, size.height - 20);

    // Góc trên trái
    canvas.drawLine(
      Offset(rect.left, rect.top + cornerLength),
      Offset(rect.left, rect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left + cornerLength, rect.top),
      paint,
    );

    // Góc trên phải
    canvas.drawLine(
      Offset(rect.right - cornerLength, rect.top),
      Offset(rect.right, rect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right, rect.top + cornerLength),
      paint,
    );

    // Góc dưới trái
    canvas.drawLine(
      Offset(rect.left, rect.bottom - cornerLength),
      Offset(rect.left, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left + cornerLength, rect.bottom),
      paint,
    );

    // Góc dưới phải
    canvas.drawLine(
      Offset(rect.right - cornerLength, rect.bottom),
      Offset(rect.right, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.bottom),
      Offset(rect.right, rect.bottom - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
