import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../models/profile.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    required this.profile,
    required this.events,
    required this.themeMode,
    required this.onProfileChanged,
    required this.onThemeChanged,
    super.key,
  });
  final Profile profile;
  final List<Event> events;
  final ThemeMode themeMode;
  final ValueChanged<Profile> onProfileChanged;
  final ValueChanged<ThemeMode> onThemeChanged;
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late final TextEditingController _name;
  late final TextEditingController _group;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile.name);
    _group = TextEditingController(text: widget.profile.group);
  }

  @override
  void didUpdateWidget(covariant ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile &&
        _name.text != widget.profile.name) {
      _name.text = widget.profile.name;
    }
    if (oldWidget.profile != widget.profile &&
        _group.text != widget.profile.group) {
      _group.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _group.dispose();
    super.dispose();
  }

  void _save() => widget.onProfileChanged(
    widget.profile.copyWith(name: _name.text.trim(), group: _group.text.trim()),
  );
  @override
  Widget build(BuildContext context) {
    final name = widget.profile.name.trim();
    final count = name.isEmpty
        ? 0
        : widget.events.where((event) => event.hasName(name)).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Your campus identity',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _group,
            decoration: const InputDecoration(labelText: 'Group'),
            validator: (value) =>
                value != null &&
                    RegExp(r'^[A-Za-zА-Яа-яӘәҒғҚқҢңӨөҰұҮүҺһІі0-9 ._-]{2,30}$')
                        .hasMatch(value.trim())
                ? null
                : 'Use 2–30 letters, numbers, spaces, . _ or -',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onFieldSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: const Text('Save profile')),
          const SizedBox(height: 24),
          Text(
            'You are on $count lists',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Text('Theme', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final mode in [
                ThemeMode.system,
                ThemeMode.light,
                ThemeMode.dark,
              ])
                ChoiceChip(
                  label: Text(
                    mode.name[0].toUpperCase() + mode.name.substring(1),
                  ),
                  selected: widget.themeMode == mode,
                  onSelected: (_) => widget.onThemeChanged(mode),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
