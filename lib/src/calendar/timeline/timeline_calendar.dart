import 'package:dartnative/dartnative.dart';

import '../../data/sample_events.dart';
import '../../models/calendar_event.dart';
import '../../utils/calendar_date_utils.dart' as calendar_date_utils;
import 'timeline_date_section.dart';

/// The Agenda/Timeline Calendar tab body: all sample events as a single
/// chronological, scrollable list grouped by date (FR-020).
///
/// Returns content only — no `Scaffold`/`AppBar` of its own, and no
/// navigation state — every sample event is always shown, sorted and
/// grouped fresh on each build.
class TimelineCalendar extends StatelessWidget {
  const TimelineCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sorted = calendar_date_utils.sortEventsChronologically(
      sampleEvents,
    );

    final eventsByDay = <DateTime, List<CalendarEvent>>{};
    for (final event in sorted) {
      final day = DateTime(
        event.start.year,
        event.start.month,
        event.start.day,
      );
      eventsByDay.putIfAbsent(day, () => []).add(event);
    }
    final orderedDays = eventsByDay.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        for (final day in orderedDays)
          TimelineDateSection(
            date: day,
            today: today,
            now: now,
            events: eventsByDay[day]!,
          ),
      ],
    );
  }
}
