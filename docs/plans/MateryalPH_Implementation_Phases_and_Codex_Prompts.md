# MateryalPH Implementation Phases and Codex Prompt Pack — Phases 3 to 20

**Revision:** 21 September 2026. Replaces the 4 September pack.
**Removed:** Phases 1 and 2. Both are accepted and verified; see §1.
**Added:** Phase 3 is split into six buildable sub-phases · every phase carries an explicit surface breakdown and a UI/UX layout architecture section · FIN-04A withholding-threshold counter.
**Place at:** `docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md`
**Repository model:** monorepo. **Reference hosting:** Render.

---

## §0 Standing Contract

Every copy-paste prompt in this pack begins with a line that references this section. Paste the phase prompt only — Codex reads §0 from the repository. This keeps each prompt short and keeps the rules in one place.

### §0.1 Reading order before any edit

`AGENTS.md` → the relevant file in `docs/workflows/` → `docs/architecture/MateryalPH_Technical_System_Design.md` → `docs/design/MateryalPH_UI_UX_Implementation_Planner.md` → `packages/api-contract/openapi.yaml` → existing migrations and tests → relevant ADRs. Figma is visual reference only.

### §0.2 Rules applied to every phase

- Inspect existing code and migration history first. Never recreate a completed feature or restart an earlier phase. For an existing implementation, audit the delta and add migrations/tests for the gap only.
- State any material unresolved assumption and ask before implementing it.
- Keep secrets out of code, tests, fixtures, logs, screenshots, generated clients and Git. `.env.example` gets names and safe defaults only.
- Server-side authorization, transactions, state-transition validation, idempotency, audit events and accessible UI patterns wherever relevant.
- Update OpenAPI and regenerate clients in the same change. Never hand-edit generated files.
- Run the phase's validation commands and report exact results. A generated test is not a passed test.
- Never deploy, push, merge, rotate credentials or use Production keys unless the prompt explicitly authorizes it and the user confirms.
- Finish with: changed files and migrations, API contract changes, security/authorization decisions, commands run and exact results, manual setup or key names still required, known limitations, suggested conventional commit.
- FIN-01–FIN-12 and MAT-01–MAT-07 in the System Workflow and Technical Design are the approved financial and Materials Analytics contracts: 2% Vendor-paid commission, simulated withholding, direct physical payments, aggregate-only competitor analytics, daily public-price history. Earlier zero-commission or mixed listing/transaction-price instructions are superseded. `LIVE_COMMERCE_ENABLED` stays false for the capstone.
- Each phase must leave the product usable. An unfinished entry point sits behind a disabled feature flag until its phase delivers the feature.
- FIN-04A (`docs/architecture/MateryalPH_Technical_Design_Delta_FIN-04A_Withholding_Threshold.md`) is binding wherever gross remittances, relief declarations or withholding status appear.

### §0.3 Surface boundary convention

Every phase declares which of the four surfaces it touches. Do not edit a surface the phase does not list.

| Surface | Path | Meaning |
| --- | --- | --- |
| **API** | `services/api` + `packages/api-contract` | Domain rules, migrations, authorization, contract |
| **Vendor** | `apps/vendor-web` | React portal for Vendor Owner and fixed-role staff |
| **Admin** | `apps/admin-web` | React portal for invitation-only least-privilege Admin roles |
| **Buyer** | `apps/buyer-mobile` | Flutter app |

"No change" on a surface means exactly that: no file edited, and the corresponding suite is not required to rerun unless a shared contract moved.

### §0.4 UI/UX and layout architecture contract

This applies to every phase. A phase's own UI section adds screen-specific structure on top of it.

**Foundations.** Inter with controlled local/system fallbacks. Canonical semantic tokens from `packages/design-tokens`; feature code never uses unexplained raw hex. `brand.orange.500` `#F97316` is the accent; `action.primary` `#C2410C` carries white button text. Base spacing unit 4px on the approved 4–64px scale. Light-first industrial language: strong hierarchy, measured spacing, clear dividers, purposeful icons, limited ornament.

**Prohibited.** Nested-card-heavy layouts, dashboard collage, decorative gradients, glow, bounce/elastic motion, gray text on colored surfaces, unlabeled icon controls, status communicated by color alone, a hidden button used as an authorization mechanism.

**Portal shell (Vendor and Admin).** One shared `packages/web-ui` shell: fixed branding header, independently scrolling flat navigation, fixed account footer. Expanded 256px, collapsed 72px, desktop from 1024px, full-width drawer below that. Desktop navigation rows 36px under the dense-navigation exception; mobile drawer rows and all product controls keep 44px minimum. Width transition 180ms, text 140ms, both disabled under reduced motion. Collapse preference persists per portal for the browser session.

**Page frame.** Quiet back link → title, status and description on one left alignment → compact paired section controls on the right at ≥1024px, reflowing under the title below → optional metadata row with a subtle divider → one content surface → a consistent bottom action area. Sections inside a surface are introduced by headings and 1px rules, not by more cards. One dominant filled action per decision area.

**Breakpoints.** Browser checks run at **320, 375, 390, 768, 1024, 1280, 1440 and 1920 px**. No horizontal page overflow, no horizontal scroll inside navigation or steppers, no empty half-row in a two-column field layout. Wide content — tables, code, diagrams — scrolls inside its own container.

**Paired controls.** Two controls on one row share height (48px inputs), width behavior, label alignment, input styling and vertical alignment. A trailing action occupies a fixed-width area so the input does not resize between states.

**Required states on every surface.** Loading with skeletons and no false empty · empty with a specific cause and a next action · field and cross-field validation · unauthorized · stale-version conflict · offline or provider failure with retry · success. Provider failure degrades to a manual path or a clear retry; it never silently accepts incomplete data.

**Accessibility.** WCAG 2.2 AA. Visible labels, semantic structure, programmatically associated errors with a summary and jump links, keyboard focus order, focus transfer on step or route change, screen-reader names, sufficient contrast, reflow, ≥24×24 CSS-px targets and 44×44 for product controls. Status is text or icon plus color. Countdown timers also show the exact Asia/Manila date and time. Every map has a synchronized accessible list or table.

**Motion.** `motion.instant` 80ms press · `motion.fast` 160ms icon/focus/selection · slower tokens per the UI planner. Motion explains a state change, cancels when stale and is removed or reduced under the platform reduced-motion setting. Never imply live GPS and never animate a delivery vehicle.

**Buyer Flutter.** Five-destination navigation foundation, safe areas, compact portrait and landscape, 320px narrow screens, text scaling to 2×, keyboard insets, semantics on every interactive widget, golden tests for critical screens. Never paste generated React/Tailwind into Flutter.

**Component reuse.** Build a behavior once per platform in `packages/web-ui` or the Flutter design system. A page-local duplicate of a shared behavior is a defect.

**Design evidence per phase.** Component tests for interaction and accessibility · browser checks at the eight widths · desktop and mobile screenshots stored under `docs/design/evidence/<task>/` using synthetic fixtures · a note stating that screenshots illustrate layout, not live provider readiness.

### §0.5 How to run a phase

1. Open the repository and confirm the branch, e.g. `phase/03a-onboarding-domain`.
2. Paste **one** prompt. Never combine phases or sub-phases.
3. For a complex phase, use Plan mode first and review the plan before allowing implementation.
4. Review the diff, the UI evidence and the test output. Resolve every failure before accepting.
5. Make one reviewed checkpoint commit after acceptance. Never commit a real `.env` or credential artifact.

---

## §1 Completed phases — do not rebuild

| Phase | Increment | Status |
| ---: | --- | --- |
| 1 | Baseline schema, three-platform authentication, Vendor landing page | **Accepted.** Passport issuance/rotation, web CSRF + HttpOnly cookies, native bearer transport, Google OIDC, login, TOTP enrollment/challenge, recovery-code hashing, logout |
| 2 | Authorization, profiles, agreements, sessions, account security | **Accepted 13 September 2026.** 86 tests / 1,096 assertions; full gate record in `docs/reports/phase-two-implementation.md` |

Foundations that exist and must be extended rather than replaced: `user_profiles`, `buyer_profiles`, `auth_sessions`, agreement documents/versions/acceptances, Vendor and Admin memberships and invitations, permissions, `audit_logs`, the transactional outbox, the shared React account workspace, the Buyer account screens, the shared portal sidebar, and the generated TypeScript/Dart clients.

Approved authorization facts to preserve: six fixed Vendor roles; only Owner and Manager hold auto-accept configuration authority; only Inventory Staff hold the limited allotment-update grant; Store Staff and Customer Service hold `auto_accept.view_outcomes` only; Store Manager delegation cannot elevate either; finance preparer and reviewer must differ.

---

## §2 Phase map

| # | Increment | Buyer | Vendor | Admin | External credentials |
| ---: | --- | :---: | :---: | :---: | --- |
| 3A | Onboarding domain, requirement registry, activation gate, evidence pipeline | — | — | — | Private object storage |
| 3B | Store Verification V1 — Business Information | — | ● | — | Email outside local dev |
| 3C | Store Verification V2–V4 — address, classification, privacy/submit | — | ● | — | Google Maps keys |
| 3D | Store Setup S1–S5 | — | ● | — | Xendit Test Mode |
| 3E | Admin Vendor Verification queue, case review, authority decisions | — | — | ● | None |
| 3F | Activation gate UI, limited dashboard, expiry, Team Accounts, E2E | — | ● | ● | None |
| 4 | Taxonomy, listings, media, PS/ICC compliance | — | ● | ● | Object storage; OCR/QR if enabled |
| 5 | Inventory, pricing, delivery, auto-accept configuration | — | ● | — | Google Routes |
| 6 | Buyer onboarding, locations, maps, supplier directory | ● | — | — | Maps, Places, Routes, geocoding |
| 7 | Item-Based discovery, ranking, favorites, cart, checkout preview | ● | — | — | Already configured |
| 8 | Orders, confirmation, NRPC, atomic reservations, auto-accept | ● | ● | — | None |
| 9 | Real-time messaging and shared Order-from-Chat engine | ● | ● | — | Reverb |
| 10 | Project-Based procurement, Work Packages, FMS, budgets | ● | ● | — | Already configured |
| 11 | Xendit checkout, payments, fees, webhooks, FIN-04A threshold engine | ● | ● | ● | Xendit TEST key + callback token |
| 12 | Fulfillment, cancellation, automatic Cancellation Refunds | ● | ● | ● | Xendit TEST |
| 13 | Disputes, appeals, Dispute-Conclusion Refunds, invoices | ● | ● | ● | Xendit TEST; storage; email |
| 14 | Reviews, scores, badges, Materials Analytics | ● | ● | ● | None |
| 15 | Notifications, reminders, PDFs, exports | ● | ● | ● | Firebase; email; storage |
| 16 | Admin operations and Philippine geographic analytics | — | ● | ● | Map browser key; PSGC data |
| 17 | Security, privacy, accessibility, performance hardening | ● | ● | ● | reCAPTCHA/Sentry if enabled |
| 18 | End-to-end testing, UAT, failure simulation, recovery | ● | ● | ● | All Staging/TEST credentials |
| 19 | CI/CD and Staging deployment | ● | ● | ● | GitHub and Render secrets |
| 20 | Capstone demonstration release | ● | ● | ● | Existing TEST credentials only |

---

# Phase 3 — Vendor Onboarding, Verification, Activation and Team Accounts

Phase 3 is one acceptance phase delivered as six sequential sub-phases. Each sub-phase is independently reviewable and leaves the product runnable. Do not merge two sub-phases into one prompt — that is the failure mode this split exists to prevent.

**Authority for all of Phase 3:** `docs/workflows/Vendor_Onboarding_Store_Verification_and_Store_Setup.md` (the build specification), the Final Vendor Workflow §Vendor Onboarding, the Final Admin Workflow §Vendor Verification and Activation Workflow, Technical Design §12.5, and FIN-04A.

**Phase-wide invariants.** Public Store identity stays separate from legal business identity. Account membership never establishes legal authority. Store Verification, Store Setup, Store Activation and Marketplace Discoverability are four independent states. Store Verification has four steps; Store Setup has six. The backend activation gate is the only thing that decides activation; the UI explains its result.

---

## Phase 3A — Onboarding domain, requirement registry and evidence pipeline

**Surfaces:** API only. No Vendor, Admin or Buyer file changes.

### Outcome

A requirement registry, a draft/version model, an immutable evidence pipeline, an authority model and an activation-gate service exist and are fully tested before any onboarding screen is built.

### Required implementation

- `vendor_onboarding_requirements` with independent `level` (`REQUIRED`, `OPTIONAL`, `CONDITIONALLY_REQUIRED`) and `status` (`NOT_STARTED`, `IN_PROGRESS`, `SUBMITTED`, `PENDING_VERIFICATION`, `APPROVED`, `COMPLETED`, `CHANGES_REQUIRED`, `REJECTED`, `EXPIRED`, `NOT_APPLICABLE`), plus `applicability_reason`, `blocking` and `lock_version`. `NOT_APPLICABLE` requires a reason and can never mask an incomplete `REQUIRED` item.
- A requirement-resolver service that computes the applicable set from Business Type, supplier configuration, fulfillment selection and representative role. Changing an input recalculates the set and reopens affected approved requirements.
- `vendor_onboarding_drafts` per workstream with optimistic `lock_version`; stale writes return a conflict.
- `vendor_documents` / `vendor_document_versions`: immutable versions, checksum, MIME and content validation, size limits, malware scan state that **fails closed**, superseded-by chain, and authenticated short-lived URLs restricted to the owning Vendor's authorized accounts and authorized Admin reviewers.
- Storage split: public Store media → Cloudinary adapter using the official server upload API; tax, identity and authority evidence → the configured private disk. Never the reverse.
- `vendor_representative_versions`, `vendor_authority_reviews` with scopes `TAX_DECLARATIONS`, `COMMISSION_AGREEMENT`, `PAYMENT_CONFIGURATION`, and encrypted `vendor_verification_change_history`.
- `vendor_tax_profiles` / `vendor_tax_profile_versions` as the single organization-level legal-tax source, with encrypted TIN and branch code, declared versus verified VAT, declaration claim/year, effective periods and `representative_version_id`. Payment Configuration references it later and never re-collects it.
- `vendor_addresses` / `vendor_address_versions` with structured PH fields and a separate `geography(Point,4326)` column with a GiST index.
- `privacy_acknowledgments`, stored separately from commercial agreements.
- `StoreActivationGate` domain service evaluating the ten activation conditions and returning a structured blocking list. `vendor_activation_history` appends every evaluation with checklist version, actor or process, previous/new state and reason.
- Deny-by-default policies for every new resource. Outbox events for notifications. Audit events for every decision and critical change.

### UI/UX and layout architecture

None. This sub-phase ships no screen. The snapshot endpoint's response shape is the UI contract: it must already carry everything §0.4 requires a screen to render — requirement level and status per key, blocking reasons, step completion, masked values, current document versions, correction reasons, current Privacy Notice version and `lock_version`.

### API/key step

Configure Development private object storage from `MateryalPH_Environment_and_API_Key_Setup.md`. Mailpit remains adequate locally. ClamAV with a current signature database is required by the existing scanner. No live Cloudinary, Google or Xendit call is made in this sub-phase.

### Acceptance gate

Migrations run from an empty database and on the current schema, and roll back safely. Requirement resolution is deterministic and covered for all five Business Types. A stale draft write returns a conflict. Scan-pending and scan-failed documents cannot satisfy a requirement. Cross-Vendor and unauthorized-staff document access return a safe `403`/`404`. The activation gate refuses activation for every individually missing mandatory requirement and returns the exact blocking list.

### Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 3A: the Vendor onboarding domain foundation in services/api and packages/api-contract only. Do not edit apps/vendor-web, apps/admin-web or apps/buyer-mobile.

Read docs/workflows/Vendor_Onboarding_Store_Verification_and_Store_Setup.md, the Final Vendor and Admin Workflows, Technical Design 12.5, and docs/architecture/MateryalPH_Technical_Design_Delta_FIN-04A_Withholding_Threshold.md. Inspect existing migrations, policies and OpenAPI paths first, then present a short plan.

Build, with additive migrations only: vendor_onboarding_requirements with independent level and status columns; a deterministic requirement-resolver service driven by Business Type, supplier configuration, fulfillment selection and representative role; vendor_onboarding_drafts with optimistic lock_version; vendor_documents and immutable vendor_document_versions with checksum, MIME and content validation, size limits, fail-closed malware scan state and superseded-by chain; vendor_representative_versions and vendor_authority_reviews with scopes TAX_DECLARATIONS, COMMISSION_AGREEMENT and PAYMENT_CONFIGURATION; encrypted vendor_verification_change_history; vendor_tax_profiles and vendor_tax_profile_versions with encrypted TIN and branch code, declared versus verified VAT, declaration claim and taxable year, and representative_version_id; vendor_addresses and vendor_address_versions with structured Philippine fields plus a separate geography(Point,4326) column and GiST index; privacy_acknowledgments separate from commercial agreements; vendor_activation_history.

Implement a StoreActivationGate domain service that evaluates the ten activation conditions in the Final Vendor Workflow and returns a structured blocking list. Nothing else decides activation.

Implement private evidence storage on the configured private disk with authenticated short-lived URLs restricted to the owning Vendor's authorized accounts and authorized Admin reviewers, and a separate Cloudinary adapter used only for public Store media. Scanning fails closed. Add deny-by-default policies, outbox notification events and audit events.

Add GET /api/v1/vendor/onboarding returning the authoritative snapshot: both workstreams, the requirement registry with level, status, blocking reason and applicability reason, step completion, activation readiness with blocking list, current Privacy Notice version, masked representative and tax values, current document versions, correction reasons and lock_version. Update OpenAPI and regenerate the TypeScript and Dart clients.

Add tests for: empty-database and current-schema migration plus rollback; requirement resolution for all five Business Types; NOT_APPLICABLE requiring a reason and never masking a REQUIRED item; stale draft conflict; scan-pending and scan-failed documents failing to satisfy a requirement; cross-Vendor and unauthorized-staff document access returning safe 403/404; and the activation gate refusing activation for each individually missing mandatory requirement.

Run Pint, PHPStan with --memory-limit=512M, the Laravel suite, OpenAPI validation, the contract checker, client generation, Dart analysis, docker compose config and a gitleaks scan. Do not deploy or commit.
```

---

## Phase 3B — Store Verification V1: Business Information

**Surfaces:** Vendor, API. No Admin or Buyer change.

### Outcome

The Vendor completes the entire Business Information step: Business Type, legal identity, government ID, authorized representative and authority to act, business identity fields, Store Email with single-field OTP, Store Phone, Tax Information and business/compliance evidence.

### Required implementation

Build every subsection in the build specification §5, exactly as specified, including: the five Business Types with `ONE_PERSON_CORPORATION` presented as its own option; conditional individual versus company legal identity with the Owner prefill that creates no verified fact; government ID front/back as private evidence; the conditional authority model and its three scopes; separate `store_name` and `legal_business_name` columns that never overwrite each other; date established validated as a real non-future date; the single named `store_email` input with its read-only ⇄ editable ⇄ Send Code ⇄ OTP ⇄ verified lifecycle; Store Phone with Owner prefill and no OTP; Core TIN of exactly 9 digits and a 3- or 5-digit Branch Code with Head Office prefill of `000`/`00000`; declared versus verified VAT; BIR COR upload that does not verify the profile and accepts Expiration: Not Applicable; the Sworn Declaration claim with taxable year and PDF that grants no relief; and Business Type-driven primary registration evidence plus the LGU permit and optional certifications.

FIN-04A: the declaration is captured as a claim only. Show the plain-language notice that cumulative gross remittances reaching ₱500,000.01 in the taxable year move the account to withholding regardless of the uploaded document. Implement no counter here.

### UI/UX and layout architecture

Page frame and stepper per §0.4 and build specification §4. Business Information renders as one surface with divider-introduced sections in this order: Business Type → Registered Legal Identity → Government-Issued Identification → Authorized Representative and Authority to Act → Business Identity → Store Contact Information → Tax Information → Business and Compliance Evidence.

Field rows:

```
Registered Business Name          │ Date Established
Public Store Name                 (full width)
──────────────────────────────────────────────  Store Contact Information
Store Email  [Verified] [Change]  │ Store Phone Number
```

Store Email and Store Phone share one desktop/tablet row with equal width and equal height and stack on mobile. The `Change` / `Send Code` action sits in a fixed-width area so the input never resizes between states. Conditional fields appear and disappear without shifting the surrounding rows into an empty half-row. Upload fields show accepted types, maximum size, scan state, the current version and a replace action. Changing Business Type shows an explicit notice when it will reopen approved requirements.

### API/key step

Email delivery outside local development needs the configured provider; Mailpit covers local. Reuse the existing OTP endpoints — do not create new ones.

### Acceptance gate

Build specification §14 for structure/navigation, Business Type, legal identity, representative and authority, TIN, Store Email, Store Phone and Tax. Plus: exactly one named `store_email` input exists in the DOM; a pending replacement never inherits verification; a stale draft write returns a conflict; private evidence is unreachable across Vendors; browser checks pass at all eight widths.

### Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 3B: Store Verification step 1, Business Information, in apps/vendor-web with the matching services/api and packages/api-contract extensions. Do not edit apps/admin-web or apps/buyer-mobile.

docs/workflows/Vendor_Onboarding_Store_Verification_and_Store_Setup.md section 5 is the field-level authority and section 4 is the layout authority. Build every subsection exactly as written: B1 Business Type, B2 Registered Legal Identity, B3 Government-Issued Identification, B4 Authorized Representative and Authority to Act, B5 business identity fields, B6 Store Email and Store Phone, B7 retired duplicate contact collection, B8 Tax Information, B9 Business and Compliance Evidence. Use the Phase 3A requirement registry, draft model, evidence pipeline and authority model; do not build a parallel one.

Non-negotiable behaviors. Present Sole Proprietorship, Partnership, Corporation, One Person Corporation (OPC) and Cooperative as five selectable types, with OPC stored distinctly while allowed to reuse corporate rules internally. Render only the fields applicable to the selected type, recalculate requirements on change before the next save, stop counting superseded evidence, and reopen affected approved requirements for Admin review. Keep store_name and legal_business_name as separate columns that never overwrite each other. Accept exactly 9 numeric digits for Core TIN and 3 or 5 numeric digits for Branch Code, reject letters and unsupported symbols, prefill 000 or 00000 when Head Office is selected, require an entered code when Branch is selected, and store both encrypted and masked on read. Keep declared VAT status separate from Admin-verified VAT status. A BIR COR upload never verifies the Tax Profile and may record Expiration: Not Applicable rather than an invented date. A Sworn Declaration requires an explicit claim, a taxable year and a BIR-received PDF, and grants no exemption, no reduced withholding and no threshold relief; display the FIN-04A notice that cumulative gross remittances reaching PHP 500,000.01 in the taxable year move the account to withholding regardless of the uploaded document, and implement no counter in this sub-phase.

Render exactly one named store_email input. It starts read-only with a Change action and a Verified badge shown only when the displayed normalized address equals the server-confirmed Store Email. Change makes that same input editable and replaces the action with Send Code in a fixed-width area. Use the existing request and confirm OTP endpoints. Successful confirmation refreshes the authoritative snapshot, clears the code, returns the field to read-only and restores Change. A pending or replacement address never inherits the previous verification. Editing after requesting a code clears the challenge. Request and confirmation failures stay recoverable and leave the existing verified email unchanged. Store Phone is an ordinary contact field with an optional Owner prefill and no OTP.

Implement the conditional authority model: an officer already established in accepted registration evidence may satisfy the requirement from that evidence, an employee, accountant or other unestablished representative must upload Authority Evidence, and a sole proprietor who is the representative resolves to NOT_APPLICABLE with a reason. Store representative and authority records immutably, preserve previous versions on replacement, reopen review, and keep previously executed agreements bound to the representative effective at execution. Final attestation requires the current Owner-linked representative and an explicit Admin approval for the applicable scope.

Layout: use the shared OnboardingFlow, the four-step stepper and the field rows in specification section 4 and 5.5. Registered Business Name and Date Established share the first row, Public Store Name spans the second, a subtle divider introduces Store Contact Information, and Store Email and Store Phone share one equal-width equal-height desktop row that stacks on mobile. Reuse packages/web-ui primitives; create no page-local duplicate of a shared behavior.

Extend the existing /api/v1 draft and document endpoints rather than renaming them. Update OpenAPI and regenerate clients.

Every draft PATCH to /api/v1/vendors/onboarding/verification sends both lock_version (from the onboarding snapshot's organization version) and draft_lock_version (from the matching workstream's drafts[].lock_version, or 0 when no draft exists yet). A future Store Setup PATCH to /api/v1/vendors/onboarding/setup uses organization_lock_version instead of lock_version for the same purpose — do not reuse the verification field name there. Sending only the organization guard is accepted by the backend but skips draft-level staleness detection, which defeats the stale-draft-conflict requirement in the build specification; always send both fields and refresh both from the authoritative response after every save. Treat a 409 RESOURCE_VERSION_CONFLICT (stale organization guard) and a 409 STALE_VERSION (stale draft guard) as the same user-facing stale-version conflict state.

Add component tests and browser checks at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px covering: conditional rendering per Business Type; the single store_email input; change, confirm and re-change; matching-address badges; pending replacements; cleared challenges; request and confirmation failures; draft payload contents; TIN and branch-code accept and reject cases including 8, 10 and 4 digits and alphanumeric input; Head Office prefill; authority conditionality per role; a stale organization guard returning 409 RESOURCE_VERSION_CONFLICT and a stale draft guard returning 409 STALE_VERSION, both rendered as the same conflict state; cross-Vendor evidence denial; field-row geometry and stable widths between Change and Send Code; and no horizontal page or stepper overflow.

Run Vendor lint, typecheck, unit tests, build and the onboarding browser spec, plus Pint, PHPStan with --memory-limit=512M, the Laravel suite, OpenAPI validation, the contract checker, client generation and a gitleaks scan. Capture desktop and mobile screenshots under docs/design/evidence/. Do not deploy or commit.
```

---

## Phase 3C — Store Verification V2 to V4: address, classification, privacy and submission

**Surfaces:** Vendor, API. No Admin or Buyer change.

### Outcome

The Vendor completes the Registered Business Address with map or manual entry, selects Supplier Type and niches, acknowledges the Privacy Notice, reviews the full requirement summary and submits Store Verification.

### Required implementation

Build specification §6, §7 and §8 in full: structured PH address fields plus interactive map selection with pin placement, structured resolution, displayed latitude and longitude, manual completion for unresolved components, review before save, stale-response rejection and an accessible non-map alternative; coordinates stored separately from the structured address; a critical address change creating a new version and reopening review. Three Supplier Types, 27 canonical niches with scope descriptions, multiple custom Other labels stored as Vendor-provided classification labels that never create taxonomy entries, and case-insensitive normalized rejection of prohibited rental categories. Privacy Notice presentation and acknowledgment recorded separately from commercial agreements. The full submission validation list returning exact failing requirement keys. `PENDING_VERIFICATION` on success and the confirmation page with **Proceed to Store Setup**.

### UI/UX and layout architecture

V2 uses a two-column desktop layout: structured fields on the left, map on the right, collapsing to fields-above-map on tablet and mobile. The map initializes only when V2 is selected. Latitude and longitude render in their own read-only-until-resolved fields. A provider failure replaces the map area with a clear message, a retry and the manual path — never a blocked step.

V3 renders the Supplier Type as a radio group, then niches as a responsive multi-select grid with a short description per entry, then the repeatable custom-label input revealed by Other Category. Prohibited-term errors name the offending label.

V4 is the only place the requirement checklist lives: grouped by step, each item showing level, status, blocking reason and a jump link, with unsaved edits listed explicitly above the Privacy Notice acknowledgment and a single dominant Submit action.

### API/key step

Restricted Google Maps keys: a browser key for the client and a separate server key for the backend geocode proxy. The backend key never appears in Vite configuration.

### Acceptance gate

Build specification §14 for address, classification, privacy and submission. Plus: manual-only completion succeeds with zero map interaction; a stale resolve response is discarded; submission without acknowledgment is refused; every missing requirement is named exactly; the confirmation page renders and Store Setup becomes reachable while review is pending.

### Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 3C: Store Verification steps 2, 3 and 4 in apps/vendor-web with the matching services/api and packages/api-contract extensions. Do not edit apps/admin-web or apps/buyer-mobile. Phase 3B must already be accepted.

Sections 6, 7 and 8 of docs/workflows/MateryalPH_Store_Verification_Onboarding_Spec.md are authoritative.

Step V2 Registered Business Address: structured Philippine fields for street or building or unit, barangay, city or municipality, province or independent-city classification and postal code, plus interactive Google Maps selection. The Vendor places or moves a pin, the system resolves structured components, latitude and longitude are displayed in their designated fields, the Vendor reviews the resolved address before saving, and any component the geocoder cannot confidently supply must be completable manually. Discard stale resolve responses so a late reply for an earlier pin cannot overwrite the current one. A provider failure degrades to manual entry with a retry, never a blocked step. Provide an accessible non-map alternative that is sufficient on its own. Store coordinates separately from the human-readable structured address using the Phase 3A geography column. A critical change to a previously approved address creates a new version and reopens review instead of overwriting a verified value. Initialize the map only when this step is selected. Use a restricted browser key in the client and a separate restricted server key in a backend geocode proxy; never place a backend key in Vite configuration.

Step V3 Supplier Type and Classification: exactly three Supplier Types — Wholesaler or Distributor, Retail Hardware Store, Specialized Supplier — and the 27 canonical niches listed in specification section 7, each with a short scope description. Allow multiple niches. Other Category reveals a repeatable text input accepting several custom labels, each stored as a Vendor-provided custom classification label that never creates a canonical taxonomy category; marketplace search, matching, analytics and product classification keep using the approved taxonomy. Reject prohibited construction-vehicle and equipment-rental entries case-insensitively after normalizing whitespace, capitalization, punctuation and equivalent wording, and show the approved message. Selecting Tools and Equipment must not make rental inventory acceptable. A custom label does not by itself require separate Admin approval.

Step V4 Privacy, Review and Submit: present the current published Privacy Notice, require acknowledgment before submission, and record user, organization, notice version, timestamp, applicable processing activity, source and acknowledgment record separately from Terms of Service, the Vendor Code of Conduct, the Commission Agreement and other commercial agreements. Block submission with a clear operational message when no current Privacy Notice is published. Show the requirement checklist here and nowhere else: grouped by step with level, status, blocking reason and jump links, with unsaved edits listed explicitly. Automatically save progress on navigation and atomically save the final package on submission; do not require a manual Save Verification Draft action. Keep private pending documents separate from Admin submissions. Validate the complete submission list in specification section 8 server-side and return the exact failing requirement keys rather than a generic failure. On success set Store Verification to PENDING_VERIFICATION and show the dedicated confirmation page with the approved message and a Proceed to Store Setup action; Store Setup must be reachable while Admin review is pending.

Layout: V2 uses structured fields beside the map at desktop widths and fields above map below that; V3 uses a radio group then a responsive niche grid then the revealed custom-label inputs; V4 uses the grouped checklist, the unsaved-edit list, the acknowledgment and one dominant Submit action.

Update OpenAPI and regenerate clients. Add component tests and browser checks at the eight standard widths for: manual-only completion with no map interaction; pin resolution and displayed coordinates; incomplete geocode requiring manual completion; discarded stale responses; provider failure fallback; separate coordinate and address storage; address versioning and reopened review; multi-niche persistence; multiple custom Other labels; prohibited-term rejection variants; refused submission without acknowledgment; exact missing-requirement identification; the confirmation page; and no horizontal page or stepper overflow.

Run the Vendor and API check suites, OpenAPI validation, the contract checker, client generation and a gitleaks scan. Capture desktop and mobile screenshots. Never print or commit any provider key. Do not deploy or commit.
```

---

**Current V4 commission placement (September 24, 2026):** The versioned 2% Commission Terms panel appears directly above Privacy Notice in Privacy, Review and Submit. Explicit acceptance is separate from automatic draft saving and evidence submission. The Owner must have current `COMMISSION_AGREEMENT` authority where applicable; initial evidence submission must remain available so Admin can approve that authority. Acceptance remains an activation condition. Store Setup has five steps and no longer collects commission consent.

## Phase 3D — Store Setup S1 to S6

**Surfaces:** Vendor, API. No Admin or Buyer application change.

### Outcome

The Vendor completes the Public Store Profile and media, Fulfillment Configuration and conditional Delivery Configuration, the mandatory Xendit TEST connection, optional Team Accounts setup, Store Operation schedule, and Store Setup review and completion. Store Setup remains a separate workstream from Store Verification and its completion never approves, overrides, or rewrites a Store Verification item.

### Required implementation

Build specification §9 in full. Public Store Profile with live marketplace-style preview and a Store Media subsection whose successful upload refreshes the preview without discarding unsaved fields. Bulk Order Capability drives Item-Based versus Item-Based plus Project-Based eligibility with no competitive RFQ queue, auction, or automatic Vendor competition mechanism.

Services Capability supports Self-Pickup, Vendor Delivery or Both. Delivery Configuration is `CONDITIONALLY_REQUIRED`; Self-Pickup only sets it to `NOT_APPLICABLE` with an applicability reason and hides the Delivery Configuration UI, while Vendor Delivery or Both displays it and makes it required before Store Activation.

For Vendor Delivery, allow the Vendor to configure as many vehicles as needed. Each applicable vehicle configuration includes Vehicle Category, Vehicle Type, Vehicle Name, Vehicle Brand, Vehicle Image, Number of Vehicles, Maximum Weight Capacity, applicable Cargo Length, Cargo Width and Cargo Height, Heavy Vehicle Classification, Base Fee, Per-Kilometer Rate and Maximum Delivery Distance. Maximum Delivery Distance includes a map interface with a visual radius centered on the configured store or fulfillment location.

Supported Vehicle Categories are Motorcycle, Pickup, Van and Truck. Truck types include Box Truck, Wing Truck, Flatbed Truck, Concrete Mixer Truck / Transit Mixer and Custom Vehicle Type. Van types include Compact / Mini Panel Van, Mid-Size Cargo Van, Full-Size Cargo Van and Custom Vehicle Type. Pickup types include Compact Pickup, Mid-Size Pickup, Heavy-Duty Pickup and Custom Vehicle Type. Vehicle Category and Vehicle Type remain separate fields, and every predefined type provides a concise description to assist Vendor selection.

Concrete Mixer Truck / Transit Mixer applies specifically to ready-mixed concrete. For this type, Mixer Capacity (`m³`) becomes required and the normal Cargo Length, Cargo Width and Cargo Height fields become `NOT_APPLICABLE` and are hidden. The backend includes the foundation for future vehicle recommendation using actual weight, volumetric or dimensional weight, cargo dimensions, vehicle capacity, delivery distance, availability, site-access restrictions, number of vehicles or trips and heavy-vehicle restrictions. Ready-mixed concrete uses required material volume and configured Mixer Capacity instead of normal cargo-dimension suitability. The system never automatically dispatches or finalizes a vehicle recommendation. Accepted orders preserve an immutable delivery snapshot so later vehicle changes never rewrite an already accepted order.

Xendit xenPlatform TEST sub-account connection is mandatory for Store Activation. The Vendor explicitly initiates the connection through MateryalPH using a Connect Xendit action. After confirmation, the backend uses the officially supported Xendit TEST Account/Create Account API flow with server-side credentials to provision the Vendor's TEST sub-account under the MateryalPH platform account. Do not require the Vendor to manually create the TEST sub-account in the Xendit Dashboard, copy and paste an invitation link, or supply a Dashboard URL. Capture and securely store the provider-issued sub-account identifier and reconcile it through permitted backend-only Xendit mechanisms before marking the connection `CONNECTED_TEST` or the equivalent approved status. A locally stored identifier, URL, or client-side success state alone never proves connection. Where the provider's TEST environment does not support production onboarding, representative invitations, KYC, activation, or verification behavior, report the limitation accurately instead of fabricating success.

Team Accounts remain optional and never block Store Activation. Support the five fixed roles: Store Manager, Store Staff, Customer Service Staff, Inventory Staff and Fulfillment Staff. Each employee has exactly one fixed role at a time. Store Staff combines the approved Customer Service and Inventory work scopes for small and medium stores without automatically receiving Fulfillment, Wallet, Earnings, Team Account administration or Owner authority. Store Manager staff-management delegation is off by default and, when enabled by the Vendor Owner, applies only to permitted non-manager roles. Sidebar visibility, direct-route access, API authorization and resource authorization must follow the predefined role scope. Wallet and Earnings remain Vendor Owner only. If no Team Accounts exist, the Vendor Owner retains all applicable operational functions.

Store Operation allows the Vendor to configure the store's operating days and opening and closing times, including marking applicable days as Closed. Enabled operating periods require valid opening and closing values. Do not fabricate holiday schedules, special hours or multiple operating windows unless explicitly supported by the authoritative workflow.

Store Setup Review and Complete shows the S1 through S5 summary, outstanding requirements, `NOT_APPLICABLE` outcomes, optional items and an explicit list of unsaved edits. Completion never approves a Store Verification item, bypasses verification review, activates the store by itself, or silently satisfies an unresolved provider, payment, tax, compliance, or activation requirement.

Commission Terms remain part of the authoritative Store Verification flow and are not duplicated or newly accepted inside Store Setup. Store Setup completion may check the existing version-bound Commission Terms acceptance and authorized signatory state where required for activation, but must never silently create, modify, or replace that acceptance.

### UI/UX and layout architecture

S1 splits into an editable form column and a preview column at ≥1024px and stacks below that; the preview shows banner, overlapping logo, name, description, public contact details and city/province summary, updates text immediately, uses structured placeholders for missing media and offers retry on a failed preview. Operating hours and gallery media are not implemented in S1 and must not be fabricated. Public Store media uses the Cloudinary adapter while private evidence remains on private storage.

S2 reveals Delivery Configuration only when Vendor Delivery or Both is selected and explains the `NOT_APPLICABLE` outcome when Self-Pickup only is selected. The vehicle form supports the complete field set, Category and Type descriptions, Custom Vehicle Type, conditional Mixer Capacity for Concrete Mixer Truck / Transit Mixer, and the Maximum Delivery Distance map/radius visualization. Normal cargo-dimension fields are hidden and marked `NOT_APPLICABLE` for mixer trucks where they are not meaningful.

S3 shows the current Xendit connection state and a plain statement that `Connected — TEST` represents successful TEST technical provisioning/reconciliation only and is not live payment approval, production KYC, government approval, BIR registration, or live payment capability. Do not provide a manual Xendit URL-entry or copy/paste field.

S4 presents the five predefined Team Account roles, their definitions and work scopes before invitation, and role-aware access to the Vendor Portal sections. Store Manager staff-management delegation is shown only when applicable and is off by default. Team Accounts remain optional.

S5 provides an organized Store Operation schedule interface for operating days, opening time, closing time and Closed status.

S6 mirrors the existing review-summary pattern for Store Setup items and clearly distinguishes completed, incomplete, optional, conditionally required, `NOT_APPLICABLE`, and unresolved requirements.

### API/key step

Xendit Test Mode only. The secret key, callback token and other provider credentials live only in backend Development configuration and never reach React, Flutter, client-side source, logs or screenshots. The backend performs TEST sub-account provisioning and reconciliation through officially supported Xendit mechanisms. No live transaction, production payout, refund, escrow release or other Phase 11 payment behavior is implemented here.

The API and contract model must also support the current Fulfillment Configuration structure, including Category and Type separation, multiple vehicle configurations, Mixer Capacity where applicable, delivery-radius configuration, future fulfillment-recommendation inputs, heavy-vehicle restriction and alternative drop-off foundations, and immutable accepted-order delivery snapshots.

Team Account authorization must be enforced server-side. Hidden navigation does not constitute authorization.

### Acceptance gate

Setup reaches `COMPLETED` only when all required Store Setup requirements are satisfied. This includes the applicable Public Store Profile requirements, applicable Fulfillment and Delivery Configuration requirements, required Store Operation information, and a successfully reconciled Xendit TEST connection.

Conditional requirements must either be completed or hold a valid `NOT_APPLICABLE` state with an applicability reason. Team Accounts remain optional and never block completion.

The required Xendit state must represent successful backend TEST provisioning or reconciliation. A locally stored identifier, URL, frontend state, or fabricated provider response alone never proves connection.

Store Setup completion must also respect applicable activation prerequisites outside Store Setup. The effective Vendor Tax Profile must be compatible with activation, required payment/provider conditions must have no unresolved blocker, and any required Commission Terms acceptance must already exist through the authoritative Store Verification flow with the correct version and authorized signatory scope.

Setup completion never changes a Store Verification item to `APPROVED`, never overrides `PENDING_VERIFICATION`, `CHANGES_REQUIRED`, `REJECTED` or `EXPIRED`, and never activates the Vendor store by itself.

Legal fields cannot be edited through the Public Store Profile editor. Private staff contacts, tax information and verification evidence never appear in the public preview. Unauthorized Team Accounts must not gain access merely because a sidebar item is visible or a direct route or API endpoint is known.

### Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 3D: the six Store Setup steps in apps/vendor-web with the matching services/api and packages/api-contract extensions. Do not edit apps/admin-web or apps/buyer-mobile. Phases 3A to 3C must already be accepted.

Section 9 of docs/workflows/Vendor_Onboarding_Store_Verification_and_Store_Setup.md and the Final Vendor Workflow sections 2 to 6 are authoritative. Keep Store Setup a separate workstream with its own checklist, draft record, progress and completion state; it must remain available while Store Verification is PENDING_VERIFICATION, CHANGES_REQUIRED, REJECTED or EXPIRED, and its completion must never change a Store Verification item to APPROVED.

S1 Public Store Profile: editable form plus a marketplace-style preview with banner, overlapping logo, name, description, public contact details and city or province summary. Text changes appear immediately. Store Media is a subsection beside the editor and preview; a successful upload refreshes the preview without discarding unsaved fields. Missing media shows structured placeholders and a failed preview offers retry. Legal fields are not editable here. Private staff contacts, tax data and evidence are excluded. Do not fabricate operating hours or gallery media that the surface does not implement. Public Store media uses the Cloudinary adapter; private evidence stays on the private disk.

S2 Fulfillment Configuration: Bulk Order Capability Yes enables Item-Based and Project-Based eligibility and No enables Item-Based only, without creating any competitive RFQ bidding queue and without rewriting accepted orders. Services Capability is Self-Pickup, Vendor Delivery or Both. Self-Pickup only sets Delivery Configuration to CONDITIONALLY_REQUIRED with status NOT_APPLICABLE and an applicability reason. Vendor Delivery or Both requires vehicle category, number of vehicles, capacity in kilograms, cargo length, width and height in metres, heavy-vehicle classification, base fee, per-kilometre rate and maximum delivery distance, validated as positive quantities, valid ranges, non-negative rates and a required distance limit. Unconfigured vehicles never appear as fulfillment options, and editing a vehicle later never changes an accepted order's delivery snapshot.

S3 Xendit TEST Connection: xenPlatform sub-account onboarding is mandatory for every Vendor seeking Store Activation regardless of Business Type. The Vendor creates the sub-account and Authorized Representative invitation through the Xendit Dashboard. Guide the Vendor to the provider flow and capture the exact HTTPS link the provider returns; never construct an undocumented Dashboard URL and never silently create the account. Capture the provider sub-account identifier and reconcile it through permitted backend-only API or webhook mechanisms. A saved link alone never proves connection. Treat invitation links as sensitive, mask them in the UI where possible and redact them from logs. Use Test Mode only and implement no live transactions, refunds or other Phase 11 payment behavior. If the provider cannot support the required link or reconciliation operation in the configured environment, keep the connection unverified and report the provider limitation instead of fabricating success. Follow the current Xendit sub-account, Create Account v3 and XenPlatform setup documentation before choosing request fields.

S4 Team Accounts: optional, never blocks activation, and explains the existing post-setup invitation route with the five fixed roles and the off-by-default Store Manager delegation limits.

S5 Review and Complete: setup summary, explicit unsaved-edit list, and completion only when the required Xendit connection and onboarding state are confirmed, required payment capabilities and settings are complete, the effective Vendor Tax Profile is compatible with activation, commission acceptance is captured separately in Store Verification and no payment or provider requirement remains unresolved.

Layout: S1 uses form beside preview at 1024px and above and stacked below that; S2 reveals delivery fields only when applicable and explains the NOT_APPLICABLE outcome in text; S3 shows connection state, the masked provider link and a plain statement that TEST capability is not live payment approval; S5 mirrors the V4 summary pattern.

Update OpenAPI and regenerate clients. Add component tests and browser checks at the eight standard widths for: live preview text updates; upload-to-preview refresh without losing unsaved fields; failed-image fallback; conditional delivery fields and the NOT_APPLICABLE outcome; bulk-capability eligibility mapping; rejection of a link-only Xendit connection; link masking and log redaction; gated Commission Terms acceptance and signatory-scope enforcement; Team Accounts gating; setup completion not approving a verification item; and no horizontal page overflow.

Run the Vendor and API check suites, OpenAPI validation, the contract checker, client generation and a gitleaks scan. Capture desktop and mobile screenshots. Never print a provider key or token. Do not deploy or commit.
```

---

## Phase 3E — Admin Vendor Verification

**Surfaces:** Admin, API. No Vendor or Buyer change beyond notification payloads.

### Outcome

Authorized Admins open submitted Store Verification cases, inspect structured sections and authorized private evidence, decide each requirement, decide authority scopes, record verified document metadata and drive corrections and reverification.

### Required implementation

Build specification §10 in full: the queue with its columns, filters, sorting and pagination; the sectioned case detail mirroring the Store Verification steps rather than an unstructured document list; per-requirement Approve, Return for Correction and Reject with required reasons; authority decisions with approved scopes; Admin-recorded verified document number, issue date, expiration date or Not Applicable, remarks, source, reviewer and timestamp with `expiration_date < issue_date` rejected; OCR as review assistance only; correction and resubmission preserving prior file, metadata, decision, remarks and replacement relationship without resetting unrelated valid requirements; and the reverification trigger list. Every decision carries the evidence version it was made against; a decision with a stale step `lock_version` is rejected. Every decision writes an audit event and a notification.

### UI/UX and layout architecture

Two-pane case layout at ≥1280px: a left section navigator showing each verification section with its status, and a right detail pane. Single column below 1024px with the navigator as a collapsible list. The evidence viewer opens a private document through an authenticated short-lived URL beside the fields it supports, with scan state, version chain and a replace-history link. Decision controls sit at the foot of each section with the reason field required and inline for `Return for Correction` and `Reject`. A stale decision surfaces a conflict banner with a refresh action rather than a silent failure. The Tax Profile panel displays legal and trade identity, VAT status, tax year, prior-year position, declaration year and receipt, outside-platform disclosure scope, current local total, threshold-breach flag and withholding reason — masked TIN only.

### Acceptance gate

The Admin review page is required Phase 3 acceptance evidence; backend review logic alone is insufficient. An Admin cannot override a missing mandatory requirement from the frontend. Vendor Verification Staff cannot authorize a statutory rate or mark a tax return filed. Cross-role and cross-scope access returns a safe `403`/`404`.

### Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 3E: the Admin Portal Vendor Management to Vendor Verification queue and case review in apps/admin-web with the matching services/api and packages/api-contract extensions. Do not edit apps/buyer-mobile, and edit apps/vendor-web only where a notification or status payload requires it. Phases 3A to 3D must already be accepted.

Section 10 of docs/workflows/Vendor_Onboarding_Store_Verification_and_Store_Setup.md and the Final Admin Workflow section Vendor Verification and Activation Workflow are authoritative.

Build the queue with organization, Public Store Name, Business Type, submitted time, oldest pending requirement age, blocking count, assigned reviewer and status; filters for status, Business Type, requirement type, age, reviewer and expiry window; oldest-pending-first default sort; and pagination.

Build the case detail so the reviewer sees the submitted information in organized sections mirroring the Store Verification steps, never an unstructured document list: Business Information, Legal Identity and Government ID, Authorized Representative and Authority, Tax Profile, Business and Compliance Evidence, Registered Business Address, Supplier Type and Classification, the Privacy acknowledgment record, and Activation readiness with its blocking list. Each section shows its fields, its evidence with scan state and version chain, its requirement level and status, its history and its decision controls.

Implement per-requirement decisions: Approve sets APPROVED, Return for Correction sets CHANGES_REQUIRED and Reject sets REJECTED, with a required non-empty reason for the latter two. Record actor, role, timestamp, before and after state, reason, evidence version, correlation identifier, notification and audit reference. Reject a decision submitted with a stale step lock_version and show a conflict banner with a refresh action. Implement authority decisions that record the approved scopes from TAX_DECLARATIONS, COMMISSION_AGREEMENT and PAYMENT_CONFIGURATION.

Only an authorized Admin records verified document number, issue date, expiration date or Expiration: Not Applicable, verification remarks, review evidence or source, decision, reviewer and review timestamp. Reject expiration_date earlier than issue_date. Distinguish no expiration applies, expiration not yet verified, expiration verified and document expired, and keep the document metadata Not Applicable separate from the requirement status NOT_APPLICABLE. Where OCR is available it may suggest document number, registered name, issue date, expiration date and TIN or branch information as review assistance only; it must never approve a document or become authoritative verified metadata without Admin review.

Implement correction and resubmission: CHANGES_REQUIRED to SUBMITTED to PENDING_VERIFICATION to APPROVED, preserving the previous file, previous metadata, previous verification decision, Admin remarks, the replacement relationship and the audit history, and never resetting unrelated requirements that remain valid. Implement the reverification triggers for Legal Business Name, Company Registered Name, Business Type, Registered Business Address, TIN or branch information, VAT classification, a required registration document, other critical compliance evidence and replacement of the representative or relevant authority evidence. An ordinary public Store Profile image, banner or marketing description change must not trigger business reverification. Reverification targets the affected requirement rather than resetting the whole record.

Show the Tax Profile panel with legal and trade identity, VAT status, tax year, prior-year position, declaration year and receipt, outside-platform disclosure scope, current local total, threshold-breach flag and withholding reason, using masked TIN values only.

Layout: two-pane case view with a left section navigator carrying per-section status at 1280px and above, single column with a collapsible navigator below 1024px, the evidence viewer opening authenticated short-lived private URLs beside the fields it supports, and decision controls at the foot of each section with inline required reasons.

Enforce that an Admin cannot override a missing mandatory requirement from the frontend, that Vendor Verification Staff cannot authorize a statutory rate or mark a tax return filed, and that cross-role and cross-scope access returns a safe 403 or 404.

Update OpenAPI and regenerate clients. Add component tests, authorization tests and browser checks at the eight standard widths for every decision path, required reasons, stale-decision rejection, date validation, OCR non-authority, correction history preservation, unrelated requirements not resetting, reverification targeting, authority scope decisions and evidence access denial.

Run the Admin and API check suites, OpenAPI validation, the contract checker, client generation and a gitleaks scan. Capture desktop and mobile screenshots. Do not deploy or commit.
```

---

## Phase 3F — Activation gate, limited dashboard, expiry and Team Accounts

**Surfaces:** Vendor, Admin, API.

### Outcome

Activation readiness is visible and enforced, the limited dashboard works end to end, document expiry produces reminders and the documented restriction, Team Accounts operate with fixed roles and delegation limits, and the complete Phase 3 journey passes cross-client tests.

### Required implementation

The welcome page for a newly verified Vendor Owner offering **Begin Store Verification** and **Finish Later**, an entry surface only — never a third onboarding section and never an activation bypass; after dismissal, later access returns through the limited dashboard. The limited dashboard exposing Store Profile, Store Account Settings, Continue Store Verification, Continue Store Setup, Review Pending Verification, Correct Changes Required and onboarding progress, with separate checklists, requirement level and status, blockers, dedicated Continue actions and the current Store Activation status, and a clear statement that permitted Store Setup work may continue while review is pending. Marketplace operations stay locked until activation. Scheduled expiry warnings and the documented restriction behavior. Team invitation lifecycle with the five fixed roles, one fixed role per membership, off-by-default Store Manager delegation that cannot reach another Store Manager, ownership, payout credentials, its own role or audit records, Owner notification on every delegated action, and session revocation with retained historical attribution. Store Activation and Marketplace Discoverability evaluated separately, with every transition appended to `vendor_activation_history` and the audit log.

### UI/UX and layout architecture

The limited dashboard leads with an activation status band that states the current state in text plus icon, then two side-by-side workstream cards at ≥1024px — each with its own progress, blocking count and one Continue action — then an action-required list ordered by blocking severity. No marketplace widgets, no fabricated metrics and no decorative collage. Expiry warnings appear as a dismissible-but-persistent band with the exact Asia/Manila date and time alongside any relative countdown. The Team Accounts screen lists members with role, status and last activity, and the delegation toggle carries a confirmation dialog naming the exact consequence.

### Acceptance gate

The backend refuses activation when any mandatory requirement is missing and names the blocking items. A hidden or re-enabled button cannot activate a store. Private documents are inaccessible across Vendors and to unauthorized staff. Team Accounts never block activation. Store Setup completion never approves a verification item. The full Phase 3 journey passes across Vendor and Admin: register → welcome → verification draft → Finish Later → resume → submit → Admin returns one item for correction → Vendor corrects → Admin approves all → Store Setup completes → activation succeeds → an expired document later restricts as documented.

### Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 3F: activation readiness, the limited Vendor dashboard, document expiry behavior, Team Accounts and the Phase 3 end-to-end acceptance journey, across apps/vendor-web, apps/admin-web and services/api. Phases 3A to 3E must already be accepted.

Add a one-time authenticated welcome page for a newly verified Vendor Owner offering Begin Store Verification and Finish Later. It is an entry surface, not a third onboarding section and not an activation bypass; after dismissal, later access returns through the limited Vendor dashboard.

Build the limited dashboard exposing Store Profile, Store Account Settings, Continue Store Verification, Continue Store Setup, Review Pending Verification, Correct Changes Required and onboarding progress. Display separate Store Verification and Store Setup checklists with requirement level and status, overall progress, pending verification, changes required, rejected and expired blockers, dedicated Continue actions and the current Store Activation status, and state clearly that permitted Store Setup work may continue while Admin review is pending. Keep marketplace operations locked until Store Activation.

Wire the Phase 3A StoreActivationGate as the only decision maker. Evaluate the ten activation conditions in the Final Vendor Workflow and return the blocking list; the UI only explains the result. Evaluate Marketplace Discoverability separately and allow an activated store with no eligible listings to remain not discoverable. Append every activation and discoverability transition, blocked evaluation, correction, expiry, restriction, suspension and restoration to vendor_activation_history and the audit log with the checklist or rule version, actor or system process, timestamp, previous and new state and reason.

Implement scheduled expiry warnings for approved documents with verified expiration dates and the documented restriction behavior when a document expires, keeping Expiration: Not Applicable documents out of that path. Display the exact Asia/Manila date and time beside any relative countdown.

Implement the Team Accounts invitation lifecycle: five fixed roles, one fixed role per membership, email-bound and organization-bound invitations with expiry and inviting actor, acceptance through an individual account that never repeats onboarding and never bypasses activation, and an off-by-default Store Manager staff-management delegation that cannot manage another Store Manager, change the Owner, transfer ownership, grant delegation, change its own role or access, edit payout credentials or alter audit records. Notify the Owner of every delegated action, revoke sessions on deactivation and retain historical attribution. Team Accounts are optional and never block activation.

Layout: lead the dashboard with an activation status band stating the state in text plus icon, then two side-by-side workstream cards at 1024px and above each with progress, blocking count and one Continue action, then an action-required list ordered by blocking severity. No marketplace widgets, fabricated metrics or decorative collage. Give the delegation toggle a confirmation dialog naming the exact consequence.

Add end-to-end tests across Vendor and Admin for the full journey: account active, welcome page, verification draft, Finish Later, resume, submit, Admin returns one requirement for correction, Vendor corrects and resubmits, Admin approves all, Store Setup completes, activation succeeds, and a later expired document produces the documented restriction. Add tests for independent workstream progression, welcome routing, activation-bypass rejection, unauthorized document access, Team Accounts gating and delegation limits.

Run the Vendor, Admin and API check suites, the browser specs at the eight standard widths, OpenAPI validation, the contract checker, client generation and a gitleaks scan. Report the Phase 3 acceptance evidence as a whole. Do not deploy or commit.
```

---

# Phase 4 — Taxonomy, Listings, Media and Product Compliance

**Surfaces:** Vendor, Admin, API. Buyer unchanged.

## Outcome

Vendors create structured materials and variants while the platform enforces category-specific fields and PS/ICC compliance before regulated products become active.

## Required implementation

**FIN/MAT integration.** Add comparable material and group mapping using exact brand, model, specification, variant and unit; versioned authorized unit conversions; immutable ordinary public price and tax-category records. Custom unmapped listings stay Not Yet Comparable. Never average fuzzy material names or private quotations.

- Canonical categories, materials, aliases, `pg_trgm` search, units, conversions, tags and technical attributes.
- Listing and variant creation with price versions, weights, dimensions, stock status and photos.
- Three compliance input paths: photo/OCR, QR, and manual with a required marking photo.
- Unified Review and Confirm, official reference adapter, Admin review queue, status history and publication gate.
- Accessible bulk spreadsheet import with row-level errors and transactionally validated rows.

## UI/UX and layout architecture

Vendor catalog uses a filterable table at ≥1024px and cards below, with status shown as text plus icon. The create/edit wizard mirrors the onboarding step pattern: numbered steps, one surface, server-derived completion, Save Draft and a single dominant action. Variant management is a repeatable row group with per-row validation, never a modal stack. Media upload shows accepted types, size, scan state and version. The compliance path selector is a three-option radio that leads to one shared Review and Confirm screen so all three paths converge visually. Bulk import shows a row-error table with jump-to-row links and never reports partial success as success. Admin compliance review uses the Phase 3E two-pane pattern: section navigator, evidence beside fields, decision with required reason.

## API/key step

Use local OCR where feasible. If Google ML Kit or another service is enabled, configure only its Development credential. OCR output is never treated as approval.

## Acceptance gate

Different grades, diameters, brands or pack units cannot merge without validated equivalence. Unknown payable tax classification blocks payable publication. Unmapped but otherwise eligible listings stay usable outside aggregates. A regulated listing cannot become Active without the applicable verified evidence. A nonmatch becomes pending review, never an automatic counterfeit accusation.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 4: taxonomy, Vendor listings and variants, listing media, price versions and the complete PS/ICC compliance workflow. Surfaces are apps/vendor-web, apps/admin-web, services/api and packages/api-contract. Buyer stays unchanged.

Implement MAT-03 comparable groups, versioned mapping and normalized ordinary VAT-inclusive public prices. Exclude promotional, volume-tier and negotiated amounts from the analytics source. Retain financial classifications VAT_12, VAT_ZERO, VAT_EXEMPT and NON_VAT distinctly under FIN-02. Price, mapping, tax and publication changes preserve source versions for later snapshots and accepted orders.

Implement canonical materials, aliases with PostgreSQL pg_trgm fuzzy matching, categories, one to three tags, compatible units, technical attribute definitions, regulated-material mappings, products, Vendor listings, variants, price history, media and status history.

Implement Photo/OCR, QR and Manual Entry compliance paths that converge on one Review and Confirm screen. Treat OCR and QR as editable extraction assistance. Store evidence privately and route uncertain, unavailable or unmatched results to PENDING_ADMIN_REVIEW. Add Admin Approve, Return for Correction and Reject with required reasons and source and version attribution. Enforce the regulated publication gate in the backend.

Build the Vendor catalog as a filterable table at 1024px and above and cards below, a numbered create/edit wizard reusing the onboarding step pattern with server-derived completion and Save Draft, variants as a repeatable row group with per-row validation rather than stacked modals, media fields showing accepted types, size, scan state and version, and a bulk spreadsheet import with a row-error table, jump-to-row links, transactional validated rows and no partial success reported as success. Build Admin compliance review with the Phase 3E two-pane pattern.

Update OpenAPI and generated clients. Add permission, state, file-abuse, compliance-gate, fuzzy-search and historical-snapshot tests plus browser checks at the eight standard widths. Run all relevant checks and report the acceptance gate. Do not deploy or commit.
```

---

# Phase 5 — Inventory, Pricing, Delivery and Auto-Accept Configuration

**Surfaces:** Vendor, API. Admin and Buyer unchanged.

## Outcome

Vendors manage exact private stock, public availability, price history, delivery vehicles and rates, stale-stock confirmation and safe per-variant Item-Based auto-accept rules.

## Required implementation

**FIN/MAT integration.** Implement `EligibleOfferQuery` shared by Explore counts, current offers and daily capture: active approved Tier 2 listing and variant, valid ordinary price, category and compliance, confirmed non-stale inventory and positive sellable quantity. Current-count and cache invalidation follows stock, reservation, listing, price and Vendor eligibility changes. Exact stock stays private.

- Inventory balances, movements, reconciliation, reserved and soft-held reporting.
- Optimistic concurrency for manual edits and row locks for reservations.
- Price and version management, plus volume tiers where the listing defines them.
- Vehicles, capacities, cargo dimensions, rates, availability, service radius and snapshot history.
- Auto-accept enabled/paused state, allotment, unit cap, amount cap, explicit resume and permissions.
- Day 7 and Day 12 reminders, and Day 15 temporary listing hide for unconfirmed stock.

## UI/UX and layout architecture

The inventory ledger is a dense table with sticky header and horizontal scroll confined to its own container. Adjustments open an inline row editor with an optimistic-conflict banner rather than a silent overwrite. Buyers-see-this labels render beside private numbers so the Vendor always understands what is public: In Stock, Limited Stock or Out of Stock. Auto-accept configuration is a single surface with the enable switch, three independent safeguard fields and an explicit pause/resume state shown as text plus icon; the resume action requires confirmation naming the allotment being restored. Delivery configuration groups vehicles as repeatable row sets with per-vehicle validation. Stale-stock reminders appear as a persistent band with the exact Asia/Manila date beside the countdown.

## Acceptance gate

A listing with multiple variants counts once; unavailable or stale variants contribute neither a current count nor a new eligible daily observation. Duplicate source offers cannot give one Vendor more aggregate weight. Buyers never receive exact stock. Inventory cannot go negative. Auto-accept never applies to Project-Based procurement or any NRPC order.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 5: exact Vendor inventory, price and version controls, vehicle and delivery configuration, stale-stock confirmation and Item-Based auto-accept policy configuration. Surfaces are apps/vendor-web, services/api and packages/api-contract.

Add the shared MAT-02 eligibility predicate and MAT-03 source version fields to the inventory and pricing services. Preserve historical observation sources rather than updating old prices in place. Wire bounded current-count invalidation to existing outbox events. Do not add a market-data call and do not expose quantity_on_hand through analytics.

Implement quantity_on_hand, hard_reserved_quantity, soft_held_quantity, available_to_sell, auto-accept allotment, reorder level and append-only movements. Buyers receive only In Stock, Limited Stock or Out of Stock. Add lock_version conflict handling for manual edits and prepare deterministic row-lock helpers for later order acceptance.

Implement vehicle capacity and dimensions, availability, base fee, per-kilometre rate, maximum distance and immutable order-time snapshots. Add auto-accept policy versions that are disabled by default with separate allotment, unit and amount safeguards, pause at zero, a notification event and a deliberate authorized resume. Explicitly prohibit Project-Based and NRPC auto-accept.

Implement Day 7 and Day 12 reminders and Day 15 TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED behavior.

Build the ledger as a dense table with a sticky header and container-confined horizontal scroll, inline row editing with an optimistic-conflict banner, public-label indicators beside private numbers, a single auto-accept surface with an enable switch, three independent safeguard fields, a text-plus-icon pause state and a confirmation naming the restored allotment on resume, and repeatable vehicle row sets with per-vehicle validation.

Update OpenAPI, clients, factories and tests including concurrent update and permission cases, plus browser checks at the eight standard widths. Report all validation results. Do not deploy or commit.
```

---

# Phase 6 — Buyer Onboarding, Locations, Maps and Supplier Directory

**Surfaces:** Buyer, API. Vendor and Admin unchanged.

## Outcome

Buyers create profiles and saved locations, browse an accessible map and list, use manual location without GPS, select 5–50 km radii, and distinguish Verified Vendors, Directory Suppliers and Favorite Suppliers.

## Required implementation

**FIN/MAT integration.** Carry the active Buyer location and the selected exact radius into Explore and future Materials Analytics; the Project origin is explicit. Support own-store-centered Vendor scope and PSGC Admin scope in shared Geography queries. Snapshot records retain the captured address and geography version.

- Buyer onboarding, primary location, saved locations, coordinate and PSGC resolution, consent and permissions.
- Flutter Google Maps integration and the list alternative.
- Map Home layout and tokens based on Figma node `1:17996`, corrected by the UI planner.
- PostGIS radius query before route or ETA requests.
- Tier 1 Places search, cache and attribution; Tier 2 Vendor serviceability.
- Ask-before-expansion through 5, 10, 20, 30, 40 and 50 km.
- PSGC import, versioning and unresolved-geography handling.
- Zoom-aware Vendor clusters and collision-safe labels.
- Tier 2 labels with store name plus VPS or New Vendor; Tier 1 labels with store name plus Directory.
- Selected-marker camera transition, one route request, route-line reveal, distance and ETA, and a Tier-specific preview sheet.

## UI/UX and layout architecture

Map Home is map-first with the five-destination shell preserved. A synchronized accessible list is a peer surface, not a hidden fallback: the same data, the same ordering, reachable by keyboard and screen reader at any time. The preview sheet has three snap positions with focus containment and an explicit View Store action for Tier 2 only. `LocationSelector` and `RadiusSelector` are shared components with visible selected state and a confirmation before any automatic expansion. Marker semantics never rely on color alone. Loading, denied-permission, offline, provider-error and route-error states are distinct and each offers a manual path. No weather widget. Under Reduce Motion the camera and route render immediately in their final state. Verify layouts at 320px, in landscape and at 2× text scaling.

## API/key step

Create restricted Development keys for Android, iOS, browser and backend. Never reuse the backend key in Flutter or React.

## Acceptance gate

50 km is the maximum Buyer and Vendor scope, not an automatic expansion from 5 km and not an Admin national limit. Exact-boundary and just-outside results are tested with PostGIS geography. The Buyer can complete every discovery action with GPS denied. Tier 1 Suppliers have no in-platform transaction action.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 6: Buyer onboarding and saved locations, PSGC-aware address storage, Flutter map and list discovery, Tier 1 directory suppliers, Tier 2 Verified Vendors, Favorite Supplier labels, radius controls and route/ETA adapters. Surfaces are apps/buyer-mobile, services/api and packages/api-contract.

Implement MAT-01 scope resolution and a stable origin and radius context. Use ST_DWithin on geography in metres; never use route distance for membership. A Vendor market request cannot select a competitor origin. Keep location ownership, privacy and optional-GPS rules, and reject unsupported radius values on the backend.

Read the exact map rules and the UI planner before coding. Use Figma node 1:17996 for composition only. GPS permission is optional. Implement manual address entry and pin placement as complete alternatives. Store authoritative coordinates and the best resolved versioned PSGC codes. Use PostGIS for the initial radius filter and call Google Routes only for the selected Vendor or a transaction-relevant result. Use exactly 5, 10, 20, 30, 40 and 50 km, default 5 km, and ask before expansion.

Implement zoom-aware clustering and collision-safe individual labels. Tier 2 labels show store name plus VPS or New Vendor; Tier 1 labels show store name plus Directory. A Tier 1 Google rating appears only in Place Details with explicit Google attribution and is never labelled VPS. On Tier 2 selection, synchronize the map and list, move the camera safely, request one driving route from the active selected location, reveal the polyline, display distance and ETA, and open the preview sheet with an explicit View Store action. On Tier 1 selection show only policy-permitted Place Details and public contact, map, website and share actions; Tier 1 is informational with no marketplace message, order, review, payment, VPS, verification or storefront action.

Use the approved motion tokens: no bounce, no moving delivery vehicle, no implication of live GPS, stale-response protection and immediate final rendering under Reduce Motion. Implement separate restricted client and server key configuration, minimum Places and Routes field masks, compliant attribution, bounded cache records, quotas, timeouts and fallbacks. Provide a synchronized accessible list as a peer surface with the same data and ordering, non-color marker semantics, distinct loading, denied, offline, provider-error and route-error states, and no weather widget. Verify 320px, landscape and 2x text scaling.

Update OpenAPI, generated clients, PSGC import documentation and tests for radius edges, denied permission, unresolved PSGC, provider timeout, cache expiry and Tier 1 restrictions. Never reveal configured keys. Do not deploy or commit.
```

---

# Phase 7 — Item-Based Discovery, Ranking, Favorites, Cart and Checkout Preview

**Surfaces:** Buyer, API. Vendor and Admin unchanged.

## Outcome

Buyers search comparable active listings, understand Best Price and ranking, personalize SRS weights, maintain favorites, and prepare a cart split by Vendor before order submission.

## Required implementation

**FIN/MAT integration.** Add Nearby Verified Vendors and Available Products above the Explore categories using current distinct eligible organization and listing counts, before category filters. Prepare the View Materials Analytics entry point with explicit availability gating until Phase 14. Checkout preview follows FIN-02 included VAT and the M/D/F/N components and excludes Vendor commission and CWT.

- Search, filters, product and vendor detail, active-stock rules, price normalization and pagination.
- Normalized SRS with exact default weights and separate Buyer overrides.
- Best Price only for a comparable variant, unit and service radius with stock.
- Favorites and Favorites First without silently changing Best Deal.
- Cart validation, Vendor grouping, delivery and pickup choices, physical-payment eligibility and checkout preview.
- No stock reservation at cart time.

## UI/UX and layout architecture

Explore leads with two accessible summary cards built from **one** server snapshot with a shared `current_as_of`; neither shows a false zero while loading. Category entries follow. Ranking explanation is a disclosure panel showing component scores in text, not a chart. The preferences screen enforces a 100% total with live remaining-weight feedback, a visible "personalization active" indicator and Reset to Default. The cart renders one group per Vendor with its own delivery or pickup choice and its own validation band; a stale price, stock, serviceability or Vendor-status result appears inline on the affected group without discarding the rest of the cart. Filters and scroll position survive navigation, and stale async responses are rejected.

## Acceptance gate

Counts handle variants, duplicate materials across stores, stale stock and radius changes correctly. No broken analytics navigation ships before its feature is enabled. Buyer totals never include the 2% commission or merchant CWT. Ranking is deterministic and explainable. All weight sets total 100%. A cart preview detects stale price, stock, serviceability and Vendor status without creating an order or a reservation.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 7: Item-Based marketplace search and product detail, deterministic SRS, Buyer ranking preferences, Best Price, Favorite Suppliers, cart, Vendor grouping and checkout preview. Surfaces are apps/buyer-mobile, services/api and packages/api-contract.

Build the Explore dashboard with current_as_of, visible scope and accessible summary cards. Use one server request snapshot for both counts, label the Product count as Vendor listings, and show no false zero while loading. Preserve filters and scroll and reject stale async responses. Keep Materials Analytics disabled until the Phase 14 end-to-end feature is installed. Use a FinancialSnapshotService-compatible included-VAT preview and never normalize a market average into an order price.

Use SRS Distance 30 percent, Price 25 percent, VPS 20 percent, Stock 15 percent and Product Rating 10 percent as a normalized weighted sum. Store Item-Based Buyer overrides separately, require a 100 percent total, reject all-zero values, show when personalization is active and implement Reset to Default. Implement explainable component scores and deterministic tie-breaking.

Best Price must compare the same product, variant, unit and service radius and require active available stock. Favorites First is explicit and must not silently override Best Deal. Cart placement creates no inventory hold. Checkout preview groups one child group per Vendor and revalidates listing state, price version, availability label, address and serviceability, delivery and pickup capability and payment-method eligibility, showing a stale result inline on the affected group without discarding the rest of the cart.

Implement the Flutter pages with accessible loading, empty, stale, error, offline and retry states, at 320px, in landscape and at 2x text scaling. Update backend queries, OpenAPI, the generated client and tests for ranking maths, comparison normalization, stale data, cross-Vendor carts and unauthorized preferences. Do not deploy or commit.
```

---

# Phase 8 — Orders, Confirmation, NRPC, Atomic Reservations and Auto-Accept

**Surfaces:** Buyer, Vendor, API. Admin unchanged.

## Outcome

Item-Based order submission creates one parent checkout and Vendor child orders. Vendors manually confirm, revise or decline, may propose a disclosed manual NRPC, or use safe auto-accept when every eligibility rule passes.

## Required implementation

**FIN/MAT integration.** Snapshot FIN-02 amounts, line discounts and VAT, the fee-policy version, NRPC affected-line allocation and the accepted version and hash. Add an immutable ESTIMATED fee assessment and an audited completion-event contract. Physical obligations stay separate from online payment state; all-or-none stock remains atomic.

- Order, line, price, fee, delivery, payment-method and policy snapshots.
- Canonical transition service and immutable history.
- Vendor confirmation, permitted revision, Buyer approval, decline and expiry.
- Manual-only NRPC reason, amount, affected lines, Terms version and Buyer acceptance or flag.
- Atomic hard reservation with deterministic row locks and all-or-nothing multi-line behavior.
- Item-Based auto-accept transaction, policy snapshot, allotment decrement, pause and manual fallback.
- 45-minute displayed payment expiry and reservation release.

## UI/UX and layout architecture

The Buyer order timeline shows order, payment, fulfillment, refund and dispute as **separate** state rows so no single status bar implies all five. `MoneyBreakdown` itemizes materials, delivery, processing fee, NRPC allocation and total, with refund effects added later. NRPC disclosure is a dedicated acceptance surface with the amount, reason, affected lines and Terms version visible before any acceptance control activates; a Buyer objection flag is separate and never silently accepts. The Vendor order workspace is a status-filtered list plus a job-order detail with one dominant action per state. The 45-minute expiry shows a countdown plus the exact Asia/Manila time and, on expiry, a cleanly resolved state rather than a stuck spinner.

## Acceptance gate

Largest-remainder discounts and partial principal VAT allocation sum exactly. NRPC reduces only principal, once. An accepted order retains its original prices, tax and fee policy when a listing or market average changes. Concurrency tests prove no overselling. NRPC can never be introduced after Buyer acceptance or payment and never participates in auto-accept.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 8 end to end: Item-Based order submission, parent checkout and per-Vendor child orders, Vendor confirmation, revision and decline, Buyer approval, manual NRPC, atomic hard reservations, auto-accept and 45-minute payment expiry preparation. Surfaces are apps/buyer-mobile, apps/vendor-web, services/api and packages/api-contract.

Implement FIN-02 centavo Money and immutable financial snapshots, including VAT_12 included tax L*12/112, E=M-V and the full online, direct cash and mixed NRPC amount matrix. Validate 0 < N <= the eligible prepared-material subtotal without introducing a numeric platform NRPC cap. Prepare unique fee estimation and completion events for FIN-03 without earning a fee on payment or confirmation. Add allocation, rounding and snapshot-version tests.

Use one server-side state-transition service and immutable order history. Snapshot every commercial input. Create hard reservations only at manual confirmation, quotation acceptance or eligible auto-accept. In one PostgreSQL transaction, lock all affected inventory and policy rows in deterministic order, revalidate every line and update all lines or none. Physical quantity_on_hand changes only at fulfillment. Release reservations on rejection, payment expiry, cancellation or approved reduction.

NRPC is disabled by default, Vendor-determined with no platform-wide numeric cap, manual only, part of the existing order value, and requires amount, reason, affected lines, versioned Terms and explicit Buyer acceptance before payment or preparation. Allow a separate Buyer objection flag without silently changing acceptance. Never enable NRPC for auto-accept.

Implement auto-accept only for eligible Item-Based orders without NRPC. Enforce per-variant allotment plus independent unit and amount safeguards. When any check fails, make no partial change and route the complete Vendor order to manual review. Pause at zero and require a deliberate authorized resume.

Build the Buyer order timeline with separate order, payment, fulfillment, refund and dispute state rows, a MoneyBreakdown itemizing materials, delivery, processing fee, NRPC allocation and total, and a dedicated NRPC disclosure surface where the acceptance control activates only after the amount, reason, affected lines and Terms version are visible. Build the Vendor status-filtered list and job-order detail with one dominant action per state. Display the payment expiry as a countdown plus the exact Asia/Manila date and time, resolving cleanly on expiry.

Update OpenAPI, generated clients, audit and outbox events, and exhaustive transaction and concurrency tests. Do not integrate real payment yet, deploy or commit.
```

---

# Phase 9 — Real-Time Messaging and Shared Order-from-Chat Engine

**Surfaces:** Buyer, Vendor, API. Admin unchanged.

## Outcome

Tier 2 Buyers and Vendor staff communicate securely. Vendors create versioned Item-Based or Project-Based quotations through one engine with deadlines, counter-offers, change history, soft holds and stale-version protection.

## Required implementation

**FIN/MAT integration.** Use the same financial snapshot calculator for Item and Project quotation publication and acceptance. The accepted version records line tax, discount, NRPC and the estimated fee-policy version. Public market analytics never ingest quotation prices or Work Package contents.

- Authorized conversations, participants, handlers, transfer system messages, receipts and attachments.
- Buyer-visible store and staff identity without personal staff contact details.
- Draft, publish, revise, withdraw; 1–72 hour deadline with a 24-hour default; reminder, expire, accept, reject, counter.
- Immutable quotation versions, before/after audit, content hash and a plain-language change summary.
- Soft holds on publish; immediate release on counter, reject, expire or withdraw.
- Acceptance-time atomic revalidation and hard reservation.
- `ITEM_BASED` and `PROJECT_BASED` flags on one engine, never a duplicated engine.

## UI/UX and layout architecture

The conversation header shows the store logo, store name and Verified badge plus the staff avatar, display name and role with "Handled by" wording — never a staff login email or personal phone. `QuotationVersionCard` marks latest versus superseded, viewed state, the change summary, the deadline and only the valid actions for that version; a superseded version is readable but its actions are gone, not merely disabled without explanation. `Deadline` shows the countdown plus the exact Asia/Manila date and time. Accepting a stale version surfaces a clear recoverable conflict, never a generic error. Attachments show type, size and scan state.

## Acceptance gate

Private negotiated quotation price changes never alter a public market average. Quotation acceptance still requires the latest version and atomic stock validation. An old version cannot be accepted after revision. Unauthorized users cannot subscribe to or retrieve another conversation.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 9: secure real-time messaging and the single shared Order-from-Chat quotation engine for ITEM_BASED and PROJECT_BASED conversations. Surfaces are apps/buyer-mobile, apps/vendor-web, services/api and packages/api-contract.

Integrate FIN-02 into the shared quotation engine and preserve source tax and price versions in the accepted order. Reject an unknown payable tax category before publication. Mark quotation and completed transaction prices as private transaction sources and exclude them from MAT snapshot queries and competitor payloads. Preserve the existing deadline, counter-offer and NRPC audit logic.

Implement authorized Reverb channels, conversation participants, staff handler assignment and transfer, read receipts, safe attachments and system messages. Buyer headers show the store logo, store name and Verified badge plus the staff avatar, display name and role with Handled by wording, but never a staff login email or personal phone.

Implement quotation draft, publish, edit-as-new-version, withdraw, view, accept, reject, counter-offer, reminder and expiry. The default Buyer deadline is 24 hours and the Vendor may choose 1 to 72 hours. Every published edit supersedes the old immutable version, resets the deadline, creates before and after plus plain-language changes, and makes a stale acceptance return a safe 409. Store products, quantities, units, prices, fulfillment, payment method, delivery calculations, NRPC fields, actor, content hash and audit events.

Publishing creates only a soft hold that does not reduce available_to_sell or the auto-accept pool. Counter, rejection, expiry or withdrawal releases it. Acceptance atomically revalidates current stock and converts to hard reservations; insufficient stock produces STOCK_REVALIDATION_REQUIRED with no payment or order acceptance.

Build QuotationVersionCard marking latest versus superseded, viewed state, change summary, deadline and only the valid actions, with a superseded version readable but without stale actions, and a clear recoverable conflict when a stale version is accepted. Show Deadline as a countdown plus the exact Asia/Manila date and time. Show attachment type, size and scan state.

Update the Flutter and Vendor UI, OpenAPI, generated clients, Reverb authorization tests, quotation-version tests, deadline tests using a fake clock and stock-contention tests. Do not deploy or commit.
```

---

# Phase 10 — Project-Based Procurement, Work Packages, FMS and Budgets

**Surfaces:** Buyer, Vendor, API. Admin unchanged.

## Outcome

Buyers manage Projects and versioned Work Packages, receive compiled one-Vendor estimates, message each eligible Vendor with locked and editable copies, compare change summaries, select one Vendor and monitor budgets.

## Required implementation

**FIN/MAT integration.** Apply FIN-11 disjoint budget buckets: pending incomplete obligations, completed or retained actual cost, and paid cancelled amounts awaiting recovery. Committed Spend is their sum; Remaining Budget = Budget − Committed Spend. Include actual materials VAT, delivery and Buyer fees and count NRPC once. Analytics planning never mutates a Project budget.

- Project, site, budget and Work Package draft, activate and version lifecycle.
- BOM/BOQ line validation and CSV import.
- Tier 2 scan, one-Vendor completeness, missing lines, estimate snapshots and 48-hour validity.
- FMS exact weights, Buyer overrides, comparison and budget labels.
- Inquiry attachments: locked Buyer original plus a Vendor-editable duplicate.
- Optional informational Note for direct selection.
- Accepting one Vendor expires competing quotation requests while preserving history.
- Project and work-package budget metrics, 90% warning and a reasoned override above 100%.
- Project Vendor Map based visually on Figma node `1:18108`, using the Project site as origin and the shared map/route engine.

## UI/UX and layout architecture

The Work Package editor shows version state prominently: Draft is editable, Active is locked with an explicit new-version action. The compiled estimate lists complete single-Vendor matches first and shows missing lines explicitly rather than hiding an incomplete match. The Project Vendor Map reuses `SupplierMarker`, `SupplierCluster`, `RouteOverlay` and `SupplierPreviewSheet` with a `PROJECT_BASED` context flag and a synchronized accessible list. `WorkPackageAttachment` renders the locked original and the Vendor working copy side by side at ≥1024px and stacked below, with every proposed change summarized in plain language before acceptance. Budget indicators show Under, Within or Over Budget with exact cost components in text; the 90% warning is a band and the over-100% path requires a written reason.

## Acceptance gate

Paid cancellation releases refundable budget only after successful recovery; unpaid obligations release at cancellation. Vendor CWT, commission and fee payment never affect Buyer budgets. The locked original never changes. Every Vendor change is visible before acceptance. A Work Package ends with one selected Vendor, not split competitive awards.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 10: Projects, project sites, versioned Work Packages, system-compiled Vendor estimates, FMS comparison, multi-Vendor inquiries, one-Vendor selection and budget monitoring. Surfaces are apps/buyer-mobile, apps/vendor-web, services/api and packages/api-contract.

Implement FIN-11 using Committed Spend = pending incomplete order cost + actual completed or retained cost + paid cancelled amount awaiting recovery, and Remaining Budget = Budget - Committed Spend. Keep the buckets disjoint and never subtract Actual Spend twice. Link market-analysis navigation to the explicitly selected Project site only; never replace accepted quotes or set project costs from historical averages.

Implement Draft, Active, Quotation Inquiry, Vendor Selected, Awaiting Payment, In Progress, Completed and Cancelled behavior exactly as documented. Lock an Active Work Package version and require an explicit new version to change it. Scan active Tier 2 inventory within the confirmed radius, favour a complete single-Vendor match, show missing lines explicitly, snapshot prices, availability and the delivery estimate, and expire system estimates after 48 hours.

Use FMS Material Match 40 percent, Budget Fit 25 percent, Distance 20 percent and VPS 15 percent as a normalized weighted sum with separate Project-Based Buyer preferences, 100 percent validation, an active indicator and Reset to Default. Show Under, Within or Over Budget with exact cost components in text.

From the compiled Vendor list and the synchronized Project Vendor Map, allow the Buyer to message each Vendor. Use Figma node 1:18108 for map composition and the UI planner for behavior. The Project site is the route origin and candidates are eligible Tier 2 Vendors only. Reuse the Phase 6 SupplierMarker, SupplierCluster, RouteOverlay and SupplierPreviewSheet components with a PROJECT_BASED context flag. Individual labels show store name plus VPS or New Vendor; selected details add FMS, match completeness, budget result, distance and ETA, fulfillment, quotation state, comparison, Add Note, Message Vendor and View Store.

Attach the locked Buyer original and a Vendor-editable duplicate to the shared Phase 9 quotation engine, rendered side by side at 1024px and above and stacked below. Track every proposed field change and show a plain-language summary before acceptance. Direct selection may include an optional informational Note requiring no Vendor response. Selecting or accepting one Vendor expires other active quotations while retaining their histories. Protect against stale route and quotation results and support the synchronized accessible list and reduced motion.

Implement project and work-package budget metrics, the 90 percent warning band and a written Buyer override when a purchase exceeds 100 percent. Update UI, OpenAPI, clients, PDF placeholders and tests for version integrity, expiry, ranking, missing lines, one-Vendor enforcement and budget calculations. Do not deploy or commit.
```

---

# Phase 11 — Xendit Checkout, Payments, Fees, Webhooks and the FIN-04A Threshold Engine

**Surfaces:** Buyer, Vendor, Admin, API.

## Outcome

Buyers pay in Xendit Test Mode through Vendor sub-accounts. The platform records transparent fee snapshots, trusts only verified provider events, handles duplicates, reconciles uncertain transactions, and maintains the authoritative rolling gross-remittance threshold counter.

## Required implementation

**FIN/MAT integration.** Implement FIN-01 to FIN-06 and FIN-10 in the Finance domain: exact amounts, tax profiles and threshold locks, canonical remittance groups, the simulated responsibility adapter, the 0.5% qualified base, the 2% completed-material commission service, monthly statements, platform fee payments, separate ledgers, physical collection records and reconciliation. Add APIs for review and approval; later Admin pages consume them.

**FIN-04A — withholding threshold counter.** Implement `vendor_withholding_accumulators` keyed on `(environment, taxpayer_key, taxable_year)` with `g_accumulated_centavos`, declared external amount, overlap, the generated `g_effective_centavos`, `withholding_status`, `crossed_at`, `crossing_assessment_id`, `prior_year_total_centavos` and `lock_version`, plus append-only `vendor_withholding_status_events`. At every assessable remittance, lock the accumulator row with `FOR UPDATE`, add the whole canonical group, and when `g_effective` exceeds 50,000,000 centavos — that is, reaches ₱500,000.01 — flip the status to `SUBJECT_THRESHOLD_BREACHED`, tax the crossing remittance in full and keep the status for the remainder of the taxable year regardless of any uploaded, approved or still-valid Sworn Declaration. A refund or a lower running total never restores relief; it opens an adjustment review. Year rollover creates a new accumulator that starts at `SUBJECT_PRIOR_YEAR` when the previous year closed above the threshold. Never hold the lock across a provider call. Full rules and the exact centavo fixtures are in `MateryalPH_Technical_Design_Delta_FIN-04A_Withholding_Threshold.md`.

- Payment adapter plus a deterministic fake adapter for automated tests.
- Xendit sub-account capability and connection checks.
- Payment methods from actual configuration; refund-incompatible channels disabled for the MVP.
- Server-side payable amount and processing-fee snapshot.
- Full-order, NRPC-assurance, order-balance and separate platform-fee payment purposes with account and ledger validation.
- 45-minute expiry, and callback/return pages that stay Pending until webhook confirmation.
- Authenticated idempotent Xendit webhook inbox and asynchronous processor.
- Scheduled reconciliation, an exception queue and a technical compensation trigger when capture occurred after an application failure.

## UI/UX and layout architecture

The Buyer payment return page shows **Pending** with an explanation until a verified event or authoritative reconciliation arrives; a browser redirect never renders success. The Vendor finance surface separates Xendit connection, Vendor Tax Profile summary, withholding arrangement, Commission Terms, online payment channels, physical payments and refund capability into distinct sections; unknown responsibility reads "Production assignment unconfirmed." The threshold panel shows the taxable year, cumulative gross remittances in pesos, the remaining allowance floored at zero, the status as text plus icon, the crossing date and time in Asia/Manila, and a plain sentence that crossing is final for the year. An advisory notice appears at 80% of the threshold and a mandatory non-disableable notice on every flip to a subject status. Every simulated figure is visibly labelled as DEMO.

## API/key step

Follow the Xendit Test Mode section of the environment guide. The secret key and callback token go only into backend Development or Staging configuration — never into React, Flutter, logs or screenshots.

## Acceptance gate

Execute all FIN-06 exact arithmetic cases plus concurrent crossing, missing declaration, year rollover, duplicate group, external-total overlap, mismatched account or purpose, balance constraints and paid-fee credit. Execute every FIN-04A fixture, including the exactly-at-limit case that stays in relief, the ₱500,000.01 case that breaches, the full taxation of the crossing remittance, the post-crossing declaration that changes nothing, and the two-concurrent-settlement case run against live PostgreSQL. Payment success alone never proves withheld tax or fee earning. A forged, duplicate, reordered, mismatched-amount or unknown webhook cannot create a paid order. A browser redirect never marks `PAID`.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 11 using Xendit Test Mode: checkout payment creation for Vendor sub-accounts, payment-processing-fee snapshots, payment purposes, verified webhooks, idempotency, expiry, reconciliation, safe client return pages, and the FIN-04A gross-remittance threshold engine. Surfaces are services/api, packages/api-contract, apps/buyer-mobile, apps/vendor-web and apps/admin-web.

Implement the full embedded FIN contract in Technical Design 13.2. G = C - R - D_r - V_r - P; W = half-up(G * 0.005); expected Vendor cash = C - R - P - W; commission_deducted_in_remittance = 0. Tax the full crossing remittance; a missing declaration is subject unless valid other relief applies; retain prior-year and breach evidence and do not double count external declarations. Lock taxpayer and year and enforce unique group and obligation, then post and enqueue the outbox without network calls under the lock. The DEMO tax adapter is separate from actual Xendit TEST payment evidence, including the provider-withholder alternate that never deducts twice. EARNED fee is 2 percent of completed nonrefunded exclusive materials; implement ESTIMATED and EARNED plus original-target credits without premature earning. Draft monthly statements at 00:05 on the first day, approved by the third, due on the fifteenth or twelve days after late issue. The Owner pays positive bills to the platform TEST account with PLATFORM_FEE_PAYMENT, 45-minute attempts, no auto debit or splits, and the platform absorbs its own bill processing fees. Persist FIN-10 states, ledgers, physical-payment evidence, installment allocation and reconciliation exceptions.

Implement FIN-04A exactly as written in docs/architecture/MateryalPH_Technical_Design_Delta_FIN-04A_Withholding_Threshold.md. Create vendor_withholding_accumulators unique on environment, taxpayer_key and taxable_year, with g_accumulated_centavos, g_external_declared_centavos, g_external_overlap_centavos, generated g_effective_centavos, withholding_status, status_reason_code, crossed_at, crossing_assessment_id, effective_declaration_id, prior_year_total_centavos and lock_version, plus append-only vendor_withholding_status_events. Use the canonical statuses RELIEF_ACTIVE, SUBJECT_STANDARD, SUBJECT_THRESHOLD_BREACHED, SUBJECT_PRIOR_YEAR and UNDER_REVIEW; never persist the literal strings EXEMPT or SUBJECT_TO_WITHHOLDING. At each assessable remittance, select the accumulator FOR UPDATE, add the entire canonical group without splitting it, and when g_effective exceeds 50000000 centavos set SUBJECT_THRESHOLD_BREACHED, apply withholding to the whole crossing remittance rather than only the excess, and keep the subject status for the remainder of the taxable year regardless of any uploaded, approved or unexpired Sworn Declaration. A refund or lower running total never restores relief and instead opens an adjustment review. A declaration uploaded after crossing is stored and acknowledged but changes nothing for that year. At rollover create a new accumulator starting at SUBJECT_PRIOR_YEAR when the prior year closed above the threshold. Never hold the row lock across a provider call. Add snapshot columns threshold_status_before, threshold_status_after, g_effective_before_centavos, g_effective_after_centavos and relief_basis_id to remittance_assessments.

Read the current Xendit documentation linked in the technical design before choosing request fields. Put all provider code behind PaymentGateway with a deterministic fake. Use only backend environment variables already entered by the user and never print them. Determine enabled methods from configured capabilities and keep refund-incompatible MVP channels disabled.

Calculate the payable amount on the server from immutable order snapshots. Store materials, delivery, the actual configured Payment Processing Fee, total, channel and rate snapshot, Vendor sub-account, idempotency key, provider identifiers, purpose and expiry. Support FULL_ORDER_PAYMENT, NRPC_ASSURANCE_PAYMENT and ORDER_BALANCE_PAYMENT without double charging NRPC, plus PLATFORM_FEE_PAYMENT to the separate platform TEST account without treating it as a Vendor remittance.

Implement /api/v1/webhooks/xendit as a fast inbox: verify the callback token and signature with constant-time comparison, store the raw event safely once by provider event identifier, acknowledge, then process asynchronously. Recheck provider transaction identifier, amount, currency, reference, sub-account and allowed transition. Keep redirect and callback UI Pending until a verified event or authoritative reconciliation sets PAID. Add scheduled reconciliation and an idempotent technical-compensation path only when capture is proven after an application failure.

Build the Vendor finance surface with separate sections for Xendit connection, Vendor Tax Profile summary, withholding arrangement, Commission Terms, online channels, physical payments and refund capability, showing Production assignment unconfirmed where responsibility is unknown. Build the threshold panel with taxable year, cumulative gross remittances in pesos, remaining allowance floored at zero, status as text plus icon, crossing date and time in Asia/Manila and a plain sentence that crossing is final for the year. Add an advisory notice at 80 percent and a mandatory non-disableable notice on every flip to a subject status. Label every simulated figure as DEMO.

Update OpenAPI, clients, Buyer, Vendor and Admin payment views, audit and outbox events, and integration tests for success, pending, failed, expired, forged, duplicate, reordered, mismatched, timeout and reconciliation cases, plus every FIN-06 and FIN-04A fixture including the exactly-at-limit, 500000.01 crossing, full-crossing-remittance taxation, post-crossing declaration, year rollover and two-concurrent-settlement cases run against live PostgreSQL. Do not use live keys, deploy or commit.
```

---

# Phase 12 — Fulfillment, Cancellation and Automatic Cancellation Refunds

**Surfaces:** Buyer, Vendor, Admin, API.

## Outcome

Vendors process orders through pickup or delivery milestones with proof. Permitted paid cancellations calculate the correct amount and automatically initiate the separate Cancellation Refund.

## Required implementation

**FIN/MAT integration.** Wire `COMPLETED` to exactly one fee earning, and a finalized cancellation to the immediate online refund outbox, unpaid-physical release or evidenced cash reimbursement, fee cancellation or credit, and a tax-review reference. Tax and commission never reduce a Buyer refund target. Add an own-platform fee-credit refund target separate from order refunds.

- `CONFIRMED → PROCESSING → READY_FOR_PICKUP/OUT_FOR_DELIVERY → PICKED_UP/DELIVERED → COMPLETED`.
- Expected date, vehicle and trip confirmation, staff assignment, proof, receiver and audit history.
- Buyer two-day receipt confirmation, paused auto-completion while an issue is open.
- Cancellation withdrawal, request and finalization rules and cutoff.
- Vendor cancellation: full Buyer-paid refund, NRPC forfeiture, NFR event, reservation release.
- Buyer cancellation in Processing: documented NRPC evidence and retention where eligible.
- Automatic idempotent Cancellation Refund to the original method; status follows webhook or reconciliation.

## UI/UX and layout architecture

The fulfillment workspace is a milestone stepper whose completed states come from the server, with proof capture attached to the milestone that requires it. Cancellation availability is explained in text at every state: at Ready for Pickup and Out for Delivery the control is absent and replaced by Report a Problem plus the statutory-remedy path, never a disabled button with no explanation. Refund initiation and refund success are visibly different states. Live GPS is out of scope and no delivery vehicle is animated.

## Acceptance gate

A Vendor cancellation of a mixed paid NRPC order refunds the original online payment including the disclosed processor fee, forfeits NRPC and earns no commission. No cash Refund API is invented. Failed funding stays visible. Completion replay does not earn twice. Cancellation is blocked at Ready for Pickup and Out for Delivery while Report a Problem and statutory remedies remain accessible.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 12: fulfillment milestones and evidence, delivery and pickup tracking without live GPS, Buyer receipt confirmation, cancellation rules, reservation release and automatic Cancellation Refunds for already-paid finalized cancellations. Surfaces are apps/buyer-mobile, apps/vendor-web, apps/admin-web, services/api and packages/api-contract.

Apply FIN-07 with target-type-aware refunds and FIN-03 completion earning. Use the original line, discount and VAT allocations, cap successful and in-flight refund totals, and separate VENDOR_REIMBURSEMENT_PENDING and REIMBURSEMENT_CONFIRMED from provider states. Queue the supported online Refund API immediately after commit. Create ADJUSTMENT_REQUIRED for posted CWT instead of automatically recovering tax from the BIR, and never reset a FIN-04A threshold status because a refund occurred. Preserve the cancellation cutoff and statutory remedies. For a paid fee credit use PLATFORM_FEE and FEE_CREDIT tied to the original fee capture and never take unrelated Buyer funds.

Enforce all transitions through the shared server state machine. Implement expected fulfillment date, assigned staff, confirmed vehicle and trips, preparation, ready, dispatch, delivery or pickup proof, receiver, Buyer confirmation and two-calendar-day auto-confirmation that pauses for an open issue or dispute. Keep live GPS out of scope.

Allow withdrawal before Vendor confirmation and reasoned cancellation requests from CONFIRMED through PROCESSING. Disable cancellation at READY_FOR_PICKUP and OUT_FOR_DELIVERY while preserving Report a Problem, dispute, return, warranty and statutory-remedy actions, and explain the unavailability in text rather than showing an unexplained disabled control. Vendor cancellation forfeits NRPC, refunds all Buyer-paid order amounts, releases reservations and creates the applicable NFR event. Eligible Buyer cancellation may retain only accepted, evidenced NRPC under the documented rules.

When a paid cancellation becomes final, create exactly one CANCELLATION refund record and immediately submit the idempotent provider request. Set REFUND_PENDING on successful initiation and wait for verified provider events or reconciliation before REFUNDED or REFUND_FAILED. Return only to the original supported method. Never open a dispute automatically.

Build the fulfillment workspace as a milestone stepper with server-derived completion and proof capture attached to the milestone that requires it, and render refund initiation and refund success as visibly different states.

Update all clients, OpenAPI, notifications, audit history and tests for each actor, state, cause and payment combination, provider timeouts, duplicate cancellation, duplicate webhooks and reservation release. Use Xendit Test Mode only. Do not deploy or commit.
```

---

# Phase 13 — Disputes, Appeals, Dispute-Conclusion Refunds and Invoices

**Surfaces:** Buyer, Vendor, Admin, API.

## Outcome

Buyers and Vendors resolve documented cases through timed steps. A refund is created only when a concluded decision awards it. Buyers access Vendor-issued invoice records and request copies or corrections; the Vendor issues through its registered process when legally due, while MateryalPH provides separately labelled operational or demo files.

## Required implementation

**FIN/MAT integration.** At an enforceable dispute conclusion, apply the awarded online and physical components, original VAT and discount allocations, the commission target credit and a reviewed tax correction. Keep the Vendor goods invoice, platform service invoice, processor invoice and Form 2307 separate. An invoice copy request never postpones legally due issuance.

- Structured dispute and refund-request form, evidence, Case ID, masked original method, no alternative destination.
- 48-hour response, 72-hour mutual resolution, 24-hour clarification, five-business-day appeal.
- Admin decision and remedy tracking.
- A separate Dispute-Conclusion Refund linked to the decision version and case.
- Review withholding and order auto-completion pause.
- Invoice request, Vendor upload, three-business-day service target, authorized access and audit.

## UI/UX and layout architecture

The case timeline is one chronological surface with actor, role, timestamp and evidence per entry; evidence opens through authenticated short-lived URLs. Every deadline shows a countdown plus the exact Asia/Manila date and time. The filing form collects issue type, affected lines, remedy, requested partial amount, description and evidence, and shows the masked original payment method as read-only information — there is no field anywhere that accepts a different refund destination. The Admin decision form requires the remedy, the reason and a conflict check before submission. MateryalPH-generated files carry a visible "not a tax invoice" label.

## Acceptance gate

Filing a dispute cannot trigger a refund or create `REFUND_PENDING`. An awarded partial refund cannot exceed the original lines or refund twice; a dispute hold does not overwrite earned-fee state. A generic PDF is never labelled structured e-invoicing compliance. A concluded refund award creates exactly one linked refund and the case stays open until the remedy reaches a terminal state.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 13: transaction disputes, mutual resolution, Admin clarification and decision, one appeal, remedy tracking, Dispute-Conclusion Refunds, returns and the Vendor invoice request and upload workflow. Surfaces are apps/buyer-mobile, apps/vendor-web, apps/admin-web, services/api and packages/api-contract.

Implement FIN-07 and FIN-09 dispute and invoice details. Make invoice records available when received or legally due rather than only after completion or a Buyer request; the three-business-day copy target is not an issuance extension. Validate issuer and type and reconcile document differences without changing accepted Buyer totals. Refund awards create linked fee adjustments and tax review, with no automatic filed-return amendment, no alternate online refund destination and no removal of statutory remedies.

Implement the documented states and Asia/Manila deadlines using exact stored instants and a visible countdown plus date and time. The filing form includes issue type, affected lines, remedy, requested partial amount, description, evidence and the masked original payment method as read-only information; it must never collect a different refund destination anywhere. Filing creates a Case ID and dispute state only.

Implement 48 calendar hours for response, 72 calendar hours for mutual resolution after response, 24 calendar hours for requested clarification, and one appeal within five business days with new evidence or a material process error. Preserve all evidence and decisions immutably. Implement Dismissed, Replacement, Full or Partial Refund, Warning, metric event, Restriction, Suspension, Ban and Inconclusive outcomes within role permissions.

Only a concluded decision awarding money creates one idempotent DISPUTE_CONCLUSION refund linked to the Case ID and decision version. Keep it separate from CANCELLATION. Track REFUND_PENDING through provider events and do not resolve the case until the remedy completes.

Implement FIN-09 invoice availability and copy or correction requests with protected externally issued invoice records, metadata, the three-business-day copy service target, reminders and audit. Do not delay legally due issuance or assume an uploaded PDF proves BIR compliance. Label MateryalPH purchase-order and payment files as not tax invoices.

Build the case timeline as one chronological surface with actor, role, timestamp and evidence per entry opening through authenticated short-lived URLs, and require remedy, reason and a conflict check on the Admin decision form.

Update clients, OpenAPI, notifications and exhaustive timeline, authorization and refund tests. Use Test Mode only. Do not deploy or commit.
```

---

# Phase 14 — Reviews, Scores, Badges and Materials Analytics

**Surfaces:** Buyer, Vendor, Admin, API.

## Outcome

Verified completed purchases produce controlled reviews, daily Vendor scores, automatic badges and local price insights without misleading small samples.

## Required implementation

**FIN/MAT integration.** Deliver MAT-01 to MAT-07 end to end for Buyer and Vendor using the shared daily snapshot service and source observations. Enable the Explore navigation entry only now. Build categorized lists, canonical Material Price Details, an exact-date graph and table, current offers for Buyers and own-price versus suppressed competitor averages for Owner and Manager. Trust-score inputs stay separate.

- 14-day review window, double-blind reveal, 24-hour edit, dispute withholding, moderation.
- MQS and VCS 90-day windows, OHS 30-day window, sample gates and daily VPS calculation.
- CRR, FRR and NFR event definitions from verified source events.
- Exact badge triggers and automatic removal; Admin suppression only for documented fraud or compliance findings.
- MAT-01 to MAT-07 public listed-price observations only, 7/30/90-day and bounded custom ranges; completed-sale and quotation prices remain separate private records.

## UI/UX and layout architecture

Materials Analytics navigation is enabled only when the feature is installed; no dead entry point ships. The price graph always has a synchronized sortable table with exact focused values, gap indicators and a participant-change flag. Insufficient data renders an explicit null state with the reason, never an empty chart or a fabricated line. Suppressed competitor data shows the suppression reason with no exact small count and no store or offer identifier. Below the minimum sample a Vendor shows "New Vendor — Building Track Record." Badge state is text plus icon.

## Acceptance gate

Pass every MAT-07 fixture and inspect the actual JSON for competitor identity leakage. Test duplicates, unit and specification mismatches, equal weighting, tax-inclusive amounts, exact endpoints, missing data, changed participants, daily job replay, revoked roles and cached response isolation. Cancelled, test, duplicate, fraudulent or otherwise ineligible activity cannot affect scores.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 14: verified-purchase reviews, moderation, MQS, VCS, OHS, VPS and operational metrics, automatic badges, and local price-trend insights. Surfaces are apps/buyer-mobile, apps/vendor-web, apps/admin-web, services/api and packages/api-contract.

Implement MAT-01 to MAT-07 exactly, replacing any older mixed listing and completed-sale insight logic. Capture eligible public ordinary prices daily at 00:10 Asia/Manila into immutable published runs, retain the actual time and geography and never fabricate a missed day. Deduplicate one Vendor per group by latest published ordinary-price effective timestamp then stable variant identifier, and average equally without inventory weighting. Buyer Explore to Materials Analytics to Material Price Details to current Vendor Product Details must be fully functional and accessible. Provide 7, 30 and 90-day and up to 365-day custom ranges, PHP per unit, current versus historical timestamps, graph gaps and table, counts, null insufficient-data states and ((end-start)/start)*100 from unrounded means. A one-seller Buyer average is limited data and a trend needs two sellers at each exact endpoint. Vendor Owner and Manager requests exclude the own organization and suppress every competitor point, variant and endpoint below three distinct competitors, with no exact small count and no individual store or offer identifiers. Use separate backend serializers, policies and cache keys; no Vendor token can request Buyer offer output. An own listing edit is an explicit normal authorized edit. Seed clearly labelled isolated DEMO history and test the 100/110/120 to 110 and 100 to 110 equals plus 10 percent fixtures plus all MAT-07 cases. Add no market-data API, forecast, automatic price change or private quote source.

Use the exact windows, minimum samples, formulas, exclusions and badge thresholds in the System Workflow. Implement a 14-calendar-day rating window, hidden-until-both-or-expiry publication, a 24-hour edit lock, dispute withholding, immutable moderation history and product and vendor rating separation. Never permit a Vendor to delete a Buyer review.

Generate metric events from authoritative order, fulfillment and dispute facts and calculate daily snapshots. Display New Vendor — Building Track Record below the minimum samples. Automatically award and remove performance badges; an Admin may suppress for a documented fraud or compliance case but may never manually award one.

Build the price graph with a synchronized sortable table, exact focused values, gap indicators and a participant-change flag, an explicit null state carrying its reason instead of an empty chart, and a suppression state showing the reason with no small count or identifier. Enable Materials Analytics navigation only now.

Update Buyer, Vendor and Admin UI, OpenAPI, jobs, audit events and deterministic fake-clock tests for every threshold and window edge. Do not deploy or commit.
```

---

# Phase 15 — Notifications, Reminders, PDFs and Exports

**Surfaces:** Buyer, Vendor, Admin, API.

## Outcome

Users receive reliable in-app, push and email notices. The system produces authorized Purchase Orders, confirmations, budget reports, summaries and operational exports.

## Required implementation

**FIN/MAT integration.** Add FIN-08 and FIN-09 sample invoice, certificate and return support packages, monthly statement PDFs and legal-date reminders. Reconcile issuer, payee, month, quarter and ATC and include required zero and exempt payee rows. Export MAT aggregates under the same audience restrictions; a Vendor export can never contain individual competitors or suppressed samples.

- Notification templates, preferences, mandatory classes, device tokens, delivery attempts, deep links and retry rules.
- FCM for Buyer push and Web Push where supported.
- Email provider adapter; Mailpit locally.
- Scheduled deadline and reminder jobs, including FIN-04A threshold advisory and breach notices.
- Purchase Order, payment confirmation, procurement summary, budget PDF/CSV and internal operational reports.
- Private export storage, expiry, access logs and data minimization.

## UI/UX and layout architecture

Notification preferences separate optional from mandatory classes and render mandatory ones as explained, not merely disabled. Deep links resolve only after fresh authentication and authorization, landing on the resource or on a clear permission message — never a blank screen. Generated documents show their generation time, the source version and a visible label when they are not tax invoices. Export screens show filters, purpose, expiry and an access record.

## API/key step

Configure Firebase Development credentials and non-local email credentials from the environment guide. The Firebase service account stays on the backend only.

## Acceptance gate

Only `DRAFT`, `REVIEWED`, `EXPORTED` and `SIMULATED_SUBMISSION_RECORDED` are possible for demo tax reporting. Missing legal-date review blocks review readiness. Export alone cannot mark `FILED` or `BIR_PAID`; a spoofed issuer and same-user approval fail. A notification-provider failure never rolls back a committed order. Deep links recheck authorization. Mandatory notices cannot be disabled.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 15: authoritative in-app notifications, FCM Buyer push, web push where approved, email delivery, mandatory reminders, PDFs, CSV exports and authorized deep links. Surfaces are apps/buyer-mobile, apps/vendor-web, apps/admin-web, services/api and packages/api-contract.

Implement tax packages for 2307, 0619-E support, 1601-EQ and QAP, and annual 1604-E and alphalist using FIN-08 effective ATCs WI820 and WC820 versus WI830 and WC830, calendar-quarter grouping and the versioned non-eFPS demo deadline calendar. Keep taxable-year threshold counters separate from the filing calendar. Watermark every sample artifact, store export hashes and exact source versions, and require an independent reviewer. Unknown or overridden due dates show DUE_DATE_REVIEW_REQUIRED with source and reviewer. Distinguish external Vendor goods invoices, platform fee invoices and processor documents; a PDF upload alone is not compliant structured e-invoicing. No live BIR API submission or fabricated government receipt. Apply MAT suppression and scope to authorized exports, neutralize spreadsheet-formula injection and revoke access when permissions change.

Store the notification before dispatching channels. Queue every external delivery, record attempts, use bounded retries and expose failed operational jobs without rolling back the original business transaction. Implement user preferences, but never allow security, legal, suspension, payment, refund, dispute or FIN-04A threshold notices to be disabled, and render mandatory classes as explained rather than merely disabled. No SMS.

Use Firebase service credentials only in the Laravel backend and environment-specific public configuration in clients. Register and revoke device tokens securely and request notification permission contextually. Deep links resolve only after fresh authentication and authorization, landing on the resource or a clear permission message.

Generate immutable-snapshot Purchase Orders, payment confirmations, project procurement summaries, budget reports and permitted operational exports showing generation time and source version. Clearly mark MateryalPH documents that are not tax invoices. Store exports privately with expiry, checksum, actor, filters, purpose and an access audit.

Implement fake providers for tests. Update OpenAPI, clients, templates, accessibility and tests for retry, duplicate, disabled optional channel, mandatory channel, revoked device, unauthorized deep link and expired export. Do not deploy or commit.
```

---

# Phase 16 — Admin Operations and Philippine Geographic Analytics

**Surfaces:** Admin, Vendor, API. Buyer unchanged.

## Outcome

Authorized Admin roles operate all review queues and see privacy-controlled supply, demand, GMV, performance and active-user trends on a drillable Philippines map and synchronized table.

## Required implementation

**FIN/MAT integration.** Embed Materials Analytics in the Philippine Geographic Marketplace Analytics section with nationwide and PSGC scope, compatible category and date filters, limited-sample labels and separately authorized source inspection. Add FIN tax, fee, evidence, adjustment, statement and package queues and independent review controls to Admin and the existing Vendor finance pages, including the FIN-04A threshold-review and overlap queues.

- Vendor verification, product compliance, dispute and appeal, review moderation, user enforcement, invoice, privacy, job health and refund-monitoring queues.
- Non-secret Platform Settings with versioning and validation.
- Searchable append-only audit log and access logging.
- PSGC map: Philippines → Region → Province or independent/highly urbanized city → City or municipality.
- Global geography, date, procurement, category, fulfillment, payment and state filters.
- Gross and net GMV, order volume, fulfillment, cancellation and dispute rates, response distribution, demand heatmap, Buyer and Vendor DAU/WAU/MAU.
- Small-cell suppression, unresolved geography, an accessible table and export controls.

## UI/UX and layout architecture

Queues share one layout: filter bar, dense table with sticky header, row detail in the Phase 3E two-pane pattern, and decisions requiring a reason. The analytics dashboard puts the map and the synchronized sortable table side by side at ≥1280px and stacked below, with geography filtering the whole dashboard, keyboard-selectable regions, breadcrumbs, a legend, exact focused values and non-color meaning. Suppressed cells state the suppression reason. Exact Buyer coordinates never render. Platform Settings show the current version, the validation rule and the previous value for every field.

## Acceptance gate

Admin aggregate access cannot inspect source listings without the separate permission; finance is separately authorized. Payment and order filters do not change listed-price observations. Source and export reviews are attributable and test data never mixes with live figures. Aggregate permission never exposes exact Buyer coordinates. Auto-accept and app opens alone do not count as human Vendor activity.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 16: all Admin operational queues, non-secret Platform Settings, append-only audit search, integration and job health, and the privacy-controlled Philippine geographic analytics dashboard. Surfaces are apps/admin-web, apps/vendor-web, services/api and packages/api-contract.

Implement MAT Admin lists, details and charts inside the existing geographic section, with source inspection only for materials_analytics.inspect_sources and a recorded reason. Nation, region, province, city and municipality filters use PSGC; do not impose a national 50 km circle. Mark transaction-only filters inapplicable to price panels. Add FIN-10 queues and scoped screens for evidence, remittance reconciliation, fee approval and payment status, overdue debt, tax adjustments, sample report readiness and the FIN-04A threshold-review and unresolved-overlap queues. Use two distinct named finance users for required preparation and review. Display gross and net GMV independently from CWT, commissions, platform revenue, collected cash and receivables. Add materials snapshot health and labelled demo datasets. No Admin rate or edit control may bypass source or effective-date review or the LIVE gates.

Read the Admin Workflow closely. Implement role-specific queues for Vendor documents and activation, product compliance, disputes, appeals and remedies, Buyer and Vendor enforcement, review moderation, invoices, privacy requests, payment and refund monitoring, and failed jobs. Every decision requires the documented authorization, reason, before and after state, actor, correlation identifier and notification. Never expose integration secrets, balances, withdrawal controls or audit-edit actions.

Implement versioned Platform Settings for only the approved non-secret defaults with validation, including SRS and FMS totals, showing the current version, the validation rule and the previous value per field. Do not add an NRPC cap or editable VPS weights.

Build daily aggregate facts and a drillable PSGC-aware map and table: Philippines to Region to Province or independent or highly urbanized city to City or Municipality, side by side at 1280px and above and stacked below. Geography filters the whole dashboard. Add Buyer and Vendor counts, gross and net GMV and order volume trends, fulfillment, cancellation and dispute rates, mean, median and p90 response time, category and material demand, and meaningful Buyer and Vendor DAU, WAU and MAU exactly as defined. Apply configured small-cell suppression and generalization with the reason shown, separate unresolved geography, and never expose exact Buyer coordinates through aggregate permission.

Implement accessible keyboard selection, breadcrumbs, legend, exact focused values, non-color meaning, a synchronized sortable table and authorized exports. Update OpenAPI, queries and materialized aggregates, jobs, tests and performance indexes. Do not deploy or commit.
```

---

# Phase 17 — Security, Privacy, Accessibility and Performance Hardening

**Surfaces:** all.

## Outcome

The complete feature system is hardened against common abuse, privacy leaks, authorization failure, inaccessible interaction, dependency risk and predictable load.

## Required implementation

**FIN/MAT integration.** Harden finance evidence and ledger export and market responses against cross-organization access, role spoofing, cache leakage, arbitrary grouping, scraping amplification, SQL injection and sensitive logging. Check responsive Explore cards and graph and table keyboard, screen reader, contrast, touch and reduced-motion behavior. Confirm that TIN, declaration evidence and threshold counters never leave an authorized audience.

- Threat model and data-flow review.
- Secure headers and CSP, CORS and CSRF, cookie flags, mobile certificate and network configuration, rate-limit tuning and account-abuse defenses.
- Secret scan, dependency scan, SAST, container scan, upload-malware gate and log-redaction tests.
- Privacy-request workflow, retention classes, legal hold, minimization, export authorization and deletion or anonymization jobs subject to approved policy.
- WCAG 2.2 AA audit for all pages.
- Database and query profiling, indexes, caching rules, N+1 elimination, pagination and provider quotas.
- Sentry or equivalent error monitoring with personal-data filtering.

## UI/UX and layout architecture

This phase changes behavior, not visual direction. Every fix must preserve the established layout architecture. Accessibility remediation is applied at the shared-component level in `packages/web-ui` and the Flutter design system so a fix lands everywhere at once. Record each finding with the surface, the WCAG criterion, the fix location and the regression test.

## API/key step

If risk-based reCAPTCHA and Sentry are approved, create separate Development and Staging projects and enter only their environment-specific values.

## Acceptance gate

Raw payloads, logs and exports never contain unauthorized competitor identity, exact stock, TIN or tax evidence. Server checks survive a hidden-button bypass. No binary-float money drift and no unbounded date or radius query is accepted. Critical and high security findings are fixed or formally blocked from release. No accessibility blocker exists on a critical journey.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement and verify MateryalPH Phase 17: security, privacy, accessibility, observability and performance hardening across Laravel, both React portals, Flutter, containers, CI and deployment configuration.

Add threat-focused tests for FIN-10, FIN-04A and MAT-05 with authenticated audience, organization and permission isolation, rejected role and filter overrides and revoked cached downloads. Exercise exact origin and radius validation, bounded 365-day queries, run publication and count invalidation. Measure seeded query plans with Technical Design section 14 fixtures and report actual hardware and timings. Preserve the stated limitation that public Buyer listings can reveal stores, without claiming complete anonymization. Audit all financial and analytics UI states and exports for accessibility and for secret, TIN, declaration-evidence or threshold-counter leakage.

Begin with a concrete threat model and data-flow review for authentication, authorization, documents, locations, conversations, inventory, checkout, Xendit, refunds, disputes, Admin exports and analytics. Test deny-by-default policies and cross-tenant isolation. Harden cookies, CSRF, CORS, CSP and headers, rate limits, account-enumeration defenses, session rotation and reuse detection, webhook replay protection, file validation and malware state, signed URLs and log redaction. Add secret, dependency, SAST and container scans.

Implement the approved privacy-request states, retention classes, legal holds, minimization, authorized exports and auditable deletion or anonymization actions without deleting records that must legally or operationally remain. Do not invent legal retention periods; expose them as reviewed policy configuration with safe defaults marked non-production until approved.

Audit every critical page against WCAG 2.2 AA: labels, errors, keyboard and focus, screen-reader semantics, contrast, reflow, target size, timers, map alternative and non-color statuses. Apply remediation at the shared-component level in packages/web-ui and the Flutter design system rather than page by page, and record each finding with its surface, WCAG criterion, fix location and regression test. Use Flutter semantics, widget and golden tests, device testing and native accessibility inspection for Buyer; do not claim a web detector proves native Flutter accessibility.

Profile API and database queries, add justified indexes and caches, remove N+1 queries, verify pagination and protect provider quotas. Configure error monitoring only through environment values and filter personal and payment data.

Produce docs/security/threat-model.md and a traceable findings report. Fix critical and high issues and add regression tests. Do not deploy or commit.
```

---

# Phase 18 — End-to-End Testing, UAT, Failure Simulation and Recovery

**Surfaces:** all.

## Outcome

The complete system is proven through repeatable automated and manual scenarios, including concurrency, outages, duplicates, reconciliation, backups and role boundaries.

## Required implementation

**FIN/MAT integration.** Run a complete capstone scenario across Buyer, Vendor Owner and Manager, denied staff and two named Admin reviewers, including FIN-06, FIN-04A, FIN-12 and MAT-07, with real Xendit TEST evidence where supported and clearly distinct simulated deductions and history.

- Cross-client end-to-end suite for Buyer, Vendor roles and Admin roles.
- A seeded deterministic Development/UAT dataset labelled as test.
- Xendit test scenarios, Google/FCM/email/storage failure adapters, a fake clock and duplicate webhook replay.
- Inventory concurrency and load tests.
- UAT scripts for Item-Based, Project-Based, Order-from-Chat, NRPC, cancellation, dispute and refund paths, plus the full Phase 3 onboarding journey.
- Backup, restore, rollback, migration and failed-job replay drills.
- A requirements traceability matrix from workflow rule to test ID.

## UI/UX and layout architecture

UAT scripts must include the accessibility and responsive passes as numbered steps, not as an appendix: keyboard-only completion of each critical journey, screen-reader announcement of state changes, 2× text scaling on Buyer, and the eight-width browser sweep on both portals. Record evidence per script step.

## Acceptance gate

Record actual test results, screenshots and expected-versus-actual centavo values. Demonstrate three-competitor visibility and two-competitor suppression, then cancellation and dispute finance separation and a blocked LIVE gate. No document-only validation is reported as implemented success. All critical journeys pass, no unresolved Severity 1 or 2 defect remains, and restore and rollback are demonstrated rather than assumed.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Implement MateryalPH Phase 18: complete automated end-to-end coverage, deterministic UAT data and scripts, provider failure simulation, concurrency and load checks, backup and restore validation, and requirements-to-test traceability.

Create a reproducible demo and UAT script: Vendor onboarding from welcome through Store Verification submission, Admin correction, approval and activation, then Explore counts, categorized material and variant averages, exact-date graph, Buyer named Vendor offers, Owner and Manager aggregate-only competitor comparisons, denied staff and Admin geography and source permission. Then run VAT and non-VAT, valid and missing declaration, FIN-04A threshold crossing under concurrency including the exactly-at-limit and 500000.01 cases, physical cash, mixed NRPC, completion and monthly fee payment, Vendor cancellation and partial dispute refund, report review and export, and the disabled live gate. Use separate isolated financial and market fixtures so no synthetic history or tax certificate is represented as actual market data or BIR evidence. Replay duplicate and out-of-order events and failed daily capture and refund funding, and capture real results and unresolved provider capability separately.

Build tests for the complete Buyer, each Vendor role and each Admin role. Cover email and Google auth, TOTP, onboarding and activation, listings and compliance, inventory, map discovery, Item-Based checkout, auto-accept, NRPC manual review, messaging, quotation versions and counter-offers, Project Work Packages, Xendit Test Mode, fulfillment, allowed and blocked cancellation, automatic Cancellation Refund, disputes, Dispute-Conclusion Refund, reviews and scores, notifications, analytics privacy and exports.

Include accessibility and responsive passes as numbered UAT steps: keyboard-only completion of each critical journey, screen-reader announcement of state changes, 2x text scaling on Buyer, and the eight-width browser sweep on both portals, with evidence recorded per step.

Use fake clocks and deterministic providers where possible and Xendit Test Mode error simulation for integration tests. Replay duplicate and reordered webhooks, timeouts, queue crashes, email, push, storage and Google failures, expired payments, stale quotations, concurrent stock acceptance and captured-payment-with-application-failure reconciliation. Confirm no overselling and no duplicate charges or refunds.

Create docs/test-plans/uat.md, recovery-drill.md, release-smoke-test.md and requirements-traceability-matrix.md. Seed only obvious test users and data and add a production guard that refuses test seeders. Run the entire CI-equivalent suite and report failures by severity. Do not deploy or commit.
```

---

# Phase 19 — CI/CD and Staging Deployment

**Surfaces:** all, plus infrastructure.

## Outcome

GitHub Actions validates every change and a fully isolated Staging environment runs on Render in Singapore with managed PostgreSQL, a Redis-compatible key-value store, API, worker, scheduler, Reverb and two static sites. The Buyer app produces a signed internal-test build without committing signing secrets.

## Required implementation

**FIN/MAT integration.** Deploy to an explicitly TEST/DEMO environment with the finance and analytics schemas, scheduler and worker, dataset-separated cache, queues and storage, and known-good demo fixtures. Register the monthly billing job at 00:05, daily prices at 00:10, the FIN-04A year-rollover job and bounded reconciliation jobs. New finance and analytics settings contain no secrets.

- Path-aware GitHub Actions for Laravel, React, Flutter, contract, security and container jobs.
- Protected `staging` and `production` GitHub environments.
- `render.yaml` defining Staging resources with `sync: false` or secret references.
- Docker production image, health checks, non-root runtime, immutable build and graceful shutdown.
- Pre-deploy migration and safe post-deploy smoke tests.
- Staging domains, CORS, cookies, OIDC callbacks, Google restrictions, Xendit webhooks, FCM, storage, email and error monitoring.
- Flutter internal Android and iOS build procedure; store release stays in Phase 20.

## UI/UX and layout architecture

Every non-production environment renders a persistent environment band in all three clients showing the environment name and the payment mode, using text plus icon and never color alone, positioned so it never overlaps a focused control or a mobile safe area. Simulated finance and analytics figures carry a DEMO label at the point of display, not only in a footnote. The band is part of the shared shell so it cannot be forgotten on a new page.

## API/key step

Enter Staging secrets directly into the GitHub, Render, Firebase, Google and Xendit dashboards. Never paste a secret into a prompt. Xendit Test Mode only.

## Acceptance gate

After deployment, verify one published daily run, snapshot failure visibility, a demo statement draft, API audience restrictions, sample export access, payment-mode labels and one FIN-04A threshold event visible in the finance queue. The environment cannot activate LIVE from a flag alone. Staging deploys only after CI passes. Migration, health, worker, scheduler, Reverb, payment webhook, private storage and critical smoke tests succeed. A rollback is rehearsed.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Prepare MateryalPH Phase 19: production-grade CI/CD configuration and the isolated Staging deployment on Render Singapore. Do not perform an external deployment until I explicitly authorize it after reviewing the diff and the required secret checklist.

Extend CI/CD and staging runbooks for the Finance and Analytics additive migrations, schema and contract checks, worker queues, shared scheduler locks and database uniqueness. Register the monthly billing job at 00:05, daily price capture at 00:10, the FIN-04A taxable-year rollover job and bounded reconciliation jobs. Use finance dry-run or tested command equivalents for job verification without fake provider success, and implement or document any command before invoking it. Keep new configuration backend-only, preserve quarterly secret rotation and separate environments, and do not request a BIR key. Smoke-test count, list and graph, Owner and Manager suppression, Admin source permission, ledger reconciliation, one threshold event and failed-job alerts before accepting staging.

Create path-aware GitHub Actions for Laravel formatting, static analysis and tests with PostgreSQL, PostGIS and Redis, both React lint, test and build jobs, Flutter analyze, test and build checks, OpenAPI validation and client drift, a secret scan, a dependency audit and a container scan. Use least-privilege workflow permissions and protected staging and production environments.

Create a root render.yaml for isolated Staging services: Laravel API Docker web service, queue worker, Reverb web service, scheduler cron, PostgreSQL 16, managed Redis-compatible key value, Vendor static site and Admin static site. Use the Singapore region for stateful and backend resources. Reference secrets without values. Add health checks, pre-deploy migrations, a non-root image, optimized Laravel caches, graceful shutdown and safe worker retry settings.

Document the exact dashboard-only steps for entering Staging secrets, Google callback and host restrictions, the Xendit Test Mode webhook URL and token, Firebase, email, private storage and error monitoring. Add post-deploy smoke checks and rollback commands. Add internal Flutter build instructions with ignored signing files and protected CI secrets.

Validate YAML, Docker and builds locally where possible. Stop before external creation or deployment and present the required approvals, costs to verify, the secret checklist and the acceptance steps. Do not commit or push.
```

---

# Phase 20 — Capstone Demonstration Release

**Surfaces:** all.

## Outcome

The approved deliverable is a controlled capstone demonstration release in TEST/DEMO, completed after the measured acceptance gates pass. The real-commerce readiness material below is a future conditional checklist; this phase authorizes no live deployment, no production key collection and no official filing.

## Required implementation

**FIN/MAT integration.** Complete the capstone release using existing TEST credentials and watermarked simulated finance and market fixtures. Record future LIVE prerequisites without blocking the academic delivery and without treating demo evidence as production approval.

- A formal go/no-go checklist with named approval owners.
- Verify TEST payment and refund capabilities and clearly simulated withholding, including a FIN-04A threshold demonstration labelled SIMULATED; record future Xendit LIVE contract, responsibility and funding prerequisites as unresolved where appropriate.
- Verify demo Google project and key restrictions, quotas, domains, app identifiers and OAuth configuration; keep future production credentials separate.
- Verify the demo database and backups, storage lifecycle, email, FCM, monitoring, alerts and a named support owner.
- Migration rehearsal, deployment, smoke tests, rollback trigger, status communication and incident response.
- Signed demonstration builds for the agreed distribution method; public app-store submission requires a separate explicit instruction.
- A 90-day secret rotation calendar and a first rotation owner.

## UI/UX and layout architecture

The release audit includes a visual pass: the environment and DEMO labels are present on every finance, tax and analytics surface; no screen claims real money movement, a filed return or a live payment; the accessibility findings from Phase 17 have no open blocker on a critical journey; and the demo script's screenshots come from the released build, not from development fixtures.

## Acceptance gate

Demo UAT, security, accessibility, restore and deployment gates pass with actual evidence. Xendit and finance remain TEST/DEMO; unconfirmed registration, withholder or funding prevents real commerce. No real BIR filing, test-to-live promotion or live credential request is part of this release. No capstone release occurs with unresolved critical or high findings, exposed secrets, default credentials, unverified TEST refund behavior, misleading real-money claims or untested restore or rollback.

## Copy-paste prompt

```text
Apply §0 Standing Contract from docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md and AGENTS.md. Do not restate them back to me.

Prepare the MateryalPH Phase 20 capstone demonstration release from accepted Staging. Complete the TEST/DEMO release path only.

Start with a readiness audit and a concrete release and rollback package. Audit FIN-12 and MAT-07 evidence, scheduled snapshots, reviewed sample finance packages, the FIN-04A threshold demonstration labelled SIMULATED, permission tests, restore and rollback and visible environment labels. Keep LIVE_COMMERCE_ENABLED false and record unresolved authentic registration, last-facility assignment, fee and tax classification, invoice and refund-funding requirements as future deployment gates. Do not ask for production keys and do not claim a simulated certificate or return is filed.

Keep payment, finance and material fixtures TEST/DEMO and real-commerce activation disabled. Do not create LIVE infrastructure, enter or rotate live keys, submit to app stores or change DNS. For any external deployment not already authorized in the active session, complete the reviewable package before requesting final deployment approval.

For a future separately authorized LIVE release only, audit all workflow requirements, Phase 18 results, Staging evidence, security, privacy and accessibility findings, dependency status, backup and restore proof, rollback proof, monitoring, support ownership and incident runbooks. Verify written confirmation of Xendit live account approval, sub-account capabilities, enabled payment and refund channels, processing-fee treatment and webhook configuration. Verify legal, tax and privacy approval for Terms, NRPC, cancellation and refund disclosures, invoice wording, retention and processor arrangements. Generate a Production environment checklist with new non-reused credentials, least privileges, restricted Google keys, protected GitHub and Render secrets, debug off, test seeders blocked, backups enabled, alerts tested, exact domains, TLS, CORS, cookies and OIDC callbacks, and a 90-day rotation register, plus the migration, release, smoke and rollback sequence with decision points and responsible owner placeholders.

For an authorized capstone deployment, execute the reviewed TEST/DEMO release steps, report each result, stop on any failed gate, never print secrets and never mark payment or refund successful from a browser redirect. Finish with release evidence, known limitations, the operations handoff and the next rotation date. Do not commit or push unless asked.
```

---

## Git checkpoints

One reviewed commit after each accepted phase or sub-phase. Branches: `phase/03a-onboarding-domain`, `phase/03b-business-information`, `phase/03c-address-classification-submit`, `phase/03d-store-setup`, `phase/03e-admin-verification`, `phase/03f-activation-team`, then `phase/04-catalog` onward.

```text
feat(onboarding): add vendor onboarding domain and activation gate
feat(onboarding): implement business information verification step
feat(onboarding): implement address classification and submission
feat(onboarding): implement store setup configuration
feat(admin): implement vendor verification review and decisions
feat(onboarding): implement activation gate limited dashboard and team accounts
```

Protect `main`. Do not squash away migration or security history until the team has reviewed it.

## Completion principle

A phase is not complete because its screens appear. It is complete when its backend rules, database constraints, permissions, error paths, external-provider behavior, audit records, accessibility states, OpenAPI contract, automated tests and manual acceptance checks all agree with the approved workflows — and the test output proving it is in the report.
