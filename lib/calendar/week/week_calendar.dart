import 'package:dartnative/dartnative.dart';

/// The Week Calendar tab body. Placeholder pending the full Week Calendar
/// implementation (see specs/001-calendar-showcase/tasks.md Phase 5).
///
/// Returns content only — no `Scaffold`/`AppBar` of its own; the title and
/// description are rendered by `CalendarShowcaseScreen`'s shared tab
/// header.
class WeekCalendar extends StatelessWidget {
  const WeekCalendar({super.key});

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
