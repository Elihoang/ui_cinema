import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import '../other/seat_food_order_page.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController controller = MobileScannerController();
  bool _isScanned = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Quét mã QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Nền tối
          Container(color: Colors.black),

          // Camera preview ở giữa màn hình (dịch lên trên)
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
                    aspectRatio: 1.0, // Tỉ lệ 1:1 để camera vuông
                    child: MobileScanner(
                      controller: controller,
                      fit: BoxFit.cover,
                      onDetect: (barcodeCapture) {
                        if (_isScanned) return;

                        final barcode = barcodeCapture.barcodes.first;
                        final String? value = barcode.rawValue;

                        if (value != null) {
                          _isScanned = true;
                          controller.stop();

                          // Rung nhẹ khi quét thành công
                          HapticFeedback.mediumImpact();

                          // Hiển thị kết quả
                          debugPrint('QR Value: $value');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('QR: $value'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );

                          // Chuyển sang trang order đồ ăn
                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SeatFoodOrderPage(seatQrCode: value),
                                ),
                              );
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Overlay khung viền quét (dịch lên trên)
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.25 - 10,
            child: Center(
              child: CustomPaint(
                size: const Size(scanAreaSize + 20, scanAreaSize + 20),
                painter: ScanFramePainter(),
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
                  Icons.qr_code_scanner,
                  size: 48,
                  color: Colors.white.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  'Đưa mã QR vào khung để quét',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Mã QR sẽ được tự động nhận diện',
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
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0xFFE53935) // Màu đỏ
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
