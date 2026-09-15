# Phase 2 implementation and acceptance

## Delta audit

| Classification | Existing evidence and intended delta |
| --- | --- |
| ALREADY IMPLEMENTED — preserve | Passport issuance/rotation, web CSRF and HttpOnly cookies, native bearer transport, Google OIDC, login, TOTP enrollment/challenge, recovery-code hashing, logout |
| FOUNDATION EXISTS — extend safely | user_profiles, buyer_profiles, auth_sessions, agreement documents/versions/acceptances, Vendor/Admin memberships and invitations, permissions, audit_logs and transactional outbox |
| PHASE 2 MISSING — implement | Request-time authorization, role/permission policies, account profile editing, session management, recent authentication, password/email changes, factor replacement, reacceptance, secure staff acceptance, Admin administration and corresponding clients/tests |
| LATER PHASE — do not implement | Operational onboarding/team dashboards, catalog, inventory, commerce, maps, analytics engines, provider payments and production notifications |

## UI brief

Authenticated Buyers, Vendor employees and Admins manage their own identity and security. Use the existing Inter typography, semantic tokens and accessible controls. Personal profile, security, sessions and agreements are separate navigable sections; privileged administration appears only after server permission resolution. Read-only role and organization information must remain distinct from editable personal fields. Require confirmation for session revocation and security changes; clear sensitive inputs after submission. Handle loading, offline/retry, validation, expired access, denied access and success without raw JSON. Preserve the Buyer five-destination navigation foundation without fictional marketplace data.

## Diagnostic limitation

IMPECCABLE — BLOCKED (TOOLING / LOCAL SECURITY)

The downloaded engine matched its published SHA-256 checksum, but Windows Security blocked the executable as containing a virus or potentially unwanted software.

This is not an application failure. No security bypass attempted. Do not execute the blocked binary again. Use DESIGN.md, the UI/UX planner, semantic components, accessibility/responsive review and automated checks. Full Impeccable audit remains available for the later designated hardening/polish phase after a security-cleared engine is available. This diagnostic limitation alone does not determine Phase 2 acceptance.

## Acceptance evidence

Implementation and final verification are complete, including the user-approved Store Staff permission correction recorded below. No Phase 2 acceptance blockers remain.

## Verification record — 13 September 2026

The acceptance run resumed the existing working tree at repository HEAD `3f5e3c2`. No repository commit, push, merge, deployment, Development database reset, credential rotation, or security bypass was performed.

| Gate | Command / evidence | Result |
| --- | --- | --- |
| Backend formatting | `cd services/api; php vendor/bin/pint --test` | Passed |
| Backend static analysis | `php vendor/bin/phpstan analyse --no-progress --memory-limit=1G` | No errors |
| Final focused authorization/account security | isolated `api-test php artisan test --compact --filter=PhaseTwoAccountSecurityTest` | 11 tests, 110 assertions passed after the final permission correction |
| Final backend and Phase 1 regression | isolated `api-test php artisan test --compact` | 86 tests, 1,096 assertions passed after the final permission correction; 59.06 seconds |
| Buyer regression | `flutter test` | 31 tests passed; repeated after generated-client cleanup |
| Buyer static analysis | `flutter analyze` | No issues; repeated after generated-client cleanup |
| Android debug | `flutter build apk --debug` | APK built; repeated after generated-client cleanup |
| Vendor final checks | `npm run lint`, `npm run typecheck`, `npm run test -- --run`, `npm run build` | Passed; 34 tests |
| Admin final checks | Same command families | Passed; 7 tests |
| Rendered portal checks | `npm run test:e2e` in vendor-web | All 144 tests passed, including 16 account checks across eight widths, 320–1,920 CSS pixels |
| OpenAPI | `npm run validate` in api-contract | Passed; three unused later-domain model recommendations |
| Route/contract enforcement | `npm run test:account-contract` | 52 protected operations matched; audience, Passport, transport, CSRF and envelopes checked |
| TypeScript generated client | `npm --script-shell=cmd.exe run build` | Passed |
| Dart generated client | `dart run build_runner build`; `dart analyze` | Passed; no analysis issues after deterministic import cleanup |
| Isolated migrations/schema | `php /workspace/scripts/verify-test-schema.php` via guarded api-test | Empty migration, rollback, remigration, seed and generated-schema comparison passed |
| Compose | `docker compose config --quiet` | Passed without printing environment values |
| Dependency advisories | `composer audit --locked --no-interaction`; portal `npm audit --omit=dev` | No advisories / 0 vulnerabilities |
| Source secrets | Gitleaks `dir --redact` on the commit-free candidate snapshot | No leaks in approximately 6.91 MB |
| History secrets | `gitleaks git --redact --no-banner` | 14 commits scanned; no leaks |
| Staged secrets | `gitleaks git --staged --redact --no-banner` | No staged files; source scan above covers the uncommitted implementation |
| Whitespace | `git -c core.safecrlf=false diff --check` | Passed after generator-owned whitespace normalization |
| Canonical clean-start and client drift | `scripts/verify-clean-start.ps1 -NoCommitSnapshot` | Passed for the final current candidate; exit 0; snapshot identity below |

### Changes completed during final verification

OpenAPI Generator emitted trailing whitespace and unused Dart imports. The generation script now normalizes its text outputs and removes only imports whose generated types are unreferenced. No generated source was hand-edited and no analysis rule was suppressed. The generated client and affected Buyer regression/build gates were rerun.

### Implementation inventory

Final verification changes are confined to `AccountAccess.php`, `PhaseTwoAccountSecurityTest.php`, Technical System Design §11.1, `generate-clients.mjs` and its generated output, `verify-clean-start.ps1`, and this report. The permission correction changes no migration, request/response schema, or UI source. API `permissions` remains an array of server-resolved strings. `AccountProfileResource` and `RequireAccountAccess` both use the canonical resolver; seeders/factories contain no duplicate auto-accept grant mapping. No operational auto-accept route exists.

The Buyer, Android and portal evidence above remains applicable: those sources did not change after their final passing runs. Earlier backend evidence (85 tests / 1,056 assertions) and earlier clean-start snapshots are historical, superseded by the final current-candidate results. Canonical verification does not run Flutter or portal builds itself; the separately executed gates above cover those clients. The verifier now also runs generated Dart analysis and `git diff --check` explicitly.

- Laravel account authorization, ownership and organization checks; fixed Vendor-role and delegation policies; explicit Admin and finance permission foundations.
- Personal profiles, optimistic profile/Admin account versions, session/device listing and revocation, session-bound recent authentication, password/email changes, TOTP replacement and recovery-code replacement.
- Versioned agreement rendering, SHA-256 content validation, required reacceptance and immutable acceptance/audit history.
- Admin invitations with hashed single-use credentials and idempotent issuance; pending activation until setup requirements pass; Admin staff access changes and session revocation.
- Vendor staff invitation acceptance tied to email, organization, fixed role, delegation and current inviter authority.
- Shared React account workspace, Vendor invitation acceptance, Admin account management, Buyer account screen and secure-session expiry handling.
- OpenAPI Accounts operations and regenerated TypeScript/Dart clients; contract checker; authorization, security, agreement, component and responsive tests.
- Additive migrations: `2026_09_11_000000_add_phase_two_account_security.php`, `2026_09_11_010000_add_phase_two_permission_grants.php`, `2026_09_12_000000_bind_account_reauthentication_email.php`.
- Generated `docs/architecture/erd.md` and `data-dictionary.md`; commit-free canonical verifier mode; this acceptance record.

### Manual and security review

- Reviewed rendered Vendor mobile and Admin desktop captures. Labels, focusable controls, readable status text, page hierarchy and responsive reflow use existing semantic components/tokens and Inter.
- Browser checks cover both portals at 320, 375, 390, 768, 1,024, 1,280, 1,440 and 1,920 pixels, reduced motion, password fields, keyboard focus and at least 44-pixel action height. These use synthetic responses; no real account secrets appear in captures.
- Buyer tests exercise compact portrait/landscape layouts with 200% text and expired-session handling. The detected Buyer-type dropdown overflow was fixed and retested.
- Passport issuance remains authoritative. Web routes retain cookie/CSRF transport; Buyer routes use native bearer transport. Client-controlled account type, role and organization cannot authorize an operation.
- Sensitive changes require recent session proof, privileged operations retain TOTP, session revocation affects actual Passport sessions, and notification payloads remain encrypted in the transactional outbox.
- No client-side Admin public registration or arbitrary Vendor custom-role creation was added. History remains append-only; finance preparer and reviewer must differ.

### Content inputs and tooling limitations

No new external provider credentials are required. Approved legal Markdown remains a content input at `services/api/resources/agreements/<DOCUMENT_CODE>/<VERSION>.md`; its SHA-256 must match the stored version. Missing or altered copy cannot be accepted. Substantive legal text was not invented.

Android tooling emitted future-support notices for Gradle 8.14, AGP 8.11.1 and Kotlin 2.2.20. The debug build passed without bypass flags or toolchain changes.

Impeccable: BLOCKED — local tooling/security limitation; no bypass attempted. The downloaded engine matched its published SHA-256 checksum, but Windows Security blocked the executable as containing a virus or potentially unwanted software. This is not an application failure. Full Impeccable audit remains available for the later designated hardening/polish phase after a security-cleared engine is available.

### Approved authorization clarification

The user confirmed that the Final Vendor Workflow is authoritative: Store Staff may view auto-accept outcomes/reasons but cannot modify policy or SKU/variant allotments. The stale Technical System Design §11.1 row was corrected. `AccountAccess` no longer grants Store Staff `auto_accept.manage_allotment`. The authorization matrix test asserts all six fixed roles: only Owner/Manager receive configuration authority and only Inventory Staff receive the limited allotment-update grant. Store Manager staff delegation cannot elevate either permission. No auto-accept mutation route was created; operational auto-accept functionality remains in its later phase.

Suggested conventional commit (not created): `feat(identity): implement phase two account authorization and security`.

Store Staff and Customer Service explicitly receive `auto_accept.view_outcomes`, covering approved outcomes/reasons only. This is a permission foundation, not a new information or mutation endpoint. The focused test resolves active persisted memberships for every role and both valid Store Manager delegation states, verifies the three auto-accept grants, and denies an unknown operation. The first fixture incorrectly attempted delegation on a non-manager; the existing PostgreSQL constraint rejected it. The fixture was corrected without relaxing the constraint, then both focused and full suites passed.

### Final current-candidate verification

The final commit-free snapshot includes both the Store Staff mutation-grant removal and explicit Store Staff/Customer Service read grant, plus the persisted-role regression test. Snapshot tree: `943043c754d07eb520624b9b03639ff275121f3f`. Container image digest: `c67fc17ec8113673fe160ca65d8c8787fd58026edf34117cbd289a8aafd47009`. Isolated project: `materyalph_clean_72ad216eff72`. Local evidence log: `%TEMP%/materyalph-phase2-clean-current.log`.

The final snapshot passed the 6.92 MB source secret scan, live PostgreSQL 16/PostGIS isolation guard, empty migrations, rollback/reapply, schema drift, Passport key handling, SMTP/Mailpit, Pint (177 files), PHPStan (no errors), full backend regression (86 tests / 1,096 assertions, 33.51 seconds), OpenAPI validation, TypeScript/Dart regeneration without drift, Dart serializer generation, Dart analysis (no issues), and whitespace verification. Disposable containers were stopped after success. Development volumes and existing Passport keys were not modified. The report was finalized after that snapshot; implementation source remains the verified candidate.

No Phase 2 functional, security, build, static-analysis or verification blocker remains. The optional Impeccable diagnostic remains blocked as documented above.

PHASE 2 — PASS
