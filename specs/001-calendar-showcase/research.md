# Research: Calendar Showcase

## Purpose

Resolve the open technical questions needed to plan the Calendar Showcase feature: which
DartNative APIs actually exist in this project (vs. Flutter APIs that may not be ported), and
how they map onto the four calendar layouts and navigation requirements from the spec.

Source inspected: the `dartnative` package resolved by this project's `.dart_tool/package_config.json`
(`~/zero/bin/cache/pkg/dartnative/lib`), specifically `src/widgets.dart`, `src/framework.dart`,
`src/core.dart`, and `flutter_compat.dart`'s Tier 1/2/3 widget reference comment.

## Decision: Import surface

- **Decision**: Use `package:dartnative/dartnative.dart` (the full native API), matching the
  existing `lib/main.dart`, rather than `package:dartnative/flutter_compat.dart`.
- **Rationale**: This is a DartNative project already using the native import; the compat shim
  exists to ease porting *from* Flutter and is not needed here. `dartnative.dart` re-exports
  `widgets.dart`, `framework.dart`, `core.dart`, `state.dart`, and `painting.dart`, which is
  everything this feature needs.
- **Alternatives considered**: `flutter_compat.dart` — rejected, unnecessary indirection for a
  project that isn't migrating from Flutter.

## Decision: Navigation mechanism (superseded)

- **Original decision**: `Navigator.push(context, PageRoute(builder: (_) => Screen()))` to open
  each calendar example from a home screen catalog, relying on the native back button.
- **Superseded during implementation**: switched to a single-screen `BottomNavigationBar` +
  `IndexedStack` tab switcher instead (see spec.md Assumptions and plan.md Summary). The push
  model worked as implemented, but a native bottom tab bar is the more idiomatic pattern for
  switching between a fixed set of sibling views, and avoids the extra push/pop indirection
  entirely for what is really "pick one of four views to look at."
- **Decision**: `Scaffold(appBar: ..., bottomNavigationBar: BottomNavigationBar(items: [...],
  currentIndex: _selectedIndex, onTap: ...), body: IndexedStack(index: _selectedIndex, children:
  [...]))` in `CalendarShowcaseScreen`, which becomes the single app shell. `BottomNavigationBar`
  and `IndexedStack` are both confirmed present in DartNative's native API
  (`src/widgets/bottom_navigation_bar.dart`, backed by `UITabBar`; `src/widgets/layout_extra.dart`).
  Each calendar style's `*_calendar.dart` widget now returns tab content only (no its own
  `Scaffold`/`AppBar`) — the shell owns the single `Scaffold`/`AppBar`.
- **Rationale**: Matches FR-001–FR-004 (single persistent title, one tab per style, in-place
  content swap, no back button needed) with no routes table, named routes, or
  state-management/router package. `IndexedStack` keeps every tab's `StatefulWidget` mounted, so
  each view's `selectedDate`/displayed month/week/day survives switching tabs within a session,
  which is a nicer showcase experience than resetting on every switch.
- **Alternatives considered**: Named routes via `registerRoutes`/`pushNamed` — rejected as
  unnecessary ceremony for 4 fixed destinations; keeping `Navigator.push` from a home catalog —
  rejected in favor of the tab bar per the decision above.

## Decision: State management

- **Decision**: Each calendar screen is a `StatefulWidget` with a `State<T>` holding only the
  values it needs (`selectedDate`, and the currently displayed month/week/day), updated via
  `setState`.
- **Rationale**: `StatefulWidget`/`State` are present in `src/core.dart` and behave like their
  Flutter counterparts. This satisfies the plan's "no global state-management package" and the
  constitution's dependency-minimalism principle. DartNative also ships a `Signal`/`Computed`
  reactive-state primitive (`src/state.dart`), but plain `StatefulWidget` state is simpler and
  sufficient for four independent, non-communicating screens.
- **Alternatives considered**: `Signal`/`Computed` reactive state — rejected as unneeded
  complexity for state that is local to one screen and never shared.

## Decision: Layout widgets available (no CustomPaint needed)

- **Decision**: Build all four calendar layouts using standard layout widgets confirmed present
  in `src/widgets/*.dart`: `Column`, `Row`, `Expanded`, `Flexible`, `Spacer`, `Stack`,
  `Positioned`, `Container`, `Padding`, `SizedBox`, `Align`, `Divider`, `GestureDetector`,
  `InkWell`, `ListView`, `SingleChildScrollView`, `GridView`, `Card`, `ListTile`, `LayoutBuilder`.
- **Rationale**: Every widget the architecture needs (month grid, scrollable time axes,
  positioned event blocks, tappable cells, scrollable agenda list) has a direct match in
  DartNative's Tier 1 (native-widget-backed) surface — no Skia/`CustomPaint` (Tier 2) is
  required, keeping the implementation on native widgets as the constitution prefers.
- **Alternatives considered**: `CustomPaint`/Canvas-based rendering for the week/day time grid —
  rejected; `Stack` + `Positioned` over a `Column` of fixed-height hour rows reproduces the same
  visual result with ordinary layout widgets, per the plan's "avoid custom drawing unless normal
  layout widgets cannot reasonably implement the interface."

## Decision: Month grid construction

- **Decision**: Use `GridView` with `crossAxisCount: 7` (one column per weekday) built from a
  flat list of dates computed by `calendar_date_utils.dart` (leading/trailing days included so
  every row is complete), rather than a `Table` or hand-rolled `Column` of `Row`s.
- **Rationale**: `GridView` (confirmed in `src/widgets/grid_view.dart`, itemBuilder-based) removes
  manual row-height/wrapping bookkeeping while still being assembled entirely by this feature's
  own code — it is a general-purpose DartNative layout widget, not a calendar package, so it does
  not conflict with constitution Principle II. Supports 5- or 6-row months naturally since the
  generated date list length simply varies (35 or 42 cells).
- **Alternatives considered**: Manual `Column` of seven-wide `Row`s — rejected only because
  `GridView` needs less manual arithmetic for row count/sizing; both are equally
  "hand-built, not a package" and either would satisfy the constitution.

## Decision: Week/Day event overlap layout

- **Decision**: For events on the same day/column that overlap in time, partition them into the
  smallest number of side-by-side sub-columns needed (group overlapping events into a cluster,
  divide the cluster's width evenly by the cluster's max concurrent-event count).
- **Rationale**: Matches the plan's explicit instruction ("if overlapping events can be handled
  without excessive complexity, place them side by side... do not build a sophisticated
  scheduling collision engine") and the spec's FR-015/edge case (overlapping events must remain
  visible, not fully hidden). This is a single pass over each day's events, computed in
  `calendar_layout_utils.dart`, independent of widget code.
- **Alternatives considered**: A general interval-scheduling / greedy-coloring collision engine —
  rejected as more complexity than the prototype needs; simple cluster-based even-width division
  is sufficient for hard-coded sample data with only occasional overlaps.

## Decision: Target platforms

- **Decision**: iOS and Android, matching the existing project's runner glue (`ios/Runner`,
  `android/app`) and `pubspec.yaml` dependencies (`dartnative_ios`, `dartnative_android`).
- **Rationale**: No other platform runners exist in this project; adding one is out of scope for
  a UI-pattern showcase feature.
- **Alternatives considered**: None — determined directly by existing project structure.

## Decision: Contracts artifact

- **Decision**: Skip generating `contracts/`.
- **Rationale**: This feature is a self-contained mobile UI prototype with hard-coded in-memory
  data; it exposes no API, CLI, or other interface to external callers or systems. The plan
  template's contracts step is explicitly skippable for purely internal projects.
- **Alternatives considered**: A "contract" describing the `CalendarEvent` shape — rejected as
  redundant with `data-model.md`, which already documents that shape.

## Outcome

All unknowns needed to proceed to Phase 1 design are resolved. No `NEEDS CLARIFICATION` markers
remain.
