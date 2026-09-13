import 'package:dartnative/dartnative.dart';

import '../../models/calendar_event.dart';
import '../../utils/calendar_date_utils.dart' as calendar_date_utils;
import 'day_header.dart';
import 'day_time_grid.dart';

/// The Day Calendar tab body: one selected day's hourly timeline with
/// previous/next day navigation, events positioned by start time and
/// duration, and a current-time indicator when viewing today.
///
/// Returns content only — no `Scaffold`/`AppBar` of its own, so it can be
/// embedded in any layout (a tab, a page, a showcase shell).
class DayCalendar extends StatefulWidget {
  /// The events to position across the day's hourly timeline.
  final List<CalendarEvent> events;

  const DayCalendar({super.key, this.events = const []});

  @override
  State<DayCalendar> createState() => _DayCalendarState();
}

class _DayCalendarState extends State<DayCalendar> {
  late final DateTime _today;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _selectedDay = _today;
  }

  void _goToPreviousDay() {
    setState(() {
      _selectedDay = _selectedDay.subtract(const Duration(days: 1));
    });
  }

  void _goToNextDay() {
    setState(() {
      _selectedDay = _selectedDay.add(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dayEvents = calendar_date_utils.eventsOnDay(
      widget.events,
      _selectedDay,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DayHeader(
          selectedDay: _selectedDay,
          onPreviousDay: _goToPreviousDay,
          onNextDay: _goToNextDay,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: DayTimeGrid(
            date: _selectedDay,
            today: _today,
            events: dayEvents,
          ),
        ),
      ],
    );
  }
}
