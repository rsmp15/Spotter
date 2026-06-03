# UI Contract: Production Readiness

## Route Coverage

Every route declared by the app must satisfy one of these outcomes:

- Opens the intended user-facing screen.
- Opens a clear fallback screen with a path back to a valid flow.

Required route groups:

- Onboarding and authentication: splash, onboarding, login, OTP, role selection.
- Rider journey: home, pickup, destination, fare, drivers, driver profile, confirmation, payment, tracking, ride OTP, completion, rating.
- Driver journey: driver home, create trip, job requests, job detail, pickup task, drop task.
- Support and operations: wallet, profile, chat, share trip, cancel ride, notifications, support, dispute, empty state, KYC, admin review.

## Ride Flow Contract

The P1 scripted flow must support:

1. Start app and reach role selection.
2. Choose rider role.
3. Start pickup or destination selection.
4. Review fare.
5. Select ride option and driver.
6. Confirm ride.
7. Track active ride.
8. Complete ride payment.
9. Rate ride.
10. Access support or dispute context if needed.

The app must preserve pickup, destination, selected ride option, selected driver, selected payment method, trip status, and share reference across the flow.

## Failure Recovery Contract

Representative failure states must show:

- A user-readable explanation.
- A primary recovery action.
- No crash or blank screen.
- Preserved ride context when safe defaults exist.

Required failure examples:

- Ride data refresh fails.
- Cancel ride action fails.
- Rating submission fails.
- Unknown route is opened.
- Payment or wallet action cannot continue.

## Release Readiness Contract

The app must expose readiness checks with:

- Stable check label.
- Category.
- Pass, warning, or blocked status.
- Human-readable reason for non-pass status.

Production readiness is blocked when any required production check is blocked.

Required check categories:

- Release mode configuration.
- Crash diagnostics.
- Payment provider setup.
- Identity verification setup.
- Location provider setup.
- Support escalation setup.
- Route coverage.
- P1 regression coverage.

## Diagnostics Contract

Diagnostics must include:

- Release mode.
- Route or screen context when available.
- Action context when available.
- Severity.
- Redacted message.

Diagnostics must exclude:

- Full payment instrument values.
- Identity document values or images.
- Precise location trails.
- Secrets or provider credentials.

## Support Case Contract

Support and dispute flows must produce reviewable context:

- Ride reference.
- User role.
- Issue category.
- User-visible status.
- Timestamp.
- Optional user description.

Support context must be useful even when optional details are absent.
