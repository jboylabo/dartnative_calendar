import 'package:calendar_kit/calendar_kit.dart';

/// The single hard-coded source of demonstration events used by every
/// calendar view. No networking, no persistence — event times are
/// computed relative to "today" (the moment the app runs) so every view
/// (Month/Week/Day/Timeline) always has real data to show, per the
/// project constitution's hard-coded-sample-data principle.
List<CalendarEvent> get sampleEvents => _buildSampleEvents();

List<CalendarEvent> _buildSampleEvents() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  DateTime at(int dayOffset, int hour, [int minute = 0]) {
    final day = today.add(Duration(days: dayOffset));
    return DateTime(day.year, day.month, day.day, hour, minute);
  }

  var nextId = 0;
  String id() {
    nextId += 1;
    return 'evt-${nextId.toString().padLeft(3, '0')}';
  }

  return [
    CalendarEvent(
      id: id(),
      title: 'Meeting',
      start: at(-7, 9),
      end: at(-7, 10),
      description: 'Weekly sync with the team.',
    ),
    CalendarEvent(id: id(), title: 'Gym', start: at(-6, 7), end: at(-6, 8)),
    CalendarEvent(
      id: id(),
      title: 'Lunch',
      start: at(-6, 12, 30),
      end: at(-6, 13, 15),
    ),
    // Day -5 intentionally left empty — exercises the "no events" state.
    CalendarEvent(
      id: id(),
      title: 'Focus Work',
      start: at(-4, 9),
      end: at(-4, 11),
      description: 'Heads-down block, notifications off.',
    ),
    CalendarEvent(
      id: id(),
      title: 'Coffee',
      start: at(-3, 15),
      end: at(-3, 15, 30),
    ),
    CalendarEvent(
      id: id(),
      title: 'App Development',
      start: at(-3, 16),
      end: at(-3, 18),
      description: 'Work on the calendar showcase widgets.',
    ),
    CalendarEvent(
      id: id(),
      title: 'Meeting',
      start: at(-2, 10),
      end: at(-2, 11),
    ),
    CalendarEvent(
      id: id(),
      title: 'Lunch',
      start: at(-1, 12),
      end: at(-1, 13),
    ),

    // Today: includes one intentionally overlapping pair (Meeting / App
    // Development) to exercise the Week/Day side-by-side overlap layout.
    CalendarEvent(id: id(), title: 'Coffee', start: at(0, 8), end: at(0, 8, 15)),
    CalendarEvent(
      id: id(),
      title: 'Meeting',
      start: at(0, 10),
      end: at(0, 11),
      description: 'Planning discussion — overlaps App Development below.',
    ),
    CalendarEvent(
      id: id(),
      title: 'App Development',
      start: at(0, 10, 30),
      end: at(0, 11, 30),
      description: 'Overlaps the Meeting above by design.',
    ),
    CalendarEvent(
      id: id(),
      title: 'Lunch',
      start: at(0, 12, 30),
      end: at(0, 13, 15),
    ),
    CalendarEvent(id: id(), title: 'Focus Work', start: at(0, 14), end: at(0, 16)),
    CalendarEvent(id: id(), title: 'Gym', start: at(0, 18), end: at(0, 19)),

    CalendarEvent(
      id: id(),
      title: 'Meeting',
      start: at(1, 9, 30),
      end: at(1, 10),
    ),
    CalendarEvent(
      id: id(),
      title: 'Focus Work',
      start: at(2, 9),
      end: at(2, 12),
      description: 'Deep work session.',
    ),
    // Day +3 intentionally left empty.
    CalendarEvent(
      id: id(),
      title: 'Coffee',
      start: at(4, 15),
      end: at(4, 15, 30),
    ),
    CalendarEvent(
      id: id(),
      title: 'App Development',
      start: at(5, 13),
      end: at(5, 17),
      description: 'Polish the Week and Day layouts.',
    ),
    CalendarEvent(
      id: id(),
      title: 'Gym',
      start: at(6, 7, 30),
      end: at(6, 8, 30),
    ),
    CalendarEvent(
      id: id(),
      title: 'Lunch',
      start: at(6, 12),
      end: at(6, 12, 45),
    ),
    CalendarEvent(
      id: id(),
      title: 'Meeting',
      start: at(7, 11),
      end: at(7, 12),
      description: 'Sprint review.',
    ),
    CalendarEvent(
      id: id(),
      title: 'Focus Work',
      start: at(9, 9),
      end: at(9, 10, 30),
    ),
    CalendarEvent(
      id: id(),
      title: 'Coffee',
      start: at(10, 10),
      end: at(10, 10, 15),
    ),
    CalendarEvent(
      id: id(),
      title: 'App Development',
      start: at(10, 11),
      end: at(10, 13),
      description: 'Wrap up the Timeline view.',
    ),
  ];
}
