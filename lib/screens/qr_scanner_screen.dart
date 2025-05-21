import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/order_service.dart';
import '../providers/auth_provider.dart';
import '../screens/ticket_verification_screen.dart';

class QRScannerScreen extends StatefulWidget {
  final String eventId;
  final String eventTitle;

  const QRScannerScreen({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true;
  bool isProcessing = false;
  late final OrderService _orderService;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _orderService = OrderService(bearerToken: authProvider.token!);
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _validateAndProceed(String code) async {
    if (!isScanning || isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    try {
      // Try to get order details to validate the ticket
      await _orderService.getOrderDetails(code);

      if (!mounted) return;

      // If we get here, the ticket is valid
      setState(() {
        isScanning = false;
      });

      // Navigate to verification screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TicketVerificationScreen(
            trackingNumber: code,
            eventTitle: widget.eventTitle,
            bearerToken: _orderService.bearerToken,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid ticket: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );

      // Resume scanning after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            isProcessing = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: AppTheme.darkGrey,
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on,
                        color: AppTheme.neonYellow);
                }
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String code = barcodes.first.rawValue ?? '';
                _validateAndProceed(code);
              }
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.neonYellow,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.neonYellow,
                ),
              ),
            ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                isProcessing
                    ? 'Validating ticket...'
                    : 'Position QR code within the frame',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
