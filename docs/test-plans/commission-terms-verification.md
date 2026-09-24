# Commission Terms in Store Verification

Implemented September 24, 2026.

## Outcome

The 2% Commission Terms panel is immediately above Privacy Notice in V4, Privacy, Review and Submit. The responsive panel presents the version, materials base, monthly collection, VAT-inclusive fee treatment where applicable, cancellation/partial-refund credits, statement due dates, dispute process and authorized acceptance summary. The existing published TEST/DEMO content is displayed in a keyboard-accessible reader. Reading to the end enables an initially unchecked consent control; an explicit action records acceptance.

Store Setup now has five steps: Public Store Profile, Fulfillment Configuration, Xendit TEST Connection, Team Accounts, Review and Complete. Setup completion no longer requests or records commission consent. Automatic verification drafts, pending evidence, inline validation and the Business Information layout are preserved. No Navigation Sidebar changes or further Phase 3D implementation are included.

## Persistence, API and authorization

- Additive migration `2026_09_24_000001_move_commission_terms_to_verification.php` moves current commission requirement rows without rewriting agreement versions, acceptance records or review history. It is reversible and works with fresh migrations in the isolated database.
- `POST /api/v1/vendors/onboarding/verification/commission` requires an organization lock version, the displayed agreement version UUID, explicit acceptance, CSRF and an idempotency key. It returns the authoritative onboarding snapshot.
- Snapshot `verification.commission_terms` includes the published agreement, `can_accept` and `accepted`. The existing requirement registry and activation gate derive commission completion from the current agreement acceptance and applicable authority approval.
- Acceptance uses the existing Owner/Owner-linked approved signatory model. Organizational representatives require current Admin approval for `COMMISSION_AGREEMENT`. There is no new representative login or staff permission.
- Evidence submission remains available while authority approval is pending. After approval, the Vendor returns to V4 to accept. Commission acceptance is excluded from Admin review decisions and submission transitions; Admin cannot accept on behalf of the Vendor.
- The generic account-agreement endpoint rejects commission consent, preventing it from bypassing the specific authority checks. Acceptance is audited. Published content must be available and hash-valid. Replayed requests do not duplicate acceptance.
- Setup completion now accepts only `organization_lock_version`. OpenAPI and generated TypeScript/Dart clients are regenerated; the contract check includes the new operation.

## Verification

- Isolated Docker Compose full API suite: **177 passed, 2,103 assertions**.
- Follow-up onboarding suite after the Admin queue adjustment and generic-account bypass regression: **64 passed, 747 assertions**.
- Pint check and PHPStan: passed, zero analysis errors.
- Vendor lint, typecheck, build and component suite: **121 passed across 15 files**.
- Admin lint, typecheck, build and component suite: **16 passed across 8 files**.
- Browser onboarding suite: **56 passed** at all eight widths: **320, 375, 390, 768, 1024, 1280, 1440, 1920 px**. Includes panel ordering, actual scroll-end gating, explicit version-bound request, recorded status, five-step setup and no horizontal overflow. Desktop and narrow-screen screenshots were visually inspected.
- OpenAPI validation, TypeScript client build, Dart serialization generation and analysis: passed. The validator reports the three pre-existing unused model recommendations.
- Vendor/Admin route-contract check: **33 operations matched**.
- Docker Compose configurations and diff whitespace check: passed. Gitleaks scanned changed/untracked source content with redaction: no leaks.

## Setup and limits

Apply the additive migration in the development environment using its normal API container: `php artisan migrate`. This task migrated only the isolated test database; it did not deploy or migrate the development database. No new environment variables or credentials are required.

The full agreement remains the existing short, immutable TEST/DEMO version. The new summary communicates the requested topics, but this change does not publish a new detailed legal agreement or production terms. Existing acceptance history is preserved. Browser tests use intercepted API fixtures; authorization and persistence are verified separately in Docker. No live payment/provider behavior is exercised. The relocation and design are ready for review after the development migration; this is not a production agreement approval.

Suggested commit: `feat(onboarding): move commission acceptance into verification review`
