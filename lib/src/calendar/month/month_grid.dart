import 'package:dartnative/dartnative.dart';

import '../../models/calendar_event.dart';
import '../../utils/calendar_date_utils.dart' as calendar_date_utils;
import 'day_cell.dart';

const List<String> _weekdayLabels = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

/// The 7-column weekday header row plus the month's grid of [DayCell]s.
///
/// Built entirely from `calendar_date_utils.dart`'s month-grid date list —
/// no calendar package involved, and no date math performed here.
class MonthGrid extends StatelessWidget {
  final DateTime displayedMonth;
  final DateTime selectedDate;
  final DateTime today;
  final List<CalendarEvent> events;
  final ValueChanged<DateTime> onSelectDate;

  const MonthGrid({
    super.key,
    required this.displayedMonth,
    required this.selectedDate,
    required this.today,
    required this.events,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    final dates = calendar_date_utils.monthGridDates(displayedMonth);

    return Column(
      children: [
        Row(
          children: [
            for (final label in _weekdayLabels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.0,
          children: [
            for (final date in dates)
              DayCell(
                date: date,
                isInDisplayedMonth: date.month == displayedMonth.month,
                isToday: calendar_date_utils.isSameDay(date, today),
                isSelected: calendar_date_utils.isSameDay(date, selectedDate),
                hasEvents: calendar_date_utils
                    .eventsOnDay(events, date)
                    .isNotEmpty,
                onTap: onSelectDate,
              ),
          ],
        ),
      ],
    );
  }
}
