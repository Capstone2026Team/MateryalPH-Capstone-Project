# Vendor and Admin return navigation consistency

Date: 5 November 2026

## Outcome

Applied the reference's quiet dark arrow-and-label treatment to 45 Vendor, Admin and shared return-control call sites. Controls share 14 px semibold text, a decorative 16 px arrow, 8 px spacing, a minimum 44 px target, wrapping for long labels, an underline on hover, visible keyboard focus, and disabled styling. Existing destination labels remain descriptive.

The shared `BackNavigation` component decorates the existing link or native button, preserving its destination, route state, history callback, ref, accessible attributes and disabled state. Return buttons inside forms retain `type="button"`. The mobile inbox return label stays visible; its existing desktop visibility remains controlled by the messaging layout.

## Files changed by this task

- Added `packages/web-ui/src/back-navigation.tsx` and `back-navigation.css`; exported the component from `packages/web-ui/src/index.ts`.
- Updated shared `account-workspace.tsx`, `delivery-vehicles.tsx`, `onboarding-flow.tsx` and `password-recovery-flow.tsx`.
- Vendor: `App.tsx`, `components/auth/VendorAuthShell.tsx`, and pages `AuthSupportPages.tsx`, `CatalogPages.tsx`, `ConversationThread.tsx`, `DisputePages.tsx`, `FinancePages.tsx`, `FulfillmentConversationDialog.tsx`, `FulfillmentPages.tsx`, `OrderPages.tsx`, `PhaseThreeVendorPages.tsx`, `ProductAnalyticsPages.tsx`, `SupportPages.tsx` and `VendorReviewPages.tsx`.
- Admin: `App.tsx` and pages `AuthSupportPages.tsx`, `DisputePages.tsx`, `EnforcementPages.tsx`, `FinancePages.tsx`, `FinanceTaxPages.tsx`, `GeoAnalyticsPage.tsx`, `InvoiceLogPage.tsx`, `PhaseThreeAdminPages.tsx`, `ProductCompliancePages.tsx`, `SupportPages.tsx`, `TrustPages.tsx` and `UserDirectoryPages.tsx`.
- Updated the existing assertion in `apps/vendor-web/src/pages/FulfillmentPages.test.tsx`: the link's accessible name is `Assigned deliveries`; the decorative arrow no longer contributes text.
- Documented the shared treatment in `DESIGN.md` and recorded validation here.

No migration, backend rule, authorization policy, route definition, API request/response, OpenAPI schema or generated-client changes. No deployment or credential changes. Unrelated workspace edits were retained.

## Validation

| Check | Result |
| --- | --- |
| Vendor `npm.cmd run lint` | Passed; one existing unused-variable warning in `e2e/admin-finance-layout.spec.ts:31` |
| Vendor `npm.cmd run typecheck` | Passed |
| Vendor `npm.cmd run build` | Passed; large-chunk advisory |
| Vendor `npm.cmd run test -- --run --maxWorkers=2` | 810 tests passed in 86 files |
| Vendor focused fulfillment and review-overview rerun | 13 tests passed |
| Admin `npm.cmd run lint` | Passed |
| Admin `npm.cmd run typecheck` | Passed |
| Admin `npm.cmd run build` | Passed; large-chunk advisory |
| Admin `npm.cmd run test -- --run --maxWorkers=2` | 282 tests passed in 42 files |
| Chromium at 320 px and 1440 px | 12 checks passed |
| `git -c core.autocrlf=false diff --check -- apps/vendor-web/src apps/admin-web/src packages/web-ui/src DESIGN.md` | Passed |
| `gitleaks stdin --redact --no-banner` on the task-only patch | Passed; no leaks |
| `gitleaks git --staged --redact --no-banner` | Passed; no staged content to scan |

Browser checks reused isolated copies of existing login, catalog-return, product-analytics/review and Admin product-compliance tests. They verify catalog filters and review return context, keyboard navigation, narrow layouts, and the shared control's computed color, font, arrow size, gap, minimum height and keyboard focus outline. Screenshots were reviewed for Vendor desktop and Admin mobile. Logs, isolated browser configuration and screenshots remain under `.tmp/back-navigation/`.

The first Vendor run found the obsolete text-arrow assertion, which was updated. Two review-overview assertions also failed in that run; both subsequently passed through unchanged direct component imports and through the original package imports. This task did not edit review-overview implementation or its tests.

## Limits and setup

No manual setup or new environment keys are required. Browser checks use mocked APIs and synthetic records; they do not certify live provider behavior. Backend, Buyer Flutter and API-contract checks were outside this presentation-only scope. Existing Vite chunk-size advisories and a non-failing jsdom navigation diagnostic remain.

Suggested commit: `style(portals): standardize return navigation`
