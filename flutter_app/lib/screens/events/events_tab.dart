import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/event_card.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({
    required this.events,
    required this.onToggle,
    required this.onOpen,
    required this.onCreate,
    super.key,
  });
  final List<Event> events;
  final void Function(Event) onToggle;
  final void Function(Event) onOpen;
  final VoidCallback onCreate;
  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  String _query = '';
  EventCategory? _category;
  bool _showPast = false;

  @override
  Widget build(BuildContext context) {
    final filtered = widget.events.where((event) {
      final text =
          '${event.title} ${event.location} ${event.description ?? ''} ${event.category.label}'
              .toLowerCase();
      return text.contains(_query.toLowerCase()) &&
          (_category == null || event.category == _category) &&
          (_showPast || !event.isPast);
    }).toList()..sort((a, b) => a.when.compareTo(b.when));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qadam Events'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onCreate,
        icon: const Icon(Icons.add),
        label: const Text('Create'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search events',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () => setState(() => _query = ''),
                        icon: const Icon(Icons.clear),
                      ),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _category == null,
                    onSelected: (_) => setState(() => _category = null),
                  ),
                  for (final category in EventCategory.values)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(category.label),
                        selected: _category == category,
                        onSelected: (_) => setState(() => _category = category),
                      ),
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('Show past events'),
                selected: _showPast,
                onSelected: (value) => setState(() => _showPast = value),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? EmptyState(
                      message: _query.isEmpty
                          ? 'No events match these filters.'
                          : 'No events match your search.',
                      icon: Icons.search_off,
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          return ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (_, index) => EventCard(
                              event: filtered[index],
                              onTap: () => widget.onOpen(filtered[index]),
                              onFavourite: () =>
                                  widget.onToggle(filtered[index]),
                            ),
                          );
                        }
                        final columns = (constraints.maxWidth / 360)
                            .ceil()
                            .clamp(2, 6);
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.0,
                              ),
                          itemCount: filtered.length,
                          itemBuilder: (_, index) => EventCard(
                            event: filtered[index],
                            onTap: () => widget.onOpen(filtered[index]),
                            onFavourite: () => widget.onToggle(filtered[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
