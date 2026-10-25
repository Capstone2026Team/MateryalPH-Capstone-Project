import 'typed_project_fixtures.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/supplier_map.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph/features/projects/vendor_quotation_screen.dart';
import 'package:materyalph/features/projects/vendor_selection_screen.dart';
import 'package:materyalph/features/projects/vendor_selection_widgets.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

const packageId = '01995000-0000-7000-8000-0000000000a1';
const lineId = '01995000-0000-7000-8000-0000000000b1';

/// The server's fulfillment for the fixture below: the cement line is supplied
/// in full, the hollow blocks are not at all.
Map<String, Object?> fulfillmentFixture({
  String status = 'PARTIAL',
  int fulfilled = 1,
  String blocksStatus = 'UNFULFILLED',
  String blocksRemaining = '7.0000',
  String blocksSeparate = '0.0000',
  List<Map<String, Object?>> separate = const [],
  int total = 3376700,
}) => {
  'status': status,
  'lines_total': 2,
  'lines_fulfilled': fulfilled,
  'lines_partial': 0,
  'lines_unfulfilled': 2 - fulfilled,
  'vendor_lines_fulfilled': 1,
  'lines': [
    {
      'line_id': '01995000-0000-7000-8000-0000000000b0',
      'name': 'Portland cement',
      'unit_code': 'BAG',
      'required_quantity': '10',
      'vendor_quantity': '10.0000',
      'separate_quantity': '0.0000',
      'substitute_quantity': '0.0000',
      'remaining_quantity': '0.0000',
      'status': 'FULFILLED',
    },
    {
      'line_id': lineId,
      'name': 'Hollow blocks',
      'unit_code': 'PC',
      'required_quantity': '7',
      'vendor_quantity': '0.0000',
      'separate_quantity': blocksSeparate,
      'substitute_quantity': '0.0000',
      'remaining_quantity': blocksRemaining,
      'status': blocksStatus,
    },
  ],
  'separate_items': separate,
  'separate_total_centavos': separate.fold<int>(
    0,
    (sum, s) => sum + (s['line_total_centavos'] as int),
  ),
  'combined_total_centavos':
      total +
      separate.fold<int>(
        0,
        (sum, s) => sum + (s['line_total_centavos'] as int),
      ),
};

/// A server candidate view, including the all-suppliers procurement totals the
/// server derives from the fulfillment (known delivery: none for Pickup).
Map<String, Object?> candidate(
  String id,
  String name, {
  int total = 3376700,
  Map<String, Object?>? fulfillment,
}) {
  final f = fulfillment ?? fulfillmentFixture(total: total);
  return {
    ..._candidate(id, name, total: total, fulfillment: f),
    'draft_groups': <Object?>[],
    'separate_delivery_centavos': 0,
    'procurement_materials_centavos':
        220000 + (f['separate_total_centavos'] as int),
    'procurement_delivery_centavos': 0,
    'procurement_total_centavos': f['combined_total_centavos'],
    'procurement_budget_label': 'UNDER_BUDGET',
  };
}

Map<String, Object?> _candidate(
  String id,
  String name, {
  required int total,
  required Map<String, Object?> fulfillment,
}) => {
  'id': id,
  'estimate_id': '01995000-0000-7000-8000-0000000000e1',
  'vendor_id':
      '01995000-0000-7000-8000-0000000000f${id.substring(id.length - 1)}',
  'store_name': name,
  'rank': 1,
  'latitude': 14.6,
  'longitude': 121.0,
  'score_label': '4.8',
  'vps': '96.0',
  'fms': {
    'score': '90.00',
    'components': {'material_match': '50.00'},
  },
  'complete': false,
  'fulfillment_percent': '50.00',
  'missing_lines': [
    {
      'line_id': lineId,
      'name': 'Hollow blocks',
      'quantity': '7.0000',
      'unit_code': 'PC',
      'reason': 'NO_EXACT_ACTIVE_MATCH',
    },
  ],
  'lines': [
    {
      'line_id': '01995000-0000-7000-8000-0000000000b0',
      'name': 'Portland cement',
      'quantity': '10',
      'matched_quantity': '10.0000',
      'missing_quantity': '0.0000',
      'unit_code': 'BAG',
      'amount_centavos': 220000,
      'allocations': [
        {
          'matched_quantity': '10.0000',
          'unit_price_centavos': 22000,
          'amount_centavos': 220000,
        },
      ],
    },
    {
      'line_id': lineId,
      'name': 'Hollow blocks',
      'quantity': '7',
      'matched_quantity': '0.0000',
      'missing_quantity': '7.0000',
      'unit_code': 'PC',
      'amount_centavos': 0,
      'allocations': <Object?>[],
    },
  ],
  'materials_centavos': 220000,
  'included_vat_centavos': 0,
  'delivery_centavos': 0,
  'processing_fee_status': 'PENDING_PAYMENT_CHANNEL',
  'projected_total_centavos': total,
  'budget_label': 'UNDER_BUDGET',
  'distance_meters': 2300,
  'distance_basis': 'GEODESIC_PROJECT_SITE_TO_STORE',
  'fulfillment_method': 'PICKUP',
  'payment_method': 'ONLINE',
  'delivery': {'status': 'NOT_APPLICABLE'},
  'destination': <String, Object?>{},
  'expires_at': '2099-01-01T00:00:00Z',
  'stale': false,
  'label': 'System-compiled estimate — advisory',
  'current_quotation_state': 'NO_INQUIRY',
  'is_favorite': true,
  'fulfillment': fulfillment,
};

const estimate = {
  'id': '01995000-0000-7000-8000-0000000000e1',
  'version_id': '01995000-0000-7000-8000-0000000000e2',
  'created_at': '2026-10-12T00:00:00Z',
  'expires_at': '2099-01-01T00:00:00Z',
  'state': 'ACTIVE',
  'context': {'radius_km': 50},
};

/// [legacy] is a package that already selected one Vendor before grouped
/// arrangements, which keeps the per-Vendor estimate list and its four sorts.
Map<String, Object?> package({bool legacy = false}) => {
  'id': packageId,
  if (legacy)
    'procurement_candidate_id': '01995000-0000-7000-8000-0000000000c9',
  'name': 'Masonry works',
  'status': 'ACTIVE',
  'project_status': 'ACTIVE',
  'budget_centavos': 34719400,
  'lock_version': 3,
  'current_version_id': '01995000-0000-7000-8000-0000000000e2',
  'version': {
    'content': {
      'radius_km': 50,
      'site': {
        'name': 'Warehouse - Manila City',
        'point': {
          'label': 'Warehouse - Manila City',
          'latitude': 14.6,
          'longitude': 121.0,
        },
      },
    },
  },
};

Map<String, Object?> offer(int i) => {
  'listing_id': '01995000-0000-7000-8000-00000000010$i',
  'variant_id': '01995000-0000-7000-8000-00000000020$i',
  'price_version_id': '01995000-0000-7000-8000-00000000030$i',
  'display_name': 'CHB 4in #$i',
  'vendor_id': '01995000-0000-7000-8000-00000000040$i',
  'store_name': 'Store $i',
  'unit_price_centavos': 1500 + i,
  'unit_code': 'PC',
  'unit_precision': 0,
  'distance_meters': 1000 * i,
  'stock_label': 'In Stock',
  'exact_match': i == 1,
  'availability': 'FULL',
  'estimated_total_centavos': (1500 + i) * 7,
  'fulfillment_methods': ['PICKUP'],
  'already_added': false,
  // The server sends the first photo as an object; a string schema once made the
  // whole page fail to load.
  'image': i == 2
      ? {'url': 'https://cdn.example.test/chb.jpg', 'alt_text': null}
      : null,
};

ProjectsRepository repository(
  List<RequestOptions> requests, {
  Map<String, Object?>? alternatives,
  int? alternativesFailure,
}) => ProjectsRepository(
  client: api.MateryalphApiClient(
    dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          final path = options.uri.path;
          if (alternativesFailure != null && path.endsWith('/alternatives')) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: alternativesFailure,
                ),
                type: DioExceptionType.badResponse,
              ),
            );
            return;
          }
          // Grouped arrangements are an empty page here; the per-Vendor
          // candidate views are the legacy estimate list.
          final Object? data = path.endsWith('/arrangement-options')
              ? {
                  'estimate': estimate,
                  'items': <Object?>[],
                  'page': 1,
                  'has_more': false,
                  'total': 0,
                  'unfiltered_total': 0,
                  'sort': options.uri.queryParameters['sort'] ?? 'BEST_MATCH',
                }
              : path.endsWith('/estimates')
              ? {
                  'estimate': estimate,
                  'items': [
                    candidate(
                      '01995000-0000-7000-8000-0000000000c1',
                      'BuildMart',
                    ),
                    candidate(
                      '01995000-0000-7000-8000-0000000000c2',
                      'JM Steel',
                    ),
                  ],
                  'page': 1,
                  'has_more': false,
                  'total': 2,
                  'unfiltered_total': 2,
                  'sort': options.uri.queryParameters['sort'] ?? 'BEST_MATCH',
                }
              : path.endsWith('/alternatives')
              ? alternatives ??
                    {
                      'line': {'id': lineId},
                      'status': 'CATALOG',
                      'location_id': '01995000-0000-7000-8000-0000000000d1',
                      'radius_km': 50,
                      'needed_quantity': '7.0000',
                      'excluded': {
                        'out_of_stock': 0,
                        'cannot_serve_fulfillment': 0,
                      },
                      'items': [for (var i = 1; i <= 4; i++) offer(i)],
                      'page': 1,
                      'has_more': false,
                      'total': 4,
                    }
              : null;
          if (data == null) {
            // Cart calls are not modelled here; failures stay non-blocking.
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(requestOptions: options, statusCode: 503),
                type: DioExceptionType.badResponse,
              ),
            );
            return;
          }
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'data': data,
                'meta': <String, Object?>{},
                'errors': <Object?>[],
              },
            ),
          );
        },
      ),
    ],
  ),
  onSessionExpired: () async {},
);

ProjectSourcingLinks links() => ProjectSourcingLinks(
  openConversation: (_, _) {},
  openOrder: (_, _) {},
  openStore: (_, _) {},
);

void main() {
  testWidgets('result card shows total, facts, budget status and actions', (
    tester,
  ) async {
    var viewed = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: VendorResultCard(
              candidate: typedCandidate(
                candidate('01995000-0000-7000-8000-0000000000c1', 'BuildMart'),
              ),
              selected: false,
              onSelect: () {},
              onMessage: null,
              onViewQuotation: () => viewed++,
            ),
          ),
        ),
      ),
    );
    expect(find.text('₱33,767.00'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('90.00/100'), findsOneWidget);
    expect(find.text('Under budget'), findsOneWidget);
    expect(
      find.text('1 material to source — see recommendations from other stores'),
      findsOneWidget,
    );
    expect(find.byTooltip('Preferred seller'), findsOneWidget);
    final message = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text('Message'),
        matching: find.byType(OutlinedButton),
      ),
    );
    expect(message.onPressed, isNull);
    await tester.tap(find.text('View quotation'));
    expect(viewed, 1);
  });

  testWidgets(
    'grouped comparisons offer Recommended and Price, sorted by the server',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final requests = <RequestOptions>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: VendorSelectionScreen(
            repository: repository(requests),
            package: typedPackage(package()),
            mapBuilder: (context, props) =>
                const ColoredBox(color: Colors.white),
            links: links(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Recommended'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Budget fit'), findsNothing);
      expect(find.text('Rating'), findsNothing);
      await tester.ensureVisible(find.text('Price'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Price'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Preferred sellers'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Preferred sellers'));
      await tester.pumpAndSettle();
      final last = requests.lastWhere(
        (r) => r.uri.path.endsWith('/arrangement-options'),
      );
      expect(last.uri.queryParameters['sort'], 'PRICE');
      expect(last.uri.queryParameters['direction'], 'ASC');
      expect(last.uri.queryParameters['favorites_only'], 'true');
      expect(
        requests.where(
          (r) => r.method == 'GET' && r.uri.path.endsWith('/estimates'),
        ),
        isEmpty,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('sorting and filters are requested from the server', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final requests = <RequestOptions>[];
    SupplierMapProps? map;
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: VendorSelectionScreen(
          repository: repository(requests),
          package: typedPackage(package(legacy: true)),
          mapBuilder: (context, props) {
            map = props;
            return const ColoredBox(color: Colors.white);
          },
          links: links(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('2 options'), findsOneWidget);
    // 50 km is the only radius: one read-only label, none of the old options.
    expect(find.text('Within 50 km'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Search radius 50 kilometres, fixed'),
      findsOneWidget,
    );
    for (final km in [5, 10, 20, 30, 40]) {
      expect(find.text('$km km'), findsNothing);
    }
    expect(find.byType(ChoiceChip), findsNothing);
    final recenter = map!.recenterToken;
    await tester.tap(find.byTooltip('Show the whole 50 km area'));
    await tester.pumpAndSettle();
    expect(map!.recenterToken, recenter + 1);
    expect(map?.items.length, 2);
    expect(map?.procurementContext, SupplierMapContext.projectBased);
    await tester.ensureVisible(find.text('Price'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price'));
    await tester.pumpAndSettle();
    expect(requests.last.uri.queryParameters['sort'], 'PRICE');
    await tester.ensureVisible(find.text('Preferred sellers'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preferred sellers'));
    await tester.pumpAndSettle();
    expect(requests.last.uri.queryParameters['favorites_only'], 'true');
    expect(requests.last.uri.queryParameters['sort'], 'PRICE');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'quotation recommends separate items for a missing line and tags the cart add',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final requests = <RequestOptions>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: VendorQuotationScreen(
            repository: repository(requests),
            package: typedPackage(package()),
            candidate: typedCandidate(
              candidate('01995000-0000-7000-8000-0000000000c1', 'BuildMart'),
            ),
            estimate: typedEstimate(estimate),
            links: links(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Order summary'), findsOneWidget);
      expect(find.text('10 BAG · BuildMart'), findsOneWidget);
      expect(find.text('₱220.00 / BAG · ₱2,200.00'), findsOneWidget);
      expect(find.text('Missing items'), findsOneWidget);
      expect(
        find.text('Recommended from other stores within 50 km'),
        findsOneWidget,
      );
      expect(find.byType(OfferRow), findsNWidgets(3));
      expect(find.text('View list (4)'), findsOneWidget);
      expect(
        requests
            .firstWhere((r) => r.uri.path.endsWith('/alternatives'))
            .uri
            .queryParameters['exclude_vendor_id'],
        isNotEmpty,
      );
      expect(
        find.text(
          'Set in the activated Work Package. Change it with a new Work Package version.',
        ),
        findsOneWidget,
      );
      expect(find.text('Procurement rules'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Add').first);
      await tester.pumpAndSettle();
      // Add saves a draft supplier item for this Vendor's gap; the cart is untouched.
      final add = requests.lastWhere(
        (r) => r.uri.path.contains('/draft-items/'),
      );
      expect(
        add.uri.path,
        endsWith(
          '/candidates/01995000-0000-7000-8000-0000000000c1/draft-items/$lineId/${offer(1)['variant_id']}',
        ),
      );
      final body = add.data as Map;
      expect(body['lock_version'], 3);
      expect(body['price_version_id'], offer(1)['price_version_id']);
      expect(body['fulfillment_method'], 'PICKUP');
      // The server fixes the radius and sizes the quantity; neither is sent.
      expect(body.containsKey('quantity'), isFalse);
      expect(body.containsKey('radius_km'), isFalse);
      expect(
        requests.where((r) => r.uri.path.endsWith('/cart/items')),
        isEmpty,
      );
      expect(
        requests
            .firstWhere((r) => r.uri.path.endsWith('/alternatives'))
            .uri
            .queryParameters['candidate_id'],
        '01995000-0000-7000-8000-0000000000c1',
      );

      await tester.tap(find.text('View list (4)'));
      await tester.pumpAndSettle();
      expect(find.text('Similar items for Hollow blocks'), findsOneWidget);
      expect(find.text('CHB 4in #4'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('opening Find vendors scans at the saved radius by itself', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final requests = <RequestOptions>[];
    final client = ProjectsRepository(
      client: api.MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              requests.add(options);
              final empty = options.uri.path.endsWith('/estimates');
              if (!empty) {
                handler.reject(
                  DioException(
                    requestOptions: options,
                    response: Response(
                      requestOptions: options,
                      statusCode: 503,
                    ),
                    type: DioExceptionType.badResponse,
                  ),
                );
                return;
              }
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'data': {
                      'estimate': null,
                      'items': <Object?>[],
                      'page': 1,
                      'has_more': false,
                      'total': 0,
                      'unfiltered_total': 0,
                      'sort': 'BEST_MATCH',
                    },
                    'meta': <String, Object?>{},
                    'errors': <Object?>[],
                  },
                ),
              );
            },
          ),
        ],
      ),
      onSessionExpired: () async {},
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: VendorSelectionScreen(
          repository: client,
          package: typedPackage(package()),
          mapBuilder: (context, props) => const ColoredBox(color: Colors.white),
          links: links(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // No chip tap and no confirmation: the scan starts when the screen opens.
    expect(find.text('Find Vendors within 50 km?'), findsNothing);
    final scan = requests.where((r) => r.method == 'POST').single;
    expect(scan.uri.path, endsWith('/estimates'));
    // The radius is fixed server-side, so the scan does not carry one.
    expect((scan.data as Map).containsKey('radius_km'), isFalse);

    // The provider failed in this test, so the manual scan stays available.
    expect(find.text('Find Vendors within 50 km'), findsOneWidget);
    await tester.tap(find.text('Find Vendors within 50 km'));
    await tester.pumpAndSettle();
    expect(find.text('Find Vendors within 50 km?'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(requests.where((r) => r.method == 'POST'), hasLength(2));
  });

  Future<void> pumpQuotation(
    WidgetTester tester,
    ProjectsRepository repository,
    Map<String, Object?> candidate,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: VendorQuotationScreen(
          repository: repository,
          package: typedPackage(package()),
          candidate: typedCandidate(candidate),
          estimate: typedEstimate(estimate),
          links: links(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'a failed search is a retryable connection problem, never "no matching products"',
    (tester) async {
      final requests = <RequestOptions>[];
      await pumpQuotation(
        tester,
        repository(requests, alternativesFailure: 500),
        candidate('01995000-0000-7000-8000-0000000000c1', 'BuildMart'),
      );
      expect(
        find.textContaining('connection or server problem'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);
      expect(find.textContaining('No suitable'), findsNothing);
      expect(find.textContaining('Something went wrong'), findsNothing);
    },
  );

  testWidgets('no suitable alternative names the quantity, the radius and why', (
    tester,
  ) async {
    final requests = <RequestOptions>[];
    await pumpQuotation(
      tester,
      repository(
        requests,
        alternatives: {
          'line': {'id': lineId},
          'status': 'NO_SUITABLE_ALTERNATIVE',
          'radius_km': 50,
          'needed_quantity': '7.0000',
          'excluded': {'out_of_stock': 2, 'cannot_serve_fulfillment': 0},
          'items': <Object?>[],
          'page': 1,
          'has_more': false,
          'total': 0,
        },
      ),
      candidate('01995000-0000-7000-8000-0000000000c1', 'BuildMart'),
    );
    expect(
      find.text(
        'No suitable product within 50 km for the 7 PC still needed. 2 listings are out of stock.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('5 km'), findsNothing);
  });

  testWidgets(
    'card, order summary and missing items read the same server fulfillment',
    (tester) async {
      final purchase = {
        'stage': 'IN_CART',
        'line_id': lineId,
        'variant_id': '01995000-0000-7000-8000-00000000020a',
        'listing_id': '01995000-0000-7000-8000-00000000010a',
        'display_name': 'CHB 4in',
        'vendor_id': '01995000-0000-7000-8000-00000000040a',
        'store_name': 'Block Depot',
        'quantity': '7.0000',
        'unit_code': 'PC',
        'unit_price_centavos': 1500,
        'line_total_centavos': 10500,
        'satisfies_requirement': true,
      };
      final covered = candidate(
        '01995000-0000-7000-8000-0000000000c1',
        'BuildMart',
        fulfillment: fulfillmentFixture(
          status: 'COMPLETE',
          fulfilled: 2,
          blocksStatus: 'FULFILLED',
          blocksRemaining: '0.0000',
          blocksSeparate: '7.0000',
          separate: [purchase],
        ),
      );
      // The card says what the page will say.
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: VendorResultCard(
                candidate: typedCandidate(covered),
                selected: false,
                onSelect: () {},
                onMessage: null,
                onViewQuotation: () {},
              ),
            ),
          ),
        ),
      );
      expect(find.text('2/2'), findsOneWidget);
      expect(
        find.text(
          '• All materials covered, including selected items from other suppliers',
        ),
        findsOneWidget,
      );

      final requests = <RequestOptions>[];
      await pumpQuotation(
        tester,
        repository(
          requests,
          alternatives: {
            'line': {'id': lineId},
            'status': 'COVERED',
            'radius_km': 50,
            'needed_quantity': '0.0000',
            'excluded': {'out_of_stock': 0, 'cannot_serve_fulfillment': 0},
            'items': <Object?>[],
            'page': 1,
            'has_more': false,
            'total': 0,
          },
        ),
        covered,
      );
      expect(
        find.text('Item fulfillment 2/2', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Every material covered'), findsOneWidget);
      expect(find.text('Covered'), findsOneWidget);
      expect(find.text('Earlier linked purchases'), findsOneWidget);
      expect(find.textContaining('Block Depot'), findsWidgets);
      // Totals come from the server: the Vendor's total plus the separate items.
      expect(find.text('₱33,872.00'), findsOneWidget);
      expect(find.text('Projected total · all suppliers'), findsOneWidget);
      expect(
        find.textContaining('Covered by the current arrangement'),
        findsOneWidget,
      );
    },
  );

  testWidgets('a similar product does not close the requirement', (
    tester,
  ) async {
    final substitute = {
      'stage': 'IN_CART',
      'line_id': lineId,
      'variant_id': '01995000-0000-7000-8000-00000000020b',
      'listing_id': '01995000-0000-7000-8000-00000000010b',
      'display_name': 'CHB 6in',
      'vendor_id': '01995000-0000-7000-8000-00000000040b',
      'store_name': 'Block Depot',
      'quantity': '7.0000',
      'unit_code': 'PC',
      'unit_price_centavos': 1500,
      'line_total_centavos': 10500,
      'satisfies_requirement': false,
    };
    await pumpQuotation(
      tester,
      repository(<RequestOptions>[]),
      candidate(
        '01995000-0000-7000-8000-0000000000c1',
        'BuildMart',
        fulfillment: fulfillmentFixture(separate: [substitute]),
      ),
    );
    expect(
      find.text('Item fulfillment 1/2', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.text('Different specifications — requirement remains open'),
      findsWidgets,
    );
    expect(find.text('Covered'), findsNothing);
  });

  test('labels and totals', () {
    expect(fulfillmentLabel('DELIVERY'), 'Site delivery');
    expect(paymentLabel('IN_STORE'), 'In-store payment');
    expect(fulfilledLines(typedCandidate(candidate('x', 'y'))), (1, 2));
    expect(fulfillmentSummary(typedCandidate(candidate('x', 'y'))), '1/2');
    expect(linesToSource(typedCandidate(candidate('x', 'y'))), 1);
    expect(
      deliveryFee(typedCandidate({'fulfillment_method': 'DELIVERY'})),
      'Vendor review',
    );
  });
}
