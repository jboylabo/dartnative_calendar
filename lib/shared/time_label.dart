import 'package:dartnative/dartnative.dart';

/// Formats an hour-of-day (0–23) into a short display label, e.g. "6 AM",
/// "12 PM". Reused by the Week and Day time axes.
String formatHourLabel(int hour) {
  final period = hour < 12 ? 'AM' : 'PM';
  final hour12 = hour % 12 == 0 ? 12 : hour % 12;
  return '$hour12 $period';
}

/// A small text label for an hour-of-day, reused by the Week and Day time
/// axes so the label styling isn't reimplemented per view.
class TimeLabel extends StatelessWidget {
  final int hour;

  const TimeLabel({super.key, required this.hour});

  @override
  Widget build(BuildContext context) {
    return Text(
      formatHourLabel(hour),
      style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
    );
  }
}
