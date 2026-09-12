import '../models/calendar_event.dart';

/// Pure date-calculation helpers shared by every calendar view.
///
/// Kept free of any widget/UI imports (see the project constitution's
/// separation-of-logic-and-presentation principle). Built entirely on
/// `dart:core`'s [DateTime]/[Duration] — no calendar package involved.
///
/// The week is treated as starting on Monday (ISO-8601) throughout.

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// Number of days in the month that [month] falls in (`month.year`/`month.month`
/// are read; the day-of-month is ignored).
int daysInMonth(DateTime month) {
  final firstOfNextMonth = DateTime(month.year, month.month + 1, 1);
  final lastOfMonth = firstOfNextMonth.subtract(const Duration(days: 1));
  return lastOfMonth.day;
}

/// The first date shown in a month grid for [month]: the Monday on or
/// before the 1st of that month, so every grid row is a complete week.
DateTime firstVisibleDateOfMonthGrid(DateTime month) {
  final firstOfMonth = DateTime(month.year, month.month, 1);
  final leadingDays = firstOfMonth.weekday - DateTime.monday;
  return firstOfMonth.subtract(Duration(days: leadingDays));
}

/// All dates to render in a month grid for [month], including leading days
/// from the previous month and trailing days from the next month so the
/// grid always has complete weeks (35 or 42 entries, i.e. 5 or 6 rows).
List<DateTime> monthGridDates(DateTime month) {
  final start = firstVisibleDateOfMonthGrid(month);
  final lastOfMonth = DateTime(month.year, month.month, daysInMonth(month));
  final trailingDays = DateTime.sunday - lastOfMonth.weekday;
  final end = lastOfMonth.add(Duration(days: trailingDays));
  final totalDays = end.difference(start).inDays + 1;
  return List<DateTime>.generate(
    totalDays,
    (i) => start.add(Duration(days: i)),
  );
}

/// The Monday of the week containing [date].
DateTime startOfWeek(DateTime date) {
  final day = _dateOnly(date);
  return day.subtract(Duration(days: day.weekday - DateTime.monday));
}

/// The Sunday of the week containing [date].
DateTime endOfWeek(DateTime date) =>
    startOfWeek(date).add(const Duration(days: 6));

/// The seven dates (Monday through Sunday) of the week containing [date].
List<DateTime> weekDates(DateTime date) {
  final start = startOfWeek(date);
  return List<DateTime>.generate(7, (i) => start.add(Duration(days: i)));
}

/// Whether [a] and [b] fall on the same calendar day, ignoring time-of-day.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// The events from [events] that start on [day].
List<CalendarEvent> eventsOnDay(List<CalendarEvent> events, DateTime day) {
  return events.where((event) => isSameDay(event.start, day)).toList();
}

/// A new list containing [events] sorted by start time, earliest first.
List<CalendarEvent> sortEventsChronologically(List<CalendarEvent> events) {
  final sorted = List<CalendarEvent>.of(events);
  sorted.sort((a, b) => a.start.compareTo(b.start));
  return sorted;
}
