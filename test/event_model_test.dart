import 'package:flutter_test/flutter_test.dart';
import 'package:qadam_events/data/seed_events.dart';
import 'package:qadam_events/models/event.dart';

void main() {
  test('seed data contains the required demonstration cases', () {
    final events = seedEvents();
    expect(events, hasLength(12));
    expect(events.any((event) => event.title.length == 60), isTrue);
    expect(events.any((event) => event.isFull), isTrue);
    expect(events.any((event) => event.isPast), isTrue);
    expect(
      events.any((event) => event.isOnline && event.location.contains('://')),
      isTrue,
    );
    expect(events.any((event) => event.description == null), isTrue);
  });

  test('event attendee list is defensively copied', () {
    final names = ['Aruzhan'];
    final event = Event(
      id: 'test',
      title: 'Campus Event',
      category: EventCategory.community,
      when: DateTime.now(),
      location: 'Room 1',
      limit: 5,
      attendees: names,
      isOnline: false,
    );
    names.add('Miras');
    expect(event.attendees, ['Aruzhan']);
    expect(event.places, (taken: 1, free: 4));
  });
}
