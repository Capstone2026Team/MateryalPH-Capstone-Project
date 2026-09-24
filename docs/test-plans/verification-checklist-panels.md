# Verification checklist panels — validation

The shared web checklist presents Business information, two applicable Government ID groups, Sworn Declaration, BIR COR, business registration and LGU permit evidence. Front/back remain distinct immutable evidence records and Admin decisions within one displayed ID item. Business information retains section navigation and Authority to Act. Non-applicable items and optional certification are omitted from the checklist. Aggregate status and progress use all applicable underlying requirements.

Store Setup, the limited dashboard and the Admin review case use the shared panel. Private saved/submitted files are fetched from the configured API with the portal cookie context and shown in a modal preview; the backend still authorizes every stream. No migration, API contract change, credential change or new setup is required.

## Checks run

- Vendor: npm run lint, npm run typecheck, npm run build — passed.
- Vendor: npm run test -- --run — 118 tests in 14 files passed.
- Admin: npm run lint, npm run typecheck, npm run build — passed.
- Admin: npm run test -- --run — 16 tests in 8 files passed.
- Vendor Playwright: npm run test:e2e -- e2e/checklist-panels.spec.ts e2e/phase-3c.spec.ts --project=chromium-1440 --project=chromium-320 --reporter=list — 12 passed.
- git diff --check — passed.
- Gitleaks stdin over the changed implementation and focused test files — no leaks found. The staged scan also found no leaks but had zero staged bytes.

Browser checks cover grouped rows and progress, responsive layout, setup/dashboard consistency, Vendor and Admin evidence preview, retained portal request origin, object-URL release, per-side Admin decisions, manual address fallback and submission. Transport unit checks cover credential inclusion, untrusted URL rejection, unsupported content, denied access and session refresh. Grouping tests cover correction propagation, authority gates, optional/non-applicable omission, passport identity pages and stable ordering.

Synthetic screenshots: ../design/evidence/checklist-panels/. Desktop verification and Admin panels and mobile verification were visually inspected.

## Limits

Browser requests use synthetic fixtures. Live private storage, login-cookie authorization, real submitted documents, Google Maps and other provider services were not exercised. Backend and mobile suites were not rerun for these web presentation/transport changes.
