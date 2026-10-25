# Vendor and Admin password recovery — 26 October 2026

Both portals use the same recovery component: choose a method, verify identity, then set a new password. The email entered on sign-in is carried through router state and shown masked. An email input appears only if the address is missing or explicitly changed. **Send authentication code** and **Use recovery codes** replace the duplicate email actions; reCAPTCHA sits below these choices.

Email codes use the shared six-digit input with paste/autofill, server cooldown, and an exact expiry in Asia/Manila. The accessible email fallback is integrated into the send action and requires only one recovery security code. Saved authenticator backup codes have a separate field. Password inputs remain hidden until server verification succeeds. Vendor retains its 12-character password minimum; Admin retains 14. Both require mixed case and a number. Legacy `/reset-password` links also begin at verification.

## Files and API contract

- Both portals: `src/App.tsx`, `src/lib/auth-api.ts`, `src/pages/AuthSupportPages.tsx`, and authentication tests; Vendor adds `VendorPasswordRecovery.test.tsx`.
- Shared UI: `packages/web-ui/src/password-recovery-flow.tsx`, its CSS, and the shared export.
- API: `RecoverWebPassword`, `WebPasswordRecoveryController`, `VerifyWebPasswordRecoveryRequest`, `CompleteWebPasswordRecoveryRequest`, cookie factory/isolation middleware, auth routes, sensitive-input flash exclusions, and Admin/Vendor recovery feature tests.
- Both workflow documents record the clarified recovery behavior. OpenAPI and generated TypeScript/Dart authentication clients/models are updated, with route/security and serialization checks.
- `POST /api/v1/auth/password/verify` takes `portal` (`VENDOR` or `ADMIN`), email, and exactly one email code or saved backup code. An optional challenge ID must identify that portal's web password-recovery challenge.
- `POST /api/v1/auth/password/complete` takes portal, email, and confirmed password, and requires the matching verified proof cookie. The existing `/auth/password/reset` contract stays available to legacy clients.
- The browser forgot-password response now includes server resend/expiry metadata. The native Buyer response stays compatible.

No migration or new environment variable is needed. Proofs use the existing `password_reset_tokens` table.

## Security and authorization

Verification issues a short-lived, single-use, password-bound proof in a Secure HttpOnly cookie scoped to the password API path and isolated by portal. JavaScript never receives that proof. Both steps retain CSRF and public-auth limits; failed verification also has an account-scoped limit. Failed OTP attempts commit, and invalid/unknown accounts receive the same failure.

Login, invitation, other-portal, and native Buyer challenges cannot authorize this reset. Backup-code use replaces the entire saved set, revokes sessions, records the method, and queues a notice transactionally. Replacement codes can be downloaded before leaving the password screen and saved after reset. Password reset consumes its proof, revokes sessions, records a security event, and queues a notice. Responses containing verification results are not cacheable.

Recovery preserves email verification, onboarding, membership and organization decisions. A legitimately invited Admin awaiting initial MFA can reset without becoming active; a Vendor awaiting email verification remains pending. Admin and privileged Vendor MFA stays required at sign-in. The authenticator remains enrolled after backup-code use.

## Validation

- Isolated API authentication regressions: **68 tests, 680 assertions passed**, covering both recovery methods, password policies, pending setup, expiry, replay, portal separation, CSRF, invalid attempts, notices, session revocation, and existing bot/MFA/native transport behavior.
- Admin component suite: **27 files, 169 tests passed**. Vendor authentication/recovery suite: **3 files, 39 tests passed**, including sign-in email carry, both recovery methods, Vendor-bound checkbox evidence, verification failure, password entry, replacement-code saving, MFA, and legacy reset links.
- Both portals' lint, typechecks and production builds passed. Builds retain the existing large-chunk advisory. Vendor lint reports an unrelated unused-variable warning in `e2e/admin-finance-layout.spec.ts`.
- PHP Pint: **835 files passed**. PHPStan: **no errors**, using the configured 512 MB limit.
- OpenAPI validation passed with eight unused-model recommendations. Generated TypeScript build, shared recovery route/security/serialization checks, and existing bot-protection contract checks passed. Dart generation/build_runner, Vendor/Admin serialization, and analysis of the changed models/authentication API/serializers passed with no issues.
- Gitleaks scanned the changed/new task files (3.81 MB) with no leaks. Docker Compose validation and whitespace checks passed. No files were staged or committed.
- Browser automation is unavailable: no enabled browser was reported. Real email delivery, Google-token acceptance, and rendered desktop/mobile acceptance remain manual.
- The full API, full Vendor component, and Buyer Flutter suites were not run for this focused web-auth change.

If the web dev servers are already running, restart them to refresh the regenerated linked API client. Existing email delivery, queue, cookie, and reCAPTCHA configuration is reused; no new key names are required.

## Manual acceptance

Use non-production Vendor and invited Admin accounts. On each portal:

1. Enter the email on sign-in, open Forgot password, and confirm the masked reference and two choices above reCAPTCHA. Open recovery directly and confirm that email entry appears only after a method is selected.
2. Send and verify an email authentication code. Try the accessible fallback; verification should show password entry without sending a second email code.
3. Try wrong/expired codes, resend cooldown, offline failure, and retry. Resending clears the old entry; failed verification never shows password fields.
4. Use a saved authenticator backup code. Save the replacement set, update the password, and confirm that previous codes fail and existing sessions are revoked.
5. Check security notices and the next sign-in, including required MFA. Confirm that pending setup and verification states are preserved.
6. Check narrow and desktop layouts, keyboard focus, six-digit paste/autofill, scrolling, and both legacy reset routes.

Suggested commit: `feat(auth): streamline vendor and admin password recovery`
