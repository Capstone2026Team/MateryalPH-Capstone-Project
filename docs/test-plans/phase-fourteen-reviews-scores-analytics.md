# Phase 14 — Reviews, Scores, Badges and Materials Analytics: Test Plan

Scope: services/api, packages/api-contract, apps/vendor-web, apps/admin-web, apps/buyer-mobile. Owner decisions of 2026-10-04 are recorded in all four workflows.

## Automated suites

| Suite | File | Covers |
| --- | --- | --- |
| API feature | `services/api/tests/Feature/Api/PhaseFourteenAnalyticsTest.php` | MAT-07: 100/110/120 → 110 equal-Vendor mean regardless of duplicate listings; volume tiers excluded; 100 → 110 = +10.00 % and reverse −9.09 %; one-Vendor limited data without trend; two-Vendor Buyer trend; missing days stay gaps; exact endpoints (never nearest date); custom range ≤ 365 days, no future dates; Vendor own 80 vs competitors 100/110/120 → 110 and suppression at two competitors with no count; own-store exclusion; raw-JSON leakage check (names, ids, listings, exact means, min/max) and absence of protected finance; all six fixed roles at route, API, CSV export and serializer level (dispute flag and Manager delegation grant nothing); Buyer route refuses Vendor tokens; undocumented filters 422; Admin roles; cache isolation per organization, revoked role, publication invalidation; radius boundary (exactly 5 km in, 5.05 km out); specification separation; stale/zero-stock exclusion; capture retry returns the same revision; midnight-crossing restart; missed day never fabricated; immutable observations; reviewed correction revision; schedule-only edit leaves counts, scores and MAT unchanged; DEMO seed isolation and navigation; kill switch. |
| API feature | `services/api/tests/Feature/Api/PhaseFourteenReviewsScoresTest.php` | 14-day window (open at −1 s, closed at the instant), 24-hour edit lock edge, blind reveal on both submissions or expiry, dispute withholding and release, idempotent submission, role grants for Buyer ratings, no Vendor delete (405) and DB-level refusal, immutable revisions and moderation history, Request Correction 7-day edges, Remove final, Admin role matrix, MQS/VCS sample gates, 90-day window edge, OHS 10-order gate, NFR 10.00 % → 0.75, VPS rounding, OHS weekly carry-forward, idempotent daily replay, reversible exclusions, CRR exactly 12 h vs 12 h + 1 s, pending inquiries, system messages ignored, Fast Responder award/removal, suppression only (no award route), Store Performance roles, LSR/FRR projection from milestones. |
| API unit | `services/api/tests/Unit/PhaseFourteenRulesTest.php` | Every NFR/LSR/RR/ODR band edge, LVD bands, OHS clamp, VCS/VPS formulas, Most Ordered ties and 20-order minimum, trend formula/direction/null reasons, per-audience point status, review windows and display names, moderation transitions, Owner/Manager-only analytics and store scores. |
| Contract | `packages/api-contract/scripts/check-trust-contract.mjs` | 38 operations match Laravel routes, transports, CSRF, idempotency, signed photo links; no review delete or badge-award operation; Vendor analytics schemas carry no identities, offers or sub-three counts; no protected finance. |
| Vendor web | `apps/vendor-web/src/pages/TrustPages.test.tsx` | Role denial before any request, suppression without a count, own price separate, explicit null state, graph/table synchronization and sorting, keyboard focus on the graph, Edit My Listing link, Store Performance sample-gate state. |
| Admin web | `apps/admin-web/src/pages/TrustPages.test.tsx` | Moderation offers only server-allowed actions (no delete) and requires a reason; no award/score control; source inspection requires an audited reason. |
| Buyer Flutter | `apps/buyer-mobile/test/trust_test.dart` | Inherited radius, DEMO label, trends, limited data, No Current Offers, period change, null state, offline retry, gap-aware details with synchronized table, offer opens Product Details, graph null state, rating validation/preview/display-name choice, listing reviews and Report Review. |

## Manual / demonstration steps

1. `docker exec materyalph-api-1 php artisan materyalph:materials-analytics-demo` (development only) seeds the DEMO stores near Manila (`--latitude/--longitude` to move them) and selects the DEMO history; `--use-test` switches back to the TEST capture dataset.
2. Buyer: Explore → View Materials Analytics → a variant → Material Price Details → an offer → Product Details.
3. Vendor Owner/Manager whose store is within 50 km of the DEMO stores: Analytics → Materials Analytics.
4. Admin (Super Admin): Marketplace Analytics → Materials Analytics; Score & Badge Monitoring; Review Moderation.

Screenshots illustrate layout only, not live provider readiness.
