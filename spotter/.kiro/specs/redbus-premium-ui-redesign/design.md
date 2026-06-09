# Design Document — RedBus Premium UI Redesign

## Overview

This document specifies the complete technical design for migrating the Spotter Flutter app from its current dark glass-effect UI to the RedBus Premium design system. The change is **purely presentational**: no controllers, models, repositories, routes, or state management are touched. Every widget change is limited to `lib/core/theme/`, `lib/core/components/`, and `lib/screens/`.

---

## 1. Architecture Strategy

### 1.1 Single Source of Truth

`lib/core/theme/redbus_theme.dart` becomes the sole file for all design tokens. All other theme files (`colors.dart`, `typography.dart`, `spacing.dart`, `radius.dart`, `shadows.dart`, `gradients.dart`) are **kept intact** to avoid breaking existing imports, but their usages in screens/components are replaced with RB-prefixed equivalents.

Token classes added/updated in `redbus_theme.dart`:

| Class | Purpose |
|---|---|
| `RBColors` | Colours — primary, backgrounds, text, semantic, shimmer |
| `RBTextStyles` | Typography — Inter-only, 7 named variants |
| `RBSpacing` | 8pt grid spacing |
| `RBRadius` | Border radii |
| `RBShadows` | Box shadows |

### 1.2 Migration Pattern

For every file that currently uses `SpottColors`, `SpottTextStyles`, `SpottSpacing`, `SpottRadius`, or `SpottShadows`, the pattern is:

```
SpottColors.background      →  RBColors.background
SpottColors.primary         →  RBColors.primary
SpottColors.surface1        →  RBColors.surface
SpottColors.textPrimary     →  RBColors.textPrimary
SpottColors.textSecondary   →  RBColors.textSecondary
SpottColors.textTertiary    →  RBColors.textSecondary
SpottColors.success         →  RBColors.success
SpottColors.warning         →  RBColors.warning
SpottColors.danger          →  RBColors.error
SpottColors.glassSurface    →  RBColors.surface (+ RBShadows.cardShadow)
SpottColors.border          →  RBColors.border
SpottColors.divider         →  RBColors.border
SpottColors.shimmerBase     →  RBColors.shimmerBase
SpottColors.shimmerHighlight→  RBColors.shimmerHighlight

SpottTextStyles.display     →  RBTextStyles.display
SpottTextStyles.headline    →  RBTextStyles.heading
SpottTextStyles.title       →  RBTextStyles.subheading
SpottTextStyles.body        →  RBTextStyles.body
SpottTextStyles.caption     →  RBTextStyles.caption
SpottTextStyles.label       →  RBTextStyles.bodyMedium

SpottSpacing.xs             →  RBSpacing.xs
SpottSpacing.sm             →  RBSpacing.sm
SpottSpacing.md             →  RBSpacing.lg
SpottSpacing.lg             →  RBSpacing.xxl
SpottSpacing.cardInner      →  RBSpacing.lg

SpottRadius.card            →  RBRadius.card
SpottRadius.pill            →  RBRadius.pill
SpottRadius.xs              →  RBRadius.xs

SpottShadows.elevation1     →  [RBShadows.cardShadow]
```

### 1.3 Glass Component Replacement

`GlassScaffold`, `GlassCard`, `GlassContainer` are replaced at the usage site, not in the component files themselves (keeping them for backward compatibility in screens not yet migrated). The replacement pattern:

```dart
// Before
GlassScaffold(body: ...)
// After
Scaffold(backgroundColor: RBColors.background, body: ...)

// Before
GlassCard(child: ...)
// After
Container(
  decoration: BoxDecoration(
    color: RBColors.surface,
    borderRadius: BorderRadius.circular(RBRadius.card),
    boxShadow: [RBShadows.cardShadow],
  ),
  child: ...,
)
```

---

## 2. Token Specification — `redbus_theme.dart`

### 2.1 RBColors (complete, corrected)

```dart
class RBColors {
  // Brand
  static const Color primary     = Color(0xFFD84E55);
  static const Color primaryDark = Color(0xFFB73D45);
  static const Color primarySoft = Color(0xFFFCEBEC);

  // Backgrounds
  static const Color background  = Color(0xFFF8F8F8);
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF8F8F8);

  // Text
  static const Color textPrimary   = Color(0xFF1D1D1D);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textWhite     = Color(0xFFFFFFFF);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);

  // UI chrome
  static const Color border  = Color(0xFFEAEAEA);
  static const Color divider = Color(0xFFEAEAEA);

  // Shimmer
  static const Color shimmerBase      = Color(0xFFEEEEEE);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Legacy aliases kept for zero-breakage migration
  static const Color textDark   = textPrimary;
  static const Color textMedium = textSecondary;
  static const Color textLight  = textSecondary;
  static const Color green      = success;
  static const Color seatAvailable   = Color(0xFF4CAF50);
  static const Color seatUnavailable = Color(0xFF9E9E9E);
  static const Color seatSelected    = Color(0xFF1976D2);
  static const Color seatLadies      = Color(0xFFE91E63);
  static const Color gold            = Color(0xFFFFC107);
}
```

### 2.2 RBTextStyles (complete, corrected)

All entries use `fontFamily: 'Inter'`. Color defaults to `RBColors.textPrimary` for headings, `RBColors.textSecondary` for body/caption.

```dart
class RBTextStyles {
  static const String font = 'Inter';

  static const TextStyle display = TextStyle(
    fontFamily: font, fontSize: 28, fontWeight: FontWeight.w800,
    color: RBColors.textPrimary, letterSpacing: -0.5, height: 1.15,
  );
  static const TextStyle heading = TextStyle(
    fontFamily: font, fontSize: 22, fontWeight: FontWeight.w700,
    color: RBColors.textPrimary, letterSpacing: -0.3, height: 1.2,
  );
  static const TextStyle subheading = TextStyle(
    fontFamily: font, fontSize: 18, fontWeight: FontWeight.w700,
    color: RBColors.textPrimary, letterSpacing: -0.2, height: 1.25,
  );
  static const TextStyle body = TextStyle(
    fontFamily: font, fontSize: 15, fontWeight: FontWeight.w400,
    color: RBColors.textSecondary, height: 1.45,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: font, fontSize: 15, fontWeight: FontWeight.w500,
    color: RBColors.textSecondary, height: 1.45,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: font, fontSize: 12, fontWeight: FontWeight.w400,
    color: RBColors.textSecondary, height: 1.4,
  );
  static const TextStyle captionMedium = TextStyle(
    fontFamily: font, fontSize: 12, fontWeight: FontWeight.w500,
    color: RBColors.textSecondary, height: 1.4,
  );
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: font, fontSize: 15, fontWeight: FontWeight.w700,
    color: RBColors.textWhite, letterSpacing: 0.3,
  );

  // Legacy aliases
  static const TextStyle appBarTitle  = subheading;
  static const TextStyle sectionHeader = heading;
  static const TextStyle cardTitle    = subheading;
  static const TextStyle cardSubtitle = caption;
  static const TextStyle price        = heading;
  static const TextStyle bodyText     = body;
  static const TextStyle filterLabel  = bodyMedium;
  static const TextStyle amenity      = caption;
  static const TextStyle badge        = captionMedium;
}
```

### 2.3 RBSpacing (complete, corrected)

```dart
class RBSpacing {
  static const double xs     = 4.0;
  static const double sm     = 8.0;
  static const double md     = 12.0;
  static const double lg     = 16.0;
  static const double xl     = 20.0;
  static const double xxl    = 24.0;
  static const double xxxl   = 32.0;
  static const double xxxxl  = 40.0;
  static const double xxxxxl = 48.0;
  // Semantic aliases
  static const double pageH    = 16.0;
  static const double cardInner = 16.0;
  static const double pageBottom = 80.0;
}
```

### 2.4 RBRadius (complete, corrected)

```dart
class RBRadius {
  static const double xs            = 4.0;
  static const double sm            = 8.0;
  static const double md            = 12.0;
  static const double lg            = 16.0;   // inputs, buttons
  static const double xl            = 20.0;   // cards
  static const double xxl           = 24.0;   // bottom sheets

  // Semantic aliases (spec-exact names used in screens)
  static const double button        = 16.0;
  static const double card          = 20.0;
  static const double input         = 16.0;
  static const double bottomSheet   = 24.0;
  static const double searchContainer = 24.0;
  static const double pill          = 9999.0;
}
```

### 2.5 RBShadows (new class)

```dart
class RBShadows {
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );
  static const BoxShadow navShadow = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 16,
    offset: Offset(0, -2),
  );
  static const BoxShadow searchShadow = BoxShadow(
    color: Color(0x12000000),
    blurRadius: 20,
    offset: Offset(0, 6),
  );
  static const BoxShadow buttonShadow = BoxShadow(
    color: Color(0x26D84E55),
    blurRadius: 12,
    offset: Offset(0, 4),
  );
}
```

---

## 3. Component Design Specs

### 3.1 `spott_buttons.dart` → `RBButton` (rewrite in-place)

Remove `GlassContainer`, `SpottGradients`, `SpottShadows`, `SpottColors`. Replace with:

| Variant | Background | Border | Text | Height | Radius |
|---|---|---|---|---|---|
| Primary | `RBColors.primary` | none | `Colors.white` | 52px | `RBRadius.button` |
| Outlined | transparent | `RBColors.primary` 1.5px | `RBColors.primary` | 52px | `RBRadius.button` |
| Ghost | transparent | none | `RBColors.primary` | 52px | — |
| Disabled (all) | `RBColors.border` | `RBColors.border` | `RBColors.textSecondary` | 52px | `RBRadius.button` |

Loading state: `CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)` at 20px, taps disabled.

Press animation: `AnimatedScale` to `0.97` over `100ms` using `Curves.easeOut`. Retain `HapticFeedback.lightImpact()` on tap.

### 3.2 `glass_scaffold.dart` — no change to file; usage replaced

All 55 screens that use `GlassScaffold` replace with:
```dart
Scaffold(
  backgroundColor: RBColors.background,
  appBar: ...,
  body: ...,
)
```
`SystemChrome.setSystemUIOverlayStyle` applied:
- White/grey header screens → `SystemUiOverlayStyle.dark` (dark status icons)
- `RBColors.primary` header screens → `SystemUiOverlayStyle.light` (light icons)

### 3.3 `glass_card.dart` — no change to file; usage replaced

Usage sites replace `GlassCard(child: X)` with a `_RBCard` helper widget or inline `Container`:
```dart
Container(
  decoration: BoxDecoration(
    color: RBColors.surface,
    borderRadius: BorderRadius.circular(RBRadius.card),
    boxShadow: const [RBShadows.cardShadow],
  ),
  padding: const EdgeInsets.all(RBSpacing.lg),
  child: X,
)
```

### 3.4 `route_card.dart` — rewrite in-place

Replace `GlassCard` with plain `Container`. Replace all `SpottColors`/`SpottTextStyles` with RB equivalents. Replace route dots: origin dot → `RBColors.success`, line → `RBColors.border`, destination dot → `RBColors.primary`.

Add "Book Now" button (outlined, `RBColors.primary`, `borderRadius: RBRadius.button`) at bottom right of card.

Layout:
```
┌──────────────────────────────────┐
│ [Avatar] Name  VerifiedBadge │ ₹Price │
│             ReputationRow    │ Time   │
├──────────────────────────────────┤
│ ○ Origin                         │
│ │                                │
│ ● Destination                    │
├──────────────────────────────────┤
│ ● seats  [demand tag]  [vehicle] │ [Book Now] │
└──────────────────────────────────┘
```

### 3.5 `skeleton_route_card.dart` — rewrite in-place

Replace `GlassCard` with plain `Container(color: RBColors.surface, borderRadius: RBRadius.card)`.
Update `ShimmerLoading` to use `RBColors.shimmerBase` / `RBColors.shimmerHighlight`.

### 3.6 `shimmer_loading.dart` — update token references

```dart
// gradient colors
colors: const [
  RBColors.shimmerBase,
  RBColors.shimmerHighlight,
  RBColors.shimmerBase,
],
```

### 3.7 `status_chip.dart` — rewrite in-place

Map `ChipStatus` to RB semantic colours:
- `verified / approved / delivered` → bg `RBColors.success.withValues(alpha:0.12)`, text `RBColors.success`
- `pending / inTransit` → bg `RBColors.warning.withValues(alpha:0.12)`, text `RBColors.warning`
- `rejected` → bg `RBColors.error.withValues(alpha:0.12)`, text `RBColors.error`
- `neutral` → bg `RBColors.border`, text `RBColors.textSecondary`

Remove `SpottColors.glassSurface`. Use `borderRadius: RBRadius.pill`, padding: `horizontal: RBSpacing.sm`.

### 3.8 `trust_badge.dart` — update token references

Replace `SpottColors.trustVerified` → `RBColors.success`.
Replace `SpottColors.warningSoft` → `RBColors.warning.withValues(alpha:0.12)`.
Replace `SpottColors.warning` → `RBColors.warning`.
Replace `SpottColors.textSecondary` → `RBColors.textSecondary`.
Replace `SpottColors.textTertiary` → `RBColors.textSecondary`.
Replace `SpottColors.surface3` → `RBColors.background`.
Replace `SpottColors.border` → `RBColors.border`.
Replace `SpottTextStyles.caption` → `RBTextStyles.caption`.

### 3.9 `branded_empty_state.dart` — rewrite in-place

Replace `SpottColors.accentPurple` → `RBColors.primary`.
Replace `SpottTextStyles.*` → `RBTextStyles.*` equivalents.
Replace `SpottButton.primary` → `RBButton.primary` (or `ElevatedButton` styled to spec).
Background: `RBColors.background` (no dark surfaces).
Icon container: `RBColors.primary.withValues(alpha:0.12)`.

### 3.10 `floating_bottom_nav.dart` — update

Replace `Colors.white` background with explicit `RBColors.surface`.
Add top border `Border(top: BorderSide(color: RBColors.border, width: 1))`.
Replace `boxShadow` with `[RBShadows.navShadow]`.
Replace `RBColors.textLight` → `RBColors.textSecondary`.
Replace inline `TextStyle` with `RBTextStyles.caption`.
Active: `RBColors.primary`. Inactive: `RBColors.textSecondary`.
Keep the animated top-bar indicator. Icon size: 24px.

### 3.11 `staggered_list.dart` — update stagger duration

Update default `staggerDelay` from `SpottAnimations.stagger` (30ms) to `const Duration(milliseconds: 60)` per Requirement 14.4.

### 3.12 `animated_entrance.dart` — update slide offset

Change default `slideOffset` from `const Offset(0, 0.08)` to a fixed 12px fractional offset computed in build using `MediaQuery`. Retain fade + slide, use `Curves.easeOutCubic`.

### 3.13 `section_title.dart`, `marketplace_card.dart`, `spott_appli_card.dart`, `scene_decorations.dart`, `spott_avatar.dart`

Replace all `SpottColors`/`SpottTextStyles` references with RB equivalents. Remove any `GlassContainer`/`BackdropFilter` usage.

---

## 4. Screen-by-Screen Widget Hierarchy

### 4.1 Home Screen (`home_screen.dart`) — already partially done

**Current issues:**
- `RBColors.primary` is `0xFFD84315` (wrong) → fixed by token update
- Button height is 50px → change to 52px
- Search card `transform: Matrix4.translationValues(0, -1, 0)` is a hack → replace with negative top margin from header (`margin: EdgeInsets.fromLTRB(16, -20, 16, 0)`)
- `RBRadius.xl = 16.0` (wrong) → fixed by token update to `RBRadius.searchContainer = 24.0`
- Hardcoded hex colours in `_buildServicesGrid` and banners → replace with `RBColors`
- Hardcoded `TextStyle` objects → replace with `RBTextStyles`
- `_WhyRow` and `_OfferCard` use hardcoded styles → migrate

**Widget hierarchy (final):**
```
Scaffold(bg: RBColors.background)
├── Column
│   ├── _PrimaryHeader            ← RBColors.primary, SafeArea, logo+greeting+notif+avatar
│   └── Expanded → SingleChildScrollView
│       ├── _SearchCard           ← RBColors.surface, RBRadius.searchContainer, RBShadows.searchShadow
│       │   ├── _ModeTabs         ← 3 tabs, active tab: RBColors.primary bg
│       │   ├── _FromToBox        ← RBColors.border border, swap button
│       │   ├── _DatePassengerRow ← 2 × _InputBox, RBRadius.input
│       │   └── _SearchButton     ← h:52, RBRadius.button, RBColors.primary
│       ├── _SectionRow('Offers') + ListView → _OfferCard×3
│       ├── _SectionRow('Popular Routes') + ListView → _RouteChip×N
│       ├── _SectionRow('Our Services') + GridView(3col) → _ServiceTile×6
│       ├── _ParcelBanner         ← gradient, white CTA button
│       ├── _TravelerBanner       ← gradient, white CTA button
│       └── _WhySpotter           ← RBColors.primarySoft bg, icon+text rows
```

### 4.2 Trip Search Screen (`trip_search_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── AppBar(bg: RBColors.primary, foreground: white, title: 'Search Rides')
└── Body → SingleChildScrollView
    ├── _SearchContainer         ← RBColors.surface, RBRadius.searchContainer, shadow
    │   ├── _FromField           ← min-height 56px, icon: green dot
    │   ├── Divider + SwapButton
    │   └── _ToField             ← min-height 56px, icon: RBColors.primary dot
    ├── _DateSelectorRow         ← RBRadius.input, border: RBColors.border
    ├── _PassengerSelectorRow    ← RBRadius.input, border: RBColors.border
    └── _SearchCTA               ← h:52, RBRadius.button, RBColors.primary, full-width
```

### 4.3 Destination Search Screen (`destination_search_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── _SearchInput                 ← full-width, RBRadius.input, fill: RBColors.surface
│                                   prefix: search icon in RBColors.textSecondary
└── Body (conditional)
    ├── IF query empty → _RecentSuggestions (clock icon, RBColors.textSecondary)
    └── IF query non-empty → _LiveResults list
```

### 4.4 Search Results Screen (`search_results_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── StickyHeader(bg: RBColors.primary)  ← From→To, date, pax count
├── _FilterChipsRow                      ← horizontal scroll, RBRadius.pill chips
└── Body (conditional)
    ├── Loading → ListView of 3× SkeletonRouteCard
    ├── Empty   → BrandedEmptyState.noResults()
    └── Results → AnimatedList of RouteCard (staggered, 60ms interval)
        └── RouteCard (see §3.4)
```

### 4.5 Trip Details Screen (`trip_details_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── AppBar(bg: RBColors.primary)
├── Body → SingleChildScrollView (bottom padding: 88px for sticky CTA)
│   ├── _DriverSection           ← white Surface card, avatar+name+rating+VerificationBadge
│   ├── _RouteSection            ← white Surface card, departure/arrival/stops timeline
│   ├── _VehicleSection          ← white Surface card, icon+label pairs, RBTextStyles.caption
│   └── _AmenitiesSection        ← white Surface card
└── _StickyCTA (fixed bottom)
    ├── height: 72px, SafeArea
    ├── price in RBColors.primary
    └── 'Book Ride' button (h:52, RBRadius.button, RBColors.primary)
```

### 4.6 Profile Screen (`profile_screen.dart`)

```
Scaffold(bg: RBColors.background)
└── CustomScrollView
    ├── SliverAppBar(bg: RBColors.primary, expandedHeight: 200)
    │   └── FlexibleSpaceBar → _ProfileHeader (avatar, name, phone, VerificationBadge)
    ├── SliverToBoxAdapter → _StatsRow
    │   └── Row of 3× _StatCard (white surface, RBRadius.card, RBShadows.cardShadow)
    └── SliverList → settings sections
        ├── _SectionHeader('Account', style: RBTextStyles.caption)
        ├── white Container → ListTile × N
        ├── _SectionHeader('Preferences')
        ├── white Container → ListTile × N
        ├── _SectionHeader('Support')
        ├── white Container → ListTile × N
        └── _SignOutRow (standalone, RBColors.error text)
```

### 4.7 Login Screen (`login_screen.dart`)

```
Scaffold(bg: RBColors.background)
└── Column
    ├── _LogoHeader              ← centred, RBColors.primary wordmark
    ├── _PhoneInputCard          ← white surface card, RBRadius.card
    │   └── TextField (styled per Req 9)
    └── _ContinueButton          ← h:52, RBRadius.button, RBColors.primary
```

### 4.8 OTP Verification Screen (`otp_verification_screen.dart`)

```
Scaffold(bg: RBColors.background)
└── Column
    ├── Back arrow AppBar (transparent)
    ├── Heading + sub in RBTextStyles
    ├── _OTPInputRow             ← 6 × TextField boxes, focusedBorder: RBColors.primary
    ├── _ResendRow               ← ghost button style
    └── _VerifyButton            ← h:52, RBRadius.button, RBColors.primary
```

### 4.9 Choose Role Screen (`choose_role_screen.dart`)

```
Scaffold(bg: RBColors.background)
└── Column
    ├── Heading (RBTextStyles.display)
    ├── _RoleCard('Passenger')   ← RBRadius.card, RBShadows.cardShadow
    │                               active: RBColors.primary border 2px
    ├── _RoleCard('Traveler')
    └── _ContinueButton          ← h:52, RBRadius.button, RBColors.primary
```

### 4.10 Splash Screen (`splash_screen.dart`)

```
Scaffold(bg: RBColors.primary)
└── Center
    └── FadeTransition(400ms)
        └── Column(logo + wordmark, white text)
```

### 4.11 Onboarding Screen (`onboarding_screen.dart`)

```
Scaffold(bg: RBColors.background)
└── Column
    ├── PageView of slides
    │   └── _SlideCard (white surface, RBRadius.card, illustration + heading + body)
    ├── _PageIndicatorRow (active: RBColors.primary dot, inactive: RBColors.border dot)
    └── _GetStartedButton (h:52, RBRadius.button, RBColors.primary)
```

### 4.12 Parcel Booking Screen (`parcel_booking_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── AppBar(bg: RBColors.primary, title: 'Send Parcel')
├── _StepProgressIndicator       ← active: RBColors.primary, pending: RBColors.border
└── Body → form sections (white surface cards)
    └── all TextField per Req 9 spec
```

### 4.13 Parcel Tracking Screen (`parcel_tracking_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── AppBar(bg: RBColors.primary)
└── Body → _StatusTimeline
    └── each step: icon colour from StatusChip mapping (success/warning/error)
```

### 4.14 Ride Confirmation Screen (`ride_confirmation_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── AppBar(bg: RBColors.primary)
├── Body → _SummaryCard (RBColors.surface, RBRadius.card)
│   ├── route + driver + price (RBColors.primary) + seats
│   └── padding per RBSpacing
└── _StickyCTA: 'Confirm & Pay' (h:52, RBColors.primary)
```

### 4.15 Booking Success Screen (`booking_success_screen.dart`)

```
Scaffold(bg: RBColors.background)
└── Center → Column
    ├── AnimatedCheckmark (RBColors.success, 80px)
    ├── Heading (RBTextStyles.heading)
    ├── Booking reference (RBTextStyles.captionMedium)
    ├── _TripSummaryCard (white surface)
    └── 'View Booking' primary button
```

### 4.16 Active Trip Screen (`active_trip_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── _StatusBar (bg: RBColors.primary, live trip status text white)
├── Map widget (unchanged — business logic)
└── _OverlayCard (bottom, RBColors.surface, RBRadius.bottomSheet, RBShadows.cardShadow)
```

### 4.17 Cancel Ride Screen (`cancel_ride_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── AppBar(bg: RBColors.primary)
└── Body → Column
    ├── _ReasonSelector → list of white surface chips (selectable, RBColors.primary border active)
    └── _CancelButton (h:52, bg: RBColors.error, foreground: white, RBRadius.button)
```

### 4.18 Rating Screen

```
Scaffold(bg: RBColors.background)
└── Column
    ├── Heading
    ├── _StarRow → 5 × Icon (selected: RBColors.warning, unselected: RBColors.border)
    ├── _CommentInput (per Req 9)
    └── _SubmitButton (h:52, RBColors.primary)
```

### 4.19 Driver Home Screen (`driver_home_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── _PrimaryHeader (RBColors.primary, same as home)
└── Body → ScrollView
    ├── _EarningsSummaryCard (white surface, RBRadius.card)
    ├── _OnlineToggle
    └── _ActiveTripCard / empty state
```

### 4.20 Driver Matches Screen / Job Requests Screen

```
Scaffold(bg: RBColors.background)
├── AppBar(bg: RBColors.primary)
└── ListView of _MatchCard
    └── each: white surface, RBRadius.card, RBShadows.cardShadow
        ├── passenger info
        ├── StatusChip (top-right)
        ├── 'Accept' primary button
        └── 'Decline' outlined button
```

### 4.21 Notifications Screen (`notifications_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── AppBar(bg: RBColors.primary)
└── Body (conditional)
    ├── Loading → Skeleton cards
    ├── Empty   → BrandedEmptyState.noNotifications()
    └── List    → _NotificationCard (white surface, RBRadius.card)
        └── left: unread dot (RBColors.primary 8px) for unread items
```

### 4.22 Safety Toolkit Screen (`safety_toolkit_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── AppBar(bg: RBColors.primary)
└── ListView of _SafetyCard
    └── white surface, RBRadius.card, left border accent (RBColors.primary 3px)
        └── Icon + label rows, RBTextStyles.body
```

### 4.23 Support Screen (`support_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── AppBar(bg: RBColors.primary)
└── ListView (grouped sections)
    └── section: white surface container
        └── ListTile (icon: RBColors.primary, text: RBTextStyles.body)
```

### 4.24 Settings Screen (`settings_screen.dart`)

Identical pattern to Profile settings sections (Requirement 20.4).

### 4.25 Maintenance / Network Error Screens

```
Scaffold(bg: RBColors.background)
└── Center → Column
    ├── Icon (RBColors.primary.withValues(alpha:0.12) container, 80px)
    ├── Heading (RBTextStyles.heading)
    ├── Description (RBTextStyles.body)
    └── 'Retry' primary button (h:52, RBColors.primary)
```

### 4.26 No Results Screen / Empty State Screen

Use `BrandedEmptyState` with appropriate preset (noResults, noTrips, etc.).

### 4.27 Chat Screen (`chat_screen.dart`)

```
Scaffold(bg: RBColors.background)
├── AppBar(bg: RBColors.primary)
├── ListView of messages
│   ├── sent  → bubble: RBColors.primary, text: white
│   └── received → bubble: RBColors.surface (border: RBColors.border), text: RBColors.textPrimary
└── _InputRow (TextField per Req 9 + send button)
```

### 4.28 KYC / Create Trip / Vehicle Management / Parcel History / Passenger Trips / Traveler Trips Screens

All use `Scaffold(bg: RBColors.background)`, `AppBar(bg: RBColors.primary)`, white surface form/list sections, and comply with Req 9 for any inputs.

---

## 5. Animation System Design

### 5.1 Page Transitions (`app_routes.dart`)

`SpottPageTransitions.fadeSlideUp` already implements FadeTransition + SlideTransition. Update duration from `SpottAnimations.medium (200ms)` to `const Duration(milliseconds: 250)` per Requirement 14.1.

### 5.2 Card Press Feedback

All tappable cards use `AnimatedScale` via `GestureDetector`:
```dart
onTapDown: (_) => _controller.forward(),   // scale to 0.97
onTapUp:   (_) => _controller.reverse(),
// duration: 100ms, curve: Curves.easeOut
```
Retain `HapticFeedback.lightImpact()`.

### 5.3 Bottom Sheet Transitions

All `showModalBottomSheet` calls use:
```dart
transitionAnimationController: AnimationController(
  duration: const Duration(milliseconds: 300),
  vsync: this,
)
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(RBRadius.bottomSheet)))
```
`Curves.easeOutCubic` on the slide.

### 5.4 Stagger List Entry

`StaggeredList.staggerDelay` updated to `const Duration(milliseconds: 60)`.
`AnimatedEntrance.slideOffset` uses a 12px downward offset:
```dart
// computed as fractional offset:
begin: const Offset(0, 0.04)  // approx 12px on 300px card height
```

### 5.5 Skeleton → Content Fade-in

After data loads, content replaces skeleton with `AnimatedSwitcher(duration: const Duration(milliseconds: 200))`.

---

## 6. Font Setup

The `Inter` font family is currently not declared in `pubspec.yaml`. Since the app has no `fonts` section, Flutter falls back to the system font which is different from Inter on all platforms.

**Required change to `pubspec.yaml`:**
Add Google Fonts package OR bundle Inter font files. The preferred approach (zero external dependencies):
1. Download Inter font files (Regular 400, Medium 500, SemiBold 600, Bold 700, ExtraBold 800) from fonts.google.com and place in `fonts/` directory.
2. Register in `pubspec.yaml`:
```yaml
fonts:
  - family: Inter
    fonts:
      - asset: fonts/Inter-Regular.ttf
        weight: 400
      - asset: fonts/Inter-Medium.ttf
        weight: 500
      - asset: fonts/Inter-SemiBold.ttf
        weight: 600
      - asset: fonts/Inter-Bold.ttf
        weight: 700
      - asset: fonts/Inter-ExtraBold.ttf
        weight: 800
```

---

## 7. File-by-File Change Inventory

### Phase 1 — Token Foundation (1 file)
| File | Change |
|---|---|
| `lib/core/theme/redbus_theme.dart` | Update `RBColors`, `RBTextStyles`, `RBSpacing`, `RBRadius`; add `RBShadows` |

### Phase 2 — Shared Components (12 files)
| File | Change |
|---|---|
| `lib/core/components/spott_buttons.dart` | Rewrite: remove glass/gradient, add RB button variants |
| `lib/core/components/status_chip.dart` | Replace SpottColors → RBColors, remove glassSurface |
| `lib/core/components/trust_badge.dart` | Replace SpottColors/SpottTextStyles → RB equivalents |
| `lib/core/components/route_card.dart` | Replace GlassCard + SpottColors → Container + RBColors, add Book Now CTA |
| `lib/core/components/skeleton_route_card.dart` | Replace GlassCard → plain Container, update ShimmerLoading |
| `lib/core/components/shimmer_loading.dart` | Replace SpottColors shimmer values → RBColors |
| `lib/core/components/branded_empty_state.dart` | Replace SpottColors/SpottTextStyles/SpottButton → RB equivalents |
| `lib/core/components/floating_bottom_nav.dart` | Add border, update shadow, update text style |
| `lib/core/components/staggered_list.dart` | Update staggerDelay to 60ms |
| `lib/core/components/animated_entrance.dart` | Update slideOffset, curve |
| `lib/core/components/section_title.dart` | Replace SpottTextStyles → RBTextStyles |
| `lib/core/components/spott_avatar.dart` | Replace SpottColors → RBColors |

### Phase 3 — Auth & Onboarding Screens (5 files)
`splash_screen.dart`, `onboarding_screen.dart`, `login_screen.dart`, `otp_verification_screen.dart`, `choose_role_screen.dart`

### Phase 4 — Core Navigation & Home (3 files)
`home_screen.dart`, `main_navigation_shell.dart`, `driver_home_screen.dart`

### Phase 5 — Search & Results Flow (4 files)
`trip_search_screen.dart`, `destination_search_screen.dart`, `search_results_screen.dart`, `no_results_screen.dart`

### Phase 6 — Trip Detail & Booking Flow (6 files)
`trip_details_screen.dart`, `ride_confirmation_screen.dart`, `payment_screen.dart`, `booking_success_screen.dart`, `active_trip_screen.dart`, `ride_complete_screen.dart`

### Phase 7 — Profile & Settings (3 files)
`profile_screen.dart`, `settings_screen.dart`, `kyc_verification_screen.dart`

### Phase 8 — Parcel Flow (5 files)
`parcel_booking_screen.dart`, `parcel_tracking_screen.dart`, `parcel_complete_screen.dart`, `parcel_history_screen.dart`, `create_trip_screen.dart`

### Phase 9 — Driver-Side Screens (6 files)
`driver_home_screen.dart`, `driver_matches_screen.dart`, `job_requests_screen.dart`, `job_detail_screen.dart`, `traveler_trips_screen.dart`, `vehicle_management_screen.dart`

### Phase 10 — Utility & Support Screens (10 files)
`notifications_screen.dart`, `activity_screen.dart`, `safety_toolkit_screen.dart`, `support_screen.dart`, `chat_screen.dart`, `cancel_ride_screen.dart`, `rating_screen.dart`, `maintenance_screen.dart`, `network_error_screen.dart`, `empty_state_screen.dart`

### Phase 11 — Remaining Screens (12 files)
`passenger_trips_screen.dart`, `passenger_requests_screen.dart`, `verification_pending_screen.dart`, `pickup_location_screen.dart`, `fare_estimate_screen.dart`, `share_trip_screen.dart`, `live_tracking_screen.dart`, `driver_profile_screen.dart`, `pickup_task_screen.dart`, `drop_task_screen.dart`, `admin_review_screen.dart`, `dispute_case_screen.dart`

### Phase 12 — Font & pubspec (1 file)
`pubspec.yaml` — add Inter font family declaration

---

## 8. Regression Guard

The following are **never modified** in any phase:

- `lib/controllers/` — all files
- `lib/models/` — all files
- `lib/repositories/` — all files
- `lib/app/app_routes.dart`
- `lib/app/app_readiness.dart`
- `lib/app/app_config.dart`
- `lib/app/app_crash_reporter.dart`
- Any `test/` or `integration_test/` file

Widget state (`setState`, `initState`, controller references, `Navigator.push*` calls) is preserved verbatim during screen redesigns. Only the `build()` method's widget tree is updated.
