import 'typed_project_fixtures.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph/features/projects/vendor_quotation_screen.dart';
import 'package:materyalph/features/projects/vendor_selection_screen.dart';
import 'package:materyalph/features/projects/vendor_selection_widgets.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

const packageId = '01995000-0000-7000-8000-0000000000a1';
const candidateId = '01995000-0000-7000-8000-0000000000c1';
const orderId = '01995000-0000-7000-8000-0000000000d9';

/// The server's fulfillment for a quotation whose one line is supplied in full.
Map<String, Object?> fulfillmentFor(int total) => {
  'status': 'COMPLETE',
  'lines_total': 1,
  'lines_fulfilled': 1,
  'lines_partial': 0,
  'lines_unfulfilled': 0,
  'vendor_lines_fulfilled': 1,
  'lines': <Object?>[],
  'separate_items': <Object?>[],
  'separate_total_centavos': 0,
  'combined_total_centavos': total,
};

/// A Both-package candidate as the server returns it: priced for [method],
/// with [options] naming what the Vendor offers.
Map<String, Object?> candidate({
  String method = 'PICKUP',
  List<String> options = const ['DELIVERY', 'PICKUP'],
}) {
  final delivery = method == 'DELIVERY';
  return {
    'id': candidateId,
    'estimate_id': '01995000-0000-7000-8000-0000000000e1',
    'vendor_id': '01995000-0000-7000-8000-0000000000f1',
    'store_name': 'BuildSphere',
    'rank': 1,
    'latitude': 14.6,
    'longitude': 121.0,
    'score_label': 'New Vendor',
    'fms': {'score': '90.00', 'components': <String, Object?>{}},
    'complete': true,
    'fulfillment_percent': '100.00',
    'missing_lines': <Object?>[],
    'selection_required': false,
    'lines': <Object?>[],
    'materials_centavos': 45000,
    'included_vat_centavos': 0,
    'delivery_centavos': delivery ? 60500 : 0,
    'processing_fee_status': 'PENDING_PAYMENT_CHANNEL',
    'projected_total_centavos': delivery ? 105500 : 45000,
    'budget_label': 'UNDER_BUDGET',
    'distance_meters': 4200,
    'distance_basis': 'GEODESIC_PROJECT_SITE_TO_STORE',
    'fulfillment_method': method,
    'fulfillment_options': options,
    'payment_method': 'ONLINE',
    'delivery': delivery
        ? {'status': 'ADVISORY_ESTIMATE'}
        : {'status': 'NOT_APPLICABLE'},
    'destination': {'type': method},
    'expires_at': '2099-01-01T00:00:00Z',
    'stale': false,
    'label': 'System-compiled estimate — advisory',
    'current_quotation_state': 'NO_INQUIRY',
    'fulfillment': fulfillmentFor(delivery ? 105500 : 45000),
    'draft_groups': <Object?>[],
    'payment_methods': [
      {'method': 'ONLINE', 'available': true},
      {
        'method': delivery ? 'CASH_ON_DELIVERY' : 'IN_STORE',
        'available': false,
      },
    ],
  };
}

/// The Work Package as the checkout reloads it before pricing.
Map<String, Object?> packageView({String method = 'BOTH'}) => {
  ...package(method: method),
  'project_id': '01995000-0000-7000-8000-0000000000b9',
  'name': 'Roof framing',
  'version': {
    'id': '01995000-0000-7000-8000-0000000000e2',
    'version': 1,
    'content_hash': 'fixture',
    'locked_at': '2026-10-01T00:00:00Z',
    'content': {'fulfillment_method': method, 'lines': <Object?>[]},
  },
  'budget': {
    'budget_centavos': 1000000,
    'pending_centavos': 0,
    'actual_centavos': 0,
    'awaiting_recovery_centavos': 0,
    'committed_centavos': 0,
    'remaining_centavos': 1000000,
    'utilization_percent': '0.00',
    'warning': false,
    'label': 'UNDER_BUDGET',
    'allocated_centavos': 1000000,
    'unallocated_centavos': 0,
    'pending_confirmation_count': 0,
    'processing_fee_status': 'PENDING_PAYMENT_CHANNEL_UNTIL_QUOTED',
  },
  'missing_lines': <Object?>[],
  'document': <String, Object?>{},
};

const estimate = {
  'id': '01995000-0000-7000-8000-0000000000e1',
  'version_id': '01995000-0000-7000-8000-0000000000e2',
  'created_at': '2026-10-12T00:00:00Z',
  'expires_at': '2099-01-01T00:00:00Z',
  'state': 'ACTIVE',
  'context': {'radius_km': 50},
};

Map<String, Object?> package({String method = 'BOTH'}) => {
  'id': packageId,
  'status': 'ACTIVE',
  'project_status': 'ACTIVE',
  'budget_centavos': 1000000,
  'lock_version': 3,
  'version': {
    'content': {'fulfillment_method': method},
  },
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
          final Object? data = path.endsWith('/selection-preview')
              ? candidate(
                  method: (options.data as Map)['fulfillment_method'] as String,
                )
              : path.endsWith('/selection') || path.endsWith('/inquiries')
              ? {'id': orderId}
              : path.endsWith('/work-packages/$packageId')
              ? packageView()
              : null;
          if (data == null) {
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
              statusCode: path.endsWith('/selection') ? 201 : 200,
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

Future<void> pumpQuotation(
  WidgetTester tester,
  List<RequestOptions> requests, {
  required Map<String, Object?> candidate,
  String packageMethod = 'BOTH',
  void Function(String id)? onOrder,
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 1800));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: BuyerTheme.light,
      home: VendorQuotationScreen(
        repository: repository(requests),
        package: typedPackage(package(method: packageMethod)),
        candidate: typedCandidate(candidate),
        estimate: typedEstimate(estimate),
        links: ProjectSourcingLinks(
          openConversation: (_, _) {},
          openOrder: (_, id) => onOrder?.call(id),
          openStore: (_, _) {},
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Selects the quotation and completes its checkout: pay online, confirm the
/// review, continue, then send the primary request. Returns that request.
Future<RequestOptions> checkout(
  WidgetTester tester,
  List<RequestOptions> requests,
) async {
  await tester.tap(find.widgetWithText(FilledButton, 'Select this quotation'));
  await tester.pumpAndSettle();
  expect(find.text('Selection checklist'), findsOneWidget);
  await tester.ensureVisible(find.text('Online payment'));
  await tester.tap(find.text('Online payment'));
  await tester.pumpAndSettle();
  final review = find.text(
    'I reviewed the items, specifications, quantities and payment choices.',
  );
  await tester.ensureVisible(review);
  await tester.tap(review);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue to quotation checkout'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Send request to primary Vendor'));
  await tester.pumpAndSettle();
  return requests.lastWhere((r) => r.uri.path.endsWith('/selection'));
}

void main() {
  testWidgets(
    'a Vendor offering both lets the Buyer pick, re-prices it and sends the pick with the selection',
    (tester) async {
      final requests = <RequestOptions>[];
      String? order;
      await pumpQuotation(
        tester,
        requests,
        candidate: candidate(),
        onOrder: (id) => order = id,
      );
      expect(
        find.text(
          'This Vendor offers both. Pick one; the totals update for it.',
        ),
        findsOneWidget,
      );
      expect(find.text('₱450.00'), findsWidgets);

      await tester.tap(find.text('Site delivery'));
      await tester.pumpAndSettle();
      final preview = requests.lastWhere(
        (r) =>
            r.uri.path.endsWith('/candidates/$candidateId/selection-preview'),
      );
      expect((preview.data as Map)['fulfillment_method'], 'DELIVERY');
      expect(find.text('₱1,055.00'), findsWidgets);
      expect(find.text('Delivery configuration'), findsOneWidget);

      final select = await checkout(tester, requests);
      expect((select.data as Map)['fulfillment_method'], 'DELIVERY');
      expect((select.data as Map)['payment_method'], 'ONLINE');
      await tester.tap(find.text('View primary request'));
      expect(order, orderId);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('a Vendor offering one method stays locked and sends its method', (
    tester,
  ) async {
    final requests = <RequestOptions>[];
    await pumpQuotation(
      tester,
      requests,
      candidate: candidate(options: const ['PICKUP']),
    );
    expect(
      find.text(
        'Your Work Package accepts either. This Vendor offers self pick-up only.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Site delivery'));
    await tester.pumpAndSettle();
    expect(
      requests.where((r) => r.uri.path.endsWith('/selection-preview')),
      isEmpty,
    );

    // The checkout prices and requests the one method the Vendor offers.
    final select = await checkout(tester, requests);
    expect((select.data as Map)['fulfillment_method'], 'PICKUP');
  });

  test('the card names the priced method and the other one on offer', () {
    expect(
      candidateFulfillmentLabel(typedCandidate(candidate())),
      'Self pick-up · site delivery also offered',
    );
    expect(
      candidateFulfillmentLabel(
        typedCandidate(candidate(options: const ['PICKUP'])),
      ),
      'Self pick-up',
    );
    expect(needsFulfillmentChoice(typedCandidate(candidate())), isTrue);
    expect(
      needsFulfillmentChoice(
        typedCandidate(candidate(options: const ['PICKUP'])),
      ),
      isFalse,
    );
  });
}
