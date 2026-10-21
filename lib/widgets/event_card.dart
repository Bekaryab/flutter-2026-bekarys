import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/format.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.event,
    required this.onTap,
    required this.onFavourite,
    super.key,
  });
  final Event event;
  final VoidCallback onTap, onFavourite;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final places = event.places;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    backgroundColor: event.category
                        .color(scheme)
                        .withValues(alpha: .18),
                    child: Icon(
                      event.category.icon,
                      color: event.category.color(scheme),
                    ),
                  ),
                  if (event.isFull || places.free <= 5)
                    Positioned(
                      bottom: -5,
                      right: -10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: event.isFull ? scheme.error : scheme.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.isFull ? 'FULL' : '${places.free} left',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: scheme.onError),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(formatDateTime(event.when)),
                    Text(
                      event.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      event.category.label,
                      style: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(color: event.category.color(scheme)),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Favourite',
                onPressed: onFavourite,
                icon: Icon(
                  event.isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: event.isFavourite ? scheme.error : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
