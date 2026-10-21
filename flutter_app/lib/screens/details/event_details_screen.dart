import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../models/event.dart';
import '../../utils/format.dart';
import '../../widgets/empty_state.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({required this.args, super.key});
  final DetailArgs args;
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Event _event;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _event = widget.args.event;
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _register() async {
    final name = widget.args.profile.name.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Set your profile name first.'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: widget.args.onProfile,
          ),
        ),
      );
      return;
    }
    final registered = _event.hasName(name);
    if (_event.isFull && !registered) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(registered ? 'Unregister?' : 'Register?'),
        content: Text(
          registered
              ? 'Remove $name from this event?'
              : 'Add $name to the attendee list?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(registered ? 'Unregister' : 'Register'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      final names = [..._event.attendees];
      registered ? names.remove(name) : names.add(name);
      final updated = _event.copyWith(attendees: names);
      setState(() => _event = updated);
      widget.args.onChanged(updated);
    }
  }

  Future<void> _edit() async {
    final result = await Navigator.pushNamed<Event>(
      context,
      Routes.form,
      arguments: FormArgs(_event),
    );
    if (result != null && mounted) {
      setState(() => _event = result);
      widget.args.onChanged(result);
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete event?'),
        content: const Text('This removes the event from the in-memory list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      widget.args.onDeleted();
      Navigator.pop(context);
    }
  }

  String _countdown() => switch (_event.countdown) {
    Upcoming(:final remaining) => 'Starts in ${formatDuration(remaining)}',
    Started(:final remaining) => 'Started ${formatDuration(remaining)} ago',
    Ended() => 'Ended',
  };
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final places = _event.places;
    final registered = _event.hasName(widget.args.profile.name.trim());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') _edit();
              if (value == 'delete') _delete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/event_header.png',
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Chip(
                  avatar: Icon(
                    _event.category.icon,
                    color: scheme.onPrimaryContainer,
                  ),
                  label: Text(_event.category.label),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: Chip(label: Text(_countdown())),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _event.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      const Tab(text: 'About'),
                      Tab(text: 'Attendees'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            ListTile(
                              leading: const Icon(Icons.schedule),
                              title: Text(formatDateTime(_event.when)),
                            ),
                            ListTile(
                              leading: Icon(
                                _event.isOnline ? Icons.link : Icons.place,
                              ),
                              title: Text(_event.location),
                            ),
                            ListTile(
                              leading: const Icon(Icons.people_outline),
                              title: Text(
                                '${places.taken} taken · ${places.free} free',
                              ),
                            ),
                            if (_event.description != null)
                              ListTile(
                                leading: const Icon(Icons.notes),
                                title: Text(_event.description ?? ''),
                              ),
                          ],
                        ),
                        _event.attendees.isEmpty
                            ? const EmptyState(
                                message: 'No attendee names yet.',
                                icon: Icons.people_outline,
                              )
                            : ListView.builder(
                                itemCount: _event.attendees.length,
                                itemBuilder: (_, index) {
                                  final name = _event.attendees[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        name.characters.first.toUpperCase(),
                                      ),
                                    ),
                                    title: Text(name),
                                    trailing: name == widget.args.profile.name
                                        ? const Chip(label: Text('You'))
                                        : null,
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_event.isFull && !registered) ? null : _register,
                  child: Text(registered ? 'Unregister' : 'Register'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
