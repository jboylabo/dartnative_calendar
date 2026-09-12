<!--
Sync Impact Report
- Version change: (unratified template) → 1.0.0
- Rationale: Initial ratification. The prior file was an unfilled template scaffold with no
  concrete principles, so this is treated as the project's first constitution rather than an
  amendment.
- Modified principles: n/a (initial adoption)
- Added principles:
  - I. Simplicity & Showcase Focus
  - II. DartNative-First
  - III. Separation of Logic and Presentation
  - IV. Independent Reusable Calendar Widgets
  - V. Small Files, Clear Directory Structure
  - VI. Shared Models & Utilities Over Duplication
  - VII. No Production-Grade Concerns
  - VIII. No Test Artifacts
  - IX. Hard-Coded Sample Data
  - X. Dependency Minimalism
- Added sections: Technology Constraints; Development Workflow
- Removed sections: none
- Templates requiring updates:
  - .specify/templates/plan-template.md — ⚠ pending manual review (not modified by this command)
  - .specify/templates/spec-template.md — ⚠ pending manual review (not modified by this command)
  - .specify/templates/tasks-template.md — ⚠ pending manual review (not modified by this command;
    should not introduce test-task sections given Principle VIII)
- Follow-up TODOs: none — ratification date set to the date this constitution was authored, since
  no earlier adoption date exists for this project.
-->

# DartNative Calendar Showcase Constitution

## Core Principles

### I. Simplicity & Showcase Focus
The project exists to demonstrate calendar UI patterns, not to be a production calendar
product. Every change MUST be evaluated first against whether it helps demonstrate a calendar
UI pattern clearly. Implementation MUST favor the simplest approach that correctly demonstrates
the pattern over general-purpose or speculative engineering. Rationale: a showcase's value is
clarity for the reader; complexity that doesn't serve demonstration is pure cost.

### II. DartNative-First
Widgets and features MUST be built with DartNative's built-in widgets and the Dart standard
library. Flutter-specific APIs that DartNative does not support MUST NOT be used as a
substitute. Third-party calendar UI packages MUST NOT be introduced under any circumstance —
the calendar UI itself is the thing being demonstrated. Rationale: the project's purpose is to
show what DartNative itself can do; leaning on Flutter-only APIs or calendar packages would
defeat that purpose.

### III. Separation of Logic and Presentation
Calendar date calculations (date math, week/month generation, event placement logic, etc.)
MUST live separately from presentation widgets. Presentation widgets MUST consume computed
data/models rather than perform date arithmetic inline. Rationale: keeping logic and rendering
apart keeps each calendar style's widget code focused on layout and makes the date logic
reusable and easy to read in isolation.

### IV. Independent Reusable Calendar Widgets
Each distinct calendar style (e.g., month grid, week view, agenda list) MUST be implemented as
its own independent, reusable widget rather than as variants/branches inside a shared widget.
Rationale: independence lets each style be read, understood, and demonstrated on its own, which
is the point of a pattern showcase.

### V. Small Files, Clear Directory Structure
Files MUST be kept small and focused on a single responsibility. Features MUST be split across
clearly named directories (e.g., by calendar style, by layer such as models/widgets/utils)
rather than accumulated into large multi-purpose files. Rationale: small, well-organized files
are easier to navigate for anyone studying the showcase as a reference.

### VI. Shared Models & Utilities Over Duplication
Common concepts (calendar events, dates, layout helpers) MUST be expressed as shared, reusable
models and utility functions. Logic MUST NOT be duplicated across calendar style widgets when a
shared utility or model would serve. Rationale: duplication invites drift between calendar
styles and obscures what's actually pattern-specific versus incidental.

### VII. No Production-Grade Concerns
This application MUST NOT implement authentication, backend services, cloud sync, Google
Calendar (or other external calendar) integration, notifications, or persistence. Rationale:
these are production concerns unrelated to demonstrating UI patterns, and including them would
expand scope far beyond a UI/framework capability showcase.

### VIII. No Test Artifacts
This prototype MUST NOT include unit tests, widget tests, integration tests, mocks, fixtures,
or test directories. Rationale: this is an explicit project-level decision for a showcase
prototype, prioritizing iteration speed over verification infrastructure.

### IX. Hard-Coded Sample Data
Calendar events used for demonstration MUST be hard-coded sample data defined in code.
Dynamic data sources, network calls, or persistence-backed data MUST NOT be used to populate
calendar content. Rationale: consistent with Principle VII, and it keeps every calendar style
demonstrable without external setup.

### X. Dependency Minimalism
New third-party dependencies MUST NOT be added unless the required behavior cannot reasonably
be implemented using DartNative and the Dart standard library. When an API is unavailable in
DartNative, the simplest compatible alternative MUST be implemented, and the limitation MUST be
documented (e.g., a code comment or README note) rather than silently worked around. Rationale:
keeps the showcase's dependency footprint minimal and keeps the focus on DartNative's own
capabilities.

## Technology Constraints

The application is built on DartNative using Dart and DartNative's built-in widget set. No
backend, cloud, or external service integrations are in scope. Data is entirely in-memory and
hard-coded; there is no persistence layer. Where DartNative lacks an API that Flutter provides,
the simplest DartNative-compatible workaround MUST be used, with the gap documented at the
point of use.

## Development Workflow

Changes MUST be reviewed against the Core Principles above before being considered complete,
in particular: no third-party calendar packages or unsupported Flutter-only APIs (Principle
II), logic/presentation separation (Principle III), one widget per calendar style (Principle
IV), and absence of test artifacts or production concerns (Principles VII, VIII). Reviewers
(including the assistant itself when self-checking work) MUST flag any change that introduces
scope beyond a UI/framework capability showcase.

## Governance

This constitution supersedes other informal practices for this project. Amendments require:
(1) the change to be stated explicitly, (2) a version bump per the policy below, and (3) the
Sync Impact Report at the top of this file to be updated to reflect the change.

Versioning policy (semantic versioning applied to governance):
- MAJOR: Backward-incompatible removals or redefinitions of principles.
- MINOR: New principle or materially expanded guidance added.
- PATCH: Wording clarifications, typo fixes, non-semantic refinements.

Compliance review: any change to the codebase should be checked against the Core Principles
above; deviations must be justified explicitly rather than made silently.

**Version**: 1.0.0 | **Ratified**: 2026-09-12 | **Last Amended**: 2026-09-12
