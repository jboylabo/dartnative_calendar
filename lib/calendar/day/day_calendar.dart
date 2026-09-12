import 'package:dartnative/dartnative.dart';

import '../../data/sample_events.dart';
import '../../utils/calendar_date_utils.dart' as calendar_date_utils;
import 'day_header.dart';
import 'day_time_grid.dart';

/// The Day Calendar tab body: one selected day's hourly timeline with
/// previous/next day navigation, events positioned by start time and
/// duration, and a current-time indicator when viewing today.
///
/// Returns content only — no `Scaffold`/`AppBar` of its own; the title and
/// description are rendered by `CalendarShowcaseScreen`'s shared tab
/// header.
class DayCalendar extends StatefulWidget {
  const DayCalendar({super.key});

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
      sampleEvents,
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
