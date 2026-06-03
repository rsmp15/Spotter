# Research: Production Readiness

## Decision: Keep the first production-readiness pass inside the existing Flutter app

**Rationale**: The repository already has a single Flutter application with route registry, app configuration, crash reporting hooks, shared ride state, repository abstraction, and starter tests. The spec asks for production readiness of the current app, not a new backend or platform split.

**Alternatives considered**: Adding a backend service or separate operations package was rejected for this phase because the spec explicitly allows launch dependencies to remain blockers until real providers are configured.

## Decision: Represent missing external providers as readiness blockers

**Rationale**: Payment, KYC, location, support escalation, messaging, and crash provider credentials are launch-critical, but the current app is a prototype. A production-grade plan should not pretend mock providers are launch-ready.

**Alternatives considered**: Replacing mock services with live integrations was rejected for planning because provider choice, credentials, and compliance requirements are outside the current spec.

## Decision: Use controller-level recoverable action states for ride failures

**Rationale**: `RideController` already owns ride context and repository actions. Adding explicit success, failure, retry, and safe-navigation behavior at that boundary keeps screens consistent and testable.

**Alternatives considered**: Handling failures separately in each screen was rejected because it would duplicate messages and increase the chance of inconsistent recovery actions.

## Decision: Treat diagnostics as structured, redacted events

**Rationale**: The spec requires production diagnostics with environment, screen, and action context while preventing sensitive payment, identity, and precise location data leaks. A structured diagnostic event model allows deterministic redaction tests.

**Alternatives considered**: Raw exception forwarding was rejected because it cannot guarantee sensitive-data exclusion.

## Decision: Validate route coverage through tests

**Rationale**: `AppRoutes` is centralized, so route coverage and fallback behavior can be tested without manual navigation through every screen. This directly supports SC-002.

**Alternatives considered**: Manual smoke testing only was rejected because route regressions are easy to introduce and cheap to test automatically.

## Decision: Use a UI contract for production readiness

**Rationale**: This is a client application with user-facing flows rather than an external API. A UI contract captures required states, actions, and visible outcomes in a form `/speckit-tasks` can convert into tests and implementation work.

**Alternatives considered**: OpenAPI-style contracts were rejected because the project does not currently expose a web service API.
