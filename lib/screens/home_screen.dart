import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../providers/auth_provider.dart';
import '../models/event.dart';
import '../screens/scanner_screen.dart';
import '../screens/ticket_qr_screen.dart';
import '../screens/qr_scanner_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hai, Abhi'),
            Text(
              'Discover amazing events',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.sectionSubtitleColor,
                  ),
            ),
          ],
        ),
        backgroundColor: AppTheme.darkGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TicketQRScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ScannerScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<EventsProvider>(
        builder: (context, eventsProvider, child) {
          if (eventsProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.neonYellow,
              ),
            );
          }

          if (eventsProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${eventsProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      if (authProvider.token != null) {
                        eventsProvider.fetchEvents(authProvider.token!);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (eventsProvider.events.isEmpty) {
            return const Center(
              child: Text(
                'No events found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                  context,
                  'All Events',
                  'Discover more events',
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: eventsProvider.events.length,
                  itemBuilder: (context, index) {
                    return EventCard(
                        event: eventsProvider.events[index], index: index);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.sectionTitleColor,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.sectionSubtitleColor,
                ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final int index;

  const EventCard({super.key, required this.event, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScannerScreen(
              eventId: event.id,
              eventTitle: event.title,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        color: AppTheme.darkGrey,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left side - Image
              SizedBox(
                width: 160,
                child: event.image != null
                    ? CachedNetworkImage(
                        imageUrl: event.image!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildShimmerEffect(),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.darkGrey,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 32,
                          ),
                        ),
                      )
                    : Container(
                        color: AppTheme.darkGrey,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 32,
                        ),
                      ),
              ),
              // Right side - Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppTheme.neonYellow,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event.formattedDate,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppTheme.neonYellow,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event.location,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 200));
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: AppTheme.darkGrey,
      highlightColor: AppTheme.darkGrey.withOpacity(0.5),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkGrey,
              AppTheme.darkGrey.withOpacity(0.8),
              AppTheme.darkGrey,
            ],
          ),
        ),
      ),
    );
  }
}
