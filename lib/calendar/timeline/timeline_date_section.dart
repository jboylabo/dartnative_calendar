import 'package:dartnative/dartnative.dart';

import '../../models/calendar_event.dart';
import '../../utils/calendar_date_utils.dart' as calendar_date_utils;
import 'timeline_event_item.dart';

const List<String> _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// One date's header followed by its events (already sorted and filtered
/// to [date] by `TimelineCalendar`), each rendered as a [TimelineEventItem]
/// (FR-020).
class TimelineDateSection extends StatelessWidget {
  final DateTime date;
  final DateTime today;
  final DateTime now;
  final List<CalendarEvent> events;

  const TimelineDateSection({
    super.key,
    required this.date,
    required this.today,
    required this.now,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = calendar_date_utils.isSameDay(date, today);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            _dateLabel(isToday),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isToday
                  ? const Color(0xFF3D7BFF)
                  : const Color(0xFF8E8E93),
            ),
          ),
        ),
        for (final event in events)
          TimelineEventItem(
            event: event,
            status: calendar_date_utils.eventTimeStatus(event, now),
          ),
      ],
    );
  }

  String _dateLabel(bool isToday) {
    final weekday = _weekdayNames[date.weekday - 1];
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final prefix = isToday ? 'Today · ' : '';
    return '$prefix$weekday, ${date.year}-$month-$day';
  }
}
