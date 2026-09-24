# Technical Design Delta — FIN-04A: Gross-Remittance Threshold Counter

**Status:** approved delta. Insert as §13.2 FIN-04A in `docs/architecture/MateryalPH_Technical_System_Design.md`, immediately after FIN-04 and before FIN-05. It refines FIN-04 and FIN-06; it does not replace them.
**Binds:** Phase 3B (declaration capture), Phase 11 (engine), Phase 14/16 (surfacing), Phase 18 (acceptance).

---

## 0. One-line rule

A Vendor's uploaded Sworn Declaration is a **claim**, never a permanent state. The ledger keeps an authoritative per-taxpayer, per-taxable-year counter of gross remittances `G_accumulated`. The instant `G_accumulated` would reach **₱500,000.01 (50,000,001 centavos)**, the taxpayer flips from relief to subject-to-withholding and stays there for the rest of that taxable year, regardless of any uploaded, approved or still-valid declaration document.

## 1. Requested behavior versus approved behavior

The enhancement request states the flip applies "on the very next transaction." The approved FIN-04/FIN-06 contract is **stricter and is authoritative**: the remittance that crosses the threshold is itself fully covered, not just the ones after it.

| Case | Requested reading | FIN-04A implemented behavior |
| --- | --- | --- |
| Prior `G=499,000.00`, next `G=2,000.00` | tax the *next* remittance after this one | `W = money(2,000.00 × 0.005) = ₱10.00` on this whole ₱2,000.00, not ₱5.00 on the ₱1,000.00 excess |
| Every later remittance that year | subject | subject |

Implementing the stricter rule automatically satisfies the requested rule. Do not implement the looser one: a group cannot be split to delay crossing, and the crossing remittance is never partially taxed.

## 2. Canonical status enum

`vendor_withholding_accumulators.withholding_status`:

| Value | Meaning | Aliases used in conversation |
| --- | --- | --- |
| `RELIEF_ACTIVE` | Reviewed, in-period declaration or other evidenced relief applies and cumulative ≤ ₱500,000.00 | EXEMPT |
| `SUBJECT_STANDARD` | No valid evidenced relief; standard `G × 0.005` applies | SUBJECT_TO_WITHHOLDING |
| `SUBJECT_THRESHOLD_BREACHED` | Relief existed but cumulative crossed the threshold this taxable year; sticky until year end | SUBJECT_TO_WITHHOLDING |
| `SUBJECT_PRIOR_YEAR` | Prior taxable year ended above threshold; carries into the new year until a new relief basis is reviewed | SUBJECT_TO_WITHHOLDING |
| `UNDER_REVIEW` | Unresolved outside-platform overlap, disputed evidence or a pending adjustment; treated as `SUBJECT_STANDARD` for assessment until resolved | — |

`RELIEF_ACTIVE` is the only non-withholding state. Never persist the literal strings `EXEMPT` or `SUBJECT_TO_WITHHOLDING`; map them at the presentation layer only.

## 3. Data model

Additive migration. No existing FIN table is rewritten.

**`vendor_withholding_accumulators`** — one row per `(environment, taxpayer_key, taxable_year)`.

| Column | Type | Rule |
| --- | --- | --- |
| `id` | uuid v7 | |
| `environment` | enum `DEMO`/`TEST`/`LIVE` | Dataset boundary; never mixed |
| `taxpayer_key` | string | Validated Vendor taxpayer identity, not a user ID |
| `organization_id` | uuid | FK, for scoping and display only |
| `taxable_year` | smallint | Calendar year, or the recorded fiscal-year label |
| `year_start_at`, `year_end_at` | timestamptz | Fiscal-year fixtures use their recorded boundary |
| `threshold_centavos` | bigint | Default `50000000`; versioned policy value, never a literal in code |
| `g_accumulated_centavos` | bigint | `>= 0`. On-platform assessable gross remittances posted this year |
| `g_external_declared_centavos` | bigint | `>= 0`. Vendor-declared outside-platform amount for the same year |
| `g_external_overlap_centavos` | bigint | `>= 0`. Part of the declared external total already represented locally |
| `g_effective_centavos` | bigint generated | `g_accumulated + g_external_declared − g_external_overlap`; the value compared to the threshold |
| `withholding_status` | enum | §2 |
| `status_reason_code` | string | e.g. `RELIEF_EVIDENCED`, `NO_DECLARATION`, `THRESHOLD_CROSSED`, `PRIOR_YEAR_BREACH`, `EXTERNAL_BREACH_REPORTED`, `OVERLAP_UNRESOLVED` |
| `crossed_at` | timestamptz null | Set once, never cleared inside the year |
| `crossing_assessment_id` | uuid null | The assessment that crossed it |
| `effective_declaration_id` | uuid null | The reviewed `tax_evidence` row relied on |
| `prior_year_total_centavos` | bigint null | Carried from the previous accumulator at rollover |
| `lock_version` | int | Optimistic guard for Admin edits |
| `created_at`, `updated_at` | timestamptz | |

Constraints: `UNIQUE (environment, taxpayer_key, taxable_year)` · all centavo columns `CHECK (>= 0)` · `CHECK (g_external_overlap_centavos <= g_external_declared_centavos)` · `CHECK (crossed_at IS NULL OR withholding_status LIKE 'SUBJECT%')` · index on `(environment, organization_id, taxable_year)`.

**`vendor_withholding_status_events`** — append-only. `accumulator_id`, `from_status`, `to_status`, `reason_code`, `g_before_centavos`, `g_after_centavos`, `assessment_id`, `actor_type` (`SYSTEM`/`ADMIN`/`VENDOR`), `actor_id`, `evidence_id`, `correlation_id`, `occurred_at`. Never updated, never deleted. Every flip writes exactly one row.

`remittance_assessments` gains `threshold_status_before`, `threshold_status_after`, `g_effective_before_centavos`, `g_effective_after_centavos`, `relief_basis_id`. These are snapshot columns; later corrections create adjustment records rather than rewriting them.

## 4. Evaluation algorithm

Called once per canonical remittance group, inside the FIN-06 step 5 assessment transaction.

```
assess(remittance_group):
  1. resolve environment, taxpayer_key, taxable_year from the remittance instant
  2. G = C - R - D_r - V_r - P                       # FIN-06 step 4, centavos
  3. BEGIN TRANSACTION
  4. acc = SELECT ... FROM vendor_withholding_accumulators
           WHERE environment=? AND taxpayer_key=? AND taxable_year=?
           FOR UPDATE                                 # serializes concurrent settlements
         ?? insert_and_lock_new_accumulator()
  5. g_before = acc.g_effective_centavos
     g_after  = g_before + G                          # the whole group, never split
  6. status_before = acc.withholding_status
     if status_before in (SUBJECT_STANDARD, SUBJECT_THRESHOLD_BREACHED,
                          SUBJECT_PRIOR_YEAR, UNDER_REVIEW):
         status_after = status_before                 # sticky; no document restores relief
     else if g_after > acc.threshold_centavos:         # > 50_000_000 == >= 50_000_001
         status_after = SUBJECT_THRESHOLD_BREACHED
         reason = THRESHOLD_CROSSED
     else if valid_reviewed_relief(acc, effective_evidence_version):
         status_after = RELIEF_ACTIVE
     else:
         status_after = SUBJECT_STANDARD
         reason = NO_DECLARATION
  7. W = (status_after == RELIEF_ACTIVE) ? 0
        : special_relief_rate_applies ? evidenced_treatment(G)
        : money_half_up(G * 0.005)
  8. persist assessment (unique on environment, taxpayer_key,
                         remittance_group_id, obligation_type)
     update acc: g_accumulated += G_on_platform_part,
                 withholding_status = status_after,
                 crossed_at ??= now() when newly SUBJECT_THRESHOLD_BREACHED,
                 crossing_assessment_id ??= assessment.id
     append vendor_withholding_status_events when status changed
     enqueue outbox events                             # no network call inside the lock
  9. COMMIT
 10. outbox worker: notify Vendor Owner + finance queue, refresh ledger projections
```

Rules the implementation must not soften:

- The comparison is on `g_effective_centavos`, so a declared outside-platform amount can breach the threshold even when local activity is small.
- A retry of the same `remittance_group_id` returns the original stored result and does not increment the counter.
- Never hold the row lock across a Xendit call, notification dispatch or PDF render.
- A refund, chargeback or downward correction lowers future assessable amounts but never lowers `g_accumulated` below a crossed threshold and never restores `RELIEF_ACTIVE` inside the year. It creates an `ADJUSTMENT_REQUIRED` case instead.
- An uploaded or newly approved Sworn Declaration after `crossed_at` is recorded, acknowledged in the UI, and has no effect on the current year's status.

## 5. Year rollover

A scheduled job, plus lazy creation on first assessment of the new year, creates the next accumulator:

- `g_accumulated = 0`, `crossed_at = null`, `prior_year_total_centavos = previous.g_effective_centavos`.
- If `prior_year_total_centavos > threshold_centavos`, the new year starts at `SUBJECT_PRIOR_YEAR`, not `RELIEF_ACTIVE`. January never grants an automatic fresh allowance.
- It leaves `SUBJECT_PRIOR_YEAR` only when a reviewer approves a new in-period relief basis for the new taxable year, which writes a status event with `actor_type=ADMIN` and the evidence reference.
- Annual relief declarations are due by the twentieth day of the first month of the taxable year; a declaration reviewed after that date records its own effective period and does not backdate assessments already posted.
- Fiscal-year fixtures roll on their recorded `year_end_at`, not on 1 January.

## 6. Surfacing

| Surface | Requirement |
| --- | --- |
| Vendor → Finance → Tax Profile | Current `taxable_year`, `g_effective` in ₱, remaining allowance (`threshold − g_effective`, floored at 0), status text + icon (never color alone), `crossed_at` date-time in Asia/Manila, declaration status, and plain-language text that crossing is final for the year |
| Vendor notification | Mandatory, non-disableable, on every status change to a `SUBJECT_*` value, plus an advisory notice at 80% of the threshold |
| Admin → Vendor Verification → Tax Profile panel | Same figures plus prior-year position, declaration year/receipt, outside-platform disclosure scope, overlap state, breach flag, reason code and the status-event history |
| Admin finance queue | `OVERLAP_UNRESOLVED` and `UNDER_REVIEW` accumulators as work items |
| Exports | Threshold columns included in the FIN-08 package; raw TIN is never exported, only the masked value and `taxpayer_key` |

The counter is private financial data. It never appears in Buyer surfaces, public analytics, Vendor discovery or another Vendor's interface.

## 7. Acceptance fixtures — exact centavos

| # | Setup | Expected |
| --- | --- | --- |
| 1 | `g_effective=49,000,000`; `G=100,000`; valid relief | `g_after=49,100,000`; `RELIEF_ACTIVE`; `W=0` |
| 2 | `g_effective=49,900,000`; `G=100,000`; valid relief | `g_after=50,000,000`; still `RELIEF_ACTIVE`; `W=0` — exactly at the limit is not a breach |
| 3 | `g_effective=49,900,000`; `G=100,001`; valid relief | `g_after=50,000,001`; `SUBJECT_THRESHOLD_BREACHED`; `W = money(100,001 × 0.005) = 500` on the whole amount |
| 4 | `g_effective=49,900,000`; `G=200,000`; valid relief | `g_after=50,100,000`; breached; `W=1,000`, not `500` on the excess |
| 5 | Case 3, then a new remittance `G=50,000` | still breached; `W=250`; no re-evaluation of the declaration |
| 6 | Case 3, then the Vendor uploads a fresh BIR-received declaration | status unchanged; evidence stored; one audit event; `W` still charged |
| 7 | `G=200,000`, no declaration at all | `SUBJECT_STANDARD`; `W=1,000` even though the year total is far below the threshold |
| 8 | Two concurrent settlements, each `G=100,000`, `g_effective=49,950,000` | Both serialize; totals `50,050,000`/`50,150,000`; exactly one crossing event; no lost update; no double assessment for the same group |
| 9 | Same `remittance_group_id` delivered twice | second call returns the stored assessment; counter unchanged |
| 10 | Prior year closed at `51,000,000`; new year first remittance `G=100,000` | new accumulator; `SUBJECT_PRIOR_YEAR`; `W=500` |
| 11 | Declared external `g_external_declared=60,000,000`, overlap `0`, local `G=100,000` | `g_effective` breaches on the first remittance; `EXTERNAL_BREACH_REPORTED` |
| 12 | Declared external total with unresolved overlap | `UNDER_REVIEW`, assessed as `SUBJECT_STANDARD`, Admin queue item created |
| 13 | Full refund of the crossing order | counter adjustment case opened; status remains breached; no automatic reversal of a posted assessment |

Run 8 against live PostgreSQL, not SQLite, and assert the row lock actually serialized.

## 8. Phase placement

- **Phase 3B** captures the Sworn Declaration claim, taxable year and BIR-received PDF, and writes the initial `RELIEF_ACTIVE`/`SUBJECT_STANDARD` intent on the Vendor Tax Profile. It creates no assessments and grants no relief by itself.
- **Phase 11** implements the accumulator, the algorithm, the locking, the events and the notifications.
- **Phase 14/16** surface the Vendor and Admin panels.
- **Phase 18** runs the fixtures in §7 including the concurrency case.
- **Phase 20** verifies that `FINANCE_MODE=DEMO` labels every figure as simulated and that no fixture claims a BIR filing.
