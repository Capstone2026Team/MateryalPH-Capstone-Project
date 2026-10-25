import 'typed_project_fixtures.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/projects/material_edit_sheet.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph/features/projects/vendor_quotation_screen.dart';
import 'package:materyalph/features/projects/vendor_selection_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import 'quotation_fulfillment_choice_test.dart' show checkout, packageView;

const packageId = '01995000-0000-7000-8000-0000000000a1';
const lineId = '01995000-0000-7000-8000-0000000000b1';
const candidateId = '01995000-0000-7000-8000-0000000000c1';
const listingId = '01995000-0000-7000-8000-000000000101';
const thin = '01995000-0000-7000-8000-000000000201';
const thick = '01995000-0000-7000-8000-000000000202';

Map<String, Object?> spec(String value) => {
  'code': 'thickness_mm',
  'label': 'Thickness',
  'value': value,
  'unit_code': 'mm',
};

Map<String, Object?> option(String id, String variant, String mm, int price) =>
    {
      'option_id': id,
      'listing_id': listingId,
      'variant_id': variant,
      'display_name': 'Hollow block',
      'variant_label': '$mm mm',
      'brand': 'BrandCo',
      'unit_price_centavos': price,
      'specifications': [spec(mm)],
      'availability': 'FULFILLABLE',
    };

Map<String, Object?> allocation(String variant, String mm, int price) => {
  'variant_id': variant,
  'listing_id': listingId,
  'description': 'Hollow block',
  'variant_label': '$mm mm',
  'brand': 'BrandCo',
  'matched_quantity': '30.0000',
  'unit_price_centavos': price,
  'amount_centavos': price * 30,
  'offered_specifications': [spec(mm)],
};

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

/// One line where two thicknesses fit; [chosen] applies the 150 mm choice.
Map<String, Object?> candidate({bool chosen = false}) => {
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
  'selection_required': !chosen,
  'lines': [
    {
      'line_id': lineId,
      'name': 'Hollow blocks',
      'quantity': '30',
      'matched_quantity': '30.0000',
      'missing_quantity': '0.0000',
      'unit_code': 'PC',
      'specifications': <String, Object?>{},
      'amount_centavos': chosen ? 66000 : 45000,
      'selection_required': !chosen,
      'selected_option_id': chosen ? 'bbbbbbbbbbbbbbbb' : null,
      'options': [
        option('aaaaaaaaaaaaaaaa', thin, '100', 1500),
        option('bbbbbbbbbbbbbbbb', thick, '150', 2200),
      ],
      'allocations': [
        chosen ? allocation(thick, '150', 2200) : allocation(thin, '100', 1500),
      ],
    },
  ],
  'materials_centavos': chosen ? 66000 : 45000,
  'included_vat_centavos': 0,
  'delivery_centavos': 0,
  'processing_fee_status': 'PENDING_PAYMENT_CHANNEL',
  'projected_total_centavos': chosen ? 66000 : 45000,
  'budget_label': 'UNDER_BUDGET',
  'distance_meters': 4200,
  'distance_basis': 'GEODESIC_PROJECT_SITE_TO_STORE',
  'fulfillment_method': 'PICKUP',
  'payment_method': 'ONLINE',
  'delivery': {'status': 'NOT_APPLICABLE'},
  'destination': <String, Object?>{},
  'expires_at': '2099-01-01T00:00:00Z',
  'stale': false,
  'label': 'System-compiled estimate — advisory',
  'current_quotation_state': 'NO_INQUIRY',
  'fulfillment': fulfillmentFor(chosen ? 66000 : 45000),
  'draft_groups': <Object?>[],
  'payment_methods': [
    {'method': 'ONLINE', 'available': true},
    {'method': 'IN_STORE', 'available': false},
  ],
};

const estimate = {
  'id': '01995000-0000-7000-8000-0000000000e1',
  'version_id': '01995000-0000-7000-8000-0000000000e2',
  'created_at': '2026-10-12T00:00:00Z',
  'expires_at': '2099-01-01T00:00:00Z',
  'state': 'ACTIVE',
  'context': {'radius_km': 50},
};

Map<String, Object?> package() => {
  'id': packageId,
  'status': 'ACTIVE',
  'project_status': 'ACTIVE',
  'budget_centavos': 1000000,
  'lock_version': 3,
};

ProjectsRepository repository(List<RequestOptions> requests) =>
    ProjectsRepository(
      client: api.MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              requests.add(options);
              final path = options.uri.path;
              final Object? data = path.endsWith('/selection-preview')
                  ? candidate(chosen: true)
                  : path.endsWith('/selection')
                  ? {'id': '01995000-0000-7000-8000-0000000000d9'}
                  : path.endsWith('/work-packages/$packageId')
                  ? packageView(method: 'PICKUP')
                  : null;
              if (data == null) {
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

void main() {
  testWidgets(
    'a specification is chosen before selecting, re-priced by the server and sent with the selection',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final requests = <RequestOptions>[];
      final opened = <(String, String?)>[];
      String? order;
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: VendorQuotationScreen(
            repository: repository(requests),
            package: typedPackage(package()),
            candidate: typedCandidate(candidate()),
            estimate: typedEstimate(estimate),
            links: ProjectSourcingLinks(
              openConversation: (_, _) {},
              openOrder: (_, id) => order = id,
              openStore: (_, _) {},
              openProduct: (_, listing, variant) =>
                  opened.add((listing, variant)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('From ₱450.00'), findsOneWidget);
      expect(find.text('Materials total (lowest options)'), findsOneWidget);
      expect(
        find.text('Choose a specification for Hollow blocks to continue.'),
        findsOneWidget,
      );
      // Selecting first asks for the choice; nothing is ordered on a guess.
      await tester.tap(
        find.widgetWithText(FilledButton, 'Choose specification'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Choose a specification'), findsOneWidget);
      expect(find.text('Thickness 150 mm', findRichText: true), findsOneWidget);
      expect(requests.where((r) => r.uri.path.endsWith('/selection')), isEmpty);
      await tester.tap(find.text('Hollow block · 150 mm'));
      await tester.pumpAndSettle();

      final preview = requests.lastWhere(
        (r) =>
            r.uri.path.endsWith('/candidates/$candidateId/selection-preview'),
      );
      expect((preview.data as Map)['selections'], [
        {'line_id': lineId, 'option_id': 'bbbbbbbbbbbbbbbb'},
      ]);
      expect(find.text('₱660.00'), findsWidgets);
      expect(find.text('Change specification (2)'), findsOneWidget);
      expect(find.text('30 PC · BuildSphere'), findsOneWidget);
      expect(find.text('₱22.00 / PC · ₱660.00'), findsOneWidget);

      // The supplied product opens its Product Details on the quoted variant.
      await tester.tap(find.text('Hollow block · 150 mm'));
      await tester.pumpAndSettle();
      expect(opened, [(listingId, thick)]);

      final select = await checkout(tester, requests);
      expect((select.data as Map)['selections'], [
        {'line_id': lineId, 'option_id': 'bbbbbbbbbbbbbbbb'},
      ]);
      await tester.tap(find.text('View primary request'));
      expect(order, '01995000-0000-7000-8000-0000000000d9');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'technical details show listed values, keep long labels whole and check numbers',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const unit = '01995000-0000-7000-8000-000000000003';
      final material = {
        'id': '01995000-0000-7000-8000-0000000000a9',
        'code': 'REROLLED_STEEL_BAR',
        'name': 'Rerolled steel bar',
        'category_id': '01995000-0000-7000-8000-0000000000b9',
        'category_name': 'Steel and Reinforcement',
        'regulated': true,
        'match_type': 'EXACT',
        'matched_text': 'rerolled steel bar',
        'similarity': 1,
        'compatible_units': [
          {'id': unit, 'code': 'PC', 'name': 'Piece', 'precision': 0},
        ],
        'attributes': [
          {
            'code': 'grade',
            'label': 'Steel grade',
            'value_type': 'ENUM',
            'allowed_values': ['Grade 170', 'Grade 230'],
            'unit_code': null,
            'offered_values': ['Grade 170'],
          },
          {
            'code': 'diameter_mm',
            'label': 'Nominal diameter or leg size',
            'value_type': 'NUMBER',
            'allowed_values': null,
            'unit_code': 'mm',
            'offered_values': ['10', '15'],
          },
        ],
      };
      final client = api.MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) => handler.resolve(
              Response<Object?>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': {
                    'items': [material],
                    'units': material['compatible_units'],
                  },
                  'meta': <String, Object?>{},
                  'errors': <Object?>[],
                },
              ),
            ),
          ),
        ],
      );
      ProjectData? submitted;
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: MaterialEditSheet(
              repository: ProjectsRepository(
                client: client,
                onSessionExpired: () async {},
              ),
              initial: {
                'material_id': material['id'],
                'name': 'Rerolled steel bar',
                'unit_id': unit,
                'unit_code': 'PC',
                'quantity': '50',
                'specifications': {'diameter_mm': '15 mm'},
              },
              onSubmit: (line) => submitted = line,
              onCancel: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final diameter = find.byWidgetPredicate(
        (w) =>
            w is TextField &&
            w.decoration?.labelText == 'Nominal diameter or leg size (mm)',
      );
      // The long label gets the full row instead of being cut off.
      expect(
        tester.getSize(diameter).width,
        greaterThan(tester.getSize(find.byType(MaterialEditSheet)).width * 0.7),
      );
      expect(find.text('Listed'), findsNWidgets(2));

      await tester.tap(find.widgetWithText(FilledButton, 'Save changes'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Nominal diameter or leg size must be a number above zero, without units.',
        ),
        findsOneWidget,
      );
      expect(submitted, isNull);

      await tester.tap(find.widgetWithText(ChoiceChip, '10'));
      await tester.tap(find.widgetWithText(ChoiceChip, 'Grade 170'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Save changes'));
      await tester.pumpAndSettle();
      expect(submitted?['specifications'], {
        'grade': 'Grade 170',
        'diameter_mm': '10',
      });
      expect(tester.takeException(), isNull);
    },
  );
}
