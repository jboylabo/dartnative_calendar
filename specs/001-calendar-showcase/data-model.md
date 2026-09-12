# Data Model: Calendar Showcase

All data is in-memory and hard-coded (Constitution IX, spec Out of Scope: no database, no
persistence). No entity is ever created, edited, or deleted at runtime by the user — the only
runtime state is *which* existing data is currently selected/displayed.

## CalendarEvent

Defined in `lib/models/calendar_event.dart`. UI-independent (Constitution III) — no widget or
layout concepts.

| Field         | Type          | Required | Notes |
|---------------|---------------|----------|-------|
| `id`          | `String`      | yes      | Unique per event; used as a stable key (e.g. for widget keys). |
| `title`       | `String`      | yes      | Short label shown in every view (e.g. "Meeting"). |
| `start`       | `DateTime`    | yes      | Local date/time the event begins. No time zone handling (spec Out of Scope). |
| `end`         | `DateTime`    | yes      | Local date/time the event ends. Must be after `start`. |
| `description` | `String?`     | no       | Optional longer text shown in Agenda view and date-selection detail (Month view). |

Derived/computed (methods on the model or in `calendar_date_utils.dart`, not stored fields):

- `Duration duration` → `end.difference(start)`.
- "occurs on day D" → `calendar_date_utils.dart`'s same-day check against `start` (events in this
  dataset do not span midnight; see Assumptions in spec.md).

**Validation rules** (enforced by construction / by the fact all data is hard-coded and
author-controlled, not user input):
- `end` must be strictly after `start`.
- `title` and `id` must be non-empty.

**Relationships**: None — flat list, no references between events, no recurrence, no ownership.

## CalendarViewType

Defined in `lib/models/calendar_view_type.dart`. An enum identifying the four showcased calendar
styles, used to drive the home screen catalog and (indirectly) which screen `Navigator.push`
opens.

```dart
enum CalendarViewType { month, week, day, timeline }
```

No additional fields on the enum itself — display name/description/icon for the home screen
catalog are presentation concerns and live alongside the home screen's UI code
(`screens/calendar_showcase_screen.dart`), each paired with a `CalendarViewType` value, per
Constitution III (keep the enum itself free of presentation strings).

## CalendarStyleEntry (tab configuration)

A small, local, UI-adjacent struct (not a persisted entity) used only to configure
`CalendarShowcaseScreen`'s bottom tab bar and each tab's content header. One instance per
`CalendarViewType`.

| Field         | Type              | Notes |
|---------------|-------------------|-------|
| `type`        | `CalendarViewType`| Which calendar example this tab selects. |
| `title`       | `String`          | View name used as the tab label (e.g. "Month Calendar"). |
| `description` | `String`          | One-sentence summary shown at the top of that tab's content. |

## Sample data set

Defined in `lib/data/sample_events.dart` as a single `List<CalendarEvent>` (or a `const`/final
top-level getter returning one, since some `start`/`end` values are computed relative to
"today" — see spec Assumptions). Covers:

- The six example types from the spec: Meeting, Focus Work, Lunch, Coffee, App Development, Gym.
- A window of roughly two weeks centered on "today" (today ± ~1 week), plus a few extra events
  further out, so Month/Week/Day navigation and the Agenda view's past/current/upcoming
  distinction all have real data to show (spec Assumptions, SC-005).
- At least one same-day overlapping pair (to exercise the Week/Day side-by-side layout and the
  corresponding edge case).
- At least one day with zero events (to exercise the "no indicator" / empty-state edge case).

No entity relationships or state machine apply — this is a static list read by every view.
