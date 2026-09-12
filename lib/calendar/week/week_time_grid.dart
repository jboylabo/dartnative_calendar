import 'package:dartnative/dartnative.dart';

import '../../models/calendar_event.dart';
import '../../shared/time_label.dart';
import '../../utils/calendar_date_utils.dart' as calendar_date_utils;
import 'week_day_column.dart';

/// Hours shown on the Week Calendar's vertical time axis and the pixel
/// layout constants shared with [WeekHeader] (so the date row above lines
/// up with the day columns below) — the same practical range and
/// `hourHeight` approach as the Day Calendar (plan.md "06:00–22:00").
const int weekStartHour = 6;
const int weekEndHour = 22;
const double weekHourHeight = 64;
const double weekLabelColumnWidth = 52;

/// The Week Calendar's scrollable time axis: hour labels on the left and
/// seven [WeekDayColumn]s side by side, each positioning its day's events
/// by start time/duration via `utils/calendar_layout_utils.dart` — the same
/// math the Day Calendar uses.
///
/// Column width is measured once here (a single outer [LayoutBuilder]) and
/// passed explicitly to each [WeekDayColumn], rather than each column
/// re-measuring itself, to keep the seven columns' layout perfectly
/// consistent.
class WeekTimeGrid extends StatelessWidget {
  final List<DateTime> weekDates;
  final DateTime today;
  final List<CalendarEvent> events;

  const WeekTimeGrid({
    super.key,
    required this.weekDates,
    required this.today,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final hourCount = weekEndHour - weekStartHour;
    final totalHeight = hourCount * weekHourHeight;

    return LayoutBuilder(
      builder: (context, outerConstraints) {
        final dayColumnWidth =
            (outerConstraints.maxWidth - weekLabelColumnWidth) /
            weekDates.length;

        return SingleChildScrollView(
          child: SizedBox(
            height: totalHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: weekLabelColumnWidth,
                  height: totalHeight,
                  child: Stack(
                    children: [
                      for (var hour = weekStartHour; hour < weekEndHour; hour++)
                        Positioned(
                          top: (hour - weekStartHour) * weekHourHeight - 7,
                          right: 8,
                          child: TimeLabel(hour: hour),
                        ),
                    ],
                  ),
                ),
                for (var i = 0; i < weekDates.length; i++)
                  WeekDayColumn(
                    key: ValueKey(weekDates[i]),
                    date: weekDates[i],
                    today: today,
                    events: calendar_date_utils.eventsOnDay(
                      events,
                      weekDates[i],
                    ),
                    width: dayColumnWidth,
                    showTrailingDivider: i != weekDates.length - 1,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
