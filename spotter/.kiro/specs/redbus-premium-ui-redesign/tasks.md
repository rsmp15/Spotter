# Implementation Plan: RedBus Premium UI Redesign

## Overview

Migrate the Spotter Flutter app from its dark glass-effect UI to the RedBus Premium design system. All changes are strictly presentational — only `lib/core/theme/`, `lib/core/components/`, `lib/screens/`, and `pubspec.yaml` are touched. No controllers, models, repositories, routes, state management, or test files are modified. Each sub-task corresponds to exactly one file change.

---

## Tasks

- [ ] 1. Phase 1 — Token Foundation
  - [ ] 1.1 Update `lib/core/theme/redbus_theme.dart` with complete RB token classes
    - Update `RBColors` with all brand, background, text, semantic, UI chrome, shimmer, and legacy alias values as specified in §2.1
    - Update `RBTextStyles` with all 8 named variants (display, heading, subheading, body, bodyMedium, caption, captionMedium, buttonLabel) plus legacy aliases as specified in §2.2 — all using `fontFamily: 'Inter'`
    - Update `RBSpacing` with all 9 values plus semantic aliases (`pageH`, `cardInner`, `pageBottom`) as specified in §2.3
    - Update `RBRadius` with all numeric and semantic aliases (`button`, `card`, `input`, `bottomSheet`, `searchContainer`, `pill`) as specified in §2.4
    - Add `RBShadows` class with `cardShadow`, `navShadow`, `searchShadow`, and `buttonShadow` as specified in §2.5
    - _Requirements: 1.1–1.10_

- [ ] 2. Phase 12 — Font & pubspec (can run in parallel with Phase 1)
  - [ ] 2.1 Update `pubspec.yaml` to declare the Inter font family
    - Add `fonts:` section declaring the `Inter` family with weights 400, 500, 600, 700, 800 mapped to font asset files under `fonts/` directory as specified in §6
    - _Requirements: 3.1_

- [ ] 3. Phase 2 — Shared Components
  - [ ] 3.1 Rewrite `lib/core/components/spott_buttons.dart` with RB button variants
    - Remove all `GlassContainer`, `SpottGradients`, `SpottShadows`, `SpottColors` references
    - Implement Primary variant: `backgroundColor: RBColors.primary`, `foregroundColor: Colors.white`, `height: 52`, `borderRadius: RBRadius.button`
    - Implement Outlined variant: transparent background, `RBColors.primary` 1.5px border, `height: 52`, `borderRadius: RBRadius.button`
    - Implement Ghost variant: no border, `foregroundColor: RBColors.primary`
    - Implement Disabled state for all variants: `backgroundColor: RBColors.border`, `foregroundColor: RBColors.textSecondary`, no tap response
    - Implement Loading state: white `CircularProgressIndicator` at 20px, taps disabled
    - Implement press animation: `AnimatedScale` to 0.97 over 100ms with `Curves.easeOut` + `HapticFeedback.lightImpact()`
    - _Requirements: 11.1–11.6_

  - [ ] 3.2 Rewrite `lib/core/components/status_chip.dart` with RB semantic colours
    - Replace all `SpottColors` references with `RBColors` equivalents
    - Remove `SpottColors.glassSurface` — replace with plain `RBColors.surface`
    - Map `verified/approved/delivered` → `RBColors.success` bg/text; `pending/inTransit` → `RBColors.warning`; `rejected` → `RBColors.error`; `neutral` → `RBColors.border` / `textSecondary`
    - Apply `borderRadius: RBRadius.pill`, horizontal padding `RBSpacing.sm`, label in `RBTextStyles.caption`
    - _Requirements: 15.1–15.5_

  - [ ] 3.3 Update `lib/core/components/trust_badge.dart` with RB token references
    - Replace `SpottColors.trustVerified` → `RBColors.success`
    - Replace `SpottColors.warningSoft` → `RBColors.warning.withOpacity(0.12)`
    - Replace `SpottColors.warning` → `RBColors.warning`
    - Replace `SpottColors.textSecondary` / `textTertiary` → `RBColors.textSecondary`
    - Replace `SpottColors.surface3` → `RBColors.background`
    - Replace `SpottColors.border` → `RBColors.border`
    - Replace `SpottTextStyles.caption` → `RBTextStyles.caption`
    - Ensure minimum touch target of 24×24px
    - _Requirements: 16.1–16.4_

  - [ ] 3.4 Rewrite `lib/core/components/route_card.dart` with RB design
    - Replace `GlassCard` wrapper with plain `Container` using `RBColors.surface`, `RBRadius.card`, `RBShadows.cardShadow`
    - Replace all `SpottColors` / `SpottTextStyles` references with RB equivalents (driver name in `RBTextStyles.subheading`, price in `RBColors.primary` + `RBTextStyles.heading`, metadata in `RBTextStyles.caption` + `RBColors.textSecondary`)
    - Replace route dots: origin → `RBColors.success`, line → `RBColors.border`, destination → `RBColors.primary`
    - Add "Book Now" outlined button (RB Outlined variant, `RBColors.primary`, `borderRadius: RBRadius.button`) at bottom-right of card
    - _Requirements: 6.2–6.6_

  - [ ] 3.5 Rewrite `lib/core/components/skeleton_route_card.dart` with RB surfaces
    - Replace `GlassCard` wrapper with `Container(color: RBColors.surface, borderRadius: BorderRadius.circular(RBRadius.card))`
    - Update `ShimmerLoading` reference to use `RBColors.shimmerBase` / `RBColors.shimmerHighlight`
    - Ensure skeleton layout mirrors RouteCard: header block, two+ content rows, right-aligned price/CTA block
    - _Requirements: 13.2, 13.5_

  - [ ] 3.6 Update `lib/core/components/shimmer_loading.dart` token references
    - Replace `SpottColors.shimmerBase` → `RBColors.shimmerBase`
    - Replace `SpottColors.shimmerHighlight` → `RBColors.shimmerHighlight`
    - Ensure base card background uses `RBColors.surface`
    - _Requirements: 13.1, 13.5_

  - [ ] 3.7 Rewrite `lib/core/components/branded_empty_state.dart` with RB tokens
    - Replace `SpottColors.accentPurple` → `RBColors.primary` for icon container colour
    - Replace all `SpottTextStyles.*` → `RBTextStyles.*` equivalents
    - Replace `SpottButton.primary` → RB primary button variant
    - Set background to `RBColors.background` — remove all dark/glass surfaces
    - Icon container: `RBColors.primary.withOpacity(0.12)`
    - Implement graceful fallback when illustration asset fails to load (heading + description only)
    - _Requirements: 12.1–12.4_

  - [ ] 3.8 Update `lib/core/components/floating_bottom_nav.dart` with RB styling
    - Replace background with explicit `RBColors.surface`
    - Add top border: `Border(top: BorderSide(color: RBColors.border, width: 1))`
    - Replace `boxShadow` with `[RBShadows.navShadow]`
    - Replace `RBColors.textLight` → `RBColors.textSecondary`
    - Replace inline `TextStyle` with `RBTextStyles.caption`
    - Active item: `RBColors.primary`; inactive: `RBColors.textSecondary`; icon size: 24px
    - Ensure centred "+" FAB at 56px diameter in `RBColors.primary` for Create Trip action
    - _Requirements: 10.1–10.6_

  - [ ] 3.9 Update `lib/core/components/staggered_list.dart` stagger timing
    - Update default `staggerDelay` to `const Duration(milliseconds: 60)`
    - _Requirements: 14.4_

  - [ ] 3.10 Update `lib/core/components/animated_entrance.dart` slide offset and curve
    - Change default `slideOffset` to a fixed 12px fractional offset (`const Offset(0, 0.04)`)
    - Retain fade + slide; use `Curves.easeOutCubic`
    - _Requirements: 14.4_

  - [ ] 3.11 Update `lib/core/components/section_title.dart` typography tokens
    - Replace all `SpottTextStyles` references with `RBTextStyles` equivalents
    - Replace any `SpottColors` references with `RBColors` equivalents
    - _Requirements: 3.1–3.5_

  - [ ] 3.12 Update `lib/core/components/spott_avatar.dart` colour tokens
    - Replace all `SpottColors` references with `RBColors` equivalents
    - Remove any `GlassContainer` or `BackdropFilter` usage
    - _Requirements: 2.3–2.4_

- [ ] 4. Checkpoint — Phase 1 & 2 complete
  - Ensure `redbus_theme.dart` compiles with no errors and all token classes are accessible. Ensure all 12 shared components compile and reference only RB tokens. Ask the user if questions arise.

- [ ] 5. Phase 3 — Auth & Onboarding Screens (5 files)
  - [ ] 5.1 Redesign `lib/screens/splash_screen.dart`
    - Replace scaffold background with `RBColors.primary`
    - Render Spotter wordmark and icon centred on primary background
    - Wrap logo in `FadeTransition` with 400ms duration
    - Render logo/wordmark text in white
    - Apply `SystemUiOverlayStyle.light` (light status bar icons on primary background)
    - _Requirements: 17.1_

  - [ ] 5.2 Redesign `lib/screens/onboarding_screen.dart`
    - Replace scaffold background with `RBColors.background`
    - Render each slide as a white Surface card (`RBColors.surface`, `RBRadius.card`, `RBShadows.cardShadow`) with illustration, heading (`RBTextStyles.heading`), and body (`RBTextStyles.body`)
    - Implement page indicator row: active dot → `RBColors.primary`, inactive → `RBColors.border`
    - Render "Get Started" using RB primary button variant (`height: 52`, `borderRadius: RBRadius.button`, `RBColors.primary`)
    - Remove all `GlassScaffold` / `GlassCard` / `SpottColors` references
    - _Requirements: 17.2_

  - [ ] 5.3 Redesign `lib/screens/login_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render centred `RBColors.primary` logo header
    - Render phone input inside a white Surface card (`RBRadius.card`, `RBShadows.cardShadow`)
    - Style `TextField` per Req 9: `fillColor: RBColors.surface`, `borderRadius: RBRadius.input`, `enabledBorderColor: RBColors.border`, `focusedBorderColor: RBColors.primary`, minimum height 56px
    - Render "Continue" using RB primary button variant
    - Apply `SystemUiOverlayStyle.dark`
    - _Requirements: 17.3, 9.1–9.6_

  - [ ] 5.4 Redesign `lib/screens/otp_verification_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render transparent AppBar with back arrow
    - Render heading + subtitle using `RBTextStyles.heading` / `RBTextStyles.body`
    - Style 6× OTP `TextField` boxes: `focusedBorderColor: RBColors.primary`; other borders per Req 9
    - Render Resend link as RB ghost button
    - Render "Verify" using RB primary button variant (`height: 52`, `RBRadius.button`, `RBColors.primary`)
    - _Requirements: 17.3, 9.1–9.6_

  - [ ] 5.5 Redesign `lib/screens/choose_role_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render heading in `RBTextStyles.display`
    - Render two role selection cards with `RBRadius.card`, `RBShadows.cardShadow`; active selection shown by 2px `RBColors.primary` border
    - Render "Continue" using RB primary button variant
    - _Requirements: 17.4_

- [ ] 6. Phase 4 — Core Navigation & Home (3 files)
  - [ ] 6.1 Redesign `lib/screens/home_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Fix `RBColors.primary` token value (was `0xFFD84315`) — now correct after Phase 1
    - Build `_PrimaryHeader` on `RBColors.primary` background with SafeArea, logo, greeting, notifications icon, and profile avatar; apply `SystemUiOverlayStyle.light`
    - Build `_SearchCard` with `RBColors.surface`, `RBRadius.searchContainer (24.0)`, `RBShadows.searchShadow`, negative top margin (`EdgeInsets.fromLTRB(16, -20, 16, 0)`)
    - Add From/To fields with vertical separator and circular swap button (`RBColors.primary` border); `_DatePassengerRow` with two `_InputBox` widgets at `RBRadius.input`
    - Fix search button height to exactly 52px (`RBRadius.button`, `RBColors.primary`)
    - Replace hardcoded hex colours in `_buildServicesGrid` and banners with `RBColors` tokens
    - Replace all hardcoded `TextStyle` objects with `RBTextStyles` variants
    - Migrate `_WhyRow` and `_OfferCard` to `RBTextStyles` / `RBColors`
    - Build Offers, Popular Routes, Quick Services (3-col grid), Parcel/Traveler banners using RB tokens
    - _Requirements: 4.1–4.10, 2.1–2.6_

  - [ ] 6.2 Update `lib/screens/main_navigation_shell.dart` (or equivalent shell file)
    - Ensure `FloatingBottomNav` (updated in 3.8) is wired correctly
    - Apply `SystemUiOverlayStyle` appropriately for each tab's active screen
    - Remove any `GlassScaffold` or dark-surface wrapper
    - _Requirements: 10.1–10.6, 2.1–2.2_

  - [ ] 6.3 Redesign `lib/screens/driver_home_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Build `_PrimaryHeader` identical to home screen pattern (`RBColors.primary`)
    - Build `_EarningsSummaryCard` as white Surface card (`RBRadius.card`, `RBShadows.cardShadow`)
    - Replace all `SpottColors` / `SpottTextStyles` with RB equivalents
    - Wire empty state via `BrandedEmptyState` (updated in 3.7)
    - _Requirements: 2.1–2.6, 20.4_

- [ ] 7. Phase 5 — Search & Results Flow (4 files)
  - [ ] 7.1 Redesign `lib/screens/trip_search_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render sticky `AppBar(backgroundColor: RBColors.primary, foregroundColor: white, title: 'Search Rides')`; `SystemUiOverlayStyle.light`
    - Build `_SearchContainer`: `RBColors.surface`, `RBRadius.searchContainer`, shadow
    - Add `_FromField` and `_ToField` at minimum 56px touch height each; divider + swap button
    - Add `_DateSelectorRow` and `_PassengerSelectorRow` with `RBRadius.input`, `RBColors.border`
    - Render "SEARCH" CTA: `height: 52`, full-width, `RBRadius.button`, `RBColors.primary`
    - _Requirements: 5.1–5.5, 9.1–9.6_

  - [ ] 7.2 Redesign `lib/screens/destination_search_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Build full-width search `TextField`: `borderRadius: RBRadius.input`, `fillColor: RBColors.surface`, magnifying-glass prefix icon in `RBColors.textSecondary`
    - Conditionally render `_RecentSuggestions` list (clock icon, `RBColors.textSecondary`) when query is empty
    - Conditionally render live results list when query is non-empty; hide recent suggestions on typing
    - _Requirements: 5.6–5.7_

  - [ ] 7.3 Redesign `lib/screens/search_results_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Build sticky header on `RBColors.primary` background showing route, date, passenger count; `SystemUiOverlayStyle.light`
    - Add `_FilterChipsRow`: horizontal scroll, chips with `borderRadius: RBRadius.pill`
    - Implement conditional body: Loading → 3× `SkeletonRouteCard`; Empty → `BrandedEmptyState.noResults()`; Results → staggered `AnimatedList` of `RouteCard` (60ms interval, from §3.11/3.12 components)
    - Wrap list in `AnimatedSwitcher(duration: 200ms)` for skeleton → content fade
    - _Requirements: 6.1–6.9, 13.3–13.4_

  - [ ] 7.4 Update `lib/screens/no_results_screen.dart` to use `BrandedEmptyState`
    - Replace existing content with `BrandedEmptyState.noResults()` (from updated component in 3.7)
    - Ensure scaffold uses `RBColors.background`
    - _Requirements: 12.1–12.5, 6.7_

- [ ] 8. Checkpoint — Phases 3–5 complete
  - Ensure auth/onboarding screens, home, and search flow screens compile and render correctly on both light-header and primary-header configurations. Ask the user if questions arise.

- [ ] 9. Phase 6 — Trip Detail & Booking Flow (6 files)
  - [ ] 9.1 Redesign `lib/screens/trip_details_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`; `SystemUiOverlayStyle.light`
    - Build `_DriverSection`: white Surface card, avatar + name (`RBTextStyles.subheading`) + rating + `TrustBadge`
    - Build `_RouteSection`: white Surface card, departure/arrival/stops timeline
    - Build `_VehicleSection`: white Surface card, icon+label pairs in `RBTextStyles.caption`
    - Build `_AmenitiesSection`: white Surface card
    - Set `SingleChildScrollView` bottom padding 88px for sticky CTA clearance
    - Build fixed `_StickyCTA` at bottom: `height: 72`, `SafeArea`, price in `RBColors.primary`, "Book Ride" button (`height: 52`, `RBRadius.button`, `RBColors.primary`)
    - _Requirements: 7.1–7.7_

  - [ ] 9.2 Redesign `lib/screens/ride_confirmation_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Build `_SummaryCard`: `RBColors.surface`, `RBRadius.card`, route + driver + price (`RBColors.primary`, `RBTextStyles.heading`) + seats
    - Add Sticky CTA "Confirm & Pay" (`height: 52`, `RBColors.primary`) with `SafeArea`
    - _Requirements: 19.1_

  - [ ] 9.3 Redesign `lib/screens/payment_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render payment method options as white Surface selection cards with `RBColors.primary` radio indicator for selected option
    - Replace all `SpottColors` / `SpottTextStyles` with RB equivalents
    - _Requirements: 19.2_

  - [ ] 9.4 Redesign `lib/screens/booking_success_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render large animated checkmark in `RBColors.success` (80px)
    - Render heading in `RBTextStyles.heading`, booking reference in `RBTextStyles.captionMedium`
    - Build `_TripSummaryCard`: white Surface
    - Render "View Booking" using RB primary button variant
    - _Requirements: 19.3_

  - [ ] 9.5 Redesign `lib/screens/active_trip_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Add `_StatusBar` at top: `backgroundColor: RBColors.primary`, live trip status text in white; `SystemUiOverlayStyle.light`
    - Keep Map widget unchanged (business logic — do not modify controller/state)
    - Build `_OverlayCard` at bottom: `RBColors.surface`, `RBRadius.bottomSheet`, `RBShadows.cardShadow`
    - _Requirements: 19.4_

  - [ ] 9.6 Redesign `lib/screens/ride_complete_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render success layout: animated checkmark in `RBColors.success`, heading, trip summary card, "Rate Your Ride" primary CTA
    - Replace all `SpottColors` / `SpottTextStyles` with RB equivalents
    - _Requirements: 19.5_

- [ ] 10. Phase 7 — Profile & Settings (3 files)
  - [ ] 10.1 Redesign `lib/screens/profile_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Use `CustomScrollView` with `SliverAppBar(backgroundColor: RBColors.primary, expandedHeight: 200)`; `SystemUiOverlayStyle.light`
    - Build `FlexibleSpaceBar` → `_ProfileHeader`: avatar + name + phone + `TrustBadge` (verified badge in `RBColors.success` for KYC-verified users, always rendered)
    - Build `_StatsRow`: row of 3× `_StatCard` (white surface, `RBRadius.card`, `RBShadows.cardShadow`)
    - Build settings `SliverList`: three sections (Account, Preferences, Support) each with `_SectionHeader` in `RBTextStyles.caption` + `RBColors.textSecondary`, white Surface container of `ListTile` rows
    - Render "Sign Out" as standalone destructive row in `RBColors.error`
    - Remove all `GlassComponent` / dark-surface usage
    - _Requirements: 8.1–8.7_

  - [ ] 10.2 Redesign `lib/screens/settings_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Implement grouped `ListTile` rows in white Surface containers identical to profile settings pattern
    - Replace all `SpottColors` / `SpottTextStyles` with RB equivalents
    - _Requirements: 20.4_

  - [ ] 10.3 Redesign `lib/screens/kyc_verification_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Style all `TextField` / `TextFormField` inputs per Req 9 (fill, border, radius, min-height 56px)
    - Render submit button using RB primary variant (`height: 52`, `RBRadius.button`, `RBColors.primary`)
    - Render validation error messages in `RBColors.error` + `RBTextStyles.caption`
    - _Requirements: 9.1–9.7_

- [ ] 11. Phase 8 — Parcel Flow (5 files)
  - [ ] 11.1 Redesign `lib/screens/parcel_booking_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary, title: 'Send Parcel')`
    - Build multi-step `_StepProgressIndicator`: active/completed steps in `RBColors.primary`, pending in `RBColors.border`
    - Style all form fields per Req 9 in white Surface form sections
    - _Requirements: 18.1–18.2, 9.1–9.7_

  - [ ] 11.2 Redesign `lib/screens/parcel_tracking_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Build `_StatusTimeline`: each step icon colour from `StatusChip` mapping (success/warning/error per Req 15)
    - _Requirements: 18.3_

  - [ ] 11.3 Redesign `lib/screens/parcel_complete_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render large success icon in `RBColors.success`, heading, summary card (white Surface), primary CTA "Return Home"
    - _Requirements: 18.5_

  - [ ] 11.4 Redesign `lib/screens/parcel_history_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Render each parcel entry as white Surface card: `RBRadius.card`, `RBShadows.cardShadow`, `StatusChip` badge
    - Implement loading state with `SkeletonRouteCard` (updated component) placeholders
    - Implement empty state via `BrandedEmptyState.noParcels()`
    - _Requirements: 18.4, 12.5, 13.3_

  - [ ] 11.5 Redesign `lib/screens/create_trip_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Style all form fields per Req 9 in white Surface form sections
    - Render submit button using RB primary variant
    - _Requirements: 9.1–9.7_

- [ ] 12. Phase 9 — Driver-Side Screens (6 files)
  - [ ] 12.1 Verify / update `lib/screens/driver_home_screen.dart` (already done in 6.3 if Phase 4 included it)
    - Confirm file is fully migrated from Phase 4 (task 6.3); apply any remaining changes from Phase 9 design notes
    - _Requirements: 2.1–2.6_

  - [ ] 12.2 Redesign `lib/screens/driver_matches_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Build `ListView` of `_MatchCard`: white Surface, `RBRadius.card`, `RBShadows.cardShadow`; passenger info + `StatusChip` (top-right) + "Accept" primary button + "Decline" outlined button
    - _Requirements: 2.1–2.6_

  - [ ] 12.3 Redesign `lib/screens/job_requests_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Build request cards as white Surface cards with RB tokens; Accept/Decline buttons using RB button variants
    - _Requirements: 2.1–2.6_

  - [ ] 12.4 Redesign `lib/screens/job_detail_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Render content sections as white Surface cards with RB spacing/radius/shadow
    - _Requirements: 2.1–2.6_

  - [ ] 12.5 Redesign `lib/screens/traveler_trips_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Render trip list as white Surface cards with `StatusChip` badges
    - Implement loading and empty states via updated skeleton/empty-state components
    - _Requirements: 2.1–2.6, 12.5, 13.3_

  - [ ] 12.6 Redesign `lib/screens/vehicle_management_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Style all form fields per Req 9; render submit button using RB primary variant
    - _Requirements: 9.1–9.7_

- [ ] 13. Checkpoint — Phases 6–9 complete
  - Ensure trip detail/booking flow, profile/settings, parcel flow, and driver screens compile and render. Verify sticky CTAs stay above system nav bar. Ask the user if questions arise.

- [ ] 14. Phase 10 — Utility & Support Screens (10 files)
  - [ ] 14.1 Redesign `lib/screens/notifications_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Implement conditional body: Loading → skeleton cards; Empty → `BrandedEmptyState.noNotifications()`; List → `_NotificationCard` (white Surface, `RBRadius.card`) with left-side unread indicator dot in `RBColors.primary` (8px) for unread items
    - _Requirements: 20.3, 12.5, 13.3_

  - [ ] 14.2 Redesign `lib/screens/activity_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Render activity list as white Surface cards with `StatusChip` badges
    - Implement loading state (skeleton) and empty state (`BrandedEmptyState`)
    - _Requirements: 12.5, 13.3_

  - [ ] 14.3 Redesign `lib/screens/safety_toolkit_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Build `ListView` of `_SafetyCard`: white Surface, `RBRadius.card`, 3px left border accent in `RBColors.primary`, icon + label rows in `RBTextStyles.body`
    - _Requirements: 20.1_

  - [ ] 14.4 Redesign `lib/screens/support_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Build grouped section list: white Surface containers, `ListTile` rows with `RBColors.primary` icons and `RBTextStyles.body` text
    - _Requirements: 20.2_

  - [ ] 14.5 Redesign `lib/screens/chat_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Style sent message bubbles: `RBColors.primary` background, white text
    - Style received message bubbles: `RBColors.surface` background, `RBColors.border` border, `RBColors.textPrimary` text
    - Style `_InputRow` `TextField` per Req 9 + send button using RB primary icon button
    - _Requirements: 2.1–2.6, 9.1_

  - [ ] 14.6 Redesign `lib/screens/cancel_ride_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Build `_ReasonSelector`: list of selectable white Surface chips; active selection shows `RBColors.primary` border
    - Render "Cancel Ride" destructive button: `height: 52`, `backgroundColor: RBColors.error`, `foreground: white`, `RBRadius.button`
    - _Requirements: 19.6_

  - [ ] 14.7 Redesign `lib/screens/rating_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render heading in `RBTextStyles.heading`
    - Build `_StarRow`: 5 × `Icon` — selected: `RBColors.warning`, unselected: `RBColors.border`
    - Style `_CommentInput` per Req 9
    - Render "Submit" using RB primary button variant
    - _Requirements: 19.7_

  - [ ] 14.8 Redesign `lib/screens/maintenance_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Build centred column: icon in `RBColors.primary.withOpacity(0.12)` container (80px), heading (`RBTextStyles.heading`), description (`RBTextStyles.body`), "Retry" primary CTA
    - _Requirements: 20.5_

  - [ ] 14.9 Redesign `lib/screens/network_error_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Build identical centred column layout to maintenance screen (icon + heading + description + retry CTA)
    - _Requirements: 20.5_

  - [ ] 14.10 Update `lib/screens/empty_state_screen.dart` to use `BrandedEmptyState`
    - Replace existing content with appropriate `BrandedEmptyState` preset
    - Ensure scaffold uses `RBColors.background`
    - _Requirements: 12.5_

- [ ] 15. Phase 11 — Remaining Screens (12 files)
  - [ ] 15.1 Redesign `lib/screens/passenger_trips_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`, white Surface trip cards, `StatusChip` badges
    - Implement loading (skeleton) and empty (`BrandedEmptyState`) states
    - _Requirements: 2.1–2.6, 12.5, 13.3_

  - [ ] 15.2 Redesign `lib/screens/passenger_requests_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`, white Surface request cards with RB tokens
    - _Requirements: 2.1–2.6_

  - [ ] 15.3 Redesign `lib/screens/verification_pending_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render centred illustration, status heading in `RBTextStyles.heading`, description in `RBTextStyles.body`
    - _Requirements: 17.5_

  - [ ] 15.4 Redesign `lib/screens/pickup_location_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Style any input fields per Req 9; replace all `SpottColors` / `SpottTextStyles` with RB equivalents
    - _Requirements: 2.1–2.6, 9.1_

  - [ ] 15.5 Redesign `lib/screens/fare_estimate_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Render fare breakdown in white Surface cards with price text in `RBColors.primary` + `RBTextStyles.heading`
    - _Requirements: 2.1–2.6_

  - [ ] 15.6 Redesign `lib/screens/share_trip_screen.dart`
    - Replace scaffold with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Replace all `SpottColors` / `SpottTextStyles` with RB equivalents
    - _Requirements: 2.1–2.6_

  - [ ] 15.7 Redesign `lib/screens/live_tracking_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Replace any glass overlay cards with `RBColors.surface` containers; preserve Map widget unchanged
    - Replace all `SpottColors` / `SpottTextStyles` with RB equivalents
    - _Requirements: 2.1–2.6_

  - [ ] 15.8 Redesign `lib/screens/driver_profile_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Render driver stats and details in white Surface sections with RB tokens; `TrustBadge` for verified drivers
    - _Requirements: 2.1–2.6, 16.1–16.4_

  - [ ] 15.9 Redesign `lib/screens/pickup_task_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Replace all `SpottColors` / `SpottTextStyles` with RB equivalents; apply RB card styling
    - _Requirements: 2.1–2.6_

  - [ ] 15.10 Redesign `lib/screens/drop_task_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Replace all `SpottColors` / `SpottTextStyles` with RB equivalents; apply RB card styling
    - _Requirements: 2.1–2.6_

  - [ ] 15.11 Redesign `lib/screens/admin_review_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Render review items as white Surface cards with RB tokens; action buttons using RB button variants
    - _Requirements: 2.1–2.6_

  - [ ] 15.12 Redesign `lib/screens/dispute_case_screen.dart`
    - Replace `GlassScaffold` with `Scaffold(backgroundColor: RBColors.background)`
    - Render `AppBar(backgroundColor: RBColors.primary)`
    - Style any form inputs per Req 9; render submit/escalate buttons using RB button variants
    - _Requirements: 2.1–2.6, 9.1_

- [ ] 16. Final Checkpoint — All phases complete
  - Ensure all 57 screens and 18 shared components compile without errors. Verify no `SpottColors`, `SpottTextStyles`, `GlassScaffold`, `GlassCard`, `GlassContainer`, or `BackdropFilter` usages remain in any non-legacy component. Ask the user if questions arise.

---

## Notes

- No controllers, models, repositories, routes (`app_routes.dart`), or test files are modified in any phase. Widget `setState`, `initState`, controller references, and `Navigator.push*` calls are preserved verbatim — only `build()` widget trees are updated.
- Phase 12 (task 2) declares Inter fonts in `pubspec.yaml` and can begin immediately in parallel with Phase 1 (task 1). Font asset files (Inter-Regular.ttf, Inter-Medium.ttf, Inter-SemiBold.ttf, Inter-Bold.ttf, Inter-ExtraBold.ttf) must be placed in `fonts/` before or during this task.
- All screen phases (3–11, tasks 5–15) depend on Phase 2 shared components (task 3) being complete, because screens import `RBButton`, `StatusChip`, `TrustBadge`, `RouteCard`, `BrandedEmptyState`, `FloatingBottomNav`, `StaggeredList`, and `AnimatedEntrance`.
- Tasks marked with `*` are optional and can be skipped for a faster initial pass — however no tasks here are marked optional since this redesign has no PBT/property-based testing requirements.
- Each sub-task touches exactly one file; this keeps diffs small and reviewable.
- The legacy token files (`colors.dart`, `typography.dart`, `spacing.dart`, `radius.dart`, `shadows.dart`, `gradients.dart`) are kept intact — only their usage sites in screens/components are migrated to RB-prefixed equivalents.

---

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1", "2.1"] },
    { "id": 1, "tasks": ["3.1", "3.2", "3.3", "3.4", "3.5", "3.6", "3.7", "3.8", "3.9", "3.10", "3.11", "3.12"] },
    { "id": 2, "tasks": ["5.1", "5.2", "5.3", "5.4", "5.5", "6.1", "6.2", "6.3", "7.1", "7.2", "7.3", "7.4"] },
    { "id": 3, "tasks": ["9.1", "9.2", "9.3", "9.4", "9.5", "9.6", "10.1", "10.2", "10.3", "11.1", "11.2", "11.3", "11.4", "11.5"] },
    { "id": 4, "tasks": ["12.1", "12.2", "12.3", "12.4", "12.5", "12.6", "14.1", "14.2", "14.3", "14.4", "14.5", "14.6", "14.7", "14.8", "14.9", "14.10"] },
    { "id": 5, "tasks": ["15.1", "15.2", "15.3", "15.4", "15.5", "15.6", "15.7", "15.8", "15.9", "15.10", "15.11", "15.12"] }
  ]
}
```
