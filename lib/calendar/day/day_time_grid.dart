import 'package:dartnative/dartnative.dart';

import '../../models/calendar_event.dart';
import '../../shared/time_label.dart';
import '../../utils/calendar_date_utils.dart' as calendar_date_utils;
import '../../utils/calendar_layout_utils.dart' as calendar_layout_utils;
import 'day_event_block.dart';

/// Hours shown on the Day Calendar's vertical timeline: a practical range
/// rather than the full 24 hours, per plan.md ("06:00–22:00").
const int _startHour = 6;
const int _endHour = 22;
const double _hourHeight = 64;
const double _labelColumnWidth = 52;

/// The Day Calendar's scrollable hourly timeline: hour separators and
/// labels, [date]'s events positioned by start time and duration (reusing
/// `utils/calendar_layout_utils.dart`, the same math the Week view will
/// use), and a current-time indicator when [date] is [today].
class DayTimeGrid extends StatelessWidget {
  final DateTime date;
  final DateTime today;
  final List<CalendarEvent> events;

  const DayTimeGrid({
    super.key,
    required this.date,
    required this.today,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final hourCount = _endHour - _startHour;
    final totalHeight = hourCount * _hourHeight;
    final layouts = calendar_layout_utils.layoutEventsForDay(events);
    final isToday = calendar_date_utils.isSameDay(date, today);
    final now = DateTime.now();
    final showsCurrentTime =
        isToday && now.hour >= _startHour && now.hour < _endHour;

    return SingleChildScrollView(
      child: SizedBox(
        height: totalHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _labelColumnWidth,
              height: totalHeight,
              child: Stack(
                children: [
                  for (var hour = _startHour; hour < _endHour; hour++)
                    Positioned(
                      top: (hour - _startHour) * _hourHeight - 7,
                      right: 8,
                      child: TimeLabel(hour: hour),
                    ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  return Stack(
                    children: [
                      for (var hour = _startHour; hour <= _endHour; hour++)
                        Positioned(
                          top: (hour - _startHour) * _hourHeight,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 1,
                            color: const Color(0xFFE5E5EA),
                          ),
                        ),
                      for (final layout in layouts)
                        _positionedEventBlock(layout, totalWidth),
                      if (showsCurrentTime) _currentTimeIndicator(now),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _positionedEventBlock(
    calendar_layout_utils.EventLayoutInfo layout,
    double totalWidth,
  ) {
    final columnWidth = totalWidth / layout.columnCount;
    final top = calendar_layout_utils.verticalOffsetForTime(
      layout.event.start,
      hourHeight: _hourHeight,
      startHour: _startHour,
    );
    final height = calendar_layout_utils.heightForDuration(
      layout.event.duration,
      hourHeight: _hourHeight,
    );
    return DayEventBlock(
      event: layout.event,
      top: top,
      left: columnWidth * layout.column,
      width: columnWidth,
      height: height < 28 ? 28 : height,
    );
  }

  Widget _currentTimeIndicator(DateTime now) {
    final top = calendar_layout_utils.verticalOffsetForTime(
      now,
      hourHeight: _hourHeight,
      startHour: _startHour,
    );
    return Positioned(
      top: top - 4,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFF3B30),
            ),
          ),
          const Expanded(
            child: SizedBox(
              height: 2,
              child: ColoredBox(color: Color(0xFFFF3B30)),
            ),
          ),
        ],
      ),
    );
  }
}
