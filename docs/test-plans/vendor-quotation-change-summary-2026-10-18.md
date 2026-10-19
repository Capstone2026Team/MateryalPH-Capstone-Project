# Vendor quotation change summary

The Vendor quotation history card now presents a filtered, readable “What changed” list. It no longer renders the API's raw change labels. The initial Self-Pickup example shows the added material, fulfillment method, payment method and fulfillment date, with trimmed quantities and readable method labels.

Internal identifiers, calculation versions, rounding rules, derived commercial breakdowns, price-source metadata, fee-policy versions and processing-status codes are omitted. Initial zero-percent discounts and irrelevant pickup destination changes are omitted. Actual product, quantity, unit price, brand, unit, specification, delivery-fee, discount, NRPC and Site Delivery address changes remain available. Only the address text is used; coordinates and address IDs are excluded. Before/after values are shown with a readable screen-reader equivalent. The count reflects displayed changes; lists longer than five use Show all/Show fewer controls.

Changed files:

- `packages/web-ui/src/quotation-changes.ts`: shared presentation allowlist and formatting.
- `packages/web-ui/src/messaging-patterns.tsx`: shared quotation change list rendering.
- `apps/vendor-web/src/lib/messaging-patterns.test.tsx`: initial quotation, internal-field exclusion, before/after, fee/NRPC/address preservation, removed materials, specification grouping, empty and folded-list regressions.

This is a Vendor/shared-web presentation change. No migration, API contract/generated-client change, authorization change, audit/notification mutation or credential setup is required. Immutable quotation snapshots and their complete raw differences remain unchanged on the server. Buyer Flutter already uses its own filtered change-note presentation and was not edited.

Validation in `apps/vendor-web`:

| Command | Result |
| --- | --- |
| `npm run lint` | Passed |
| `npm run typecheck` | Passed |
| `npm run test -- --run src/lib/messaging-patterns.test.tsx src/pages/FulfillmentConversationDialog.test.tsx --maxWorkers=1` | 31 passed, 2 files |
| `npm run build` | Passed; existing large-chunk advisory retained |

No browser/device E2E or full-repository test run was performed. Manual acceptance: refresh Vendor, open quotation history, expand What changed, confirm readable terms with no calculation dump or IDs, and check older versions and long-list controls.

Suggested commit: `fix(vendor): simplify quotation change summaries`.
