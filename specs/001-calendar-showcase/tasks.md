---

description: "Task list for Calendar Showcase implementation"
---

# Tasks: Calendar Showcase

**Input**: Design documents from `/specs/001-calendar-showcase/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Not included — the project constitution (Principle VIII) and the spec's Out of Scope
section both prohibit unit/widget/integration test code for this prototype.

**Organization**: Tasks are grouped by user story (from spec.md) to enable independent
implementation and testing of each calendar example.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on an incomplete task)
- **[Story]**: Which user story this task belongs to (US1–US5, matching spec.md priorities)
- File paths below are relative to the repository root and match `plan.md`'s Project Structure

---

## Phase 1: Setup

**Purpose**: Create the directory skeleton this feature's files will live in. No new
dependencies are added (research.md: no new `pubspec.yaml` entries needed).

- [x] T001 Create the empty directory skeleton `lib/models/`, `lib/data/`, `lib/screens/`,
      `lib/calendar/month/`, `lib/calendar/week/`, `lib/calendar/day/`,
      `lib/calendar/timeline/`, `lib/shared/`, `lib/utils/`, per the Project Structure in
      `specs/001-calendar-showcase/plan.md`

**Checkpoint**: Directory structure exists; no other tasks depend on more than this.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The shared model, sample data, and utility/shared-widget layer every calendar view
(Month/Week/Day/Timeline) reads from. Per constitution Principles III and VI, this logic MUST be
written once here rather than duplicated inside each view.

**⚠️ CRITICAL**: No user story phase (Phase 3+) may begin until this phase is complete.

- [x] T002 [P] Create the `CalendarEvent` model in `lib/models/calendar_event.dart`: fields
      `id` (`String`), `title` (`String`), `start` (`DateTime`), `end` (`DateTime`),
      `description` (`String?`, optional per data-model.md); add a `Duration get duration` getter
      computed as `end.difference(start)`. Keep the class free of any widget/UI imports
      (constitution Principle III).
- [x] T003 [P] Create the `CalendarViewType` enum in `lib/models/calendar_view_type.dart` with
      exactly the four values `month`, `week`, `day`, `timeline` (data-model.md) — no
      display-string fields on the enum itself.
- [x] T004 [P] Create the hard-coded sample data in `lib/data/sample_events.dart`: a
      `List<CalendarEvent>` covering the six example types from spec.md (Meeting, Focus Work,
      Lunch, Coffee, App Development, Gym), spanning roughly two weeks centered on "today" plus a
      few events further out (spec.md Assumptions), including at least one same-day overlapping
      pair and at least one day with zero events (data-model.md "Sample data set"). Depends on
      T002 for the `CalendarEvent` type.
- [x] T005 [P] Implement `lib/utils/calendar_date_utils.dart` with pure functions: number of days
      in a given month; the first visible date of a month grid (including leading days from the
      previous month); the full list of dates for a month grid (35 or 42 entries, supporting both
      5- and 6-row months per spec.md FR-006 and research.md); start-of-week and end-of-week for
      a given date (week starts Monday, per spec.md Assumptions); the seven dates of a week;
      `bool isSameDay(DateTime a, DateTime b)`; `List<CalendarEvent> eventsOnDay(List<CalendarEvent> events, DateTime day)`;
      and a chronological sort of events by `start`. Depends on T002 for the `CalendarEvent`
      type.
- [x] T006 [P] Implement `lib/utils/calendar_layout_utils.dart` with pure functions: convert an
      event's `start` time-of-day into a vertical pixel offset given an `hourHeight` constant and
      a visible-range start hour; convert an event's `duration` into a block height using the
      same `hourHeight`; and an overlap-clustering function that, given one day's events, groups
      mutually-overlapping events into clusters and assigns each event a `(column, columnCount)`
      pair so overlapping events can be laid out side by side (research.md "Week/Day event
      overlap layout" — cluster-based even-width division, not a general scheduling engine).
      Depends on T002 for the `CalendarEvent` type.
- [x] T007 [P] Implement a reusable `CalendarNavigationHeader` widget in
      `lib/shared/calendar_navigation.dart`: a row with a previous-button, a title
      `Widget`/`String` slot, and a next-button, taking `onPrevious`/`onNext` callbacks — reused
      by the Month, Week, and Day headers (constitution Principle VI) using DartNative's
      `Row`/`IconButton`/`GestureDetector` (research.md).
- [x] T008 [P] Implement reusable hour-label helpers in `lib/shared/time_label.dart`: a function
      formatting an hour-of-day `int` (0–23) into a display string (e.g. "6 AM"), and a small
      `TimeLabel` widget wrapping it in a `Text`, for reuse by the Week and Day time axes.

**Checkpoint**: Model, sample data, date/layout math, and shared header/label widgets all exist
and compile — every user story phase below can now proceed.

---

## Phase 3: User Story 1 - Switch Between Calendar Examples (Priority: P1) 🎯 MVP

> **Revised during implementation**: this phase originally built a home-screen catalog that
> pushed to a separate screen per example (T009–T014 below as first written). That was replaced
> with a single-screen bottom tab bar (see spec.md Assumptions, plan.md Summary, research.md
> "Navigation mechanism (superseded)"). The task list below reflects the current tab-based
> design; T009–T014's original IDs are kept for traceability but their descriptions now describe
> the tab shell.

**Goal**: A single screen titled "Calendar Showcase" has a bottom tab bar with one tab per
calendar style; selecting a tab shows that style's content — starting with a short description —
in place, with no separate screen or back button involved.

**Independent Test**: Launch the app, confirm the title and all four tabs are present, select
each tab in turn, and confirm its content (starting with its description) replaces the previous
tab's content — this is testable even before any calendar view has real content beyond its
description (spec.md User Story 1), since this phase gives Week/Day/Timeline minimal placeholder
bodies that Phases 5–7 later fill in.

### Implementation for User Story 1

- [x] T009 [US1] Implement `CalendarShowcaseScreen` in
      `lib/screens/calendar_showcase_screen.dart` as the app's single shell: a `StatefulWidget`
      holding the selected tab index; a `Scaffold` with `AppBar` title "Calendar Showcase"
      (FR-001, shown regardless of selected tab), `bottomNavigationBar: BottomNavigationBar` with
      exactly one item per `CalendarViewType` labeled with that view's name (FR-002), and
      `body: IndexedStack` switching between the four tab bodies on `BottomNavigationBar.onTap`
      (FR-003) — no `Navigator.push` involved.
- [x] T010 [P] [US1] `MonthCalendar` in `lib/calendar/month/month_calendar.dart` returns its tab
      body content (starting with its one-sentence description, FR-004) directly — no `Scaffold`
      or `AppBar` of its own, since `CalendarShowcaseScreen` owns the single shell. Full
      implementation lands in Phase 4.
- [x] T011 [P] [US1] Create a minimal `WeekCalendar` placeholder tab body in
      `lib/calendar/week/week_calendar.dart`: its one-sentence description (FR-004) plus a
      placeholder message — no `Scaffold`/`AppBar` — to be replaced with the full implementation
      in Phase 5.
- [x] T012 [P] [US1] Create a minimal `DayCalendar` placeholder tab body in
      `lib/calendar/day/day_calendar.dart`: its one-sentence description (FR-004) plus a
      placeholder message — no `Scaffold`/`AppBar` — to be replaced with the full implementation
      in Phase 6.
- [x] T013 [P] [US1] Create a minimal `TimelineCalendar` placeholder tab body in
      `lib/calendar/timeline/timeline_calendar.dart`: its one-sentence description (FR-004) plus
      a placeholder message — no `Scaffold`/`AppBar` — to be replaced with the full
      implementation in Phase 7.
- [x] T014 [US1] Update `lib/main.dart` to call `runApp(const CalendarShowcaseScreen())` instead
      of the scaffolded placeholder `HomeScreen` (leave `DartNativePluginRegistrant.registerAll()`
      and the `SystemChrome.defaultStyle` setup untouched). Depends on T009.

**Checkpoint**: The tab shell is browsable; all four tabs switch their content in place, even
though three are still placeholders. This alone satisfies spec.md User Story 1 and is the
smallest demoable slice.

---

## Phase 4: User Story 2 - View Month Calendar (Priority: P1)

**Goal**: A traditional monthly grid with today highlighted, event indicators, date selection
showing that date's events, and previous/next month navigation.

**Independent Test**: Select the Month tab and verify the grid, today's
highlight, event indicators, date selection, and month navigation, independent of the other three
views (spec.md User Story 2).

### Implementation for User Story 2

- [x] T015 [P] [US2] Implement `MonthHeader` in `lib/calendar/month/month_header.dart`: shows the
      displayed month/year as the title and wraps `CalendarNavigationHeader`
      (`lib/shared/calendar_navigation.dart`, T007) for previous/next month controls (FR-008).
- [x] T016 [P] [US2] Implement `DayCell` in `lib/calendar/month/day_cell.dart`: renders a date
      number; visually distinguishes today (FR-007); visually mutes dates outside the displayed
      month (spec.md "Month view implementation"); renders a small dot/indicator when the date
      has one or more events (FR-009); and calls an `onTap(DateTime)` callback when selected
      (FR-010), using `GestureDetector`/`InkWell`.
- [x] T017 [US2] Implement `MonthGrid` in `lib/calendar/month/month_grid.dart`: a 7-column
      `GridView` (research.md "Month grid construction") built from
      `calendar_date_utils.dart`'s month-grid date list (T005), rendering one `DayCell` (T016)
      per date, passing each date's event indicator flag (via `calendar_date_utils.eventsOnDay`)
      and today/selected/outside-month state, and forwarding cell taps up to a
      `ValueChanged<DateTime>` prop.
- [x] T018 [US2] Implement the full `MonthCalendar` tab body in
      `lib/calendar/month/month_calendar.dart` (filling in the T010 content): a `StatefulWidget`
      holding `displayedMonth` and `selectedDate` state; its description header (FR-004) followed
      by `MonthHeader` (T015) + `MonthGrid` (T017) + a section below listing the selected date's
      events (from `lib/data/sample_events.dart`, T004, filtered via
      `calendar_date_utils.eventsOnDay`, T005), showing an empty state when there are none
      (spec.md Edge Cases); wires the header's previous/next callbacks to move `displayedMonth` by
      one month via `DateTime`/`Duration` math, correctly crossing year boundaries (spec.md Edge
      Cases, SC-007). Still no `Scaffold`/`AppBar` of its own — it's tab content inside
      `CalendarShowcaseScreen`'s `IndexedStack`.

**Checkpoint**: User Stories 1 and 2 both work independently — the Month tab is fully functional
in addition to the tab-switching shell.

---

## Phase 5: User Story 3 - View Week Calendar (Priority: P2)

**Goal**: Seven-day week layout with a vertical time axis, events positioned by start time and
duration, side-by-side overlap handling, and previous/next week navigation.

**Independent Test**: Select the Week tab and verify the week's dates, time
axis, event placement (including an overlapping pair), and week navigation, independent of the
other three views (spec.md User Story 3).

### Implementation for User Story 3

- [x] T019 [P] [US3] Implement `WeekHeader` in `lib/calendar/week/week_header.dart`: shows the
      selected week's seven dates across the top (FR-011) and wraps `CalendarNavigationHeader`
      (T007) for previous/next week controls (FR-014).
- [x] T020 [P] [US3] Implement `EventBlock` in `lib/calendar/week/event_block.dart`: a
      `Positioned` block (top offset + height from `calendar_layout_utils.dart`, T006; horizontal
      slot from the event's `(column, columnCount)` overlap assignment) showing the event title,
      styled per the "Styling" guidance in plan.md (clean, neutral, consistent spacing/corner
      radius).
- [x] T021 [US3] Implement `WeekDayColumn` in `lib/calendar/week/week_day_column.dart`: a `Stack`
      for one day, with an hour-row background and one `EventBlock` (T020) per event on that day,
      using `calendar_layout_utils.dart`'s overlap-clustering output (T006) so overlapping events
      sit side by side rather than hiding one another (FR-015).
- [x] T022 [US3] Implement `WeekTimeGrid` in `lib/calendar/week/week_time_grid.dart`: a vertical
      time axis (FR-012) using `TimeLabel`/hour formatting from `lib/shared/time_label.dart`
      (T008) alongside a horizontally-laid-out row of seven `WeekDayColumn`s (T021), scrollable
      vertically via `SingleChildScrollView`, covering the practical visible range described in
      plan.md (e.g. 06:00–22:00, or the full day).
- [x] T023 [US3] Implement the full `WeekCalendar` screen in
      `lib/calendar/week/week_calendar.dart` (replacing the T011 placeholder): a `StatefulWidget`
      holding `displayedWeekStart` state; composes `WeekHeader` (T019) + `WeekTimeGrid` (T022),
      sourcing the week's dates from `calendar_date_utils.dart`'s week helpers (T005) and that
      week's events from `lib/data/sample_events.dart` (T004); wires previous/next callbacks to
      move `displayedWeekStart` by seven days, correctly handling a week that spans two months
      (spec.md Edge Cases).

**Checkpoint**: User Stories 1, 2, and 3 all work independently.

---

## Phase 6: User Story 4 - View Day Calendar (Priority: P2)

**Goal**: A single day's vertical hourly timeline with events positioned by start time/duration
and a current-time indicator when viewing today, plus previous/next day navigation.

**Independent Test**: Select the Day tab and verify the hourly timeline,
event placement, current-time indicator (when viewing today), and day navigation, independent of
the other three views (spec.md User Story 4).

### Implementation for User Story 4

- [x] T024 [P] [US4] Implement `DayEventBlock` in `lib/calendar/day/day_event_block.dart`: a
      `Positioned` block sized/positioned using the same `calendar_layout_utils.dart` functions
      as `EventBlock` (T006/T020), for a single day's full-width timeline.
- [x] T025 [US4] Implement `DayTimeGrid` in `lib/calendar/day/day_time_grid.dart`: renders hour
      separators and labels (FR-016) via `lib/shared/time_label.dart` (T008), lays out one
      `DayEventBlock` (T024) per event on the selected day (FR-017), and — only when the selected
      day `isSameDay` as `DateTime.now()` (via `calendar_date_utils.dart`, T005) — renders a
      clearly visible current-time indicator line positioned via `calendar_layout_utils.dart`
      (T006) at the current time-of-day (FR-019; must NOT render for any other day).
- [x] T026 [P] [US4] Implement `DayHeader` in `lib/calendar/day/day_header.dart`: shows the
      selected date as a title and wraps `CalendarNavigationHeader` (T007) for previous/next day
      controls (FR-018).
- [x] T027 [US4] Implement the full `DayCalendar` screen in `lib/calendar/day/day_calendar.dart`
      (replacing the T012 placeholder): a `StatefulWidget` holding `selectedDay` state (defaulting
      to today); composes `DayHeader` (T026) + `DayTimeGrid` (T025), sourcing that day's events
      from `lib/data/sample_events.dart` (T004) via `calendar_date_utils.eventsOnDay` (T005);
      wires previous/next callbacks to move `selectedDay` by one day.

**Checkpoint**: User Stories 1, 2, 3, and 4 all work independently.

---

## Phase 7: User Story 5 - View Agenda / Timeline Calendar (Priority: P3)

**Goal**: All sample events shown as a single chronological, readable list grouped by date, with
time/title/optional description per entry and past/current/upcoming events visually
distinguished.

**Independent Test**: Select the Agenda/Timeline tab and verify events are
grouped by date in chronological order, show the expected fields, and are visually distinguished
by past/current/upcoming status, independent of the other three views (spec.md User Story 5).

### Implementation for User Story 5

- [x] T028 [P] [US5] Implement `TimelineEventItem` in
      `lib/calendar/timeline/timeline_event_item.dart`: renders an event's time and title always,
      and its `description` only when non-null (FR-021); styles itself distinctly for past
      (event's `end` before now), current (`now` between `start` and `end`), and upcoming
      (`start` after now) status (FR-022), using styling only (no added interactive controls, per
      spec.md Assumptions).
- [x] T029 [US5] Implement `TimelineDateSection` in
      `lib/calendar/timeline/timeline_date_section.dart`: a date header followed by one
      `TimelineEventItem` (T028) per event on that date, in chronological order.
- [x] T030 [US5] Implement the full `TimelineCalendar` screen in
      `lib/calendar/timeline/timeline_calendar.dart` (replacing the T013 placeholder): sorts all
      of `lib/data/sample_events.dart` (T004) chronologically and groups them by calendar date
      using `calendar_date_utils.dart` (T005) (FR-020), then renders a vertically scrollable
      `ListView` of `TimelineDateSection`s (T029).

**Checkpoint**: All five user stories are independently functional — every calendar example is
fully implemented.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Final checks spanning all four calendar examples.

- [x] T031 [P] Run `dn analyze` (or `dart analyze`) across `lib/` and fix any warnings/lints
      surfaced against this project's `analysis_options.yaml`.
- [x] T032 Walk through every scenario in `specs/001-calendar-showcase/quickstart.md` on a running
      app (`dn run -d <device-id>`) and confirm each checklist item and success-criteria check
      passes.
- [x] T033 [P] Re-review `lib/models/`, `lib/data/`, `lib/calendar/*/`, `lib/shared/`, and
      `lib/utils/` against constitution Principles II, III, IV, V, and VI (no third-party
      calendar package or unsupported Flutter-only API; date/layout math stays out of widgets;
      each calendar style remains its own independent widget tree; files stay small and
      correctly located; no duplicated date/layout logic across views).

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately.
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS every user story phase.
- **User Stories (Phase 3–7)**: All depend on Foundational completion.
  - Phase 3 (US1) additionally creates the placeholder screens that Phases 4–7 replace, so in
    practice Phase 3 should run before Phases 4–7, but Phases 4, 5, 6, and 7 have no dependencies
    on each other and can proceed in any order (or in parallel) once Phase 3 is done.
- **Polish (Phase 8)**: Depends on whichever user story phases are in scope for a given delivery
  being complete.

### User Story Dependencies

- **US1 (P1)**: Depends only on Foundational. Creates the placeholder screens US2–US5 replace.
- **US2 (P1)**: Depends on Foundational + the `MonthCalendar` placeholder existing from US1
  (T010) so there's a file to replace; otherwise independent of US3/US4/US5.
- **US3 (P2)**: Depends on Foundational + the `WeekCalendar` placeholder from US1 (T011);
  otherwise independent of US2/US4/US5.
- **US4 (P2)**: Depends on Foundational + the `DayCalendar` placeholder from US1 (T012);
  otherwise independent of US2/US3/US5.
- **US5 (P3)**: Depends on Foundational + the `TimelineCalendar` placeholder from US1 (T013);
  otherwise independent of US2/US3/US4.

### Within Each User Story

- Header/cell/block "leaf" widgets before the screen that composes them.
- The full screen implementation task always depends on its own leaf-widget tasks and (for
  US2–US5) replaces the placeholder file created in US1.

### Parallel Opportunities

- T002 and T003 (Phase 2) can run in parallel.
- T004, T005, T006, T007, T008 (Phase 2) can run in parallel once T002/T003 are done.
- T010, T011, T012, T013 (Phase 3 placeholders) can run in parallel once T009 exists.
- Within Phase 4: T015 and T016 in parallel; T017 after T016; T018 after T015+T017.
- Within Phase 5: T019 and T020 in parallel; T021 after T020; T022 after T021; T023 after
  T019+T022.
- Within Phase 6: T024 and T026 in parallel; T025 after T024; T027 after T025+T026.
- Within Phase 7: T028 alone first; T029 after T028; T030 after T029.
- Once Phase 3 is complete, Phases 4, 5, 6, and 7 can be worked in parallel by different
  developers (each touches only its own `lib/calendar/<style>/` directory).
- T031 and T033 (Phase 8) can run in parallel; T032 is a manual walkthrough best done last.

---

## Parallel Example: Phase 2 (Foundational)

```bash
# After T002 and T003 land:
Task: "Create hard-coded sample data in lib/data/sample_events.dart"
Task: "Implement lib/utils/calendar_date_utils.dart"
Task: "Implement lib/utils/calendar_layout_utils.dart"
Task: "Implement lib/shared/calendar_navigation.dart"
Task: "Implement lib/shared/time_label.dart"
```

## Parallel Example: User Story 2 (Month Calendar)

```bash
Task: "Implement MonthHeader in lib/calendar/month/month_header.dart"
Task: "Implement DayCell in lib/calendar/month/day_cell.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational (blocks everything).
3. Complete Phase 3: User Story 1 — home screen + four placeholder screens with working
   navigation.
4. **STOP and VALIDATE**: run quickstart.md scenario 1 — confirm the catalog and navigation work.
5. Demo if ready — this is the smallest slice that matches spec.md's own "independently testable
   even before any calendar view has real content" framing of User Story 1.

### Incremental Delivery

1. Setup + Foundational → shared foundation ready.
2. Add US1 → home screen + placeholders → validate → demo (MVP).
3. Add US2 (Month) → validate quickstart scenario 2 → demo — the most recognizable pattern, also
   P1.
4. Add US3 (Week) → validate quickstart scenario 3 → demo.
5. Add US4 (Day) → validate quickstart scenario 4 → demo.
6. Add US5 (Agenda/Timeline) → validate quickstart scenario 5 → demo.
7. Phase 8: polish and full quickstart walkthrough.

### Parallel Team Strategy

With multiple developers, after Setup + Foundational + US1 (Phase 3) land:

- Developer A: US2 (Month) — `lib/calendar/month/`
- Developer B: US3 (Week) — `lib/calendar/week/`
- Developer C: US4 (Day) — `lib/calendar/day/`
- Developer D: US5 (Timeline) — `lib/calendar/timeline/`

Each touches only its own directory plus the already-completed shared/utils/models layer, so the
four stories integrate without conflict.

---

## Notes

- [P] tasks touch different files and have no unmet same-phase dependency.
- [Story] labels map every Phase 3+ task to its spec.md user story for traceability.
- No test tasks are included, per constitution Principle VIII and spec.md's Out of Scope section.
- Commit after each task or logical group.
- Stop at any checkpoint to validate a story independently via the matching quickstart.md
  scenario.
