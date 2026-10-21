import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../data/seed_events.dart';
import '../../models/event.dart';
import '../../models/profile.dart';
import '../events/events_tab.dart';
import '../favourites/favourites_tab.dart';
import '../profile/profile_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    required this.themeMode,
    required this.onThemeChanged,
    super.key,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  List<Event> _events = seedEvents();
  Profile _profile = const Profile.empty();
  int _tab = 0;
  void _update(Event event) => setState(
    () => _events = _events
        .map((item) => item.id == event.id ? event : item)
        .toList(),
  );
  void _toggle(Event event) =>
      _update(event.copyWith(isFavourite: !event.isFavourite));
  void _openDetail(Event event) => Navigator.pushNamed(
    context,
    Routes.detail,
    arguments: DetailArgs(
      event,
      onChanged: _update,
      onDeleted: () =>
          setState(() => _events.removeWhere((item) => item.id == event.id)),
      profile: _profile,
      onProfile: () => setState(() => _tab = 2),
    ),
  );
  Future<void> _create() async {
    final event = await Navigator.pushNamed<Event>(
      context,
      Routes.form,
      arguments: const FormArgs(null),
    );
    if (event != null && mounted) setState(() => _events = [..._events, event]);
  }

  Future<void> _reset() async {
    Navigator.pop(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset data?'),
        content: const Text(
          'Restore the original sample events and clear your profile?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() {
        _events = seedEvents();
        _profile = const Profile.empty();
        _tab = 0;
      });
    }
  }

  void _about() {
    Navigator.pop(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Qadam Events'),
        content: const Text(
          'Qadam Events is an in-memory coursework demo for campus and technology events.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      EventsTab(
        events: _events,
        onToggle: _toggle,
        onOpen: _openDetail,
        onCreate: _create,
      ),
      FavouritesTab(
        events: _events.where((event) => event.isFavourite).toList(),
        onToggle: _toggle,
        onOpen: _openDetail,
      ),
      ProfileTab(
        profile: _profile,
        events: _events,
        themeMode: widget.themeMode,
        onProfileChanged: (profile) => setState(() => _profile = profile),
        onThemeChanged: widget.onThemeChanged,
      ),
    ];
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const DrawerHeader(child: Text('Qadam Events')),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: _about,
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Reset data'),
                onTap: _reset,
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _tab, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
