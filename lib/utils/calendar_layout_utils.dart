import '../models/calendar_event.dart';

/// Pure layout-calculation helpers shared by the Week and Day time-axis
/// views. Kept free of any widget/UI imports (see the project
/// constitution's separation-of-logic-and-presentation principle).
///
/// Deliberately simple: overlapping events are grouped into clusters and
/// divided evenly into side-by-side columns. This is not a general
/// scheduling/collision engine — it's the smallest algorithm that keeps
/// overlapping sample events visible and legible.

/// Where one event should be drawn within its day's overlap cluster.
class EventLayoutInfo {
  final CalendarEvent event;

  /// Zero-based column index within [columnCount].
  final int column;

  /// Total number of side-by-side columns in this event's overlap cluster.
  final int columnCount;

  const EventLayoutInfo({
    required this.event,
    required this.column,
    required this.columnCount,
  });
}

/// Vertical pixel offset for [time]'s time-of-day, [hourHeight] pixels per
/// hour, measured from [startHour] (the top of the visible time range).
double verticalOffsetForTime(
  DateTime time, {
  required double hourHeight,
  int startHour = 0,
}) {
  final minutesSincStart = (time.hour - startHour) * 60 + time.minute;
  return (minutesSincStart / 60.0) * hourHeight;
}

/// Pixel height for an event lasting [duration], at [hourHeight] pixels
/// per hour.
double heightForDuration(Duration duration, {required double hourHeight}) {
  return (duration.inMinutes / 60.0) * hourHeight;
}

/// Assigns each of [dayEvents] a side-by-side column so that events whose
/// times overlap are placed next to each other rather than hiding one
/// another. Events that don't overlap anything are assigned column 0 of a
/// 1-column cluster. Order of the result does not match [dayEvents]' order.
List<EventLayoutInfo> layoutEventsForDay(List<CalendarEvent> dayEvents) {
  if (dayEvents.isEmpty) return const [];

  final sorted = List<CalendarEvent>.of(dayEvents)
    ..sort((a, b) => a.start.compareTo(b.start));

  final result = <EventLayoutInfo>[];
  var cluster = <CalendarEvent>[sorted.first];
  var clusterEnd = sorted.first.end;

  void flushCluster(List<CalendarEvent> clusterEvents) {
    final columnEnds = <DateTime>[];
    final columnByEvent = <CalendarEvent, int>{};

    for (final event in clusterEvents) {
      var assignedColumn = -1;
      for (var column = 0; column < columnEnds.length; column++) {
        if (!event.start.isBefore(columnEnds[column])) {
          assignedColumn = column;
          break;
        }
      }
      if (assignedColumn == -1) {
        columnEnds.add(event.end);
        assignedColumn = columnEnds.length - 1;
      } else {
        columnEnds[assignedColumn] = event.end;
      }
      columnByEvent[event] = assignedColumn;
    }

    final columnCount = columnEnds.length;
    for (final event in clusterEvents) {
      result.add(
        EventLayoutInfo(
          event: event,
          column: columnByEvent[event]!,
          columnCount: columnCount,
        ),
      );
    }
  }

  for (var i = 1; i < sorted.length; i++) {
    final event = sorted[i];
    if (event.start.isBefore(clusterEnd)) {
      cluster.add(event);
      if (event.end.isAfter(clusterEnd)) {
        clusterEnd = event.end;
      }
    } else {
      flushCluster(cluster);
      cluster = [event];
      clusterEnd = event.end;
    }
  }
  flushCluster(cluster);

  return result;
}
