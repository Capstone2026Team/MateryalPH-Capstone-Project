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

Map<String, Object?> candidate(String id, String name, {int total = 3376700}) =>
    {
      'id': id,
      'estimate_id': '01995000-0000-7000-8000-0000000000e1',
      'vendor_id': '01995000-0000-7000-8000-0000000000f$id'.substring(0, 36),
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
            {'matched_quantity': '10.0000', 'unit_price_centavos': 22000},
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
    };

const estimate = {
  'id': '01995000-0000-7000-8000-0000000000e1',
  'version_id': '01995000-0000-7000-8000-0000000000e2',
  'created_at': '2026-10-12T00:00:00Z',
  'expires_at': '2099-01-01T00:00:00Z',
  'state': 'ACTIVE',
  'context': {'radius_km': 5},
};

Map<String, Object?> package() => {
  'id': packageId,
  'name': 'Masonry works',
  'status': 'ACTIVE',
  'project_status': 'ACTIVE',
  'budget_centavos': 34719400,
  'lock_version': 3,
  'current_version_id': '01995000-0000-7000-8000-0000000000e2',
  'version': {
    'content': {
      'radius_km': 5,
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
};

ProjectsRepository repository(
  List<RequestOptions> requests,
) => ProjectsRepository(
  client: api.MateryalphApiClient(
    dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          final path = options.uri.path;
          final Object? data = path.endsWith('/estimates')
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
              ? {
                  'line': {'id': lineId},
                  'status': 'CATALOG',
                  'location_id': '01995000-0000-7000-8000-0000000000d1',
                  'radius_km': 5,
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
              candidate: candidate(
                '01995000-0000-7000-8000-0000000000c1',
                'BuildMart',
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
    expect(find.text('• 1 material missing — buy separately'), findsOneWidget);
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
          package: package(),
          mapBuilder: (context, props) {
            map = props;
            return const ColoredBox(color: Colors.white);
          },
          links: links(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Found 2 Vendors within 5 km'), findsOneWidget);
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
            package: package(),
            candidate: candidate(
              '01995000-0000-7000-8000-0000000000c1',
              'BuildMart',
            ),
            estimate: estimate,
            links: links(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Order summary'), findsOneWidget);
      expect(find.text('10 BAG × ₱220.00 · Sold by BuildMart'), findsOneWidget);
      expect(find.text('Missing items'), findsOneWidget);
      expect(find.text('This Vendor has no exact match'), findsOneWidget);
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

      await tester.tap(find.widgetWithText(FilledButton, 'Add').first);
      await tester.pumpAndSettle();
      final add = requests.lastWhere((r) => r.uri.path.endsWith('/cart/items'));
      final body = add.data as Map;
      expect(body['work_package_line_id'], lineId);
      expect(body['quantity'], '7');
      expect(body['radius_km'], 5);

      await tester.tap(find.text('View list (4)'));
      await tester.pumpAndSettle();
      expect(find.text('Similar items for Hollow blocks'), findsOneWidget);
      expect(find.text('CHB 4in #4'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the preselected radius scans when no scan exists yet', (
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
          package: package(),
          mapBuilder: (context, props) => const ColoredBox(color: Colors.white),
          links: links(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('No scan yet'), findsOneWidget);
    expect(find.text('Find Vendors within 5 km'), findsOneWidget);

    await tester.tap(find.text('5 km'));
    await tester.pumpAndSettle();
    expect(find.text('Find Vendors within 5 km?'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    final scan = requests.where((r) => r.method == 'POST').single;
    expect(scan.uri.path, endsWith('/estimates'));
    expect((scan.data as Map)['radius_km'], 5);
  });

  test('labels and totals', () {
    expect(fulfillmentLabel('DELIVERY'), 'Site delivery');
    expect(paymentLabel('IN_STORE'), 'In-store payment');
    expect(fulfilledLines(candidate('x', 'y')), (1, 2));
    expect(deliveryFee({'fulfillment_method': 'DELIVERY'}), 'Vendor review');
  });
}
