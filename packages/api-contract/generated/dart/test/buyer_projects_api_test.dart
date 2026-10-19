import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for BuyerProjectsApi
void main() {
  final instance = MateryalphApiClient().getBuyerProjectsApi();

  group(BuyerProjectsApi, () {
    // Lock the original version; scan explicitly afterward.
    //
    //Future<WorkPackageViewResponse> activateWorkPackage(String packageId, String idempotencyKey, ProjectVersionRequest projectVersionRequest) async
    test('test activateWorkPackage', () async {
      // TODO
    });

    // Cancel an unassigned package, retaining its saved contents. Selected work follows order cancellation rules.
    //
    //Future<WorkPackageViewResponse> closeWorkPackage(String packageId, ProjectVersionRequest projectVersionRequest) async
    test('test closeWorkPackage', () async {
      // TODO
    });

    // Scan eligible Bulk Yes Tier 2 offers within the fixed 50 km Project-Based radius from the Project site. FMS uses exact normalized weights. Unknown delivery cost remains pending; schedules never change validity or score.
    //
    //Future<ProjectEstimatePageResponse> compileProjectEstimates(String packageId, ProjectCompile projectCompile) async
    test('test compileProjectEstimates', () async {
      // TODO
    });

    // Create an Active Project with a frozen site copied from the authenticated Buyer saved location.
    //
    //Future<ProjectViewResponse> createProject(String idempotencyKey, ProjectCreate projectCreate) async
    test('test createProject', () async {
      // TODO
    });

    //Future<ProjectArrangementResponse> createProjectArrangement(String packageId, String idempotencyKey, ProjectArrangementCreate projectArrangementCreate) async
    test('test createProjectArrangement', () async {
      // TODO
    });

    // Save a Draft. Normalized units, positive quantities, explicit site and access are validated. The budget is deducted from the Project budget immediately; WORK_PACKAGE_BUDGET_EXCEEDS_PROJECT (422) when non-cancelled allocations would exceed it.
    //
    //Future<WorkPackageViewResponse> createWorkPackage(String projectId, String idempotencyKey, WorkPackageInput workPackageInput) async
    test('test createWorkPackage', () async {
      // TODO
    });

    // Delete only when no Work Packages or procurement history exists. Otherwise archive.
    //
    //Future<ChatEmptyResponse> deleteProject(String projectId, ProjectVersionRequest projectVersionRequest) async
    test('test deleteProject', () async {
      // TODO
    });

    // Delete a Work Package that has no order, tagged purchase or selected Vendor. A Draft with no locked history is removed; any other package is cancelled and hidden from the Buyer while its saved originals, estimates and quotations are retained. A package with an order returns WORK_PACKAGE_HAS_ORDER.
    //
    //Future<ChatEmptyResponse> deleteWorkPackage(String packageId, ProjectVersionRequest projectVersionRequest) async
    test('test deleteWorkPackage', () async {
      // TODO
    });

    //Future<ProjectArrangementResponse> editProjectArrangement(String packageId, String arrangementId, ProjectArrangementEdit projectArrangementEdit) async
    test('test editProjectArrangement', () async {
      // TODO
    });

    // Edit the Work Package directly, with no new list entry. Allowed until an order, tagged purchase or selected Vendor exists (otherwise WORK_PACKAGE_HAS_ORDER). Estimates and open quotation requests built on the old materials are invalidated; a compared or quoted package returns to Active.
    //
    //Future<WorkPackageViewResponse> editWorkPackage(String packageId, String idempotencyKey, WorkPackageInput workPackageInput) async
    test('test editWorkPackage', () async {
      // TODO
    });

    // Advisory budget estimate for a Work Package being drafted. Each catalog line is priced at the half-up average of one price per eligible Vendor (that Vendor's lowest exact match) within the radius of the site. Unlisted and unmatched lines carry no price. Excludes labor and processing fees. Site Delivery and Both include actual route/vehicle estimates for a representative exact-match supplier plan, consolidated per supplier. Unknown delivery remains null. Nothing is stored.
    //
    //Future<WorkPackageBudgetEstimateResponse> estimateWorkPackageBudget(String projectId, WorkPackageBudgetEstimateRequest workPackageBudgetEstimateRequest) async
    test('test estimateWorkPackageBudget', () async {
      // TODO
    });

    // Project sites and paginated Work Packages.
    //
    //Future<ProjectViewResponse> getProject(String projectId, { int page }) async
    test('test getProject', () async {
      // TODO
    });

    //Future<ProjectArrangementResponse> getProjectArrangement(String packageId, String arrangementId) async
    test('test getProjectArrangement', () async {
      // TODO
    });

    // One decision route from the frozen Project site. Separate delivery endpoint/rate basis remains in the advisory estimate.
    //
    //Future<ProjectRouteResponse> getProjectCandidateRoute(String packageId, String candidateId) async
    test('test getProjectCandidateRoute', () async {
      // TODO
    });

    // Immutable, paginated snapshots. Complete one-Vendor matches first by default; missing lines explicit. Expiry is exactly 48 hours. Sorting and filters run on the server so every page is consistent; each ordering ends on the system rank.
    //
    //Future<ProjectEstimatePageResponse> getProjectEstimates(String packageId, { int page, String sort, String direction, bool favoritesOnly, bool completeOnly, bool withinBudget }) async
    test('test getProjectEstimates', () async {
      // TODO
    });

    // Separate Project-Based preference record and active personalized indicator.
    //
    //Future<ProjectPreferencesResponse> getProjectRankingPreferences() async
    test('test getProjectRankingPreferences', () async {
      // TODO
    });

    // The package's current materials, missing-item resolution, budget metrics and delete/edit availability. PDF generation remains Phase 15.
    //
    //Future<WorkPackageViewResponse> getWorkPackage(String packageId, { int page }) async
    test('test getWorkPackage', () async {
      // TODO
    });

    //Future<ProjectArrangementResponse> inquireProjectArrangementVendor(String packageId, String arrangementId, String vendorId, ProjectArrangementInquiry projectArrangementInquiry) async
    test('test inquireProjectArrangementVendor', () async {
      // TODO
    });

    // Open/resume this eligible candidate inquiry only; attach locked original and Vendor-editable duplicate to the shared quotation engine.
    //
    //Future<ChatIdResponse> inquireProjectVendor(String packageId, String idempotencyKey, ProjectCandidateRequest projectCandidateRequest) async
    test('test inquireProjectVendor', () async {
      // TODO
    });

    //Future<ProjectArrangementPageResponse> listProjectArrangementOptions(String packageId, { int page, String sort, String direction, bool favoritesOnly, bool completeOnly, bool withinBudget }) async
    test('test listProjectArrangementOptions', () async {
      // TODO
    });

    // Paginated owned Projects and disjoint FIN-11 metrics.
    //
    //Future<ProjectPageResponse> listProjects({ int page }) async
    test('test listProjects', () async {
      // TODO
    });

    // Eligible Item-Based offers for the same canonical material and unit within the fixed 50 km Project-Based radius of the package site, for buying a missing line separately. Ranked by specification match, whether the store covers the quantity, whether it can serve the package's fulfillment method, total price, then distance. Unlisted lines return status UNLISTED with no items; a line already covered returns COVERED; no suitable store returns NO_SUITABLE_ALTERNATIVE with the reasons in `excluded`.
    //
    //Future<WorkPackageAlternativePageResponse> listWorkPackageLineAlternatives(String packageId, String lineId, { String arrangementId, bool replace, int page, String excludeVendorId, String candidateId, String specificationChoices, String fulfillmentMethod }) async
    test('test listWorkPackageLineAlternatives', () async {
      // TODO
    });

    // Re-price a fresh candidate with the Buyer's specification choices (lines, totals, delivery estimate, score and budget label). Exact-match defaults for missing materials are saved to the draft arrangement; explicit removals and manual replacements are preserved. No regular cart, order or payment is created. Send the same selections when selecting or inquiring. An unknown option is SPECIFICATION_OPTION_INVALID.
    //
    //Future<ProjectCandidateResponse> previewProjectSpecificationSelection(String packageId, String candidateId, ProjectSelectionPreview projectSelectionPreview) async
    test('test previewProjectSpecificationSelection', () async {
      // TODO
    });

    // Validate at most 100 CSV lines without saving. Header: material_code,name,unit_code,quantity,preferred_brand,specifications.
    //
    //Future<ProjectImportPreviewResponse> previewWorkPackageCsv(ProjectImportRequest projectImportRequest) async
    test('test previewWorkPackageCsv', () async {
      // TODO
    });

    // Reactivate the same owned Cancelled Work Package after current version, open-order and Project budget checks. Cancelled, declined and expired orders do not keep the old Vendor selection locked. A cancelled order original is retained internally and the reactivated package uses fresh requirement identities, estimates and inquiries; no order is reopened or duplicated.
    //
    //Future<WorkPackageViewResponse> reactivateWorkPackage(String packageId, String idempotencyKey, ProjectVersionRequest projectVersionRequest) async
    test('test reactivateWorkPackage', () async {
      // TODO
    });

    // Remove an unsubmitted supplementary selection, preserving the requirement and restoring remaining fulfillment on the next preview. Submitted orders retain existing cancellation rules.
    //
    //Future<ChatIdResponse> removeProjectDraftItem(String packageId, String candidateId, String lineId, String variantId, ProjectVersionRequest projectVersionRequest) async
    test('test removeProjectDraftItem', () async {
      // TODO
    });

    // Explicit request to ONE supplementary supplier after the primary Project-Based request exists. Revalidate the reviewed fingerprint, prices, eligibility, fulfillment, payment, ownership and budgets. Create a separate linked Item-Based order awaiting manual Vendor confirmation; never touch the regular cart, auto-accept an order, request other suppliers or start payment.
    //
    //Future<ChatIdResponse> requestProjectDraftSupplier(String packageId, String candidateId, String vendorId, String idempotencyKey, ProjectDraftSupplierRequest projectDraftSupplierRequest) async
    test('test requestProjectDraftSupplier', () async {
      // TODO
    });

    // Reset to current platform defaults with version conflict protection.
    //
    //Future<ProjectPreferencesResponse> resetProjectRankingPreferences(ProjectPreferenceReset projectPreferenceReset) async
    test('test resetProjectRankingPreferences', () async {
      // TODO
    });

    // Link a covering owned Item-Based order or explicitly waive with a reason. Linked child orders enter budgets once.
    //
    //Future<WorkPackageViewResponse> resolveProjectMissingLine(String packageId, String lineId, ProjectMissingResolve projectMissingResolve) async
    test('test resolveProjectMissingLine', () async {
      // TODO
    });

    // Add one recommendation to the Work Package draft. Server caps quantity by the remaining requirement and available stock. Idempotent PUT never stacks duplicates. No cart, order, stock reservation or payment is created.
    //
    //Future<ChatIdResponse> saveProjectDraftItem(String packageId, String candidateId, String lineId, String variantId, ProjectDraftItemInput projectDraftItemInput) async
    test('test saveProjectDraftItem', () async {
      // TODO
    });

    // Exactly four independent integer weights in [0,100], at least one above zero (422 WEIGHTS_ALL_ZERO). Original values are stored and restored; scoring divides each by the sum of weights. Defaults: material_match 40, budget_fit 25, distance 20, vps 15.
    //
    //Future<ProjectPreferencesResponse> saveProjectRankingPreferences(ProjectPreferenceSave projectPreferenceSave) async
    test('test saveProjectRankingPreferences', () async {
      // TODO
    });

    // Up to eight canonical material suggestions, each with compatible normalized units. Buyer must explicitly select a suggestion.
    //
    //Future<ProjectMaterialPageResponse> searchProjectMaterials(String query) async
    test('test searchProjectMaterials', () async {
      // TODO
    });

    // Select exactly one Vendor from a fresh estimate and expire other active quotations. Creates a manual 24-hour package request. Optional Note needs no Vendor response. No auto-accept.
    //
    //Future<ChatIdResponse> selectProjectVendor(String packageId, String idempotencyKey, ProjectVendorSelectionRequest projectVendorSelectionRequest) async
    test('test selectProjectVendor', () async {
      // TODO
    });

    //Future<ProjectArrangementResponse> submitProjectArrangement(String packageId, String arrangementId, String idempotencyKey, ProjectArrangementSubmit projectArrangementSubmit) async
    test('test submitProjectArrangement', () async {
      // TODO
    });

    // Edit before procurement history; complete/archive afterward. A site never replaces an accepted destination.
    //
    //Future<ProjectViewResponse> updateProject(String projectId, String idempotencyKey, ProjectUpdate projectUpdate) async
    test('test updateProject', () async {
      // TODO
    });

  });
}
