import 'package:dartnative/dartnative.dart';

/// A single date cell in the Month Calendar grid.
///
/// Purely presentational: today/selected/muted styling and the event
/// indicator are all driven by flags passed in by [MonthGrid] — no date
/// math happens here (see `utils/calendar_date_utils.dart`).
class DayCell extends StatelessWidget {
  final DateTime date;
  final bool isInDisplayedMonth;
  final bool isToday;
  final bool isSelected;
  final bool hasEvents;
  final ValueChanged<DateTime> onTap;

  const DayCell({
    super.key,
    required this.date,
    required this.isInDisplayedMonth,
    required this.isToday,
    required this.isSelected,
    required this.hasEvents,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color numberColor = !isInDisplayedMonth
        ? const Color(0xFFC7C7CC)
        : isToday
        ? Colors.white
        : const Color(0xFF111111);

    return GestureDetector(
      onTap: () => onTap(date),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isToday
                    ? const Color(0xFF3D7BFF)
                    : isSelected
                    ? const Color(0xFFE4ECFF)
                    : null,
                border: (isSelected && !isToday)
                    ? Border.all(color: const Color(0xFF3D7BFF), width: 1.5)
                    : null,
              ),
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                  color: numberColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 5,
              height: 5,
              decoration: hasEvents
                  ? const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF9500),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
