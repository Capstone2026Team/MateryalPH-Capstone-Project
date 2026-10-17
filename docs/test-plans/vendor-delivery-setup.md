# Vendor Delivery setup acceptance

Use the existing Store Setup, Store Profile → Fulfillment Configuration, Team Accounts, Vehicles and Orders modules. Apply `2026_10_13_140000_add_vendor_delivery_activation.php` before running the updated API in development. No new credentials or provider setup are required.

| Scenario | Expected result |
| --- | --- |
| Self-Pickup Only without staff or vehicles | Draft/setup remains valid for pickup; delivery requirements are not applicable. |
| Vendor Delivery Only or Both without active Fulfillment Staff | Draft saves; **Fulfillment Staff Required** appears with **Manage Fulfillment Staff**; activation is unavailable and direct activation returns `VENDOR_DELIVERY_SETUP_REQUIRED`. |
| Delivery selection without an eligible registered vehicle | Draft saves; **Delivery Vehicle Required** appears with **Manage Vehicles**; direct activation is rejected. |
| Foreign staff, another role, an inactive membership, inactive identity or deleted membership | None qualifies as active Fulfillment Staff. |
| Disabled/unavailable/removed vehicle, missing clean image, incomplete capacity or missing current rates | Vehicle does not satisfy delivery readiness. |
| Missing store location or active delivery service settings | Checklist identifies the missing requirement and activation is rejected. |
| All saved requirements complete | **Vendor Delivery Ready** appears; explicit activation succeeds. Buyer delivery options still require normal Store Activation and procurement eligibility. |
| Last eligible staff account deactivated or changed to another role | New delivery options disappear immediately on authoritative API reads; Both retains pickup. Existing orders and assignments remain intact. |
| Last eligible vehicle disabled/unavailable/removed | New delivery pauses; existing accepted snapshots remain unchanged. Restore the accepted vehicle before dispatch or follow the existing Buyer-approved revision process. |
| Eligibility restored | Previously activated delivery resumes. A deliberately paused delivery requires explicit reactivation. |
| Stale checkout, cart method update, Project selection or quotation acceptance | Current eligibility is checked again; unavailable delivery cannot create a new order or silently become pickup. |
| Active delivery handover obligation and switch to Self-Pickup Only | Frontend explains the blocker; API returns `ACTIVE_DELIVERY_OBLIGATIONS`. Pausing new delivery remains available. |
| Dispatch without active assigned staff | Owner/Manager assigns eligible staff through the existing order controls; direct dispatch returns `FULFILLMENT_STAFF_REQUIRED` until assigned. |
| Accepted vehicle is inactive/unavailable at dispatch | `DELIVERY_VEHICLE_REQUIRED`; no milestone, trip, assignment or commercial snapshot is overwritten. |
| New delivery paused while an accepted order remains open | Existing assigned staff workspace, milestones, proof and Buyer Order Details remain available under existing authorization. |
| Delivery handover complete | Switching to Self-Pickup Only is allowed; receipt confirmation, disputes and immutable history remain accessible. |

Fulfillment settings remain Owner-controlled. Store Managers retain existing vehicle management and assignment permissions; delegated Team management remains subject to Owner settings. Fulfillment Staff see their assigned order workspace. Buyer Order Details expose the public staff display name, accepted vehicle and recorded status, with private staff identifiers/contacts protected as before.

Vehicle availability continues to use the existing Vendor-maintained availability and usable-count model. A configuration represents multiple physical vehicles; this change does not introduce an individual-vehicle reservation system or live GPS tracking.

Automated evidence lives in `VendorDeliveryEligibilityTest`, the delivery dispatch case in `PhaseTwelveFulfillmentTest`, stale checkout coverage in `PhaseEightOrdersTest`, and the existing onboarding, fleet and procurement regression suites. Vendor checklist, navigation, vehicle and fulfillment component tests cover the corresponding presentation. Manual browser/device acceptance and live provider behavior remain separate checks.
