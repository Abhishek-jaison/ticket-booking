import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_ticket/providers/event_provider.dart';
import 'package:event_ticket/screens/scanner_screen.dart';
import 'package:event_ticket/screens/ticket_qr_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:event_ticket/theme/app_theme.dart';
import 'package:event_ticket/screens/qr_scanner_screen.dart';

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
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                  context,
                  'Trending',
                  'Most popular events right now',
                ),
                _buildHorizontalEventList(
                  context,
                  eventProvider.events,
                  height: 250,
                  isRectangular: true,
                ),
                _buildSectionHeader(
                  context,
                  'Made for You',
                  'Based on your interests',
                ),
                _buildHorizontalEventList(
                  context,
                  eventProvider.events.reversed.toList(),
                  height: 250,
                  isRectangular: false,
                ),
                _buildSectionHeader(
                  context,
                  'All Events',
                  'Discover more events',
                ),
                _buildEventGrid(context, eventProvider.events),
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

  Widget _buildHorizontalEventList(
    BuildContext context,
    List<Event> events, {
    required double height,
    required bool isRectangular,
  }) {
    // Calculate card width based on style
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = isRectangular
        ? (screenWidth - 48) / 2.5 // Show 2.5 cards for rectangular style
        : 200.0; // Fixed width for square style

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: events.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final event = events[index];
          return SizedBox(
            width: cardWidth,
            child: isRectangular
                ? _buildRectangularCard(context, event)
                : _buildSquareCard(context, event),
          );
        },
      ),
    );
  }

  Widget _buildRectangularCard(BuildContext context, Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScannerScreen(eventId: event.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.darkGrey,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: event.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => _buildShimmerEffect(),
              errorWidget: (context, url, error) => _buildShimmerEffect(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Text(
                  event.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildSquareCard(BuildContext context, Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScannerScreen(eventId: event.id),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.darkGrey,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: event.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Shimmer.fromColors(
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
              ),
              errorWidget: (context, url, error) => Shimmer.fromColors(
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
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Text(
                  event.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventGrid(BuildContext context, List<Event> events) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(event: events[index], index: index);
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final int index;

  const EventCard({super.key, required this.event, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: AppTheme.darkGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: event.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => Shimmer.fromColors(
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
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppTheme.darkGrey,
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                        size: 48,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      event.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: AppTheme.darkGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppTheme.neonYellow,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.date,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
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
                          event.venue,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
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
    ).animate().fadeIn(delay: Duration(milliseconds: index * 200));
  }
}
