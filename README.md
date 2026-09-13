# calendar_kit

Reusable **month**, **week**, **day**, and **agenda (timeline)** calendar
views for [DartNative](https://dartnative.com) apps — today highlighted,
per-date event indicators, time-grid layout with overlap handling, and a
live current-time indicator on the day view.

Each view is a plain content widget (no `Scaffold`/`AppBar` of its own), so
it drops into a tab, a page, or any layout you already have.

## Install

Add a dependency on `calendar_kit` in your app's `pubspec.yaml`. Once
published to [dartpub.dev](https://dartpub.dev), a plain version dependency
resolves it the same way the DartNative framework itself does:

```yaml
dependencies:
  calendar_kit: ^0.1.0
```

Then fetch it with:

```sh
dn pub get
```

## Usage

```dart
import 'package:calendar_kit/calendar_kit.dart';

final events = [
  CalendarEvent(
    id: 'evt-001',
    title: 'Meeting',
    start: DateTime(2026, 1, 10, 9),
    end: DateTime(2026, 1, 10, 10),
  ),
];

// Pick the view that fits your screen:
MonthCalendar(events: events);
WeekCalendar(events: events);
DayCalendar(events: events);
TimelineCalendar(events: events);
```

## Public API

- `MonthCalendar({List<CalendarEvent> events})` — monthly grid with
  previous/next navigation and a selected-date event list.
- `WeekCalendar({List<CalendarEvent> events})` — seven-day time-axis view.
- `DayCalendar({List<CalendarEvent> events})` — single-day hourly timeline.
- `TimelineCalendar({List<CalendarEvent> events})` — chronological agenda
  list grouped by date.
- `CalendarEvent` — `id`, `title`, `start`, `end`, optional `description`.
- `CalendarViewType` — `month` / `week` / `day` / `timeline` enum, useful if
  you build your own switcher between views.

## Example

See [`example/`](example) for a full showcase app that tabs between all four
views. Run it with:

```sh
cd example
dn pub get
dn run
```

## License

MIT — see [LICENSE](LICENSE).
