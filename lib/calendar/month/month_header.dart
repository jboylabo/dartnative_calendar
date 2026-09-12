import 'package:dartnative/dartnative.dart';

import '../../shared/calendar_navigation.dart';

const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Title (month + year) and previous/next month controls for
/// [MonthCalendar].
class MonthHeader extends StatelessWidget {
  final DateTime displayedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const MonthHeader({
    super.key,
    required this.displayedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final label =
        '${_monthNames[displayedMonth.month - 1]} ${displayedMonth.year}';
    return CalendarNavigationHeader(
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111111),
        ),
      ),
      onPrevious: onPreviousMonth,
      onNext: onNextMonth,
    );
  }
}
