# Implementation Plan: Rider Home, Destination, and Services Refresh

**Branch**: `001-rider-home-services` | **Date**: 2026-05-14 | **Spec**: [spec.md](D:/PROJECTS/Spotter/spotter/specs/001-rider-home-services/spec.md)

**Input**: Feature specification from `/specs/001-rider-home-services/spec.md`

## Summary

Replace the existing rider landing experience with a discovery-style home screen, connect it directly to the refreshed destination planner, add a new services screen, and verify the end-to-end rider flow and tab navigation with widget tests.

## Technical Context

**Language/Version**: Dart 3.11 / Flutter

**Primary Dependencies**: Flutter Material, existing `RideController`, existing route registry

**Storage**: N/A

**Testing**: `flutter_test`, `dart analyze`, targeted `flutter test`

**Target Platform**: Flutter mobile/web prototype

**Project Type**: Mobile app

**Performance Goals**: Smooth scrollable layouts with stable fixed bottom navigation

**Constraints**: Keep changes within the existing route/controller architecture and avoid breaking the rider booking flow

**Scale/Scope**: Three rider-facing screens plus route and test updates

## Constitution Check

The repository constitution is still template-only, so no additional project-specific gates are defined. The implementation follows existing route/controller patterns, keeps the change scoped to rider discovery screens, and preserves automated validation.

## Project Structure

### Documentation (this feature)

```text
specs/001-rider-home-services/
├── plan.md
├── spec.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── app/app_routes.dart
└── screens/
    ├── destination_search_screen.dart
    ├── home_screen.dart
    ├── rider_bottom_nav.dart
    └── services_screen.dart

test/
├── home_services_navigation_test.dart
├── rider_flow_test.dart
└── route_coverage_test.dart
```

**Structure Decision**: Reuse the existing Flutter single-project structure and keep the refresh confined to the route registry, rider-facing screen files, and focused widget tests.

## Complexity Tracking

No constitution violations or extra complexity exceptions were needed.
