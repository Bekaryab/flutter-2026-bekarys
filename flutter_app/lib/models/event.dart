import 'dart:collection';

import 'package:flutter/material.dart';

enum EventCategory {
  technology('Technology', Icons.computer),
  career('Career', Icons.work_outline),
  culture('Culture', Icons.palette_outlined),
  sport('Sport', Icons.sports_basketball_outlined),
  science('Science', Icons.science_outlined),
  community('Community', Icons.groups_outlined);

  const EventCategory(this.label, this.icon);
  final String label;
  final IconData icon;
  Color color(ColorScheme scheme) => switch (this) {
    EventCategory.technology => scheme.primary,
    EventCategory.career => scheme.tertiary,
    EventCategory.culture => scheme.secondary,
    EventCategory.sport => scheme.error,
    EventCategory.science => scheme.inversePrimary,
    EventCategory.community => scheme.primaryContainer,
  };
}

sealed class Countdown {
  const Countdown();
}

final class Upcoming extends Countdown {
  const Upcoming(this.remaining);
  final Duration remaining;
}

final class Started extends Countdown {
  const Started(this.remaining);
  final Duration remaining;
}

final class Ended extends Countdown {
  const Ended();
}

class Event {
  Event._({
    required this.id,
    required this.title,
    required this.category,
    required this.when,
    required this.location,
    required this.limit,
    required List<String> attendees,
    required this.isOnline,
    required this.description,
    required this.isFavourite,
  }) : _attendees = UnmodifiableListView(List<String>.of(attendees));
  factory Event({
    required String id,
    required String title,
    required EventCategory category,
    required DateTime when,
    required String location,
    required int limit,
    List<String> attendees = const [],
    required bool isOnline,
    String? description,
    bool isFavourite = false,
  }) => Event._(
    id: id,
    title: title,
    category: category,
    when: when,
    location: location,
    limit: limit,
    attendees: attendees,
    isOnline: isOnline,
    description: description,
    isFavourite: isFavourite,
  );
  factory Event.empty() => Event(
    id: 'new',
    title: '',
    category: EventCategory.technology,
    when: DateTime.now().add(const Duration(days: 1)),
    location: '',
    limit: 20,
    isOnline: false,
    description: null,
  );
  final String id, title, location;
  final EventCategory category;
  final DateTime when;
  final int limit;
  final bool isOnline, isFavourite;
  final String? description;
  final UnmodifiableListView<String> _attendees;
  List<String> get attendees => _attendees;
  int get attendeeCount => attendees.length;
  int get freePlaces => (limit - attendeeCount).clamp(0, limit);
  bool get isFull => freePlaces == 0;
  bool get isPast => when.isBefore(DateTime.now());
  bool hasName(String name) =>
      name.trim().isNotEmpty && attendees.contains(name.trim());
  ({int taken, int free}) get places =>
      (taken: attendeeCount, free: freePlaces);
  Countdown get countdown {
    final difference = when.difference(DateTime.now());
    return difference > Duration.zero
        ? Upcoming(difference)
        : (DateTime.now().difference(when) < const Duration(hours: 2)
              ? Started(DateTime.now().difference(when))
              : const Ended());
  }

  Event copyWith({
    String? id,
    String? title,
    EventCategory? category,
    DateTime? when,
    String? location,
    int? limit,
    List<String>? attendees,
    bool? isOnline,
    String? description,
    bool clearDescription = false,
    bool? isFavourite,
  }) => Event(
    id: id ?? this.id,
    title: title ?? this.title,
    category: category ?? this.category,
    when: when ?? this.when,
    location: location ?? this.location,
    limit: limit ?? this.limit,
    attendees: attendees ?? this.attendees,
    isOnline: isOnline ?? this.isOnline,
    description: clearDescription ? null : (description ?? this.description),
    isFavourite: isFavourite ?? this.isFavourite,
  );
}
