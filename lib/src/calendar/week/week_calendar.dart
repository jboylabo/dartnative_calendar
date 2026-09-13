import 'package:dartnative/dartnative.dart';

import '../../data/sample_events.dart';
import '../../utils/calendar_date_utils.dart' as calendar_date_utils;
import 'week_header.dart';
import 'week_time_grid.dart';

/// The Week Calendar tab body: the selected week's seven dates, a vertical
/// time axis, sample events positioned by start time/duration with basic
/// side-by-side overlap handling, and previous/next week navigation.
///
/// Returns content only — no `Scaffold`/`AppBar` of its own; the title and
/// description are rendered by `CalendarShowcaseScreen`'s shared tab
/// header.
class WeekCalendar extends StatefulWidget {
  const WeekCalendar({super.key});

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  late final DateTime _today;
  late DateTime _displayedWeekStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _displayedWeekStart = calendar_date_utils.startOfWeek(_today);
  }

  void _goToPreviousWeek() {
    setState(() {
      _displayedWeekStart = _displayedWeekStart.subtract(
        const Duration(days: 7),
      );
    });
  }

  void _goToNextWeek() {
    setState(() {
      _displayedWeekStart = _displayedWeekStart.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekDates = calendar_date_utils.weekDates(_displayedWeekStart);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WeekHeader(
          weekDates: weekDates,
          today: _today,
          onPreviousWeek: _goToPreviousWeek,
          onNextWeek: _goToNextWeek,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: WeekTimeGrid(
            weekDates: weekDates,
            today: _today,
            events: sampleEvents,
          ),
        ),
      ],
    );
  }
}
