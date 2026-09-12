import 'package:dartnative/dartnative.dart';

import '../../models/calendar_event.dart';
import '../../utils/calendar_date_utils.dart' as calendar_date_utils;
import '../../utils/calendar_layout_utils.dart' as calendar_layout_utils;
import 'event_block.dart';
import 'week_time_grid.dart' show weekStartHour, weekEndHour, weekHourHeight;

/// One day's column in the Week Calendar grid: hour separator lines, a
/// light tint when [date] is [today], and one [EventBlock] per event —
/// overlapping events are laid out side by side using
/// `utils/calendar_layout_utils.dart`'s clustering (the same function the
/// Day Calendar uses), not a general scheduling engine.
///
/// [width] is measured once by the parent `WeekTimeGrid` (a single outer
/// `LayoutBuilder`) and passed in explicitly, rather than each column
/// re-measuring itself.
class WeekDayColumn extends StatelessWidget {
  final DateTime date;
  final DateTime today;
  final List<CalendarEvent> events;
  final double width;
  final bool showTrailingDivider;

  const WeekDayColumn({
    super.key,
    required this.date,
    required this.today,
    required this.events,
    required this.width,
    required this.showTrailingDivider,
  });

  @override
  Widget build(BuildContext context) {
    final hourCount = weekEndHour - weekStartHour;
    final totalHeight = hourCount * weekHourHeight;
    final isToday = calendar_date_utils.isSameDay(date, today);
    final layouts = calendar_layout_utils.layoutEventsForDay(events);

    return Container(
      width: width,
      height: totalHeight,
      color: isToday ? const Color(0xFFEFF4FF) : null,
      child: Stack(
        children: [
          for (var hour = weekStartHour; hour <= weekEndHour; hour++)
            Positioned(
              top: (hour - weekStartHour) * weekHourHeight,
              left: 0,
              right: 0,
              child: Container(height: 1, color: const Color(0xFFE5E5EA)),
            ),
          if (showTrailingDivider)
            const Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: 1,
              child: ColoredBox(color: Color(0xFFE5E5EA)),
            ),
          for (final layout in layouts) _positionedEventBlock(layout),
        ],
      ),
    );
  }

  Widget _positionedEventBlock(calendar_layout_utils.EventLayoutInfo layout) {
    final columnWidth = width / layout.columnCount;
    final top = calendar_layout_utils.verticalOffsetForTime(
      layout.event.start,
      hourHeight: weekHourHeight,
      startHour: weekStartHour,
    );
    final height = calendar_layout_utils.heightForDuration(
      layout.event.duration,
      hourHeight: weekHourHeight,
    );
    return EventBlock(
      event: layout.event,
      top: top,
      left: columnWidth * layout.column,
      width: columnWidth,
      height: height < 24 ? 24 : height,
    );
  }
}
