import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

// Layout tests often specify only the fields they exercise. Complete their
// synthetic wire fixtures before decoding them with the generated serializers.
const _id = '01995000-0000-7000-8000-000000000001';
Map<String, Object?> _map(Object? value) =>
    value is Map ? value.cast<String, Object?>() : <String, Object?>{};

api.ProjectBudget typedBudget(Map<String, Object?> value) =>
    api.standardSerializers.deserializeWith(api.ProjectBudget.serializer, {
      'budget_centavos': 0,
      'pending_centavos': 0,
      'actual_centavos': 0,
      'awaiting_recovery_centavos': 0,
      'committed_centavos': 0,
      'remaining_centavos': 0,
      'utilization_percent': '0.00',
      'warning': false,
      'label': 'UNDER_BUDGET',
      'allocated_centavos': 0,
      'unallocated_centavos': 0,
      'pending_confirmation_count': 0,
      'processing_fee_status': 'PENDING_PAYMENT_CHANNEL_UNTIL_QUOTED',
      ...value,
    })!;

Map<String, Object?> _budgetJson(Object? value) =>
    api.standardSerializers.serializeWith(
          api.ProjectBudget.serializer,
          typedBudget(_map(value)),
        )!
        as Map<String, Object?>;

api.ProjectView typedProject(Map<String, Object?> value) =>
    api.standardSerializers.deserializeWith(api.ProjectView.serializer, {
      'id': _id,
      'name': 'Project',
      'status': 'ACTIVE',
      'budget_centavos': 0,
      'lock_version': 1,
      'packages': {'items': [], 'page': 1, 'has_more': false},
      ...value,
      'budget': _budgetJson(value['budget']),
      'sites': [
        for (final site in value['sites'] as List? ?? [])
          {
            'discovery_origin': 'SAVED_LOCATION',
            'point': <String, Object?>{},
            ..._map(site),
          },
      ],
    })!;

api.WorkPackageView typedPackage(Map<String, Object?> value) =>
    api.standardSerializers.deserializeWith(api.WorkPackageView.serializer, {
      'id': _id,
      'project_id': _id,
      'name': 'Work Package',
      'status': 'DRAFT',
      'project_status': 'ACTIVE',
      'budget_centavos': 0,
      'lock_version': 1,
      'missing_lines': [],
      'document': <String, Object?>{},
      ...value,
      'budget': _budgetJson(value['budget']),
      if (value['version'] != null)
        'version': {
          'id': _id,
          'content_hash': 'synthetic-layout-fixture',
          ..._map(value['version']),
        },
    })!;

api.ProjectCandidate typedCandidate(Map<String, Object?> value) =>
    api.standardSerializers.deserializeWith(api.ProjectCandidate.serializer, {
      'id': _id,
      'estimate_id': _id,
      'vendor_id': _id,
      'store_name': 'Store',
      'rank': 1,
      'latitude': 14.6,
      'longitude': 121.0,
      'score_label': 'New Vendor',
      'fms': <String, Object?>{},
      'complete': false,
      'fulfillment_percent': '0.00',
      'missing_lines': [],
      'lines': [],
      'materials_centavos': 0,
      'included_vat_centavos': 0,
      'processing_fee_status': 'PENDING_PAYMENT_CHANNEL',
      'budget_label': 'UNDER_BUDGET',
      'distance_meters': 0,
      'distance_basis': 'GEODESIC_PROJECT_SITE_TO_STORE',
      'fulfillment_method': 'PICKUP',
      'payment_method': 'ONLINE',
      'delivery': <String, Object?>{},
      'destination': <String, Object?>{},
      'expires_at': '2099-01-01T00:00:00Z',
      'stale': false,
      'label': 'Advisory',
      'current_quotation_state': 'NO_INQUIRY',
      'fulfillment': {
        'status': 'NONE',
        'lines_total': 0,
        'lines_fulfilled': 0,
        'lines_partial': 0,
        'lines_unfulfilled': 0,
        'vendor_lines_fulfilled': 0,
        'lines': [],
        'separate_items': [],
        'separate_total_centavos': 0,
        'combined_total_centavos': 0,
      },
      ...value,
    })!;

api.ProjectCompiledEstimate typedEstimate(Map<String, Object?> value) => api
    .standardSerializers
    .deserializeWith(api.ProjectCompiledEstimate.serializer, value)!;

api.ProjectMaterial typedMaterial(Map<String, Object?> value) =>
    api.standardSerializers.deserializeWith(api.ProjectMaterial.serializer, {
      'code': 'TEST',
      'category_id': _id,
      'compatible_units': [],
      'attributes': [],
      ...value,
    })!;

api.WorkPackageBudgetEstimate typedBudgetEstimate(Map<String, Object?> value) =>
    api.standardSerializers.deserializeWith(
      api.WorkPackageBudgetEstimate.serializer,
      {
        'unpriced_line_count': 0,
        'basis': 'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE',
        'excludes': [],
        'computed_at': '2026-10-24T00:00:00Z',
        ...value,
        'lines': [
          for (final line in value['lines'] as List? ?? [])
            {'vendor_count': 0, ..._map(line)},
        ],
      },
    )!;
