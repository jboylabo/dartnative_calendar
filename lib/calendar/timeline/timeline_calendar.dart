import 'package:dartnative/dartnative.dart';

/// The Agenda/Timeline Calendar tab body. Placeholder pending the full
/// implementation (see specs/001-calendar-showcase/tasks.md Phase 7).
///
/// Returns content only — no `Scaffold`/`AppBar` of its own; the title and
/// description are rendered by `CalendarShowcaseScreen`'s shared tab
/// header.
class TimelineCalendar extends StatelessWidget {
  const TimelineCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Coming soon.',
        style: TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
      ),
    );
  }
}
