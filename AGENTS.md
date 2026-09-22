# MateryalPH — Agent Rules

Product context: `PRODUCT.md`. Visual language: `DESIGN.md`. Read both once per task; this file does not repeat them.

Authority, descending: `docs/workflows/` (System, Buyer, Vendor, Admin) → `docs/architecture/MateryalPH_Technical_System_Design.md` → `docs/design/MateryalPH_UI_UX_Implementation_Planner.md` → Figma (visual only). Never invent or silently change a role, status, timer, formula, threshold, payment/refund rule, map tier or excluded feature. Correct obsolete prototype content; never reintroduce it.

## Method

Read the relevant workflow, design, migrations, OpenAPI paths and tests before editing. Complex task → post a short plan and the affected domains first. Ask only when a material requirement is genuinely undefined or contradictory. Ship the smallest complete vertical slice: migration → domain rule → authorization → OpenAPI → affected clients → audit/notification → tests. Run the checks and review the diff before reporting. Never deploy, push, merge, rotate credentials or perform destructive DB/Git actions unless asked.

## Layout

`apps/buyer-mobile` Flutter · `apps/vendor-web` React · `apps/admin-web` React · `services/api` Laravel monolith · `packages/api-contract` OpenAPI + generated clients · `packages/design-tokens` · `packages/web-ui` · `docs/{workflows,architecture,design,security,test-plans}`

## Architecture

Every client calls `/api/v1`; none touches PostgreSQL, Redis, private storage or a provider API directly. One modular monolith, no microservices. Rules live in domain actions/services; a controller validates transport → authorizes → invokes one use case → returns an API Resource; models never call providers; external systems sit behind interfaces with replaceable adapters. Critical multi-record changes use one PostgreSQL transaction; noncritical side effects use a post-commit outbox event. Never hold a DB lock across a network call.

## Fixed stack

Laravel `^13.0`, PHP 8.4, Composer 2 · PostgreSQL 16 + PostGIS/`pg_trgm`/`pgcrypto` · Redis-compatible cache/queues + Horizon · Passport · Reverb · React 19 + strict TS + Vite 8 + Tailwind on semantic tokens · Flutter/Dart · OpenAPI 3.1 with generated TS+Dart clients · Docker Compose · GitHub Actions + Render. Changing any of these needs an approved ADR and user confirmation. Laravel minor/patch only after full test and security gates pass; major needs a new ADR.

## Security

`.gitignore` exists before any `.env` or credential file. Never commit, print, log, return, snapshot or seed a secret — `.env`, keys, service-account JSON, certificates, keystores, tokens, OTPs, provider payloads. `.env.example` holds names and safe defaults only. Real credentials go only in ignored env files or cloud secret fields; never ask for one in chat. Development/Staging/Production credentials stay separate and non-reused; caller-generated secrets ≥32 random chars. No backend secret in a `VITE_` variable or Flutter config. Argon2id passwords; OTPs and recovery codes stored only as keyed/adaptive hashes. Web tokens: `Secure`+`HttpOnly` cookies with CSRF, never `localStorage`; mobile tokens: OS secure storage. Deny-by-default authorization on every protected request. Validate Xendit webhooks for provider ID, amount, currency, reference, state and replay uniqueness. Private object storage, content validation, fail-closed malware scanning, authorized short-lived URLs. Logs redact credentials, tokens, OTPs, payment details and unnecessary personal data. Secret scan before accepting any phase.

## Data

UUIDv7 business IDs, opaque API IDs. Money as integer centavos, never binary float. `TIMESTAMPTZ` in UTC; deadlines render in Asia/Manila. Foreign keys, checks, unique constraints, purposeful indexes; PostGIS geography + GiST for location search. Published quotations, order snapshots, payment/refund events, compliance and dispute decisions, tax assessments and audit records are immutable — corrections create new versions or compensating events. Never cascade-delete commercial, financial, compliance, dispute or audit history. A migration must work from an empty database and on the current schema; never modify an applied migration, add a new one.

## Commerce invariants beyond PRODUCT.md

`available_to_sell = quantity_on_hand - hard_reserved_quantity`; `quantity_on_hand` drops only at fulfillment. Acceptance/reservation locks all affected rows in deterministic order and succeeds or fails for every line together. All five order-related state families move through one server-side transition service; `Idempotency-Key` on retry-sensitive mutations. Auto-accept is Item-Based only, off by default, unavailable with NRPC, governed by allotment plus independent unit and amount safeguards. Commission is 2%, Vendor-paid, billed monthly, earned on completed materials after discounts excluding materials VAT. Withholding is `W = money(G × 0.005)` half-up; the ₱500,000.00 relief threshold is cumulative per taxpayer per taxable year; cumulative ≥ ₱500,000.01 makes the crossing remittance and every later one subject regardless of any uploaded Sworn Declaration, and is sticky for that year (FIN-04/FIN-04A).

## Coding

PHP: strict types where practical, PSR-12, Pint, PHPStan/Larastan, typed DTOs, backed enums, Form Requests, Policies, API Resources, explicit transaction boundaries. TypeScript: strict, no unjustified `any`, ESLint + formatter, schema validation at boundaries, accessible semantic components, generated API client. Dart: sound null safety, immutable models, repository/service separation, centralized error mapping, secure-storage abstraction, `flutter analyze` clean. Name business concepts exactly as the workflows name them. Prefer clear code over premature abstraction. No commented-out production code, placeholder success responses, hidden bypasses or TODOs on a required acceptance path. Structured errors with a correlation ID; never expose stack traces.

## API contract

Update `packages/api-contract/openapi.yaml` whenever request/response behavior changes, then regenerate TS and Dart clients; never hand-edit generated files. Responses use `{ data, meta, errors }` with canonical statuses and stable error codes. Paginate every unbounded list. Use explicit resource/version fields for concurrency-sensitive updates. Add contract tests so implementation and OpenAPI cannot drift.

## UI beyond DESIGN.md

WCAG 2.2 AA; read the UI/UX planner before editing any client. Build a behavior once in `packages/web-ui` or the Flutter design system — a page-local duplicate is a defect. Targets ≥24×24 CSS px, 44×44 for product controls, except the documented dense-navigation exception. Every page handles loading, empty, validation, unauthorized, offline/provider failure, retry and success. A hidden or disabled control is never the authorization mechanism. Never expose private staff contacts, exact Vendor inventory, exact Buyer coordinates in analytics, or private documents. For a referenced Figma node, retrieve that node's context first and reuse hierarchy, spacing, assets and composition while adapting behavior to the workflows; never paste generated React/Tailwind into Flutter; never commit expiring Figma asset URLs.

## Testing and definition of done

Add the smallest sufficient combination of: unit tests for calculations and state rules; feature/API tests for validation, authorization, idempotency and failure paths; database tests for constraints and transactions; contract tests; component tests for interaction and accessibility; end-to-end tests for critical cross-client journeys; provider adapter tests using fakes or sandboxes.

```bash
cd services/api && vendor/bin/pint --test && vendor/bin/phpstan analyse --memory-limit=512M && php artisan test
cd apps/vendor-web && npm run lint && npm run typecheck && npm run test -- --run && npm run build
cd apps/admin-web && npm run lint && npm run typecheck && npm run test -- --run && npm run build
cd apps/buyer-mobile && flutter analyze && flutter test
cd packages/api-contract && npm run validate
docker compose config --quiet && gitleaks git --staged --redact --no-banner && git diff --check
```

If a command is unavailable, say why and give the exact command the user must run. Never claim a test passed unless it ran.

## Final report

Outcome · files and migrations changed · API contract changes · security/authorization decisions · tests and exact results · manual setup or key names still required · known limitations or blocked gates · suggested conventional commit. No secret values, no repeated commentary.
