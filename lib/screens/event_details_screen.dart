import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_ticket/providers/event_provider.dart';
import 'package:event_ticket/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;
  final String ticketCode;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.ticketCode,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        final event = eventProvider.getEventById(eventId);
        if (event == null) {
          return Scaffold(
            backgroundColor: AppTheme.darkBackground,
            appBar: AppBar(
              title: const Text('Event Details'),
              backgroundColor: AppTheme.darkGrey,
            ),
            body: const Center(
              child: Text(
                'Event not found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.darkBackground,
          appBar: AppBar(
            title: const Text('Event Details'),
            backgroundColor: AppTheme.darkGrey,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Event Image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: event.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.darkGrey,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.neonYellow,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.darkGrey,
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
                // Event Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        context,
                        icon: Icons.calendar_today,
                        label: 'Date',
                        value: event.date,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        context,
                        icon: Icons.location_on,
                        label: 'Venue',
                        value: event.venue,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        context,
                        icon: Icons.access_time,
                        label: 'Time',
                        value: event.time,
                      ),
                      const SizedBox(height: 24),
                      // Ticket Details
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.darkGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ticket Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              context,
                              icon: Icons.qr_code,
                              label: 'Ticket Code',
                              value: ticketCode,
                            ),
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              context,
                              icon: Icons.person,
                              label: 'Ticket Type',
                              value: 'General Admission',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.neonYellow,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
