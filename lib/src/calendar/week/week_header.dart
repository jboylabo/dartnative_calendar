import 'package:dartnative/dartnative.dart';

import '../../shared/calendar_navigation.dart';
import '../../utils/calendar_date_utils.dart' as calendar_date_utils;
import 'week_time_grid.dart' show weekLabelColumnWidth;

const List<String> _weekdayShortLabels = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

/// The selected week's seven dates across the top (FR-011) and
/// previous/next week controls (FR-014) for [WeekCalendar]. The date row
/// is indented by [weekLabelColumnWidth] so each date lines up with its
/// day column in `WeekTimeGrid` below.
class WeekHeader extends StatelessWidget {
  final List<DateTime> weekDates;
  final DateTime today;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const WeekHeader({
    super.key,
    required this.weekDates,
    required this.today,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  @override
  Widget build(BuildContext context) {
    final rangeLabel =
        '${_isoDate(weekDates.first)} – ${_isoDate(weekDates.last)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarNavigationHeader(
          title: Text(
            rangeLabel,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
            ),
          ),
          onPrevious: onPreviousWeek,
          onNext: onNextWeek,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: weekLabelColumnWidth),
            for (final date in weekDates)
              Expanded(
                child: _WeekDateCell(
                  date: date,
                  isToday: calendar_date_utils.isSameDay(date, today),
                ),
              ),
          ],
        ),
      ],
    );
  }

  static String _isoDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

class _WeekDateCell extends StatelessWidget {
  final DateTime date;
  final bool isToday;

  const _WeekDateCell({required this.date, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _weekdayShortLabels[date.weekday - 1],
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8E8E93),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isToday ? const Color(0xFF3D7BFF) : null,
          ),
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
              color: isToday ? Colors.white : const Color(0xFF111111),
            ),
          ),
        ),
      ],
    );
  }
}
