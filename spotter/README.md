# Spotter

Spotter is a Flutter ride-marketplace prototype covering rider booking, driver
availability, live tracking, payment, support, and post-ride feedback flows.

## Production Readiness

The app now has a production-oriented shell:

- Centralized route registry with a safe "page not found" fallback.
- Guarded app bootstrap for Flutter and platform-level uncaught errors.
- Environment-driven app configuration via Dart defines.
- Owned controller lifecycle so shared ride state is disposed correctly.
- Repository-backed ride data with mock seed data and async refresh handling.
- Shared theme, button, card, and screen primitives for consistent UX.

Example production build:

```sh
flutter build apk --release \
  --dart-define=APP_ENV=production \
  --dart-define=APP_NAME=Spotter \
  --dart-define=ENABLE_CRASH_DIAGNOSTICS=true \
  --dart-define=PAYMENT_PROVIDER_CONFIGURED=true \
  --dart-define=IDENTITY_VERIFICATION_CONFIGURED=true \
  --dart-define=LOCATION_PROVIDER_CONFIGURED=true \
  --dart-define=SUPPORT_ESCALATION_CONFIGURED=true \
  --dart-define=ROUTE_COVERAGE_VERIFIED=true \
  --dart-define=P1_REGRESSION_COVERAGE_VERIFIED=true
```

Before launch, wire a real crash provider in
`lib/app/app_crash_reporter.dart`, replace `MockRideRepository` with
authenticated API-backed repositories, and add payment/KYC/location provider
credentials per platform.

Production readiness remains blocked until diagnostics, payment, identity
verification, location services, support escalation, route coverage, and P1
regression coverage are all explicitly marked ready for the production build.
Diagnostic events are structured and redacted before they can be forwarded to a
future provider.

## Validation

```sh
dart analyze
flutter test
```
