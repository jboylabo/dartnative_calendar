import 'package:dartnative_calendar/dartnative_calendar.dart';
import 'package:dartnative_calendar/src/utils/calendar_date_utils.dart'
    as calendar_date_utils;
import 'package:test/test.dart';

void main() {
  group('CalendarEvent', () {
    test('duration is end minus start', () {
      final event = CalendarEvent(
        id: 'evt-1',
        title: 'Meeting',
        start: DateTime(2026, 1, 10, 9),
        end: DateTime(2026, 1, 10, 10, 30),
      );
      expect(event.duration, const Duration(hours: 1, minutes: 30));
    });
  });

  group('calendar_date_utils', () {
    test('startOfWeek returns the Monday of the containing week', () {
      final wednesday = DateTime(2026, 1, 14);
      expect(
        calendar_date_utils.startOfWeek(wednesday),
        DateTime(2026, 1, 12),
      );
    });

    test('eventsOnDay filters to events starting on that day', () {
      final onDay = CalendarEvent(
        id: 'evt-1',
        title: 'On day',
        start: DateTime(2026, 1, 10, 9),
        end: DateTime(2026, 1, 10, 10),
      );
      final otherDay = CalendarEvent(
        id: 'evt-2',
        title: 'Other day',
        start: DateTime(2026, 1, 11, 9),
        end: DateTime(2026, 1, 11, 10),
      );
      final result = calendar_date_utils.eventsOnDay(
        [onDay, otherDay],
        DateTime(2026, 1, 10),
      );
      expect(result, [onDay]);
    });

    test('sortEventsChronologically orders by start time', () {
      final later = CalendarEvent(
        id: 'evt-1',
        title: 'Later',
        start: DateTime(2026, 1, 10, 14),
        end: DateTime(2026, 1, 10, 15),
      );
      final earlier = CalendarEvent(
        id: 'evt-2',
        title: 'Earlier',
        start: DateTime(2026, 1, 10, 9),
        end: DateTime(2026, 1, 10, 10),
      );
      final result = calendar_date_utils.sortEventsChronologically([
        later,
        earlier,
      ]);
      expect(result, [earlier, later]);
    });
  });
}
