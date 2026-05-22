# Tasks: Rider Home, Destination, and Services Refresh

**Input**: Design documents from `/specs/001-rider-home-services/`

**Prerequisites**: `plan.md`, `spec.md`

**Tests**: Include targeted widget tests for the refreshed home flow and bottom navigation.

## Phase 1: Setup

- [x] T001 Review current rider home, destination, routes, and tests in `lib/screens/` and `test/`
- [x] T002 Capture Speckit feature metadata in `specs/001-rider-home-services/`

## Phase 2: Foundational

- [x] T003 Add shared rider bottom navigation in `lib/screens/rider_bottom_nav.dart`
- [x] T004 Register the new services screen route in `lib/app/app_routes.dart`

## Phase 3: User Story 1 - New rider home (Priority: P1)

**Goal**: Replace the old rider landing view with the new discovery-style home.

**Independent Test**: Launch `AppRoutes.home` and verify the search-led discovery layout renders and routes into planning.

- [x] T005 Rebuild `lib/screens/home_screen.dart` with the new discovery sections and fixed bottom navigation
- [x] T006 Wire the home search affordance and relevant tiles to `AppRoutes.destination`
- [x] T007 Preserve recovery-state rendering on the refreshed home screen

## Phase 4: User Story 2 - Destination planning (Priority: P1)

**Goal**: Align destination planning with the provided plan-your-ride mockup and keep selection wired into booking.

**Independent Test**: Open `AppRoutes.destination`, select a destination, and verify the controller advances to fare estimation.

- [x] T008 Update `lib/screens/destination_search_screen.dart` to match the requested planning content more closely
- [x] T009 Keep destination selection updating `RideController` and navigating to `AppRoutes.fare`
- [x] T010 Update `test/rider_flow_test.dart` for the new direct home-to-destination path

## Phase 5: User Story 3 - Services screen (Priority: P2)

**Goal**: Add the new services screen and let riders switch to it from the bottom navigation.

**Independent Test**: Navigate from home to services and back via bottom navigation.

- [x] T011 Create `lib/screens/services_screen.dart` using the requested services layout
- [x] T012 Add focused navigation coverage in `test/home_services_navigation_test.dart`

## Phase 6: Polish & Validation

- [x] T013 Run `dart format` on touched Dart files
- [x] T014 Run `dart analyze` on changed screens and tests
- [x] T015 Run focused widget tests for rider flow, services navigation, and route coverage
