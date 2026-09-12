# Quickstart: Calendar Showcase

Validation guide for confirming the feature works end-to-end once implemented. See
`data-model.md` for the `CalendarEvent`/`CalendarViewType` shapes referenced below and `spec.md`
for the full acceptance scenarios these steps trace back to.

## Prerequisites

- DartNative SDK + license configured (`dn config --license-key dnk_...`), as described in this
  project's `README.md`.
- Dependencies fetched: `dn pub get` (this feature adds no new dependencies, per research.md).

## Run

```sh
dn run -d <device-id>
```

## Validation scenarios

1. **Tab switching** (User Story 1 / FR-001–FR-004)
   - Launch the app.
   - Confirm the title "Calendar Showcase" is visible.
   - Confirm exactly four bottom tabs are present: Month, Week, Day, Agenda/Timeline.
   - Select each tab in turn; confirm its content — starting with a one-sentence description of
     what it demonstrates — replaces the previous tab's content in place, with no screen
     transition and no back button.

2. **Month Calendar** (User Story 2 / FR-005–FR-010)
   - Select the "Month" tab.
   - Confirm a 7-column weekday grid renders showing every day of the current month.
   - Confirm today's date is visually distinguished from other days.
   - Confirm any date with sample events shows a small indicator.
   - Tap a date with events; confirm that date's events are listed. Tap a date with none; confirm
     an empty state (no error).
   - Use the previous/next controls to move at least one month back and forward; confirm the grid
     updates correctly, including across a month that needs 6 rows and one that needs 5.

3. **Week Calendar** (User Story 3 / FR-011–FR-015)
   - Select the "Week" tab.
   - Confirm the current week's seven dates are shown across the top with a vertical time axis
     below.
   - Confirm sample events are positioned/sized along the axis consistent with their start
     time/duration (spot-check one event against its known `start`/`end`).
   - Find (or temporarily note) a day with two overlapping sample events; confirm both are
     visible side by side rather than one hiding the other.
   - Navigate to the previous/next week; confirm the displayed dates and events update.

4. **Day Calendar** (User Story 4 / FR-016–FR-019)
   - Select the "Day" tab; confirm it opens on today by default.
   - Confirm the hourly timeline renders with today's events positioned by start time/duration,
     and that a current-time indicator is visible.
   - Navigate to a different day; confirm the current-time indicator disappears and that day's
     events render instead.
   - Navigate back to today; confirm the current-time indicator reappears.

5. **Agenda / Timeline Calendar** (User Story 5 / FR-020–FR-022)
   - Select the "Agenda / Timeline" tab.
   - Confirm all sample events appear in chronological order, grouped under their date.
   - Confirm each entry shows time + title (+ description when present).
   - Confirm events before today read as "past", today's not-yet-finished/in-progress events read
     as "current", and later events read as "upcoming" — distinguishable by styling alone.

## Success criteria check (spec.md)

- SC-001/SC-002: every tab switches its content in one tap, from any other tab; the selected
  tab + its description header always identify which view is showing (step 1).
- SC-003: today + event-bearing dates are identifiable in Month view without opening any date
  (step 2).
- SC-004: event position/size in Week and Day views reflects start time/duration without reading
  text (steps 3–4).
- SC-005: every sample event defined in `sample_events.dart` appears in at least one view during
  steps 2–5 (cross-check the full list against what was seen).
- SC-006: past/current/upcoming are visually distinguishable in Agenda view without reading
  timestamps (step 5).
- SC-007: repeat the month/week/day navigation in steps 2–4 three times forward and back; confirm
  today's highlight and date labels stay correct throughout.
