import 'package:dartnative/dartnative.dart';

import '../../shared/calendar_navigation.dart';

const List<String> _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// Selected date label and previous/next day controls for [DayCalendar].
class DayHeader extends StatelessWidget {
  final DateTime selectedDay;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;

  const DayHeader({
    super.key,
    required this.selectedDay,
    required this.onPreviousDay,
    required this.onNextDay,
  });

  @override
  Widget build(BuildContext context) {
    final weekday = _weekdayNames[selectedDay.weekday - 1];
    final month = selectedDay.month.toString().padLeft(2, '0');
    final day = selectedDay.day.toString().padLeft(2, '0');
    final label = '$weekday, ${selectedDay.year}-$month-$day';
    return CalendarNavigationHeader(
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111111),
        ),
      ),
      onPrevious: onPreviousDay,
      onNext: onNextDay,
    );
  }
}
