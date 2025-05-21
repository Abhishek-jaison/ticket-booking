import 'package:flutter/material.dart';
import '../models/order_details.dart';
import '../services/order_service.dart';

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
      final success = await _orderService.verifyTicket(widget.trackingNumber);
      if (success) {
        setState(() {
          _isVerified = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket verified successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to verify ticket. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Verification'),
      ),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.eventTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ticket #${orderDetails.trackingNumber}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
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
                      ),
                      child: _isVerifying
                          ? const CircularProgressIndicator()
                          : const Text('Verify Ticket'),
                    ),
                  )
                else
                  const Card(
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Ticket Verified',
                            style: TextStyle(
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
