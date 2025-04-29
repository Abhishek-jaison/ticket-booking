import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_ticket/providers/event_provider.dart';
import 'package:event_ticket/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('All Events'),
        backgroundColor: AppTheme.darkGrey,
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: eventProvider.events.length,
            itemBuilder: (context, index) {
              final event = eventProvider.events[index];
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
                            placeholder:
                                (context, url) => _buildShimmerEffect(),
                            errorWidget:
                                (context, url, error) => _buildShimmerEffect(),
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
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white),
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
              );
            },
          );
        },
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
}
