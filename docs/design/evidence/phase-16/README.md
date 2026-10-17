# Phase 16 design evidence

Screenshots were **not captured** for this phase. Capturing them needs a signed-in Admin session against a migrated development database with TEST or DEMO analytics facts. Capture them after running the manual steps in `docs/test-plans/phase-sixteen-admin-operations-analytics.md`.

| Screen | Route | What to capture |
| --- | --- | --- |
| Marketplace Analytics | `/analytics` | Map and table side by side at 1280px and 1440px. Stacked at 1024px and 375px. Tile fallback without `VITE_GOOGLE_MAPS_BROWSER_KEY`. A suppressed cell with its reason. The DEMO dataset label |
| Materials Analytics in the geographic section | `/analytics?view=materials` | PSGC scope line and the "not applicable" note for transaction filters |
| Platform Settings | `/settings` | Version, previous value and rule. The weight-total error. Fixed rules with no control |
| Enforcement | `/enforcement`, `/enforcement/:id` | Referred queue. Decision form with the exact target, version, before and after, and continuation plans |
| Buyer Management | `/buyer-management` | Buyer-only enforcement queue |
| Privacy Requests | `/privacy`, `/privacy/:id` | Lifecycle actions and history |
| Audit Log | `/audit` | Search filters, keyset "Load older entries", redacted detail panel |
| Integration & Job Health | `/integrations` | Masked integration statuses, analytics run health, retry panel |
| Finance | `/finance?view=overview` and the other FIN-10 tabs | GMV kept apart from finance amounts, report readiness, tax adjustment two-person review |
| Vendor verification | `/vendor-verification`, case detail | Separate workstream columns. Source-revision blockers with no override |
| Dashboard | `/dashboard` | Role-scoped work queues with ages |
| Vendor finance | Vendor portal `/finance` | Owner "Finance reviews" section |

Visual language follows `DESIGN.md`:
- Semantic tokens.
- One-hue sequential ramp (`--mp-viz-seq-1…5`).
- Validated categorical series 1–2 for two-line trends.
- Status shown as an icon plus a word.
- Hatch plus text for suppression, kept in forced-colors mode.
