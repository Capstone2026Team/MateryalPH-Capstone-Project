# Admin reCAPTCHA acceptance — 14 October 2026

Admin sign-in, invitation-only registration, and password recovery now use the
shared reCAPTCHA Enterprise checkbox and accessible email security check.
Google decides whether a checkbox requires an image or audio challenge. A
checkmark without a puzzle can be valid; application code cannot require an
image puzzle on every click of a standard checkbox key.

## Implementation and files

- Admin forms: `apps/admin-web/src/App.tsx`,
  `src/pages/AuthSupportPages.tsx`, `src/components/AdminBotProtection.tsx`,
  `src/lib/auth-api.ts`, `src/vite-env.d.ts`, and `.env.example`.
- Shared controls: `packages/web-ui/src/recaptcha-enterprise.ts`,
  `recaptcha-checkbox.tsx`, `email-security-check.tsx`,
  `web-bot-protection.ts`, `bot-protection.css`, and `index.ts`.
  Vendor checkbox, email panel, authentication helpers, and `App.css` reuse
  those controls without duplicating the behavior.
- API domain: `BotProtectionService.php`, `AcceptAdminInvitation.php`, and
  `AuthenticateAccount.php`. Login rechecks current account eligibility and
  password state after provider verification. Invitation acceptance checks
  recipient and inviter authority before verification and again on acceptance.
- API transport: Admin invitation and bot-challenge requests/controllers,
  shared evidence validation, login and recovery controllers.
- Configuration: `services/api/config/materyalph.php`, `.env.example`,
  `scripts/recaptcha-preflight.php`, `README.md`, and the environment setup guide.
- Contract: `packages/api-contract/openapi.yaml`, regenerated TypeScript/Dart
  clients and Dart serializers, `scripts/check-bot-protection-contract.mjs`,
  `scripts/check-bot-protection.dart`, and the contract package script.
- Regression coverage: `BotProtectionTest.php`, Admin `App.test.tsx`, and
  Admin `src/lib/auth-api.test.ts`.

New migration:
`services/api/database/migrations/2026_10_14_120000_allow_admin_bot_risk_challenges.php`.
It extends the existing PostgreSQL portal constraint to include Admin without
changing or deleting existing challenge records. The development API reports
this migration as applied in batch 41. Laravel's configuration cache was cleared.

## Security and API behavior

The API selects `admin_login`, `admin_invitation_accept`, or
`admin_password_recovery` and checks Google's token validity, action, and
configured hostname. Missing evidence is rejected while bot protection is
enabled. Invalid assessments and provider outages require the email security
check; missing configuration fails closed. Invalid invitation links and
recipients cannot trigger security emails or create accounts.

Email proofs remain single-use, short-lived, and bound to email, portal, and
action. Web proofs stay in HttpOnly cookies, isolated by the existing portal
cookie middleware. Mandatory Admin authenticator MFA, invitation-only access,
rate limits, server authorization, and security audit events remain in force.
Email bot verification does not replace MFA or password recovery verification.

Admin invitation requests accept optional `email` and `bot_protection` fields.
The server derives the account and delivery recipient from the invitation.
Browser challenge requests accept `portal: ADMIN` or `VENDOR`; omission keeps
the existing Vendor selection. Browser operation names are
`verifyWebBotChallenge` and `resendWebBotChallenge`, using
`WebVerifyBotChallengeRequest` and `WebResendBotChallengeRequest`. URLs remain
unchanged. Buyer-native challenge schemas and serialized requests omit the
browser portal field; mobile routes reject it.

## Configuration and manual acceptance

Development bot protection is enabled. The existing Admin public site key
matches the API configuration; no environment credentials were changed.
Optional `RECAPTCHA_ADMIN_WEB_SITE_KEY` and
`RECAPTCHA_ADMIN_WEB_ALLOWED_HOSTNAMES` select a separate Admin configuration.
Blank values reuse the Vendor key and allowed-host configuration.
`VITE_RECAPTCHA_SITE_KEY` contains only a public site key.

In Google Cloud, verify that each portal uses an Enterprise checkbox key and
that its hostname is allowed. Review the key's challenge security preference
to increase challenge frequency if needed. Testing keys configured for
`NOCAPTCHA` deliberately omit puzzles. The Google Cloud key configuration has
not been inspected or changed. The current local site key is not the Classic
universal testing key; that check does not establish the Cloud key's testing
settings.

Google documents this behavior in
[checkbox installation](https://docs.cloud.google.com/recaptcha/docs/instrument-web-pages-with-checkbox)
and [key types](https://docs.cloud.google.com/recaptcha/docs/choose-key-type).

Manual browser acceptance remains:

1. Sign in with an invited Admin using the checkbox; confirm mandatory MFA.
2. Accept a valid Admin invitation; confirm sign-in and authenticator enrollment.
3. Use the email security alternative on both flows and recovery; confirm that
   verification continues the original request once.
4. Check expiration, provider failure, keyboard navigation, and narrow screens.
5. Confirm a real Development token is assessed by Google through Laravel.

No browser/E2E or real user-token provider assessment was run.

## Verification results

- Isolated API regression suite: **82 passed, 2,261 assertions**. Included
  bot protection, Enterprise adapter, authentication acceptance, transport,
  Admin administration, account security, MFA, and rate-limit isolation tests.
- Admin full suite: **112 passed across 23 files**.
- Vendor full suite: **464 passed, 6 failed across 53 files**. All failures are
  in the unchanged `OrderPages.test.tsx`: order-document navigation for pickup
  and delivery, pickup confirmation payload, NRPC reason handling, and two
  fulfillment Message cases. Authentication and checkbox tests passed.
- PHP Pint and PHPStan: passed.
- Admin and Vendor lint, strict TypeScript checks, and production builds: passed.
  Builds retain non-blocking chunk-size warnings.
- OpenAPI validation and TypeScript bot-protection serialization checks: passed.
- Dart serializers regenerated and the handwritten bot-protection serialization
  check passed. Focused analysis of the changed authentication API and models
  passed with no issues. Full generated-client analysis found one warning in the
  unrelated `geo_demand_cell_value.dart:40` (`unused_element_parameter`).
- Docker Compose configuration and development migration status: passed.
- Source review: no introduced trailing whitespace; Gitleaks directory scan of
  the task's source files found no leaks. No Git commands were used.

Full API and Buyer app suites were not run. The API tests used isolated
PostgreSQL, not the development database; development migration status was
checked separately. Initial unrestricted parallel portal runs exhausted memory;
the reported results use `--maxWorkers=1 --no-file-parallelism`.

Suggested commit: `feat(auth): validate Admin reCAPTCHA and share bot protection`.
