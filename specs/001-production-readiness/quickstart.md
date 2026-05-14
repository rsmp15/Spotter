# Quickstart: Production Readiness

## Prerequisites

- Flutter SDK compatible with Dart `^3.10.8`.
- Project dependencies restored in `spotter/`.

## Validate Current App

From `D:\projects\spotter\spotter`:

```powershell
flutter pub get
dart analyze
flutter test
```

Validation completed on 2026-05-14:

- `dart analyze` passes with no issues.
- `flutter test` passes with the production-readiness regression suite.

## Expected Production-Readiness Work

Implementation tasks should add or update:

- Release readiness checks for environment, diagnostics, payment, KYC, location, support, route coverage, and regression coverage.
- Redacted diagnostic event handling.
- Consistent recoverable action states for ride refresh, cancellation, rating, payment, support, and unknown navigation failures.
- Tests for route coverage, P1 ride flow, driver flow, support context, readiness checks, and diagnostics redaction.

Implemented coverage includes route fallback tests, rider flow tests, driver
flow tests, ride recovery tests, launch readiness checks, diagnostics redaction
tests, support/dispute context tests, and cancellation/rating recovery tests.

## Manual Smoke Flow

1. Launch the app.
2. Confirm splash screen appears.
3. Continue to role selection.
4. Choose rider.
5. Start pickup or destination flow.
6. Review fare.
7. Select a ride option.
8. Confirm driver and ride.
9. Move through tracking, payment, completion, and rating.
10. Open support or dispute flow and confirm ride context is visible.
11. Open wallet, profile, notifications, and an unknown route fallback.

## Production Build Example

```powershell
flutter build apk --release `
  --dart-define=APP_ENV=production `
  --dart-define=APP_NAME=Spotter `
  --dart-define=ENABLE_CRASH_DIAGNOSTICS=true
```

The build must remain blocked from production readiness until all required readiness checks pass.

## Smoke Validation Notes

- Rider flow: covered by automated widget flow from home through rating.
- Driver flow: covered by automated widget flow from driver home through drop task.
- Failure recovery: covered for failed refresh, cancellation, rating, and unknown routes.
- Launch controls: readiness checks expose blocked launch dependencies until production flags are supplied.
