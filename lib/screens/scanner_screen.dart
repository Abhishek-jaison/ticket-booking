import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:event_ticket/providers/event_provider.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool isProcessing = false;

  void _onDetect(BarcodeCapture capture) {
    if (isProcessing) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    setState(() => isProcessing = true);

    try {
      final ticket = context.read<EventProvider>().verifyTicket(
        barcodes.first.rawValue!,
      );
      if (!mounted) return;
      if (ticket != null) {
        _showTicketDetails(ticket);
      }
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  void _showTicketDetails(Ticket ticket) {
    final event = context.read<EventProvider>().events.firstWhere(
      (e) => e.id == ticket.eventId,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Ticket Verified'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Event: ${event.name}'),
                const SizedBox(height: 8),
                Text('Name: ${ticket.name}'),
                const SizedBox(height: 8),
                Text('Seat: ${ticket.seatNo}'),
                const SizedBox(height: 8),
                Text('Status: ${ticket.isVerified ? "Verified" : "Valid"}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Ticket')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _onDetect,
            overlay: QRScannerOverlay(
              overlayColor: Theme.of(context).colorScheme.primary,
              borderColor: Theme.of(context).colorScheme.primary,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Position the QR code within the frame',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRScannerOverlay extends StatelessWidget {
  final Color overlayColor;
  final Color borderColor;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final double cutOutSize;

  const QRScannerOverlay({
    super.key,
    required this.overlayColor,
    required this.borderColor,
    required this.borderRadius,
    required this.borderLength,
    required this.borderWidth,
    required this.cutOutSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            overlayColor.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.black),
                child: Center(
                  child: Container(
                    height: cutOutSize,
                    width: cutOutSize,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            height: cutOutSize,
            width: cutOutSize,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: borderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Stack(
              children: [
                _buildCorner(
                  borderLength,
                  borderWidth,
                  borderColor,
                  borderRadius,
                  true,
                  true,
                ),
                _buildCorner(
                  borderLength,
                  borderWidth,
                  borderColor,
                  borderRadius,
                  true,
                  false,
                ),
                _buildCorner(
                  borderLength,
                  borderWidth,
                  borderColor,
                  borderRadius,
                  false,
                  true,
                ),
                _buildCorner(
                  borderLength,
                  borderWidth,
                  borderColor,
                  borderRadius,
                  false,
                  false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(
    double length,
    double width,
    Color color,
    double radius,
    bool top,
    bool left,
  ) {
    return Positioned(
      top: top ? 0 : null,
      bottom: !top ? 0 : null,
      left: left ? 0 : null,
      right: !left ? 0 : null,
      child: Container(
        width: length,
        height: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: top && left ? Radius.circular(radius) : Radius.zero,
            topRight: top && !left ? Radius.circular(radius) : Radius.zero,
            bottomLeft: !top && left ? Radius.circular(radius) : Radius.zero,
            bottomRight: !top && !left ? Radius.circular(radius) : Radius.zero,
          ),
        ),
      ),
    );
  }
}
