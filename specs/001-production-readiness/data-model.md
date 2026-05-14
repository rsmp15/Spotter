# Data Model: Production Readiness

## Ride Journey

Represents the full ride experience from role selection through booking, matching, tracking, payment, rating, and support.

Fields:

- `id`: Stable ride reference shown to users and support.
- `role`: Rider or driver.
- `context`: Current ride context.
- `status`: Draft, searching, driver assigned, arriving, in progress, completed, cancelled, or failed.
- `lastUpdatedAt`: Timestamp of the latest state change.

Validation:

- A journey must always have a status.
- A journey cannot be marked completed before it has entered an in-progress state.
- A cancelled journey must include a cancellation reason when the user supplied one.

## Ride Context

Carries user selections and operational context across screens.

Fields:

- `pickup`: User-visible pickup label and approximate detail.
- `destination`: User-visible destination label and approximate detail.
- `selectedRideOption`: Selected service option, if available.
- `selectedDriver`: Selected or assigned driver, if available.
- `selectedPaymentMethod`: Selected payment method, if available.
- `shareReference`: Shareable trip reference or link.

Validation:

- Pickup and destination labels must be user-readable.
- Payment, identity, and precise location values must not be embedded in diagnostic context.
- Missing optional selections must produce safe defaults or a recoverable empty state.

## Release Mode

Identifies the current operating mode and launch behavior.

Fields:

- `name`: Development, staging, or production.
- `displayName`: User- or operator-readable release identity.
- `diagnosticsEnabled`: Whether crash/error diagnostics are enabled.
- `isProduction`: Whether production readiness gates apply.

Validation:

- Production mode requires diagnostics to be enabled.
- Unknown release mode must be treated as non-production and blocked from production readiness.

## Readiness Check

Represents one launch gate required before production release.

Fields:

- `id`: Stable check identifier.
- `label`: Human-readable check name.
- `category`: Configuration, diagnostics, payment, identity, location, support, navigation, test coverage, or release.
- `status`: Pass, blocked, warning.
- `reason`: Required when blocked or warning.
- `requiredForProduction`: Whether this check blocks production readiness.

Validation:

- Blocked and warning checks must include a human-readable reason.
- Production readiness passes only when every required production check has pass status.

## Diagnostic Event

Represents a crash or error report that can be sent to a future provider.

Fields:

- `environment`: Current release mode.
- `screen`: Screen or route where the event occurred.
- `action`: User or system action being performed.
- `severity`: Info, warning, error, fatal.
- `message`: Redacted summary.
- `stackAvailable`: Whether stack details exist.
- `rideReference`: Optional non-sensitive ride reference.

Validation:

- Must not include full payment details, identity documents, or precise location trails.
- Must include environment when diagnostics are enabled.
- Fatal events must include enough context to identify the screen and action when available.

## Support Case

Represents a help, dispute, cancellation, or escalation record.

Fields:

- `caseId`: Stable support reference.
- `rideReference`: Associated ride reference.
- `role`: Rider, driver, or operator.
- `category`: Cancellation, payment, safety, route, driver, rider, technical, or other.
- `status`: Draft, submitted, in review, resolved.
- `description`: User-provided issue summary.
- `createdAt`: Submission timestamp.

Validation:

- Submitted support cases must include role, category, status, and ride reference when tied to a ride.
- Optional details may be missing, but the case must remain reviewable without screenshots for scripted test cases.

## Recoverable Action State

Represents user-facing recovery when an action fails.

Fields:

- `action`: The failed or delayed action.
- `state`: Idle, loading, success, failure.
- `message`: User-facing explanation.
- `primaryRecovery`: Retry, go home, contact support, cancel ride, or continue with defaults.
- `canRetry`: Whether retry is allowed.

Validation:

- Failure state must include a user-facing message.
- Failure state must include at least one safe recovery action.
- Recovery state must preserve existing ride context whenever possible.
