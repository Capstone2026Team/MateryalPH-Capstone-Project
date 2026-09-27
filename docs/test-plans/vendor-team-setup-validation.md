# Vendor Team setup and access validation

The optional Team Accounts step contains the same invitation component as Team Accounts. Owners can invite before setup completion or Store Activation. No employee invitation is an activation prerequisite.

Invitation records retain name, email, optional contact number, organization, one fixed role, delegation, inviter, creation/expiry/acceptance timestamps. Status is derived as ACCEPTED, REVOKED, EXPIRED or PENDING. Resending creates a fresh invitation, revokes and audits the old link, and never changes accepted membership history. The existing 24-hour expiry and sealed email outbox remain in use. Contact is optional because no role-specific mandatory-contact condition is defined in the approved policy.

Owners alone can invite Managers or grant staff-management delegation. Delegated Managers can manage non-manager staff only. Role and name edits require a membership version, recent authentication and current agreements; access changes revoke sessions. The organization dispute setting defaults on and only the Owner may change it, with a version guard and recent authentication. Staff settings and invitation/membership actions are audited; delegated management notifies the Owner through the existing outbox notice mechanism.

Employees receive a reduced onboarding snapshot, their own Account Profile, role-filtered navigation, and no Wallet, Earnings, private verification documents or protected onboarding controls. Store activation remains a separate gate. Team Tracking displays a paginated, organization-scoped audit projection with the historical actor role and safe before/after fields. Delegated Managers see only non-manager employee activity.

## Changed boundaries

- Migration: `2026_09_25_000001_add_vendor_staff_dispute_setting.php` adds `vendor_organizations.staff_disputes_enabled`, default true.
- POST `/api/v1/vendors/account/invitations` accepts Owner-only Manager delegation and allows invitations during setup.
- GET `/api/v1/vendors/account/invitations` lists scoped invitation records.
- PATCH `/api/v1/vendors/account/memberships/{membershipId}` updates permitted staff names/roles with a version guard.
- PATCH `/api/v1/vendors/account/staff-disputes` updates the Owner-controlled dispute setting.
- GET `/api/v1/vendors/account/activity` exposes the safe immutable audit projection.
- OpenAPI and generated TypeScript/Dart clients cover these boundaries.

## Validation

- Vendor suite: 137 existing tests passed; the final affected navigation/invitation run passed 66 tests, including 3 new tests.
- Admin suite: 16 tests passed; lint, typecheck and builds passed for both portals.
- Playwright: invitation submission, delegation default, history display, optional continuation and no horizontal overflow passed at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px. Uses intercepted API responses, not live provider delivery. Desktop and 320 px screenshots were inspected.
- Pure backend role tests: 3 tests, 94 assertions passed.
- Pint and PHPStan passed. OpenAPI validation and route-contract checks passed (61 account operations and 34 Vendor/Admin onboarding operations). Generated Dart analysis passed with no issues. Diff checks and redacted secret scans passed.
- Database feature tests were added for invitation organization isolation, Manager restrictions, private snapshot denial, dispute settings, role changes and historical attribution. Execution is blocked: Docker Desktop CLI is absent.

Run the database gate when Docker Desktop is available:

```powershell
./scripts/run-tests-isolated.ps1
```

Apply the new migration to the intended local API database before using the updated portal:

```powershell
cd services/api
php artisan migrate
```

No new secret keys are required. Live email delivery and real invitation acceptance still need provider-backed validation. Orders, fulfillment, normal conversations and dedicated fulfillment threads remain unimplemented operational modules; these changes do not claim to implement or verify their resource-assignment rules. Generated Dart clients and built_value serializers were regenerated; Buyer Flutter runtime use was not exercised.
