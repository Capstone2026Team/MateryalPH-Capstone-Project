import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'dart:convert';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../core/api_guard.dart';
import '../../core/buyer_transport.dart';
import '../../design_system/components/peso_amount_field.dart';
import '../map_discovery/discovery_repository.dart';

typedef ProjectData = Map<String, Object?>;

/// The one radius Project-Based vendor selection searches (owner decision
/// 2026-10-17). It is shown, never chosen; the server applies it to the scan,
/// the alternatives for missing items and the purchases tagged to them.
const projectSearchRadiusKm = 50;

/// Transport is always validated by the generated contract before entering the UI.
final class ProjectsRepository {
  ProjectsRepository({
    required api.MateryalphApiClient client,
    required Future<void> Function() onSessionExpired,
  }) : this.withGuard(client: client, guard: ApiGuard(onSessionExpired));

  ProjectsRepository.withGuard({
    required api.MateryalphApiClient client,
    required ApiGuard guard,
  }) : _client = client,
       _guard = guard {
    configureBuyerTransport(_client.dio);
  }

  final api.MateryalphApiClient _client;
  final ApiGuard _guard;
  api.BuyerProjectsApi get _api => _client.getBuyerProjectsApi();
  Future<api.ProjectPage> list({int page = 1}) => _guard(
    () async =>
        _guard.required((await _api.listProjects(page: page)).data?.data),
  );
  Future<api.ProjectView> project(String id, {int page = 1}) => _guard(
    () async => _guard.required(
      (await _api.getProject(projectId: id, page: page)).data?.data,
    ),
  );
  Future<api.WorkPackageView> package(String id, {int page = 1}) => _guard(
    () async => _guard.required(
      (await _api.getWorkPackage(packageId: id, page: page)).data?.data,
    ),
  );
  Future<api.ProjectView> create(ProjectData input, String key) => _guard(
    () async => _guard.required(
      (await _api.createProject(
        idempotencyKey: key,
        projectCreate: _guard.required(
          _client.serializers.deserializeWith(
            api.ProjectCreate.serializer,
            input,
          ),
        ),
      )).data?.data,
    ),
  );
  Future<api.ProjectView> update(String id, ProjectData input, String key) =>
      _guard(
        () async => _guard.required(
          (await _api.updateProject(
            projectId: id,
            idempotencyKey: key,
            projectUpdate: _guard.required(
              _client.serializers.deserializeWith(
                api.ProjectUpdate.serializer,
                input,
              ),
            ),
          )).data?.data,
        ),
      );
  Future<api.WorkPackageView> save(
    String projectId,
    ProjectData input,
    String key, {
    String? id,
  }) => _guard(() async {
    final body = _guard.required(
      _client.serializers.deserializeWith(
        api.WorkPackageInput.serializer,
        input,
      ),
    );
    return _guard.required(
      id == null
          ? (await _api.createWorkPackage(
              projectId: projectId,
              idempotencyKey: key,
              workPackageInput: body,
            )).data?.data
          : (await _api.editWorkPackage(
              packageId: id,
              idempotencyKey: key,
              workPackageInput: body,
            )).data?.data,
    );
  });
  Future<api.WorkPackageView> activate(String id, int version, String key) =>
      _guard(
        () async => _guard.required(
          (await _api.activateWorkPackage(
            packageId: id,
            idempotencyKey: key,
            projectVersionRequest: api.ProjectVersionRequest(
              (b) => b..lockVersion = version,
            ),
          )).data?.data,
        ),
      );
  Future<api.WorkPackageView> reactivate(String id, int lock, String key) =>
      _guard(
        () async => _guard.required(
          (await _api.reactivateWorkPackage(
            packageId: id,
            idempotencyKey: key,
            projectVersionRequest: api.ProjectVersionRequest(
              (b) => b..lockVersion = lock,
            ),
          )).data?.data,
        ),
      );
  Future<api.WorkPackageView> close(String id, int version) => _guard(
    () async => _guard.required(
      (await _api.closeWorkPackage(
        packageId: id,
        projectVersionRequest: api.ProjectVersionRequest(
          (b) => b..lockVersion = version,
        ),
      )).data?.data,
    ),
  );
  Future<void> delete(String id, int version, {bool project = false}) =>
      _guard(() async {
        final body = api.ProjectVersionRequest((b) => b..lockVersion = version);
        if (project) {
          await _api.deleteProject(projectId: id, projectVersionRequest: body);
        } else {
          await _api.deleteWorkPackage(
            packageId: id,
            projectVersionRequest: body,
          );
        }
      });

  /// Vendor results; sorting and filters run on the server so pages agree.
  Future<api.ProjectEstimatePage> estimates(
    String id, {
    int page = 1,
    String sort = 'BEST_MATCH',
    String? direction,
    bool favoritesOnly = false,
    bool completeOnly = false,
    bool withinBudget = false,
  }) => _guard(
    () async => _guard.required(
      (await _api.getProjectEstimates(
        packageId: id,
        page: page,
        sort: sort,
        direction: direction,
        favoritesOnly: favoritesOnly ? true : null,
        completeOnly: completeOnly ? true : null,
        withinBudget: withinBudget ? true : null,
      )).data?.data,
    ),
  );

  /// Item-Based offers for a missing Work Package line within the fixed
  /// Project-Based radius. With [candidateId] the server sizes the quantity to
  /// what that Vendor's quotation still lacks after the separate purchases.
  Future<api.WorkPackageAlternativePage> alternatives(
    String packageId,
    String lineId, {
    int page = 1,
    String? excludeVendorId,
    String? candidateId,
    Map<String, String> selections = const {},
    String? fulfillmentMethod,
    String? arrangementId,
    bool replace = false,
  }) => _guard(
    () async => _guard.required(
      (await _api.listWorkPackageLineAlternatives(
        packageId: packageId,
        lineId: lineId,
        page: page,
        excludeVendorId: excludeVendorId,
        candidateId: candidateId,
        specificationChoices: jsonEncode(specificationSelections(selections)),
        fulfillmentMethod: fulfillmentMethod,
        arrangementId: arrangementId,
        replace: replace,
      )).data?.data,
    ),
  );

  Future<api.ProjectArrangementPage> arrangementOptions(
    String id, {
    int page = 1,
    String sort = 'BEST_MATCH',
    String direction = 'ASC',
    bool favoritesOnly = false,
    bool completeOnly = false,
    bool withinBudget = false,
  }) => _guard(
    () async => _guard.required(
      (await _api.listProjectArrangementOptions(
        packageId: id,
        page: page,
        sort: sort,
        direction: direction,
        favoritesOnly: favoritesOnly,
        completeOnly: completeOnly,
        withinBudget: withinBudget,
      )).data?.data,
    ),
  );

  Future<api.ProjectArrangement> createArrangement(
    String packageId,
    String source,
    String key, {
    String? proposalToken,
  }) => _guard(
    () async => _guard.required(
      (await _api.createProjectArrangement(
        packageId: packageId,
        idempotencyKey: key,
        projectArrangementCreate: api.ProjectArrangementCreate(
          (b) => b
            ..sourceCandidateId = source
            ..proposalToken = proposalToken,
        ),
      )).data?.data,
    ),
  );

  Future<api.ProjectArrangement> arrangement(String packageId, String id) =>
      _guard(
        () async => _guard.required(
          (await _api.getProjectArrangement(
            packageId: packageId,
            arrangementId: id,
          )).data?.data,
        ),
      );

  Future<api.ProjectArrangement> editArrangement(
    String packageId,
    String id,
    ProjectData input,
  ) => _guard(
    () async => _guard.required(
      (await _api.editProjectArrangement(
        packageId: packageId,
        arrangementId: id,
        projectArrangementEdit: _guard.required(
          _client.serializers.deserializeWith(
            api.ProjectArrangementEdit.serializer,
            input,
          ),
        ),
      )).data?.data,
    ),
  );

  Future<api.ProjectArrangement> submitArrangement(
    String packageId,
    String id,
    ProjectData input,
    String key,
  ) => _guard(
    () async => _guard.required(
      (await _api.submitProjectArrangement(
        packageId: packageId,
        arrangementId: id,
        idempotencyKey: key,
        projectArrangementSubmit: _guard.required(
          _client.serializers.deserializeWith(
            api.ProjectArrangementSubmit.serializer,
            input,
          ),
        ),
      )).data?.data,
    ),
  );

  Future<api.ProjectArrangement> arrangementInquiry(
    String packageId,
    String id,
    String vendorId,
    int version,
  ) => _guard(
    () async => _guard.required(
      (await _api.inquireProjectArrangementVendor(
        packageId: packageId,
        arrangementId: id,
        vendorId: vendorId,
        projectArrangementInquiry: api.ProjectArrangementInquiry(
          (b) => b..version = version,
        ),
      )).data?.data,
    ),
  );

  /// Draft selections stay with this Work Package, independent of the cart.
  Future<void> saveDraftItem({
    required String packageId,
    required String candidateId,
    required String lineId,
    required api.WorkPackageAlternative offer,
    required int lockVersion,
    required Map<String, String> selections,
    required String fulfillmentMethod,
  }) => _guard(() async {
    await _api.saveProjectDraftItem(
      packageId: packageId,
      candidateId: candidateId,
      lineId: lineId,
      variantId: offer.variantId,
      projectDraftItemInput: _guard.required(
        _client.serializers
            .deserializeWith(api.ProjectDraftItemInput.serializer, {
              'lock_version': lockVersion,
              'price_version_id': offer.priceVersionId,
              'selections': specificationSelections(selections),
              'fulfillment_method': fulfillmentMethod,
            }),
      ),
    );
  });

  Future<void> removeDraftItem({
    required String packageId,
    required String candidateId,
    required String lineId,
    required String variantId,
    required int lockVersion,
  }) => _guard(() async {
    await _api.removeProjectDraftItem(
      packageId: packageId,
      candidateId: candidateId,
      lineId: lineId,
      variantId: variantId,
      projectVersionRequest: api.ProjectVersionRequest(
        (b) => b..lockVersion = lockVersion,
      ),
    );
  });

  Future<String> requestDraftSupplier({
    required String packageId,
    required String candidateId,
    required String vendorId,
    required ProjectData input,
    required String key,
  }) => _guard(
    () async => _guard
        .required(
          (await _api.requestProjectDraftSupplier(
            packageId: packageId,
            candidateId: candidateId,
            vendorId: vendorId,
            idempotencyKey: key,
            projectDraftSupplierRequest: _guard.required(
              _client.serializers.deserializeWith(
                api.ProjectDraftSupplierRequest.serializer,
                input,
              ),
            ),
          )).data?.data,
        )
        .id,
  );

  /// Scans from the locked Project site at [projectSearchRadiusKm]; the radius
  /// is not a parameter because the server fixes it.
  Future<api.ProjectEstimatePage> compile(String id, int version) => _guard(
    () async => _guard.required(
      (await _api.compileProjectEstimates(
        packageId: id,
        projectCompile: _guard.required(
          _client.serializers.deserializeWith(api.ProjectCompile.serializer, {
            'lock_version': version,
          }),
        ),
      )).data?.data,
    ),
  );
  Future<String> candidate(
    String id,
    ProjectData input,
    String key, {
    bool select = false,
  }) => _guard(() async {
    final body = _guard.required(
      _client.serializers.deserializeWith(
        api.ProjectCandidateRequest.serializer,
        input,
      ),
    );
    return _guard
        .required(
          select
              ? (await _api.selectProjectVendor(
                  packageId: id,
                  idempotencyKey: key,
                  projectVendorSelectionRequest: _guard.required(
                    _client.serializers.deserializeWith(
                      api.ProjectVendorSelectionRequest.serializer,
                      input,
                    ),
                  ),
                )).data?.data
              : (await _api.inquireProjectVendor(
                  packageId: id,
                  idempotencyKey: key,
                  projectCandidateRequest: body,
                )).data?.data,
        )
        .id;
  });

  /// The candidate re-priced with the Buyer's specification choices
  /// (line id → option id); the server stores nothing.
  ///
  /// [fulfillmentMethod] re-prices a Vendor that offers both Delivery and
  /// Pickup for that method.
  Future<api.ProjectCandidate> selectionPreview(
    String id,
    String candidate,
    Map<String, String> selections, {
    String? fulfillmentMethod,
  }) => _guard(
    () async => _guard.required(
      (await _api.previewProjectSpecificationSelection(
        packageId: id,
        candidateId: candidate,
        projectSelectionPreview: _guard.required(
          _client.serializers
              .deserializeWith(api.ProjectSelectionPreview.serializer, {
                'selections': specificationSelections(selections),
                'fulfillment_method': ?fulfillmentMethod,
              }),
        ),
      )).data?.data,
    ),
  );

  /// The Buyer's registered contact number (E.164), or null when the profile
  /// has none. The Work Package editor offers it as the default Site contact.
  Future<String?> profilePhone() => _guard(() async {
    final profile = (await _client.getAccountsApi().getAccountProfile(
      accountPortal: 'buyers',
    )).data?.data;
    final phone = profile?.mobileE164?.trim();
    return phone == null || phone.isEmpty ? null : phone;
  });
  Future<api.ProjectRoute> route(String id, String candidate) => _guard(
    () async => _guard.required(
      (await _api.getProjectCandidateRoute(
        packageId: id,
        candidateId: candidate,
      )).data?.data,
    ),
  );
  Future<api.ProjectImportPreview> importCsv(String csv) => _guard(
    () async => _guard.required(
      (await _api.previewWorkPackageCsv(
        projectImportRequest: api.ProjectImportRequest((b) => b..csv = csv),
      )).data?.data,
    ),
  );
  Future<api.ProjectMaterialPage> materials(String query) => _guard(
    () async => _guard.required(
      (await _api.searchProjectMaterials(query: query)).data?.data,
    ),
  );

  /// Advisory, materials-only estimate; the server stores nothing.
  Future<api.WorkPackageBudgetEstimate> estimateBudget(
    String projectId,
    ProjectData input,
  ) => _guard(
    () async => _guard.required(
      (await _api.estimateWorkPackageBudget(
        projectId: projectId,
        workPackageBudgetEstimateRequest: _guard.required(
          _client.serializers.deserializeWith(
            api.WorkPackageBudgetEstimateRequest.serializer,
            input,
          ),
        ),
      )).data?.data,
    ),
  );
  Future<api.ProjectPreferences> preferences() => _guard(
    () async =>
        _guard.required((await _api.getProjectRankingPreferences()).data?.data),
  );
  Future<api.ProjectPreferences> savePreferences(
    ProjectData input, {
    bool reset = false,
  }) => _guard(
    () async => _guard.required(
      reset
          ? (await _api.resetProjectRankingPreferences(
              projectPreferenceReset: _guard.required(
                _client.serializers.deserializeWith(
                  api.ProjectPreferenceReset.serializer,
                  input,
                ),
              ),
            )).data?.data
          : (await _api.saveProjectRankingPreferences(
              projectPreferenceSave: _guard.required(
                _client.serializers.deserializeWith(
                  api.ProjectPreferenceSave.serializer,
                  input,
                ),
              ),
            )).data?.data,
    ),
  );
  Future<api.WorkPackageView> resolve(
    String id,
    String line,
    ProjectData input,
  ) => _guard(
    () async => _guard.required(
      (await _api.resolveProjectMissingLine(
        packageId: id,
        lineId: line,
        projectMissingResolve: _guard.required(
          _client.serializers.deserializeWith(
            api.ProjectMissingResolve.serializer,
            input,
          ),
        ),
      )).data?.data,
    ),
  );
}

/// Request rows for chosen specification options.
List<ProjectData> specificationSelections(Map<String, String> selections) => [
  for (final e in selections.entries) {'line_id': e.key, 'option_id': e.value},
];

/// Only contract-declared free-form JSON is unwrapped here. Generated response models stay typed.
ProjectData projectObject(Object? value) {
  if (value is JsonObject) return projectObject(value.value);
  if (value is BuiltMap<String, JsonObject?>) {
    return value.toMap().map((key, value) => MapEntry(key, value?.value));
  }
  return value is Map ? Map<String, Object?>.from(value) : <String, Object?>{};
}

List<ProjectData> projectRows(Object? value) =>
    value is Iterable ? value.map(projectObject).toList() : [];
String projectText(Object? value) {
  if (value is EnumClass) {
    final name = value.name;
    if (name.startsWith('number') &&
        num.tryParse(name.substring(6).replaceFirst('Period', '.')) != null) {
      return name.substring(6).replaceFirst('Period', '.');
    }
    return name;
  }
  return value?.toString() ?? '';
}

int projectInt(Object? value) =>
    value is num ? value.toInt() : int.tryParse(projectText(value)) ?? 0;
String projectMoney(Object? value) {
  final amount = projectInt(value);
  return '${amount < 0 ? '-' : ''}₱${groupPesoDigits('${amount.abs() ~/ 100}')}.${(amount.abs() % 100).toString().padLeft(2, '0')}';
}

int? parseProjectMoney(String input) {
  final match = RegExp(
    r'^([0-9]{1,9}|[0-9]{1,3}(?:,[0-9]{3}){1,2})(?:\.([0-9]{1,2}))?$',
  ).firstMatch(input.trim());
  return match == null
      ? null
      : int.parse(match[1]!.replaceAll(',', '')) * 100 +
            int.parse((match[2] ?? '').padRight(2, '0'));
}

String projectKey() => newIdempotencyKey();

String projectStatus(Object? value) => projectText(value)
    .toLowerCase()
    .split('_')
    .map(
      (word) =>
          word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}',
    )
    .join(' ');
