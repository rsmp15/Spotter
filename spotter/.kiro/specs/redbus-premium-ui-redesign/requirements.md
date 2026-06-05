# Requirements Document

## Introduction

This feature covers the complete UI redesign of the Spotter Flutter application to match the design quality, cleanliness, spacing, and visual language of the RedBus mobile application. The redesign applies exclusively to the presentation layer — no business logic, APIs, navigation routes, state management, data models, or backend integrations are modified. The goal is to standardise the entire app on the RedBus Premium design system: clean white surfaces, a bold primary red, Inter typography, an 8pt spacing grid, and consistent component tokens across all 57 screens and 18 shared components.

---

## Glossary

- **Design_System**: The collection of `RBColors`, `RBTextStyles`, `RBSpacing`, and `RBRadius` design tokens defined in `lib/core/theme/redbus_theme.dart` and extended by this spec.
- **SpottColors / SpottTextStyles / SpottRadius / SpottSpacing**: The legacy dark-glass design token classes in `lib/core/theme/` that are superseded by the Design_System.
- **RBColors**: The canonical colour token class of the RedBus Premium Design_System.
- **RBTextStyles**: The canonical typography token class of the Design_System.
- **RBSpacing**: The canonical spacing token class of the Design_System.
- **RBRadius**: The canonical border-radius token class of the Design_System.
- **Surface**: A white (#FFFFFF) or off-white (#F8F8F8) background panel used instead of dark or glass-effect containers.
- **Primary_Red**: The brand primary colour `#D84E55` used for CTAs, active states, and brand accents.
- **Glass_Component**: Any widget that currently uses `GlassCard`, `GlassContainer`, `GlassScaffold`, or `SpottColors.glassSurface` / `SpottColors.glassHigh`.
- **CTA**: Call-to-action button — the primary interactive action on a screen.
- **Skeleton_Loader**: A shimmering placeholder widget shown during data-loading states.
- **Bottom_Sheet**: A modal panel that slides up from the bottom of the screen.
- **Bottom_Nav**: The persistent bottom navigation bar rendered by `FloatingBottomNav`.
- **Shimmer**: An animated highlight sweep used on Skeleton_Loaders to indicate loading.
- **Inter**: The sole typeface used across all text in the app.
- **8pt_Grid**: The spacing system where all margins, paddings, and gaps are multiples of 8 (values: 4, 8, 12, 16, 20, 24, 32, 40, 48).
- **Empty_State**: A full-area placeholder widget shown when a list or screen has no data to display.
- **Status_Chip**: A small inline badge used to display trip, booking, or parcel status.
- **Trust_Badge**: A small inline indicator displaying user verification level or premium status.
- **Route_Card**: A card component displaying an available trip/ride result in search results.
- **Sticky_CTA**: A `CTA` button fixed at the bottom of a scrollable screen that remains visible during scroll.

---

## Requirements

---

### Requirement 1: Design Token Consolidation

**User Story:** As a developer, I want a single authoritative set of design tokens, so that every screen and component references the same colours, spacing, radii, and typography without inconsistencies.

#### Acceptance Criteria

1. THE Design_System SHALL define `RBColors.primary` as `Color(0xFFD84E55)` and `RBColors.primaryDark` as `Color(0xFFB73D45)`.
2. THE Design_System SHALL define `RBColors.background` as `Color(0xFFF8F8F8)` and `RBColors.surface` as `Color(0xFFFFFFFF)`.
3. THE Design_System SHALL define `RBColors.textPrimary` as `Color(0xFF1D1D1D)` and `RBColors.textSecondary` as `Color(0xFF666666)`.
4. THE Design_System SHALL define `RBColors.border` as `Color(0xFFEAEAEA)`, `RBColors.success` as `Color(0xFF22C55E)`, `RBColors.warning` as `Color(0xFFF59E0B)`, and `RBColors.error` as `Color(0xFFEF4444)`.
5. THE Design_System SHALL define `RBRadius.button` as `16.0`, `RBRadius.card` as `20.0`, `RBRadius.input` as `16.0`, `RBRadius.bottomSheet` as `24.0`, and `RBRadius.searchContainer` as `24.0`.
6. THE Design_System SHALL define `RBSpacing` values: `xs = 4.0`, `sm = 8.0`, `md = 12.0`, `lg = 16.0`, `xl = 20.0`, `xxl = 24.0`, `xxxl = 32.0`, `xxxxl = 40.0`, `xxxxxl = 48.0`.
7. THE Design_System SHALL define `RBTextStyles` entries for Display (28px/w800), Heading (22px/w700), Subheading (18px/w700), Body (15px/w400), BodyMedium (15px/w500), Caption (12px/w400), and CaptionMedium (12px/w500), all using the `Inter` font family.
8. WHEN a screen or component references a colour, spacing, radius, or text style, THE Design_System SHALL be the sole source — no hard-coded hex literals, numeric padding values, or raw `TextStyle` objects SHALL appear outside of `redbus_theme.dart`.
9. THE Design_System SHALL expose a `RBShadows` utility with at least one `cardShadow` value defined as `BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4))` for subtle soft elevation.
10. IF SpottColors, SpottTextStyles, SpottSpacing, or SpottRadius are referenced anywhere in the codebase, THEN THE Design_System SHALL provide a deprecated alias or the reference SHALL be migrated to the RB-prefixed equivalent.

---

### Requirement 2: Global Surface and Background Replacement

**User Story:** As a user, I want all screens to feel clean, bright, and modern, so that the app no longer looks like a dark glass-effect interface.

#### Acceptance Criteria

1. THE App SHALL render every screen scaffold with `backgroundColor: RBColors.background` (`#F8F8F8`) replacing all current dark-background scaffolds.
2. THE App SHALL replace every `GlassScaffold` usage with a standard `Scaffold` using `RBColors.background`.
3. THE App SHALL replace every `GlassCard` and `GlassContainer` usage with a `Container` or `Card` using `color: RBColors.surface` with `RBShadows.cardShadow` and `borderRadius: RBRadius.card`.
4. THE App SHALL remove all `BackdropFilter` blur effects from production UI widgets.
5. WHEN a section requires visual separation, THE App SHALL use a `RBColors.border`-coloured border or `RBShadows.cardShadow` — not glass overlays or dark surfaces.
6. THE App SHALL set `SystemUiOverlayStyle` to a light status bar (dark icons) on all screens that use a white/grey header, and a dark status bar (light icons) on all screens with a `RBColors.primary` coloured header.

---

### Requirement 3: Typography System Migration

**User Story:** As a user, I want consistent, readable text throughout the app, so that every label, heading, and body copy feels part of a unified system.

#### Acceptance Criteria

1. THE App SHALL use only the `Inter` font family for all text rendered in the app.
2. THE App SHALL replace all `SpottTextStyles` references with the corresponding `RBTextStyles` variant based on visual hierarchy: display → `RBTextStyles.display`, section headers → `RBTextStyles.heading`, card titles → `RBTextStyles.subheading`, body text → `RBTextStyles.body`, metadata → `RBTextStyles.caption`.
3. THE App SHALL render heading text (`RBTextStyles.display`, `RBTextStyles.heading`) with `color: RBColors.textPrimary`.
4. THE App SHALL render secondary and descriptive text with `color: RBColors.textSecondary`.
5. THE App SHALL not use `SpottColors.textPrimary`, `SpottColors.textSecondary`, or `SpottColors.textTertiary` for any new or migrated text widget.
6. WHEN text appears on a `RBColors.primary` coloured background, THE App SHALL render that text with `color: Colors.white` regardless of whether the text role would otherwise use `RBColors.textSecondary`.

---

### Requirement 4: Home Screen Redesign

**User Story:** As a passenger, I want a clean, welcoming home screen, so that I can quickly access search, services, and key information at a glance.

#### Acceptance Criteria

1. THE Home_Screen SHALL render a solid `RBColors.primary` header bar containing the Spotter logo, a greeting message, a notifications icon, and a profile avatar.
2. THE Home_Screen SHALL render a white Surface search card that overlaps the bottom edge of the primary header, with `borderRadius: RBRadius.searchContainer` and `RBShadows.cardShadow`.
3. THE Home_Screen SHALL render From/To city fields inside the search card with a vertical-line separator and a circular swap button using `RBColors.primary` border.
4. THE Home_Screen SHALL render a Date selector input box and a Passengers selector input box side by side below the From/To fields, each with `borderRadius: RBRadius.input` and `border: RBColors.border`.
5. THE Home_Screen SHALL render a full-width "SEARCH RIDES" CTA button inside the search card with `height: 52` (exact value required), `borderRadius: RBRadius.button`, and `backgroundColor: RBColors.primary`.
6. THE Home_Screen SHALL render a horizontally scrollable Offers & Deals section below the search card with promotional banner cards.
7. THE Home_Screen SHALL render a horizontally scrollable Popular Routes section with route chips using `RBColors.surface`, `RBRadius.card`, and `RBShadows.cardShadow`.
8. THE Home_Screen SHALL render a 3-column Quick Services grid using white Surface tiles with coloured icon containers and Inter labels.
9. THE Home_Screen SHALL render promotional full-width banner cards (Parcel Delivery, Become a Traveler) using gradient backgrounds and a white CTA button.
10. THE Home_Screen SHALL not use any Glass_Component, dark surface, or `SpottColors` reference.

---

### Requirement 5: Search Screen Redesign

**User Story:** As a passenger, I want large, easy-to-tap search fields and a prominent search button, so that searching for rides feels fast and effortless.

#### Acceptance Criteria

1. THE Trip_Search_Screen SHALL render a sticky `RBColors.primary` app bar with a back arrow and "Search Rides" title in white.
2. THE Trip_Search_Screen SHALL render a white Surface container with `borderRadius: RBRadius.searchContainer` containing From and To location fields separated by a horizontal divider and a swap icon button.
3. THE Trip_Search_Screen SHALL render the From and To fields at a minimum touch target height of 56px — this constraint is independent and SHALL be satisfied regardless of other UI element height requirements on the same screen.
4. THE Trip_Search_Screen SHALL render a date selector row and a passenger count selector row below the From/To container, each using `borderRadius: RBRadius.input` and icon-prefixed label layout.
5. THE Trip_Search_Screen SHALL render a full-width "SEARCH" CTA at the bottom of the form with `height: 52`, `borderRadius: RBRadius.button`, and `backgroundColor: RBColors.primary`.
6. THE Destination_Search_Screen SHALL render a full-width text input at the top with `borderRadius: RBRadius.input`, `fillColor: RBColors.surface`, and a magnifying-glass prefix icon in `RBColors.textSecondary`.
7. WHEN the Destination_Search_Screen has no query entered, THE Destination_Search_Screen SHALL render a list of recent search suggestions with a clock icon in `RBColors.textSecondary`. WHEN the user begins typing a query, THE Destination_Search_Screen SHALL hide the recent suggestions and render only live search results.

---

### Requirement 6: Search Results Screen Redesign

**User Story:** As a passenger, I want clearly structured ride result cards, so that I can quickly compare options and select the best one.

#### Acceptance Criteria

1. THE Search_Results_Screen SHALL render a sticky header with the route summary (From → To), date, and passenger count on a `RBColors.primary` background.
2. THE Search_Results_Screen SHALL render each available trip as a Route_Card widget using `RBColors.surface`, `borderRadius: RBRadius.card`, and `RBShadows.cardShadow`.
3. THE Route_Card SHALL render the driver name, departure time, and arrival time as primary content in `RBTextStyles.subheading` / `RBTextStyles.heading`.
4. THE Route_Card SHALL render the price in `RBColors.primary` using `RBTextStyles.heading` weight.
5. THE Route_Card SHALL render a "Book Now" CTA button aligned to the right with `borderRadius: RBRadius.button`, `backgroundColor: RBColors.primary`, and visible on the card without scrolling.
6. THE Route_Card SHALL render secondary metadata (seats available, vehicle type, amenities) in `RBTextStyles.caption` with `color: RBColors.textSecondary`.
7. WHEN the Search_Results_Screen has no results, THE Search_Results_Screen SHALL render the No_Results Empty_State component. IF the screen state indicates no results but cached route data exists, THE Search_Results_Screen SHALL render the cached Route_Cards rather than the Empty_State.
8. WHEN the Search_Results_Screen is loading, THE Search_Results_Screen SHALL render at least 3 Skeleton_Loader cards matching the Route_Card layout.
9. THE Search_Results_Screen SHALL render a filter row below the sticky header using horizontally scrollable filter chips with `borderRadius: RBRadius.pill`.

---

### Requirement 7: Trip Detail and Ride Detail Screens Redesign

**User Story:** As a passenger, I want a well-organised detail screen with a clearly visible booking button, so that I can review all trip information before confirming.

#### Acceptance Criteria

1. THE Trip_Details_Screen SHALL render a `RBColors.primary` header containing the route title and a back arrow.
2. THE Trip_Details_Screen SHALL render content in clearly separated white Surface sections, each with `borderRadius: RBRadius.card`, `RBShadows.cardShadow`, and `RBSpacing.lg` vertical gap between sections.
3. THE Trip_Details_Screen SHALL render driver information (avatar, name, rating, verification status) as the first content section below the header.
4. THE Trip_Details_Screen SHALL render route details (departure/arrival times, stops, duration) as the second content section.
5. THE Trip_Details_Screen SHALL render a Sticky_CTA bar fixed at the bottom of the screen showing total price in `RBColors.primary` and a "Book Ride" button with `borderRadius: RBRadius.button` and `backgroundColor: RBColors.primary`.
6. THE Sticky_CTA bar SHALL remain visible above the system navigation bar using `SafeArea` at a height of 72px.
7. THE Trip_Details_Screen SHALL render vehicle and amenity information as tertiary content using icon-label pairs in `RBTextStyles.caption`.

---

### Requirement 8: Profile Screen Redesign

**User Story:** As a user, I want a modern, well-organised profile screen, so that I can view my stats, manage settings, and access account actions clearly.

#### Acceptance Criteria

1. THE Profile_Screen SHALL render a large profile header section on a `RBColors.primary` background containing avatar, display name, phone number, and a verification status badge.
2. THE Profile_Screen SHALL render statistics (total trips, ratings, parcels sent) as a horizontal row of white Surface stat cards with `borderRadius: RBRadius.card` and `RBShadows.cardShadow` directly below the profile header.
3. THE Profile_Screen SHALL render settings and account actions as grouped `ListTile` rows inside white Surface containers, with a visible section header label in `RBTextStyles.caption` with `color: RBColors.textSecondary`.
4. THE Profile_Screen SHALL group settings into at least three sections: Account, Preferences, and Support.
5. THE Profile_Screen SHALL render a "Sign Out" action as a standalone destructive row in `RBColors.error` at the bottom of the settings list.
6. THE Profile_Screen SHALL not render any Glass_Component or dark-surface widget.
7. WHEN the Profile_Screen user has completed KYC verification, THE Profile_Screen SHALL render a Trust_Badge indicating "Verified" status using `RBColors.success` — the Trust_Badge SHALL always render for verified users, and the screen SHALL be considered non-compliant if the badge cannot be displayed.

---

### Requirement 9: Forms and Input Fields Redesign

**User Story:** As a user, I want form inputs that are easy to read, clearly labelled, and visually consistent, so that filling in details feels smooth and error-free.

#### Acceptance Criteria

1. THE App SHALL render all `TextField` and `TextFormField` inputs with `fillColor: RBColors.surface`, `borderRadius: RBRadius.input`, `enabledBorderColor: RBColors.border`, and `focusedBorderColor: RBColors.primary`.
2. THE App SHALL render all input labels using `RBTextStyles.caption` with `color: RBColors.textSecondary` as floating or above-field labels.
3. THE App SHALL render all input fields at a minimum height of 56px for comfortable touch interaction.
4. WHEN a form field contains a validation error, THE App SHALL render the error message text in `color: RBColors.error` below the input using `RBTextStyles.caption`.
5. WHEN a form field passes validation, THE App SHALL not show any additional icon or colour change on the border.
6. THE App SHALL render all form submit buttons using `borderRadius: RBRadius.button`, `height: 52`, and `backgroundColor: RBColors.primary`.
7. THE KYC_Verification_Screen, Create_Trip_Screen, and Parcel_Booking_Screen SHALL comply with acceptance criteria 1 through 6 of this requirement.

---

### Requirement 10: Bottom Navigation Redesign

**User Story:** As a user, I want a clean, modern bottom navigation bar, so that switching between app sections is intuitive and visually consistent.

#### Acceptance Criteria

1. THE Bottom_Nav SHALL render on a `RBColors.surface` white background with a top border of `RBColors.border` and a subtle `RBShadows.cardShadow`.
2. THE Bottom_Nav SHALL render each navigation icon at 24px with a label in `RBTextStyles.caption` below.
3. WHEN a navigation item is active, THE Bottom_Nav SHALL render the icon and label in `RBColors.primary`.
4. WHEN a navigation item is inactive, THE Bottom_Nav SHALL render the icon and label in `RBColors.textSecondary`.
5. THE Bottom_Nav SHALL not use the default `BottomNavigationBar` Flutter widget styling, `SpottColors`, or any glass/blur effect.
6. THE Bottom_Nav SHALL include a centred, elevated circular "+" action button in `RBColors.primary` for the Create Trip action, at 56px diameter.

---

### Requirement 11: Button Component Standardisation

**User Story:** As a developer, I want a standard set of button variants, so that every screen uses consistent interactive elements without custom per-screen button styling.

#### Acceptance Criteria

1. THE App SHALL provide a primary button variant with `backgroundColor: RBColors.primary`, `foregroundColor: Colors.white`, `height: 52`, `borderRadius: RBRadius.button`, and label in `RBTextStyles.buttonLabel`.
2. THE App SHALL provide an outlined button variant with `border: RBColors.primary`, `foregroundColor: RBColors.primary`, `height: 52`, `borderRadius: RBRadius.button`, and `backgroundColor: transparent`.
3. THE App SHALL provide a ghost/text button variant with no border, `foregroundColor: RBColors.primary`, and label in `RBTextStyles.body`.
4. WHEN the primary button is in a loading state, THE primary button SHALL render a `CircularProgressIndicator` in `Colors.white` at 20px in place of the label text, and SHALL disable tap interaction.
5. WHEN any button variant (primary, outlined, or ghost) is in a disabled state, THE button SHALL render with `backgroundColor: RBColors.border` (or transparent with `borderColor: RBColors.border` for outlined), `foregroundColor: RBColors.textSecondary`, and SHALL not respond to taps — all variants share the same disabled styling behaviour.
6. THE App SHALL migrate all existing `SpottButtons` usages to the standardised button variants described above.

---

### Requirement 12: Empty State Components

**User Story:** As a user, I want informative and visually consistent empty states, so that I understand why a screen has no content and know what action to take.

#### Acceptance Criteria

1. THE App SHALL provide distinct Empty_State configurations for: No Results, No Trips, No Transactions, No Notifications, and No Bookings.
2. THE Empty_State SHALL render a centred illustration or icon in `RBColors.primary.withOpacity(0.12)` container, a heading in `RBTextStyles.heading` with `color: RBColors.textPrimary`, and a description in `RBTextStyles.body` with `color: RBColors.textSecondary`. IF the illustration asset fails to load, THE Empty_State SHALL display only the heading and description text without the illustration.
3. WHERE the Empty_State has a recoverable action (e.g., "Search for Rides", "Try Again"), THE Empty_State SHALL render a primary CTA button below the description.
4. THE Empty_State SHALL use `RBColors.background` as its background — not dark or glass surfaces.
5. THE No_Results_Screen, Empty_State_Screen, and inline empty states in the Activity_Screen, Notifications_Screen, and Parcel_History_Screen SHALL comply with acceptance criteria 1 through 4 of this requirement.

---

### Requirement 13: Loading and Skeleton State Components

**User Story:** As a user, I want smooth, consistent loading placeholders, so that the app feels responsive and polished while data is being fetched.

#### Acceptance Criteria

1. THE Shimmer_Loading component SHALL animate using a sweep of `RBColors.shimmerBase` to `RBColors.shimmerHighlight` (both light grey tones appropriate for a white Surface background).
2. THE Skeleton_Route_Card SHALL mirror the layout dimensions of the Route_Card: a header block, two or more rows of content blocks, and a right-aligned price/CTA block — implementations with more than two content rows are acceptable.
3. THE App SHALL render Skeleton_Loader placeholders for Search_Results_Screen, Activity_Screen, Parcel_History_Screen, Notifications_Screen, and Passenger_Trips_Screen during their initial load state.
4. WHEN data loading completes, THE App SHALL replace Skeleton_Loader instances with real content using a fade-in transition of 200ms duration.
5. THE Skeleton_Loader components SHALL use `RBColors.surface` as the base card background and `RBColors.background` as the overall screen background — never dark colours.

---

### Requirement 14: Animations and Micro-interactions

**User Story:** As a user, I want subtle, professional animations, so that the app feels fluid and premium without being distracting.

#### Acceptance Criteria

1. THE App SHALL apply a `FadeTransition` with a 250ms duration for all primary page route transitions.
2. WHEN a tappable card is pressed, THE card SHALL scale down to 0.97 using an `AnimatedScale` or `GestureDetector` with a 100ms animation — providing press feedback.
3. WHEN a Bottom_Sheet is opened, THE Bottom_Sheet SHALL slide up using a 300ms `CurvedAnimation` with `Curves.easeOutCubic` — the 300ms duration is exact and any deviation SHALL be considered a violation.
4. WHEN a list of cards is first rendered, THE App SHALL stagger-animate each card in with a `SlideTransition` (from bottom, 12px offset) and `FadeTransition` at 60ms interval between items.
5. WHEN a primary button is tapped, THE App SHALL trigger `HapticFeedback.lightImpact()`.
6. THE App SHALL not use bounce, overshoot, or spring animations on any UI element — all animations SHALL use ease-in-out or ease-out curves.
7. THE App SHALL not add animations that increase perceived page load time or delay user interaction.

---

### Requirement 15: Status Chip Standardisation

**User Story:** As a user, I want clear, colour-coded status indicators, so that I can instantly understand the state of a trip, parcel, or booking.

#### Acceptance Criteria

1. THE Status_Chip SHALL render "Confirmed" / "Active" / "Completed" statuses with `backgroundColor: RBColors.success.withOpacity(0.12)` and `textColor: RBColors.success`.
2. THE Status_Chip SHALL render "Pending" / "Waiting" statuses with `backgroundColor: RBColors.warning.withOpacity(0.12)` and `textColor: RBColors.warning`.
3. THE Status_Chip SHALL render "Cancelled" / "Failed" / "Rejected" statuses with `backgroundColor: RBColors.error.withOpacity(0.12)` and `textColor: RBColors.error`.
4. THE Status_Chip SHALL use `borderRadius: RBRadius.pill`, `RBTextStyles.caption` for the label, and horizontal padding of `RBSpacing.sm` (8px).
5. THE Status_Chip SHALL not render with any dark background or glass surface — glass surface effects are prohibited on all Status_Chip instances regardless of visual hierarchy context.

---

### Requirement 16: Trust Badge Standardisation

**User Story:** As a user, I want to clearly see which drivers and passengers are verified, so that I can make informed decisions about safety.

#### Acceptance Criteria

1. THE Trust_Badge SHALL render a "Verified" badge with a check-circle icon in `RBColors.success` and label "Verified" in `RBTextStyles.caption` with `color: RBColors.success`.
2. THE Trust_Badge SHALL render a "Premium" badge with a star icon in `RBColors.warning` and label "Premium" in `RBTextStyles.caption` with `color: RBColors.warning`.
3. THE Trust_Badge SHALL render on a white or `RBColors.background` surface — not on dark or glass backgrounds.
4. THE Trust_Badge SHALL have a minimum touch target of 24x24px.

---

### Requirement 17: Onboarding, Splash, and Auth Screens Redesign

**User Story:** As a new user, I want the first-run screens to match the premium style of the rest of the app, so that my first impression is consistent and professional.

#### Acceptance Criteria

1. THE Splash_Screen SHALL render the Spotter wordmark and icon centred on a `RBColors.primary` background, fading in over 400ms.
2. THE Onboarding_Screen SHALL render slides with white Surface cards, `RBColors.primary` page indicator dots for active pages, and a "Get Started" CTA button using the primary button variant.
3. THE Login_Screen and OTP_Verification_Screen SHALL use `RBColors.background` scaffold, white Surface input cards, and form inputs compliant with Requirement 9.
4. THE Choose_Role_Screen SHALL render two large selection cards on `RBColors.background` with `borderRadius: RBRadius.card`, `RBShadows.cardShadow`, and an active selection state indicated by a `RBColors.primary` border.
5. THE Verification_Pending_Screen SHALL render a centred illustration, a status heading in `RBTextStyles.heading`, and a description in `RBTextStyles.body` on `RBColors.background`.

---

### Requirement 18: Parcel Flow Screen Redesign

**User Story:** As a user sending a parcel, I want a clean, step-by-step flow that matches the rest of the app's visual style, so that the booking process feels premium and trustworthy.

#### Acceptance Criteria

1. THE Parcel_Booking_Screen SHALL use `RBColors.background` scaffold, white Surface form sections, and input fields compliant with Requirement 9.
2. THE Parcel_Booking_Screen SHALL render a multi-step progress indicator using `RBColors.primary` for completed/active steps and `RBColors.border` for pending steps.
3. THE Parcel_Tracking_Screen SHALL render a timeline of parcel status steps using icon-colour mapping from Requirement 15 (success/warning/error colours).
4. THE Parcel_History_Screen SHALL render each parcel entry as a white Surface card with `borderRadius: RBRadius.card` and `RBShadows.cardShadow`.
5. THE Parcel_Complete_Screen SHALL render a large success icon in `RBColors.success`, a heading, a summary card, and a primary CTA button to return home.

---

### Requirement 19: Ride Flow Screen Redesign

**User Story:** As a passenger confirming or managing a ride, I want all ride-flow screens to be visually consistent and clearly communicate status, so that the booking and active-trip experience feels reliable.

#### Acceptance Criteria

1. THE Ride_Confirmation_Screen SHALL render a summary card (route, driver, price, seats) on `RBColors.surface` with `borderRadius: RBRadius.card`, a Sticky_CTA "Confirm & Pay" button, and `RBColors.primary` for price text.
2. THE Payment_Screen SHALL render payment method options as white Surface selection cards with a `RBColors.primary` radio indicator for the selected option.
3. THE Booking_Success_Screen SHALL render a large animated checkmark in `RBColors.success`, a booking reference, a trip summary card, and a "View Booking" primary CTA.
4. THE Active_Trip_Screen SHALL render a persistent status bar at the top in `RBColors.primary` showing live trip status text in white.
5. THE Ride_Complete_Screen SHALL render a success confirmation layout matching Requirement 19, criterion 3, substituting the "View Booking" label with "Rate Your Ride".
6. THE Cancel_Ride_Screen SHALL render a confirmation card with the reason selector as a list of selectable white Surface chips and a destructive "Cancel Ride" button in `RBColors.error` style.
7. THE Rating_Screen SHALL render star icons in `RBColors.warning` for selected stars and `RBColors.border` for unselected stars, with a comment input field compliant with Requirement 9.

---

### Requirement 20: Utility, Support, and Miscellaneous Screen Redesign

**User Story:** As a user, I want every secondary screen (safety, support, notifications, settings) to feel as polished as the main screens, so that the entire app is visually cohesive.

#### Acceptance Criteria

1. THE Safety_Toolkit_Screen SHALL render safety features as white Surface info cards with coloured left-border accents and icon-label rows.
2. THE Support_Screen SHALL render support topic categories as a grouped list on `RBColors.background` with white Surface section containers and `RBColors.primary` icons.
3. THE Notifications_Screen SHALL render notification items as white Surface cards with a left-side unread indicator dot in `RBColors.primary` for unread items.
4. THE Settings_Screen SHALL render settings as grouped `ListTile` rows in white Surface containers on `RBColors.background`, identical to the profile settings pattern in Requirement 8.
5. THE Maintenance_Screen and Network_Error_Screen SHALL render centred icon + heading + description + retry button layouts on `RBColors.background`, compliant with the Empty_State pattern in Requirement 12.
6. THE Live_Tracking_Screen SHALL render an overlay card at the bottom of the map using `RBColors.surface`, `borderRadius: RBRadius.bottomSheet`, and `RBShadows.cardShadow`.
7. THE Chat_Screen SHALL render sent message bubbles in `RBColors.primary` with white text, and received message bubbles in `RBColors.surface` with `RBColors.textPrimary` text.

---

### Requirement 21: Driver-Side Screen Redesign

**User Story:** As a driver (traveler), I want my home and trip management screens to have the same premium look as the passenger-side app, so that the experience feels unified.

#### Acceptance Criteria

1. THE Driver_Home_Screen SHALL use a `RBColors.primary` header, white Surface content cards, and comply with the Design_System tokens for all typography, spacing, and radii — screens that omit white Surface content cards SHALL be considered non-compliant even if the header colour and design tokens are otherwise correct.
2. THE Driver_Matches_Screen SHALL render each passenger match as a white Surface card with `borderRadius: RBRadius.card`, `RBShadows.cardShadow`, and an "Accept" primary button and "Decline" outlined button side by side — comprehensive Design_System token compliance is required for all typography, spacing, and colour beyond the explicitly listed tokens.
3. THE Traveler_Trips_Screen and Passenger_Trips_Screen SHALL render trip history as white Surface cards grouped by date section headers in `RBTextStyles.caption` with `color: RBColors.textSecondary` — comprehensive Design_System compliance for all tokens is required, not only the caption style and text colour.
4. THE Job_Requests_Screen SHALL render pending requests as white Surface cards with a Status_Chip in the top-right corner, and SHALL comply with Design_System tokens for all typography, spacing, colour, and radius values.
5. THE Vehicle_Management_Screen SHALL render the vehicle entry form compliant with Requirement 9, and each saved vehicle as a white Surface card with `borderRadius: RBRadius.card`.

---

### Requirement 22: No Business Logic or Functional Regression

**User Story:** As a developer, I want the UI redesign to be strictly limited to the presentation layer, so that no existing functionality, navigation, or data handling is broken.

#### Acceptance Criteria

1. THE App SHALL not modify any `Provider`, `ChangeNotifier`, `StateNotifier`, controller, service, or repository class during the UI redesign.
2. THE App SHALL not modify any model class, data transfer object, or serialisation logic.
3. THE App SHALL not modify any `AppRoutes` route definitions or navigation push/pop calls.
4. THE App SHALL not modify any Firebase, Firestore, REST API, or local database query.
5. WHEN a screen is redesigned, THE screen SHALL navigate to the same destination routes as before the redesign.
6. WHEN a screen is redesigned, THE screen SHALL display the same data fields sourced from the same controllers as before the redesign.
7. THE App SHALL pass all existing integration tests and widget tests after the redesign is applied (no test covering business logic or navigation SHALL break as a result of UI changes).
