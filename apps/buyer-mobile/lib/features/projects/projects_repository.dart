import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../core/api_guard.dart';
import '../../design_system/components/peso_amount_field.dart';
import '../map_discovery/discovery_repository.dart';

typedef ProjectData = Map<String, Object?>;

/// Transport is always validated by the generated contract before entering the UI.
final class ProjectsRepository {
  ProjectsRepository({
    required api.MateryalphApiClient client,
    required Future<void> Function() onSessionExpired,
  }) : _client = client,
       _guard = ApiGuard(onSessionExpired);

  ProjectsRepository.withGuard({
    required api.MateryalphApiClient client,
    required ApiGuard guard,
  }) : _client = client,
       _guard = guard;

  final api.MateryalphApiClient _client;
  final ApiGuard _guard;
  api.BuyerProjectsApi get _api => _client.getBuyerProjectsApi();
  ProjectData _json(Object? value) {
    final checked = _guard.required(value);
    return Map<String, Object?>.from(
      _client.serializers.serializeWith(
            _client.serializers.serializerForType(checked.runtimeType)!,
            checked,
          )
          as Map,
    );
  }

  Future<ProjectData> list({int page = 1}) => _guard(
    () async => _json((await _api.listProjects(page: page)).data?.data),
  );
  Future<ProjectData> project(String id, {int page = 1}) => _guard(
    () async =>
        _json((await _api.getProject(projectId: id, page: page)).data?.data),
  );
  Future<ProjectData> package(String id, {int page = 1}) => _guard(
    () async => _json(
      (await _api.getWorkPackage(packageId: id, page: page)).data?.data,
    ),
  );
  Future<ProjectData> create(ProjectData input, String key) => _guard(
    () async => _json(
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
  Future<ProjectData> update(String id, ProjectData input, String key) =>
      _guard(
        () async => _json(
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
  Future<ProjectData> save(
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
    return _json(
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
  Future<ProjectData> activate(String id, int version, String key) => _guard(
    () async => _json(
      (await _api.activateWorkPackage(
        packageId: id,
        idempotencyKey: key,
        projectVersionRequest: api.ProjectVersionRequest(
          (b) => b..lockVersion = version,
        ),
      )).data?.data,
    ),
  );
  Future<ProjectData> reactivate(String id, int lock, String key) => _guard(
    () async => _json(
      (await _api.reactivateWorkPackage(
        packageId: id,
        idempotencyKey: key,
        projectVersionRequest: api.ProjectVersionRequest(
          (b) => b..lockVersion = lock,
        ),
      )).data?.data,
    ),
  );
  Future<ProjectData> close(String id, int version) => _guard(
    () async => _json(
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
  Future<ProjectData> estimates(
    String id, {
    int page = 1,
    String sort = 'BEST_MATCH',
    bool favoritesOnly = false,
    bool completeOnly = false,
    bool withinBudget = false,
  }) => _guard(
    () async => _json(
      (await _api.getProjectEstimates(
        packageId: id,
        page: page,
        sort: sort,
        favoritesOnly: favoritesOnly ? true : null,
        completeOnly: completeOnly ? true : null,
        withinBudget: withinBudget ? true : null,
      )).data?.data,
    ),
  );

  /// Similar Item-Based offers for a missing Work Package line.
  Future<ProjectData> alternatives(
    String packageId,
    String lineId, {
    int page = 1,
    String? excludeVendorId,
  }) => _guard(
    () async => _json(
      (await _api.listWorkPackageLineAlternatives(
        packageId: packageId,
        lineId: lineId,
        page: page,
        excludeVendorId: excludeVendorId,
      )).data?.data,
    ),
  );

  /// Adds a separate Item-Based purchase for a missing line to the cart,
  /// tagged with the line it covers (owner decision 2026-10-12).
  Future<void> addMissingToCart({
    required ProjectData offer,
    required String quantity,
    required String workPackageLineId,
    required String? locationId,
    required int radiusKm,
    required String idempotencyKey,
  }) => _guard(() async {
    await _client.getBuyerCartApi().addBuyerCartItem(
      idempotencyKey: idempotencyKey,
      cartItemCreate: api.CartItemCreate(
        (b) => b
          ..listingVariantId = projectText(offer['variant_id'])
          ..expectedPriceVersionId = projectText(offer['price_version_id'])
          ..quantity = quantity
          ..locationId = locationId
          ..radiusKm = radiusKm
          ..workPackageLineId = workPackageLineId,
      ),
    );
  });

  /// Cart lines already bought for Work Package lines, keyed by that line.
  Future<Map<String, List<ProjectData>>> taggedCartLines() => _guard(() async {
    final cart = _json(
      (await _client.getBuyerCartApi().getBuyerCart()).data?.data,
    );
    final tagged = <String, List<ProjectData>>{};
    for (final group in projectRows(cart['groups'])) {
      final vendor = projectObject(group['vendor']);
      for (final line in projectRows(group['lines'])) {
        final tag = line['work_package_line_id'];
        // Each separate purchase names the store that supplies it.
        if (tag is String) {
          (tagged[tag] ??= []).add({...line, 'store_name': vendor['name']});
        }
      }
    }
    return tagged;
  });
  Future<ProjectData> compile(String id, int version, int radius) => _guard(
    () async => _json(
      (await _api.compileProjectEstimates(
        packageId: id,
        projectCompile: _guard.required(
          _client.serializers.deserializeWith(api.ProjectCompile.serializer, {
            'lock_version': version,
            'radius_km': radius,
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
                  projectCandidateRequest: body,
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
  Future<ProjectData> selectionPreview(
    String id,
    String candidate,
    Map<String, String> selections,
  ) => _guard(
    () async => _json(
      (await _api.previewProjectSpecificationSelection(
        packageId: id,
        candidateId: candidate,
        projectSelectionPreview: _guard.required(
          _client.serializers.deserializeWith(
            api.ProjectSelectionPreview.serializer,
            {'selections': specificationSelections(selections)},
          ),
        ),
      )).data?.data,
    ),
  );
  Future<ProjectData> route(String id, String candidate) => _guard(
    () async => _json(
      (await _api.getProjectCandidateRoute(
        packageId: id,
        candidateId: candidate,
      )).data?.data,
    ),
  );
  Future<ProjectData> importCsv(String csv) => _guard(
    () async => _json(
      (await _api.previewWorkPackageCsv(
        projectImportRequest: api.ProjectImportRequest((b) => b..csv = csv),
      )).data?.data,
    ),
  );
  Future<ProjectData> materials(String query) => _guard(
    () async =>
        _json((await _api.searchProjectMaterials(query: query)).data?.data),
  );

  /// Advisory, materials-only estimate; the server stores nothing.
  Future<ProjectData> estimateBudget(String projectId, ProjectData input) =>
      _guard(
        () async => _json(
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
  Future<ProjectData> preferences() => _guard(
    () async => _json((await _api.getProjectRankingPreferences()).data?.data),
  );
  Future<ProjectData> savePreferences(
    ProjectData input, {
    bool reset = false,
  }) => _guard(
    () async => _json(
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
  Future<ProjectData> resolve(String id, String line, ProjectData input) =>
      _guard(
        () async => _json(
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

ProjectData projectObject(Object? value) =>
    value is Map ? Map<String, Object?>.from(value) : <String, Object?>{};
List<ProjectData> projectRows(Object? value) =>
    value is List ? value.map(projectObject).toList() : [];
String projectText(Object? value) => value?.toString() ?? '';
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
