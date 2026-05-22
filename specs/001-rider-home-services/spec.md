# Feature Specification: Rider Home, Destination, and Services Refresh

**Feature Branch**: `001-rider-home-services`

**Created**: 2026-05-14

**Status**: Implemented

**Input**: User description: "Replace the old home screen with the new rider discovery home, navigate to the new plan-your-ride screen, and add the new services screen."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Open ride discovery from the new home screen (Priority: P1)

As a rider, I want the landing screen to look like the new Uber-style discovery home so the first screen feels modern and I can start booking from the main search affordance.

**Why this priority**: This is the first screen of the rider journey and the primary entry point into booking.

**Independent Test**: Launch the app on `AppRoutes.home`, confirm the new discovery layout renders, and tap the main search header to enter ride planning.

**Acceptance Scenarios**:

1. **Given** the rider is on the home screen, **When** the screen renders, **Then** the new discovery layout shows the search header, recent destinations, suggestions, promotional sections, and bottom navigation.
2. **Given** the rider is on the home screen, **When** they tap `Where to?`, **Then** the app opens the plan-your-ride destination flow.

---

### User Story 2 - Select a destination from the new planning screen (Priority: P1)

As a rider, I want the destination selection screen to match the provided plan-your-ride mockup so I can quickly choose where I am going.

**Why this priority**: The destination selection step is the critical bridge between discovery and booking.

**Independent Test**: Open `AppRoutes.destination`, tap a result item, and verify the app advances to fare estimation with the selected destination stored in the controller.

**Acceptance Scenarios**:

1. **Given** the rider is on the planning screen, **When** they see the location list, **Then** the screen shows the provided pickup display, saved places, and a keyboard-style footer.
2. **Given** the rider taps a destination result, **When** the selection completes, **Then** the controller destination updates and the app navigates to `AppRoutes.fare`.

---

### User Story 3 - Browse the new services screen from bottom navigation (Priority: P2)

As a rider, I want a dedicated services screen in the bottom nav so I can browse ride, package, rentals, and related service types.

**Why this priority**: It is a secondary top-level destination that supports discovery beyond the default home screen.

**Independent Test**: From home, tap `Services`, verify the services layout appears, then tap `Home` and verify the app returns to the discovery home.

**Acceptance Scenarios**:

1. **Given** the rider is on the home screen, **When** they tap `Services`, **Then** the app opens the new services screen with the expected primary and secondary service grids.
2. **Given** the rider is on the services screen, **When** they tap `Home`, **Then** the app returns to the home discovery screen.

### Edge Cases

- If network images fail to load, the UI should still render usable fallbacks.
- If the rider taps the currently active bottom-nav tab, the app should not push duplicate routes.
- If the controller has an action failure state, the new home and destination screens should still surface the recovery banner.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST replace the existing rider home screen with the provided discovery-style layout.
- **FR-002**: The system MUST allow the rider to open the destination-planning screen from the home search affordance.
- **FR-003**: The system MUST render the provided plan-your-ride layout and allow destination selection from its result list.
- **FR-004**: The system MUST add a dedicated `Services` route and screen to the route registry.
- **FR-005**: The system MUST provide bottom navigation that allows switching between home and services and offers entry points to activity and account screens.
- **FR-006**: The system MUST preserve the downstream rider flow from destination selection through fare, driver, payment, tracking, and rating.
- **FR-007**: The system MUST provide visual fallbacks when remote illustration assets are unavailable.

### Key Entities *(include if feature involves data)*

- **Discovery Destination**: A tappable destination preview shown on home and plan-your-ride screens that can update the ride controller destination.
- **Service Entry**: A top-level service tile shown on the services screen and, in compact form, on the home suggestions grid.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Riders can move from home to the planning screen in one tap.
- **SC-002**: Riders can move from destination selection to fare estimation in one tap without errors.
- **SC-003**: Riders can switch between home and services using the bottom navigation during widget tests.
- **SC-004**: Route coverage and rider flow widget tests continue to pass after the UI refresh.

## Assumptions

- Remote illustration URLs are acceptable for mock fidelity as long as offline/icon fallbacks exist.
- Existing notifications and profile screens are sufficient targets for the `Activity` and `Account` bottom-nav items.
- The legacy pickup screen remains in the app but is no longer the primary path from the new rider home screen.
