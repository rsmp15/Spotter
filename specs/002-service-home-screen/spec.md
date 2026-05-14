# Feature Specification: Service Home Screen

**Feature Branch**: `[002-service-home-screen]`

**Created**: 2026-05-14

**Status**: Draft

**Input**: User description: "add a homepage , or homescreen having listed different services a camouflag refer uber app"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Choose A Service From Home (Priority: P1)

As a rider, I need the home screen to show the main services Spotter offers, so that I can quickly choose whether I want a ride, a delivery-style task, saved places, wallet actions, or support without guessing where to start.

**Why this priority**: The home screen is the main entry point after role selection; if service choices are not clear, users cannot start the intended journey confidently.

**Independent Test**: Can be tested by opening the home screen and selecting each primary service option, confirming each option has a clear label, supporting context, and a valid next step.

**Acceptance Scenarios**:

1. **Given** a rider lands on the home screen, **When** the page loads, **Then** the rider sees a clearly grouped list of available services with recognizable labels and icons.
2. **Given** a rider wants to book transport, **When** they select a ride-related service, **Then** the app begins the existing pickup and destination flow.
3. **Given** a rider selects a non-ride service that is not fully available yet, **When** the selection is made, **Then** the app shows a clear coming-soon or unavailable state instead of a broken screen.

---

### User Story 2 - Start A Destination Search Quickly (Priority: P2)

As a rider, I need a prominent destination prompt on the home screen, so that I can start the most common ride-booking action without scanning all service cards first.

**Why this priority**: Ride booking remains the primary workflow, and users expect a familiar ride-hailing home pattern where destination search is immediately visible.

**Independent Test**: Can be tested by opening the home screen, activating the destination prompt, and confirming the destination flow starts in one action.

**Acceptance Scenarios**:

1. **Given** the rider is on the home screen, **When** they tap the primary destination prompt, **Then** the app moves to the destination or pickup flow.
2. **Given** the rider has saved or recent places available, **When** the home screen loads, **Then** the rider can see quick destination shortcuts without them overwhelming the service list.
3. **Given** no saved or recent places are available, **When** the home screen loads, **Then** the quick destination area is hidden or replaced by a useful empty state.

---

### User Story 3 - Navigate Supporting Actions (Priority: P3)

As a rider, I need supporting actions such as wallet, notifications, profile, and support to remain easy to access, so that service discovery does not hide account and help workflows.

**Why this priority**: A service-first home screen still needs predictable access to common account and operational actions.

**Independent Test**: Can be tested by opening the home screen and reaching each supporting action in no more than two taps.

**Acceptance Scenarios**:

1. **Given** a rider needs account or payment information, **When** they use home-screen shortcuts, **Then** wallet and profile remain reachable.
2. **Given** a rider has notifications, **When** the home screen loads, **Then** the notification action is visible and does not compete with the primary booking action.
3. **Given** a rider needs help, **When** they use the support entry point, **Then** the app opens the existing support flow or a clear support option.

### Edge Cases

- A service is configured but temporarily unavailable.
- A service is planned but not yet active.
- The user has no saved destinations, recent destinations, or active ride.
- The screen is opened on a small device where service cards could wrap or truncate.
- The user changes role from rider to driver and should not see rider-only actions as primary actions.
- The user opens the home screen while offline or while service availability is delayed.
- A service selection points to a route that cannot currently be opened.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST provide a home screen that presents Spotter's primary rider services as distinct selectable options.
- **FR-002**: The system MUST include ride-booking as the most prominent service and provide a one-action path into pickup or destination selection.
- **FR-003**: The system MUST list at least four service entries relevant to the current product direction, including ride booking, package or task delivery, wallet or payments, and support or safety.
- **FR-004**: Each service entry MUST include a short label, a concise supporting description, and a recognizable visual cue.
- **FR-005**: The system MUST preserve Spotter branding and avoid copying another company's protected brand assets, names, exact layout, or trade dress.
- **FR-006**: The home screen MUST use a familiar ride-hailing service-discovery pattern inspired by mainstream mobility apps while remaining visually distinct.
- **FR-007**: The system MUST provide clear states for active, unavailable, and coming-soon services.
- **FR-008**: The system MUST keep wallet, profile, notifications, and support reachable from the home screen without making them more prominent than the primary booking action.
- **FR-009**: The system MUST show quick destination shortcuts when recent or saved destination data exists.
- **FR-010**: The system MUST provide a useful empty state when recent or saved destination data is unavailable.
- **FR-011**: The system MUST handle failed or unknown service navigation with a user-facing fallback and a path back to the home screen.
- **FR-012**: The system MUST keep the service list usable on common phone screen sizes without clipped labels, overlapping actions, or inaccessible service entries.

### Key Entities

- **Home Service**: A selectable service offered from the home screen, with a label, description, visual cue, availability status, and target action.
- **Service Availability**: The current user-facing state of a service, such as active, unavailable, or coming soon.
- **Primary Destination Prompt**: The main home-screen action that starts the rider's pickup or destination journey.
- **Quick Destination**: A saved or recent place shown as a shortcut for repeat trips.
- **Supporting Action**: A secondary home-screen action such as wallet, profile, notifications, or support.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 90% of test users can identify the primary ride-booking action within 5 seconds of landing on the home screen.
- **SC-002**: Users can reach the pickup or destination flow from the home screen in one tap.
- **SC-003**: Users can reach every listed active service from the home screen in no more than two taps.
- **SC-004**: 100% of inactive or coming-soon services show a clear status instead of navigating to a broken or empty page.
- **SC-005**: The home screen displays service labels without truncation or overlap on common compact and standard phone sizes.
- **SC-006**: At least 80% of usability test participants describe the home screen as clear and service-oriented while still recognizing it as Spotter.
- **SC-007**: No reviewed screen uses another company's logo, protected product names, or exact visual identity as part of the Spotter home experience.

## Assumptions

- "Camouflag refer Uber app" is interpreted as an Uber-inspired service-discovery pattern, not a request to copy Uber branding, names, or exact visual identity.
- The first implementation should prioritize rider-facing home services because the existing rider home screen already exists and the user asked for a homepage or homescreen.
- Ride booking remains the primary service; package or task delivery, wallet or payments, and support or safety are included as service entries because they align with the current Spotter app flows.
- Driver-specific services should remain available through existing driver flows rather than becoming the primary content of the rider home screen.
- Detailed visual styling, layout structure, and route wiring decisions belong in the planning phase.
