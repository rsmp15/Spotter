# Tasks: Production Readiness

**Input**: Design documents from `/specs/001-production-readiness/`

**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md), [data-model.md](./data-model.md), [contracts/production-readiness-ui.md](./contracts/production-readiness-ui.md), [quickstart.md](./quickstart.md)

**Tests**: Required by FR-012 and SC-007. Write failing tests before implementation for each user story.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel with other marked tasks in the same phase because it touches a different file or has no dependency on incomplete tasks.
- **[Story]**: Maps the task to a user story from [spec.md](./spec.md).
- Every task includes an exact repository-relative file path.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare shared test and fixture structure used by all production-readiness stories.

- [X] T001 [P] Create shared widget test harness in spotter/test/helpers/app_test_harness.dart
- [X] T002 [P] Create reusable fake ride repository fixtures in spotter/test/helpers/fake_ride_repository.dart
- [X] T003 [P] Create production-readiness test entry file in spotter/test/production_readiness_test.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core models and services that MUST be complete before any user story can be implemented.

**CRITICAL**: No user story work can begin until this phase is complete.

- [X] T004 Add production readiness domain models for release mode, readiness checks, diagnostic events, support cases, and recoverable action state in spotter/lib/models/production_readiness_models.dart
- [X] T005 Implement launch readiness check service and default required check catalog in spotter/lib/app/app_readiness.dart
- [X] T006 Extend environment and launch dependency configuration flags in spotter/lib/app/app_config.dart
- [X] T007 Implement diagnostic event creation and sensitive-data redaction in spotter/lib/app/app_crash_reporter.dart
- [X] T008 Update ride repository contracts to support failure-aware cancel and rating actions in spotter/lib/repositories/ride_repository.dart
- [X] T009 Update ride controller action state, retry, and context-preservation behavior in spotter/lib/controllers/ride_controller.dart
- [X] T010 Update generic app error fallback actions and copy in spotter/lib/app/app_error_screen.dart

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel.

---

## Phase 3: User Story 1 - Complete Reliable Ride Flow (Priority: P1) MVP

**Goal**: Users can complete the rider and driver ride flows with preserved ride context, route fallback, and recoverable failure states.

**Independent Test**: Walk through rider and driver journeys with normal data, failed refreshes, failed ride actions, and unknown navigation targets while confirming no crash, no blank screen, preserved context, and a visible recovery path.

### Tests for User Story 1

> Write these tests FIRST and confirm they fail before implementation.

- [X] T011 [P] [US1] Add route coverage and unknown-route fallback widget tests in spotter/test/route_coverage_test.dart
- [X] T012 [P] [US1] Add end-to-end rider flow widget tests in spotter/test/rider_flow_test.dart
- [X] T013 [P] [US1] Add driver workflow regression tests in spotter/test/driver_flow_test.dart
- [X] T014 [P] [US1] Add failed refresh and failed ride action controller tests in spotter/test/ride_recovery_test.dart

### Implementation for User Story 1

- [X] T015 [US1] Expose a complete route registry list for validation tests in spotter/lib/app/app_routes.dart
- [X] T016 [US1] Wire route fallback navigation to a recoverable home path in spotter/lib/app/app_routes.dart
- [X] T017 [US1] Render failed ride data refresh recovery state on the rider home screen in spotter/lib/screens/home_screen.dart
- [X] T018 [US1] Render selected ride context and action failures in pickup and destination flows in spotter/lib/screens/pickup_location_screen.dart
- [X] T019 [US1] Render selected ride context and action failures in fare and driver matching flows in spotter/lib/screens/fare_estimate_screen.dart
- [X] T020 [US1] Render selected ride context and action failures in confirmation and tracking flows in spotter/lib/screens/ride_confirmation_screen.dart
- [X] T021 [US1] Render selected ride context and action failures in payment and completion flows in spotter/lib/screens/payment_screen.dart
- [X] T022 [US1] Render selected ride context and action failures in driver job, pickup, and drop task flows in spotter/lib/screens/driver_home_screen.dart
- [X] T023 [US1] Update shared screen and recovery widgets used by rider and driver flows in spotter/lib/spotter_widgets.dart

**Checkpoint**: User Story 1 is fully functional and testable independently as the MVP.

---

## Phase 4: User Story 2 - Operate With Launch Controls (Priority: P2)

**Goal**: Operators can validate development, staging, and production release behavior through explicit readiness checks and release configuration.

**Independent Test**: Run production-readiness tests with different configuration values and confirm release identity, diagnostics behavior, and blocked readiness reasons are reported correctly.

### Tests for User Story 2

> Write these tests FIRST and confirm they fail before implementation.

- [X] T024 [P] [US2] Add release mode and app configuration tests in spotter/test/app_config_test.dart
- [X] T025 [P] [US2] Add launch readiness check tests for pass, warning, and blocked status in spotter/test/app_readiness_test.dart
- [X] T026 [P] [US2] Add diagnostics enablement and redaction tests in spotter/test/app_crash_reporter_test.dart

### Implementation for User Story 2

- [X] T027 [US2] Implement typed release mode parsing and production detection in spotter/lib/app/app_config.dart
- [X] T028 [US2] Implement required launch dependency checks for diagnostics, payment, identity verification, location, support, route coverage, and regression coverage in spotter/lib/app/app_readiness.dart
- [X] T029 [US2] Integrate readiness status and diagnostic behavior with app bootstrap in spotter/lib/main.dart
- [X] T030 [US2] Document production readiness flags and blocked launch dependency behavior in spotter/README.md

**Checkpoint**: User Story 2 is independently testable through configuration and readiness-check tests.

---

## Phase 5: User Story 3 - Support Production Incidents (Priority: P3)

**Goal**: Ride failures, disputes, cancellations, and support requests retain reviewable ride context while protecting sensitive data.

**Independent Test**: Force cancellation, rating, payment, support, dispute, and diagnostic events and confirm each one includes ride reference, role, issue category, status, timestamp, and safe redacted context.

### Tests for User Story 3

> Write these tests FIRST and confirm they fail before implementation.

- [X] T031 [P] [US3] Add support case model and validation tests in spotter/test/support_case_test.dart
- [X] T032 [P] [US3] Add support and dispute context widget tests in spotter/test/support_dispute_flow_test.dart
- [X] T033 [P] [US3] Add cancellation and rating failure recovery tests in spotter/test/incident_recovery_test.dart

### Implementation for User Story 3

- [X] T034 [US3] Create support case factory and validation helpers in spotter/lib/models/production_readiness_models.dart
- [X] T035 [US3] Preserve ride reference, user role, issue category, status, and timestamp in support flow UI in spotter/lib/screens/support_screen.dart
- [X] T036 [US3] Preserve ride reference, user role, issue category, status, and timestamp in dispute flow UI in spotter/lib/screens/dispute_case_screen.dart
- [X] T037 [US3] Show recoverable cancellation failure state with preserved ride context in spotter/lib/screens/cancel_ride_screen.dart
- [X] T038 [US3] Show recoverable rating submission failure state with preserved ride context in spotter/lib/screens/rating_screen.dart

**Checkpoint**: User Story 3 is independently testable through incident, support, dispute, and diagnostics tests.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and cleanup across all implemented user stories.

- [X] T039 [P] Update production quickstart notes after implementation in specs/001-production-readiness/quickstart.md
- [X] T040 [P] Update app production-readiness documentation after implementation in spotter/README.md
- [X] T041 Run Dart static analysis and resolve reported issues in spotter/analysis_options.yaml
- [X] T042 Run all Flutter tests and fix any production-readiness regressions in spotter/test/production_readiness_test.dart
- [X] T043 Perform manual smoke flow validation from quickstart and record final notes in specs/001-production-readiness/quickstart.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion - blocks all user stories.
- **User Stories (Phase 3+)**: Depend on Foundational completion.
- **Polish (Phase 6)**: Depends on the desired user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundation. This is the MVP and has no dependency on US2 or US3.
- **User Story 2 (P2)**: Starts after Foundation. Can run in parallel with US1 after shared app config and readiness models exist.
- **User Story 3 (P3)**: Starts after Foundation. Can run in parallel with US1/US2 after support case and diagnostic models exist.

### Within Each User Story

- Tests must be written and fail before implementation.
- Domain models and service behavior must exist before UI integration.
- UI integration must preserve ride context before polish validation.
- Story checkpoint must pass before moving to the next priority in a sequential workflow.

### Parallel Opportunities

- Setup tasks T001-T003 can run in parallel.
- US1 test tasks T011-T014 can run in parallel.
- US2 test tasks T024-T026 can run in parallel.
- US3 test tasks T031-T033 can run in parallel.
- Documentation polish tasks T039-T040 can run in parallel.
- After Phase 2, US1, US2, and US3 can be staffed in parallel if file ownership is coordinated.

---

## Parallel Example: User Story 1

```text
Task: "T011 [US1] Add route coverage and unknown-route fallback widget tests in spotter/test/route_coverage_test.dart"
Task: "T012 [US1] Add end-to-end rider flow widget tests in spotter/test/rider_flow_test.dart"
Task: "T013 [US1] Add driver workflow regression tests in spotter/test/driver_flow_test.dart"
Task: "T014 [US1] Add failed refresh and failed ride action controller tests in spotter/test/ride_recovery_test.dart"
```

---

## Parallel Example: User Story 2

```text
Task: "T024 [US2] Add release mode and app configuration tests in spotter/test/app_config_test.dart"
Task: "T025 [US2] Add launch readiness check tests for pass, warning, and blocked status in spotter/test/app_readiness_test.dart"
Task: "T026 [US2] Add diagnostics enablement and redaction tests in spotter/test/app_crash_reporter_test.dart"
```

---

## Parallel Example: User Story 3

```text
Task: "T031 [US3] Add support case model and validation tests in spotter/test/support_case_test.dart"
Task: "T032 [US3] Add support and dispute context widget tests in spotter/test/support_dispute_flow_test.dart"
Task: "T033 [US3] Add cancellation and rating failure recovery tests in spotter/test/incident_recovery_test.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Stop and validate route coverage, rider flow, driver flow, failed refresh, and unknown route fallback.
5. Demo production-ready ride-flow recovery before starting launch controls or incident support.

### Incremental Delivery

1. Setup + Foundational -> shared production-readiness models and services.
2. US1 -> reliable ride flow and route fallback.
3. US2 -> release controls and readiness checks.
4. US3 -> support, dispute, cancellation, rating, and diagnostic incident context.
5. Polish -> documentation, static analysis, tests, and quickstart smoke validation.

### Parallel Team Strategy

1. Complete setup and foundational tasks together.
2. Assign one owner to US1 screens and route tests.
3. Assign one owner to US2 configuration, readiness checks, and diagnostics tests.
4. Assign one owner to US3 support, dispute, cancellation, and rating incident flows.
5. Merge only after each story checkpoint passes independently.

## Notes

- [P] tasks touch different files or are safe to run concurrently.
- [US1], [US2], and [US3] labels map directly to the user stories in [spec.md](./spec.md).
- Keep external provider integrations as readiness blockers until real credentials and compliance requirements exist.
- Avoid copying or replacing unrelated service-home-screen work from `specs/002-service-home-screen/`.
