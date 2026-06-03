# Implementation Plan: Production Readiness

**Branch**: `[001-production-readiness]` | **Date**: 2026-05-14 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-production-readiness/spec.md`

## Summary

Harden the existing Spotter ride-marketplace prototype into a production-ready app shell by validating the full rider and driver ride flow, preserving ride context across screens, adding explicit release readiness checks, improving failure recovery, strengthening diagnostics redaction, and expanding regression coverage around launch-critical flows. The implementation should stay inside the current single Flutter app structure and build on the existing route registry, app configuration, crash reporter, ride controller, repository boundary, shared widgets, and tests.

## Technical Context

**Language/Version**: Dart SDK ^3.10.8 with Flutter

**Primary Dependencies**: Flutter Material, cupertino_icons, flutter_test, flutter_lints; no new runtime dependency is required for the first production-readiness pass

**Storage**: In-memory ride state and repository-provided bootstrap data for the current prototype; readiness checks must expose blockers for future payment, KYC, location, support, and diagnostics provider credentials

**Testing**: `dart analyze`, `flutter test`, focused controller tests, widget navigation tests, and failure-state tests

**Target Platform**: Flutter mobile app with existing Android, iOS, web, desktop project scaffolding; production readiness is validated primarily against phone-sized rider and driver flows

**Project Type**: Single Flutter application

**Performance Goals**: User-visible recovery state appears within 2 seconds of a failed action; all scripted P1 ride-flow checks complete without crashes or unrecoverable screens

**Constraints**: Preserve existing app structure; do not add backend services in this feature; do not capture sensitive payment, identity, or precise location data in diagnostics; keep inactive launch dependencies visible as readiness blockers

**Scale/Scope**: Approximately 30 routed screens across rider, driver, support, wallet, admin review, and recovery flows

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project constitution at `.specify/memory/constitution.md` is still the uncustomized template and contains no enforceable project-specific MUST or SHOULD statements. No constitution violations are present.

Planning gates for this feature:

- PASS: Scope remains within the existing Flutter application.
- PASS: The plan includes regression coverage for P1 ride flows and launch readiness checks.
- PASS: Diagnostics must avoid sensitive payment, identity, and precise location data.
- PASS: External provider integrations are represented as launch blockers, not silently mocked as production-ready.

Post-design constitution check: PASS. The generated data model, UI contract, and quickstart preserve the same constraints and introduce no constitution conflict.

## Project Structure

### Documentation (this feature)

```text
specs/001-production-readiness/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
|   `-- production-readiness-ui.md
|-- checklists/
|   `-- requirements.md
`-- tasks.md
```

### Source Code (repository root)

```text
spotter/
|-- lib/
|   |-- app/
|   |   |-- app_config.dart
|   |   |-- app_crash_reporter.dart
|   |   |-- app_error_screen.dart
|   |   `-- app_routes.dart
|   |-- controllers/
|   |   `-- ride_controller.dart
|   |-- models/
|   |   `-- ride_models.dart
|   |-- repositories/
|   |   `-- ride_repository.dart
|   |-- screens/
|   |   |-- home_screen.dart
|   |   |-- driver_home_screen.dart
|   |   |-- pickup_location_screen.dart
|   |   |-- destination_search_screen.dart
|   |   |-- fare_estimate_screen.dart
|   |   |-- driver_matches_screen.dart
|   |   |-- ride_confirmation_screen.dart
|   |   |-- live_tracking_screen.dart
|   |   |-- payment_screen.dart
|   |   |-- ride_complete_screen.dart
|   |   |-- support_screen.dart
|   |   |-- dispute_case_screen.dart
|   |   `-- related rider, driver, wallet, notification, and recovery screens
|   |-- spotter_widgets.dart
|   |-- helper.dart
|   `-- main.dart
`-- test/
    |-- ride_controller_test.dart
    |-- widget_test.dart
    `-- production_readiness_test.dart
```

**Structure Decision**: Use the existing single Flutter app. Production-readiness work should extend current app, controller, repository, route, and test boundaries rather than introducing new packages or services.

## Phase 0: Research Decisions

See [research.md](./research.md).

## Phase 1: Design Outputs

- Data model: [data-model.md](./data-model.md)
- UI and readiness contract: [contracts/production-readiness-ui.md](./contracts/production-readiness-ui.md)
- Validation guide: [quickstart.md](./quickstart.md)

## Implementation Strategy

1. Add explicit production readiness domain objects for release mode, readiness checks, diagnostic events, support cases, and recoverable action states.
2. Extend the repository/controller boundary so ride actions expose success and failure states consistently without breaking existing mock behavior.
3. Strengthen `AppConfig` and `AppCrashReporter` so production mode, diagnostics enablement, and redaction behavior are testable.
4. Add a readiness checklist/service that reports pass or blocked status for launch-critical dependencies.
5. Add route and navigation validation tests covering all declared app destinations and fallback behavior.
6. Add widget and controller regression tests for P1 rider flow, driver flow, failed refresh, failed ride action, support/dispute context, and sensitive diagnostics redaction.
7. Update README or quick release notes only after implementation tasks exist, so production build instructions match the final code.

## Complexity Tracking

No constitution violations or exceptional complexity are introduced by this plan.
