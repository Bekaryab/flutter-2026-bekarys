import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/event_card.dart';

class FavouritesTab extends StatelessWidget {
  const FavouritesTab({
    required this.events,
    required this.onToggle,
    required this.onOpen,
    super.key,
  });
  final List<Event> events;
  final void Function(Event) onToggle;
  final void Function(Event) onOpen;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: events.isEmpty
          ? const EmptyState(
              message: 'Favourite events will appear here.',
              icon: Icons.favorite_border,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, index) => EventCard(
                event: events[index],
                onTap: () => onOpen(events[index]),
                onFavourite: () => onToggle(events[index]),
              ),
            ),
    );
  }
}
