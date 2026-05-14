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
  --dart-define=ENABLE_CRASH_DIAGNOSTICS=true
```

Before launch, wire a real crash provider in
`lib/app/app_crash_reporter.dart`, replace `MockRideRepository` with
authenticated API-backed repositories, and add payment/KYC/location provider
credentials per platform.

## Validation

```sh
dart analyze
flutter test
```
