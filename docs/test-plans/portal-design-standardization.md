# Admin and Vendor portal standardization

The portals share the existing semantic design tokens and `packages/web-ui` components. Page headers, dashboard headers, buttons, fields, search with a clear action, selectors, tables, pagination, section navigation, and modal behavior use the same foundation. Role-specific routes, grants, commercial state transitions and workflows remain authoritative.

## Date selection

`DateFilter` presents the reference-style calendar trigger, context title, presets, dual-month calendar, From/To fields, Cancel and Apply. Changes are drafts until Apply; Cancel and Escape restore the previous selection and trigger focus. Calendar navigation supports arrows, Home/End and Page Up/Down. Custom and open-ended selections display their boundaries in the trigger. Malformed saved URL dates can be repaired or reset without crashing the picker. Calendar targets are at least 44 by 44 pixels. Compact screens use a horizontally scrolling preset row and stacked months, with fixed modal actions and scrolling content.

Calendar days use Asia/Manila. A timestamp selection includes the From day at Manila midnight and excludes midnight after the To day. Date-only fields use inclusive calendar comparisons. Lists filter before pagination; changing date scope resets pagination and keeps the other query filters.

Ordinary history lists offer All dates, Today, Yesterday and the 7/30/60/90/365-day presets, including open-ended boundaries. Materials Analytics retains the existing paired-date rule, start before end, and maximum 365-day difference (366 inclusive days). Its 7/30/90-day comparison presets use the latest published snapshot and the observation exactly N days earlier, including both endpoints; these are explicitly labeled comparisons. Geographic and Admin dashboard analytics retain their existing bounded window. Current inventory quantities, operational queues, score calculation windows, forecasts and financial year thresholds retain their own documented meanings.

## Coverage inventory

| Surface | Date field or purpose |
| --- | --- |
| Vendor orders | Submitted order timestamp; all existing status/search filters retained |
| Vendor dashboard charts | Reporting window; model-specific windows remain documented |
| Vendor transactions and CSV | Transaction record dates; same scope for table, KPIs and export |
| Vendor earnings | Reporting date scope; Owner permission retained |
| Vendor/Admin disputes | Case creation |
| Vendor/Admin invoice requests | Request creation |
| Vendor/Admin reviews | Review submission; score definitions unaffected |
| Materials Analytics and material export | Observation calendar dates within the existing bound |
| Vendor team activity | Recorded action timestamp; historical role filters retained |
| Vendor inventory/price history | Movement creation and price-version effective timestamps; current stock remains current |
| Admin verification | Immutable submission timestamp |
| Admin audit | Audit creation timestamp; keyset pagination retained |
| Admin privacy/enforcement/compliance/moderation | Privacy receipt, enforcement creation and compliance/review submission timestamps |
| Admin finance operations | Record timestamps; date-only remittance/statement periods where applicable |
| Admin integrations/jobs/budget records | Job/failure/action record timestamps |
| Notifications | Complete authorized inbox snapshot filtered by notice creation; bulk read uses the same server-side scope |
| Document export history | Export request creation; downloads reauthorize independently |

Settings, vehicles, public profile configuration, stock quantities, current role permissions and live health indicators do not receive meaningless date filters. Existing fixed score/model windows remain intact. These current-state sections explicitly describe their scope separately from dated charts.

## Validation

Validation results and synthetic responsive screenshots are recorded in [the evidence README](../design/evidence/portal-standardization/README.md). Browser fixtures contain synthetic identities and records, and do not verify live credentials, private files, providers or development data.

No migrations, development data changes, environment-file changes, Git commands, commits or deployments are part of this task.
