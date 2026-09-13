import 'package:dartnative/dartnative.dart';
import 'package:calendar_kit/calendar_kit.dart';

import '../data/sample_events.dart';

/// Configuration for one calendar style's tab: its bottom-bar label/icon
/// and the one-sentence description shown at the top of its content.
class _CatalogEntry {
  final CalendarViewType type;
  final String tabLabel;
  final String title;
  final String description;
  final IconData icon;

  const _CatalogEntry({
    required this.type,
    required this.tabLabel,
    required this.title,
    required this.description,
    required this.icon,
  });
}

const List<_CatalogEntry> _catalog = [
  _CatalogEntry(
    type: CalendarViewType.month,
    tabLabel: 'Month',
    title: 'Month Calendar',
    description:
        'Traditional month grid with today highlighted and per-date event indicators.',
    icon: CupertinoIcons.calendar,
  ),
  _CatalogEntry(
    type: CalendarViewType.week,
    tabLabel: 'Week',
    title: 'Week Calendar',
    description:
        'Seven-day time-axis view with events positioned by start time and duration.',
    icon: CupertinoIcons.calendar_today,
  ),
  _CatalogEntry(
    type: CalendarViewType.day,
    tabLabel: 'Day',
    title: 'Day Calendar',
    description: 'Single-day hourly timeline with a live current-time indicator.',
    icon: CupertinoIcons.clock,
  ),
  _CatalogEntry(
    type: CalendarViewType.timeline,
    tabLabel: 'Agenda',
    title: 'Agenda / Timeline Calendar',
    description:
        'Chronological list of events grouped by date, prioritizing readability.',
    icon: CupertinoIcons.list_bullet,
  ),
];

/// The showcase's single app shell: a static "Calendar Showcase" title, a
/// native bottom tab bar with one tab per calendar style, and an
/// [IndexedStack] body that switches content in place — no `Navigator.push`
/// or back button involved (see specs/001-calendar-showcase/spec.md
/// Assumptions for why this replaced the original push-navigation design).
class CalendarShowcaseScreen extends StatefulWidget {
  const CalendarShowcaseScreen({super.key});

  @override
  State<CalendarShowcaseScreen> createState() =>
      _CalendarShowcaseScreenState();
}

class _CalendarShowcaseScreenState extends State<CalendarShowcaseScreen> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      brightness: Brightness.light,
      appBar: AppBar(
        title: const Text(
          'Calendar Showcase',
          style: TextStyle(
            color: Color(0xFF111111),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F7),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _TabScaffold(
            entry: _catalog[0],
            child: MonthCalendar(events: sampleEvents),
          ),
          _TabScaffold(
            entry: _catalog[1],
            child: WeekCalendar(events: sampleEvents),
          ),
          _TabScaffold(
            entry: _catalog[2],
            child: DayCalendar(events: sampleEvents),
          ),
          _TabScaffold(
            entry: _catalog[3],
            child: TimelineCalendar(events: sampleEvents),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        items: [
          for (final entry in _catalog)
            BottomNavigationBarItem(
              label: entry.tabLabel,
              icon: Icon(entry.icon),
            ),
        ],
      ),
    );
  }
}

/// Wraps one tab's body content with its title + one-sentence description
/// header (FR-004), shared by all four calendar styles so the description
/// isn't reimplemented per view.
class _TabScaffold extends StatelessWidget {
  final _CatalogEntry entry;
  final Widget child;

  const _TabScaffold({required this.entry, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                entry.description,
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B6B70)),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
