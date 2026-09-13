import 'package:dartnative/dartnative.dart';

import '../../models/calendar_event.dart';
import '../../utils/calendar_date_utils.dart' as calendar_date_utils;
import 'month_grid.dart';
import 'month_header.dart';

/// The Month Calendar tab body: a traditional monthly grid with
/// previous/next month navigation, today highlighted, per-date event
/// indicators, and a list of the selected date's events below the grid.
///
/// Returns content only — no `Scaffold`/`AppBar` of its own, so it can be
/// embedded in any layout (a tab, a page, a showcase shell).
class MonthCalendar extends StatefulWidget {
  /// The events to display across the month grid and selected-date list.
  final List<CalendarEvent> events;

  const MonthCalendar({super.key, this.events = const []});

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late final DateTime _today;
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _displayedMonth = DateTime(_today.year, _today.month, 1);
    _selectedDate = _today;
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
        1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
        1,
      );
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDateEvents = calendar_date_utils.sortEventsChronologically(
      calendar_date_utils.eventsOnDay(widget.events, _selectedDate),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonthHeader(
            displayedMonth: _displayedMonth,
            onPreviousMonth: _goToPreviousMonth,
            onNextMonth: _goToNextMonth,
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.white,
            child: MonthGrid(
              displayedMonth: _displayedMonth,
              selectedDate: _selectedDate,
              today: _today,
              events: widget.events,
              onSelectDate: _selectDate,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _selectedDateLabel(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 10),
          if (selectedDateEvents.isEmpty)
            const Text(
              'No events for this date.',
              style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final event in selectedDateEvents) ...[
                  _SelectedDateEventTile(event: event),
                  const SizedBox(height: 8),
                ],
              ],
            ),
        ],
      ),
    );
  }

  String _selectedDateLabel() {
    final month = _selectedDate.month.toString().padLeft(2, '0');
    final day = _selectedDate.day.toString().padLeft(2, '0');
    return 'Events on ${_selectedDate.year}-$month-$day';
  }
}

/// One row in the selected date's event list: a colored accent bar, the
/// event's title, and its start–end time.
class _SelectedDateEventTile extends StatelessWidget {
  final CalendarEvent event;

  const _SelectedDateEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF3D7BFF),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatTime(event.start)} – ${_formatTime(event.end)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B6B70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime time) {
    final hour24 = time.hour;
    final period = hour24 < 12 ? 'AM' : 'PM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour12:$minute $period';
  }
}
