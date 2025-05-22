import 'package:flutter/material.dart';
import '../models/order_details.dart';
import '../services/order_service.dart';
import '../theme/app_theme.dart';

class TicketVerificationScreen extends StatefulWidget {
  final String trackingNumber;
  final String eventTitle;
  final String bearerToken;

  const TicketVerificationScreen({
    Key? key,
    required this.trackingNumber,
    required this.eventTitle,
    required this.bearerToken,
  }) : super(key: key);

  @override
  State<TicketVerificationScreen> createState() =>
      _TicketVerificationScreenState();
}

class _TicketVerificationScreenState extends State<TicketVerificationScreen> {
  late final OrderService _orderService;
  late Future<OrderDetails> _orderDetailsFuture;
  bool _isVerifying = false;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _orderService = OrderService(bearerToken: widget.bearerToken);
    _orderDetailsFuture = _orderService.getOrderDetails(widget.trackingNumber);
  }

  Future<void> _verifyTicket() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      final success =
          await _orderService.updateScanCount(widget.trackingNumber);
      if (success) {
        setState(() {
          _isVerified = true;
        });
        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket verified successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );

        // Return to scanner screen after a short delay
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          // Pop until we reach the scanner screen
          Navigator.of(context).popUntil((route) {
            return route.settings.name == '/scanner' ||
                route.settings.name ==
                    null; // Fallback to pop if no named route
          });
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to verify ticket. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Verification'),
        backgroundColor: AppTheme.darkGrey,
      ),
      backgroundColor: AppTheme.darkBackground,
      body: FutureBuilder<OrderDetails>(
        future: _orderDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No ticket data found'));
          }

          final orderDetails = snapshot.data!;
          final bool isReVerification = orderDetails.scanCount > 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: AppTheme.darkGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.eventTitle,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tracking Number: ${widget.trackingNumber}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: AppTheme.darkGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                            'Customer Name', orderDetails.customerName),
                        _buildInfoRow('Contact', orderDetails.customerContact),
                        _buildInfoRow('Email', orderDetails.customerEmail),
                        _buildInfoRow(
                            'Purchase Date', orderDetails.formattedDate),
                        _buildInfoRow(
                            'Purchase Time', orderDetails.formattedTime),
                        _buildInfoRow('Amount',
                            '${orderDetails.currencyCode} ${orderDetails.total}'),
                        _buildInfoRow(
                            'Payment Status', orderDetails.paymentStatus),
                        _buildInfoRow(
                            'Scan Count', orderDetails.scanCount.toString()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (!_isVerified)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isVerifying ? null : _verifyTicket,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: isReVerification
                            ? Colors.orange
                            : AppTheme.neonYellow,
                      ),
                      child: _isVerifying
                          ? const CircularProgressIndicator()
                          : Text(
                              isReVerification
                                  ? 'Re-verify Ticket'
                                  : 'Verify Ticket',
                              style: TextStyle(
                                color: isReVerification
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  )
                else
                  Card(
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            isReVerification
                                ? 'Ticket Re-verified'
                                : 'Ticket Verified',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
