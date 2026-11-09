# Vendor Work Package attachment details

Implemented locally on 5 November 2026.

## Outcome

Clicking a Work Package message card opens a scrollable popup and preserves the chat draft. The popup shows the store's assigned materials, quantities, units and specifications while quoting. After acceptance, both the card and the Vendor fulfillment reference show that store's actual order items from its accepted commercial snapshot, including unit prices, schedule, fulfillment/payment method and order reference. The old quotation proposal is omitted after acceptance.

Other suppliers' items, uncovered materials and the package-wide budget are excluded from these API projections. A legacy inquiry without a known allocation shows no assigned materials rather than falling back to the complete package. The Buyer retains access to the complete original. Its stored content, version and hash are unchanged; the hash identifies the original, not the filtered projection.

The popup uses a compact layout on phones, with the package name and assigned items near the top. Fulfillment conversations, its popup, staff permissions, the single Buyer/Store chat, quotation rules and cancellation behavior are retained.

## Files and API

- `services/api/app/Domain/Messaging/WorkPackageAttachmentView.php`: shared read projection; order lines and the relevant accepted/current snapshot are loaded in batches.
- `ConversationService.php`: scopes current and historical message cards and resolves an accepted inquiry to its actual order.
- `ConversationHeaders.php`: applies the same scope to Vendor inquiry/fulfillment references, including references carried in the combined timeline.
- `packages/web-ui/src/work-package-attachment.tsx`: clickable summary, bounded popup, scoped materials, order reference, responsive presentation and useful empty state.
- `apps/buyer-mobile/lib/design_system/components/messaging_components.dart`: accurate labels for scoped cards.
- OpenAPI, regenerated TypeScript/Dart clients, messaging contract checks, component/browser/API tests and workflow/UI planner clarification.

No migration, endpoint, permission or secret/key setup was added. The existing `reference` object now describes `material_scope` (`VENDOR_ALLOCATION` or `VENDOR_ORDER`), scoped `work_package.lines` and optional `order` metadata. Every original conversation/order remains authorized by the existing server policies; another store cannot read the attachment by guessing its ID. Internal immutable originals and commercial snapshots are not rewritten.

## Executed verification

| Check | Result |
| --- | --- |
| Complete messaging and Work Package API suites | 77 passed, 1,985 assertions |
| Final focused allocation-to-accepted-order regression | 1 passed, 61 assertions; verifies item isolation, allocated/accepted quantities, accepted prices/specifications, cross-store denial, fulfillment reference and unchanged original |
| Full Vendor suite | 84 files, 785 tests passed |
| Final attachment and fulfillment component checks after popup spacing changes | 24 passed |
| Browser chat, attachment, settings and fulfillment journeys | 6 passed at Chromium widths 320, 390 and 1440 |
| Buyer messaging and attachment tests | 12 passed |
| Flutter analysis | No issues found |
| Pint | 874 files passed |
| PHPStan | No errors |
| Vendor/Admin lint, typecheck and builds | Passed; existing Vendor unused `inStore` warning and bundle-size/build advisories |
| OpenAPI validation | Passed with eight unused-model recommendations |
| Messaging contract | 50 authorized operations passed |
| Generated TypeScript build | Passed; regenerated Dart models remain compatible with the executed Flutter tests and analysis |
| Diff whitespace, redacted secret scans, Compose configuration | Passed |

The final popup spacing change was covered by the focused component and browser reruns after the complete Vendor suite. The complete API suite and Buyer golden suite were not rerun for this scoped read/UI correction. Browser evidence uses synthetic fixtures; live two-account and physical-device acceptance were not performed. No push, merge or deployment occurred.

Ignored logs: `services/api/storage/logs/package-details-*.log`. Reviewed popup screenshots are saved in `docs/design/evidence/vendor-package-details/`.

Suggested commit: `fix(messaging): scope work package details to vendor order items`.
