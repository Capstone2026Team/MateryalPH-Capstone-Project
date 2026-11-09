# Annual retained payments and selected-period Payments — 6 November 2026

The count discrepancy comes from different date scopes. The annual threshold list contains four retained successful payments, while the default Transactions range (8 October–6 November 2026, inclusive Manila dates) contains two. The earlier refund audit did not explain that date-range difference.

| Order reference | Paid date in Asia/Manila | Annual list | Default Transactions range |
| --- | --- | --- | --- |
| ORD-2026-AZ5YXGDX | 2 October 2026 | Included | Outside range |
| ORD-2026-WKRIWRHJ | 7 October 2026 | Included | Outside range |
| ORD-2026-QOJYQLNH | 13 October 2026 | Included | Included |
| ORD-2026-BCZHVR6Q | 20 October 2026 | Included | Included |

The local database was inspected inside a read-only transaction. All four payments are PAID with zero completed principal refunds. The store's other two assessed payments are fully refunded and already omitted from the retained list. A comparison using the same `PortalDateRange` helper as the Payments endpoint returned four annual records and two records for 8 October–6 November.

## Change

- `packages/web-ui/src/assessed-payment-breakdown.tsx`: label the expansion **View annual retained online payments**, explain that it covers the full taxable year independently of the selected Balance/Transactions dates, and accept a history-link slot.
- `apps/vendor-web/src/pages/FinancePages.tsx`: provide **View Payments for this taxable year**, using the API's actual taxpayer-year start/end boundaries rather than the selected Balance range.
- Existing retained-payment component and responsive browser assertions cover the label, scope explanation and annual Payments link.

No financial formula, refund handling, posted assessment, authorization, API contract, generated client, migration, order or payment record changed. No setup or keys are required. No deployment or live provider action was performed.

## Validation

- Vendor component suites: **58 passed** across two files.
- Vendor typecheck: passed.
- Vendor lint: passed with the existing unused `inStore` warning in the Admin Finance browser fixture.
- Vendor production build: passed with the existing bundle-size warning.
- The first browser run used the previous production build; four new-label assertions failed. Rebuilt before the verification run.
- Responsive browser verification after rebuilding: **8 passed**, covering 320, 390, 1280 and 1920px. The annual link uses 1 January–31 December for the supplied calendar-year fixture; the mobile rendering was visually inspected.

Suggested commit: `fix(vendor): clarify annual payment count and matching history dates`
