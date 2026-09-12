# Implementation Plan: Calendar Showcase

**Branch**: `001-calendar-showcase` | **Date**: 2026-09-12 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-calendar-showcase/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Build a DartNative UI showcase app: a single screen titled "Calendar Showcase" whose native
bottom tab bar switches between four independent, hand-built calendar examples — Month, Week,
Day, and Agenda/Timeline — each reading from one shared, hard-coded `List<CalendarEvent>`. Date
math and event-layout math are implemented once as pure utility functions
(`calendar_date_utils.dart`, `calendar_layout_utils.dart`) shared by all four views; each view is
otherwise its own self-contained widget tree. Switching uses DartNative's native
`BottomNavigationBar` + `IndexedStack` (not `Navigator.push`/back — that was the original design
but was replaced with tab switching during implementation; see spec.md Assumptions); per-tab
state (`selectedDate`, displayed month/week/day) lives in ordinary `StatefulWidget`/`State` and
persists across tab switches because `IndexedStack` keeps every tab mounted. No new dependencies,
no persistence, no tests, no third-party calendar package — confirmed feasible entirely on
DartNative's existing Tier 1 (native-widget-backed) API surface (see research.md).

## Technical Context

**Language/Version**: Dart (SDK constraint `^3.12.0-192.0.dev`, per this project's `pubspec.yaml`)

**Primary Dependencies**: `dartnative`, `dartnative_ios`, `dartnative_android`, `dartnative_skia`
— all already present in `pubspec.yaml`; this feature adds none. `dartnative_skia` is a pubspec
requirement of the DartNative runner and is not used directly by this feature (no `CustomPaint`
needed — see research.md).

**Storage**: N/A — in-memory, hard-coded sample data only (`lib/data/sample_events.dart`); no
database, no local persistence (constitution Principle VII/IX).

**Testing**: N/A — no unit/widget/integration tests, mocks, or fixtures (constitution Principle
VIII; spec Out of Scope).

**Target Platform**: iOS and Android, matching this project's existing runner glue
(`ios/Runner`, `android/app`) and platform dependencies.

**Project Type**: Single DartNative mobile app (existing project; this feature only adds
`lib/` source files).

**Performance Goals**: No numeric target beyond "feels like a normal native app" — smooth
scrolling in Week/Day/Agenda views and instant month/week/day navigation using native widgets;
not benchmarked (prototype/showcase scope, constitution Principle I).

**Constraints**: No third-party calendar UI package (constitution II, spec Out of Scope); no new
pubspec dependencies (constitution X); DartNative Tier 1 widgets only, no Skia/`CustomPaint`
unless a Tier 1 widget genuinely cannot do the job (none identified — see research.md); no
authentication/backend/persistence/notifications (constitution VII; spec Out of Scope).

**Scale/Scope**: 1 app shell screen (title + bottom tab bar) hosting 4 calendar-style tab bodies,
~20 small source files per the architecture below, one shared sample-event list (roughly 15–20
hard-coded events).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Result |
|---|---|---|
| I. Simplicity & Showcase Focus | Plan explicitly avoids elaborate animation, custom drawing, and a general collision-scheduling engine; favors the simplest layout that demonstrates each pattern. | PASS |
| II. DartNative-First | All planned widgets (Column/Row/Stack/Positioned/GridView/ListView/GestureDetector/BottomNavigationBar/IndexedStack/etc.) confirmed present in DartNative's native API (research.md); no Flutter-only APIs, no third-party calendar package. | PASS |
| III. Separation of Logic and Presentation | Date math isolated in `utils/calendar_date_utils.dart`; layout math isolated in `utils/calendar_layout_utils.dart`; `CalendarEvent` model is UI-independent. | PASS |
| IV. Independent Reusable Calendar Widgets | Month/Week/Day/Timeline each have their own directory and top-level widget (`month_calendar.dart`, `week_calendar.dart`, `day_calendar.dart`, `timeline_calendar.dart`), not variants of a shared calendar widget. | PASS |
| V. Small Files, Clear Directory Structure | Architecture below splits every view into header/grid/cell-level files across `models/`, `data/`, `screens/`, `calendar/<style>/`, `shared/`, `utils/`. | PASS |
| VI. Shared Models & Utilities Over Duplication | `CalendarEvent` model, `calendar_date_utils.dart`, `calendar_layout_utils.dart`, and `shared/` widgets (`calendar_navigation.dart`, `time_label.dart`) are reused by Week and Day (and, where applicable, Month/Timeline) instead of duplicated per view. | PASS |
| VII. No Production-Grade Concerns | No auth, backend, sync, external calendar integration, or notifications planned. | PASS |
| VIII. No Test Artifacts | No test files, dev test dependencies, or test directories planned. | PASS |
| IX. Hard-Coded Sample Data | `lib/data/sample_events.dart` is the single hard-coded source used by all four views. | PASS |
| X. Dependency Minimalism | No new `pubspec.yaml` dependencies; DartNative's existing native widget set covers every planned UI element (research.md). | PASS |

No violations — Complexity Tracking is not needed.

## Project Structure

### Documentation (this feature)

```text
specs/001-calendar-showcase/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Skipped — no external interface (see research.md)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
lib/
├── main.dart                              # Existing entry point; updated to runApp the showcase app shell
├── dartnative_plugin_registrant.dart       # Existing — untouched
│
├── models/
│   ├── calendar_event.dart                # CalendarEvent (id, title, start, end, description)
│   └── calendar_view_type.dart            # CalendarViewType enum (month/week/day/timeline)
│
├── data/
│   └── sample_events.dart                 # Hard-coded List<CalendarEvent>
│
├── screens/
│   └── calendar_showcase_screen.dart      # App shell: title, BottomNavigationBar, IndexedStack of the 4 tab bodies
│
├── calendar/
│   ├── month/
│   │   ├── month_calendar.dart            # Month tab body: state (displayed month, selected date) + composition — no own Scaffold/AppBar
│   │   ├── month_header.dart              # Month title + prev/next controls
│   │   ├── month_grid.dart                # 7-column grid of DayCell, built from calendar_date_utils
│   │   └── day_cell.dart                  # Single date cell: number, today/muted styling, event indicator, tap
│   │
│   ├── week/
│   │   ├── week_calendar.dart             # Week tab body: state (displayed week) + composition — no own Scaffold/AppBar
│   │   ├── week_header.dart               # Week's 7 dates + prev/next controls
│   │   ├── week_time_grid.dart            # Hour rows + 7 WeekDayColumns side by side
│   │   ├── week_day_column.dart           # One day's Stack of EventBlocks over the hour rows
│   │   └── event_block.dart               # Positioned event block (shared sizing from calendar_layout_utils)
│   │
│   ├── day/
│   │   ├── day_calendar.dart              # Day tab body: state (selected day) + composition — no own Scaffold/AppBar
│   │   ├── day_header.dart                # Selected date label + prev/next controls
│   │   ├── day_time_grid.dart             # Hour rows + current-time indicator (when today)
│   │   └── day_event_block.dart           # Positioned event block for the single-day timeline
│   │
│   └── timeline/
│       ├── timeline_calendar.dart         # Timeline tab body: composition — no own Scaffold/AppBar, no navigation state
│       ├── timeline_date_section.dart     # One date's header + its events
│       └── timeline_event_item.dart       # One event row: time, title, description, past/current/upcoming style
│
├── shared/
│   ├── calendar_navigation.dart           # Reusable prev/next header row used by Month/Week/Day headers
│   └── time_label.dart                    # Reusable hour-label formatting/widget for Week/Day time axes
│
└── utils/
    ├── calendar_date_utils.dart           # Days-in-month, month-grid dates, week start/end, same-day, filter/sort
    └── calendar_layout_utils.dart         # start-time → vertical offset, duration → height, overlap clustering
```

**Structure Decision**: Single existing DartNative app (`lib/`) — this feature only adds files
under `models/`, `data/`, `screens/`, `calendar/`, `shared/`, and `utils/`, and updates
`lib/main.dart`'s `runApp` call to launch `CalendarShowcaseScreen` instead of the scaffolded
placeholder `HomeScreen`. `CalendarShowcaseScreen` is now the single app shell (one `Scaffold`,
one `AppBar`, one `BottomNavigationBar`) hosting all four tab bodies in an `IndexedStack`; each
`calendar/<style>/<style>_calendar.dart` widget returns tab *content* only (no `Scaffold`/`AppBar`
of its own), a deviation from the original push-navigation design made during implementation once
`Navigator.push`-based navigation between screens proved awkward in practice for this showcase
(see spec.md Assumptions). No new top-level project, package, or platform runner is introduced —
directory structure still matches constitution Principle V (small files, clear directories) and
Principle IV (one directory per calendar style).

## Complexity Tracking

*No constitution violations — this section is intentionally empty.*
