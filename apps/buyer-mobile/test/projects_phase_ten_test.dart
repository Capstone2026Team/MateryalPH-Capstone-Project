import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/device_location.dart';
import 'package:materyalph/features/map_discovery/supplier_map.dart';
import 'map_discovery_fakes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/work_package_attachment.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph/features/projects/projects_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

void main() {
  test(
    'opening Projects sends the current Buyer token and retains session',
    () async {
      final client = api.MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
      );
      client.setBearerAuth('passportBearer', 'project-test-token');
      var authenticated = false;
      var expired = false;
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            authenticated =
                options.headers['Authorization'] == 'Bearer project-test-token';
            if (!authenticated) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response<Object?>(
                    requestOptions: options,
                    statusCode: 401,
                  ),
                  type: DioExceptionType.badResponse,
                ),
              );
              return;
            }
            handler.resolve(
              Response<Object?>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': {
                    'items': <Object?>[],
                    'page': 1,
                    'has_more': false,
                    'total': 0,
                  },
                  'meta': <String, Object?>{},
                  'errors': <Object?>[],
                },
              ),
            );
          },
        ),
      );
      final repository = ProjectsRepository(
        client: client,
        onSessionExpired: () async {
          expired = true;
        },
      );
      final data = await repository.list();
      expect(authenticated, isTrue);
      expect(expired, isFalse);
      expect(projectRows(data['items']), isEmpty);
    },
  );
  setUpAll(() async {
    await (FontLoader('packages/lucide_icons_flutter/Lucide')..addFont(
          rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'),
        ))
        .load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'))).load();
  });
  for (final width in [390.0, 1024.0]) {
    testWidgets(
      'Project map uses the locked site and archived history is read-only at $width px',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        const projectId = '01995000-0000-7000-8000-000000000001';
        const packageId = '01995000-0000-7000-8000-000000000002';
        const siteId = '01995000-0000-7000-8000-000000000003';
        final budget = <String, Object?>{
          'budget_centavos': 100000,
          'pending_centavos': 0,
          'actual_centavos': 0,
          'awaiting_recovery_centavos': 0,
          'committed_centavos': 0,
          'remaining_centavos': 100000,
          'utilization_percent': '0.00',
          'warning': false,
          'label': 'UNDER_BUDGET',
          'allocated_centavos': 100000,
          'unallocated_centavos': 0,
          'pending_confirmation_count': 0,
          'processing_fee_status': 'PENDING_PAYMENT_CHANNEL_UNTIL_QUOTED',
        };
        final site = <String, Object?>{
          'id': siteId,
          'name': 'Locked foundation site',
          'discovery_origin': 'PROJECT_SITE',
          'point': {
            'latitude': '14.60',
            'longitude': '121.00',
            'label': 'Confirmed foundation',
            'formatted_address': 'Quezon City',
          },
        };
        final project = <String, Object?>{
          'id': projectId,
          'name': 'Home construction',
          'status': 'ARCHIVED',
          'budget_centavos': 100000,
          'lock_version': 2,
          'budget': budget,
        };
        final summary = <String, Object?>{
          'id': packageId,
          'project_id': projectId,
          'name': 'Foundation package',
          'status': 'ACTIVE',
          'budget_centavos': 100000,
          'lock_version': 1,
        };
        final version = <String, Object?>{
          'id': '01995000-0000-7000-8000-000000000004',
          'version': 1,
          'content_hash': 'saved-original',
          'locked_at': '2026-10-01T00:00:00Z',
          'content': {
            'site': site,
            'name': 'Foundation package',
            'lines': <Object?>[],
            'radius_km': 5,
            'budget_centavos': 100000,
            'fulfillment_method': 'PICKUP',
            'payment_method': 'ONLINE',
          },
        };
        final client = api.MateryalphApiClient(
          dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
          interceptors: [
            InterceptorsWrapper(
              onRequest: (request, handler) {
                final path = request.uri.path;
                Object? data;
                if (path.endsWith('/estimates')) {
                  data = {
                    'estimate': null,
                    'items': <Object?>[],
                    'page': 1,
                    'has_more': false,
                    'total': 0,
                  };
                } else if (path.endsWith('/work-packages/$packageId')) {
                  data = {
                    ...summary,
                    'project_status': 'ARCHIVED',
                    'version': version,
                    'versions': {
                      'items': [version],
                      'page': 1,
                      'has_more': false,
                    },
                    'budget': budget,
                    'missing_lines': <Object?>[],
                    'document': <String, Object?>{},
                  };
                } else if (path.endsWith('/projects/$projectId')) {
                  data = {
                    ...project,
                    'sites': [site],
                    'packages': {
                      'items': [summary],
                      'page': 1,
                      'has_more': false,
                    },
                  };
                } else {
                  data = {
                    'items': [project],
                    'page': 1,
                    'has_more': false,
                  };
                }
                handler.resolve(
                  Response<Object?>(
                    requestOptions: request,
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
        );
        final map = RecordingMap();
        String? analysisSite;
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: BuyerTheme.light,
            home: ProjectsScreen(
              repository: ProjectsRepository(
                client: client,
                onSessionExpired: () async {},
              ),
              discovery: FakeDiscoveryRepository(),
              deviceLocation: FakeDeviceLocation(
                const DeviceLocationResult(DeviceLocationStatus.denied),
              ),
              mapBuilder: (context, props) => Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color(0xfff1f5f9),
                      child: Center(
                        child: Text('Synthetic map · Project site'),
                      ),
                    ),
                  ),
                  Positioned.fill(child: map.build(context, props)),
                ],
              ),
              openConversation: (_, _) {},
              openOrder: (_, _) {},
              openStore: (_, _) {},
              openAnalysis: (_, site) => analysisSite = projectText(site['id']),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            '../../../docs/design/evidence/phase-10/buyer-project-list-${width.toInt()}.png',
          ),
        );
        await tester.tap(find.text('Home construction').last);
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            '../../../docs/design/evidence/phase-10/buyer-archived-project-${width.toInt()}.png',
          ),
        );
        await tester.tap(find.text('Sites'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Market analysis'));
        await tester.tap(find.text('Market analysis'));
        expect(analysisSite, siteId);
        await tester.tap(find.text('Work Packages').first);
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'New Work Package'),
              )
              .onPressed,
          isNull,
        );
        await tester.ensureVisible(find.text('Foundation package'));
        await tester.tap(find.text('Foundation package'));
        await tester.pumpAndSettle();
        expect(find.text('Create new version'), findsNothing);
        expect(find.text('Cancel package'), findsNothing);
        await tester.ensureVisible(find.text('Project Vendor Map'));
        await tester.tap(find.text('Project Vendor Map'));
        await tester.pumpAndSettle();
        expect(map.last.procurementContext, SupplierMapContext.projectBased);
        expect(map.last.origin!.latitude, 14.60);
        expect(map.last.origin!.longitude, 121.00);
        expect(map.last.items, isEmpty);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            '../../../docs/design/evidence/phase-10/buyer-project-map-${width.toInt()}.png',
          ),
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
  test('money input preserves centavos and rejects unsupported decimals', () {
    expect(parseProjectMoney('500000.01'), 50000001);
    expect(parseProjectMoney('25.5'), 2550);
    expect(parseProjectMoney('1.234'), isNull);
    expect(parseProjectMoney('-1'), isNull);
    expect(projectMoney(-16000), '-₱160.00');
  });
  test(
    'generated Project transport retains empty and expired states',
    () async {
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
                    'estimate': null,
                    'items': <Object?>[],
                    'page': 1,
                    'has_more': false,
                    'total': 0,
                    'suggested_radius_km': null,
                  },
                  'meta': <String, Object?>{},
                  'errors': <Object?>[],
                },
              ),
            ),
          ),
        ],
      );
      final repository = ProjectsRepository(
        client: client,
        onSessionExpired: () async => fail('Must retain session'),
      );
      final data = await repository.estimates(
        '01995000-0000-7000-8000-000000000001',
      );
      expect(data['estimate'], isNull);
      expect(projectRows(data['items']), isEmpty);
      expect(data['has_more'], false);
    },
  );
  test(
    'Project heavy restriction and radius remain strings and canonical enum values',
    () {
      final input = api.standardSerializers.deserializeWith(
        api.WorkPackageInput.serializer,
        {
          'name': 'Foundation',
          'budget_centavos': 10000,
          'site_id': '01995000-0000-7000-8000-000000000001',
          'radius_km': 5,
          'fulfillment_method': 'DELIVERY',
          'payment_method': 'ONLINE',
          'heavy_vehicle_restriction': 'YES',
          'lines': [
            {
              'material_id': '01995000-0000-7000-8000-000000000002',
              'name': 'Blocks',
              'unit_id': '01995000-0000-7000-8000-000000000003',
              'quantity': '10',
              'specifications': <String, String>{},
              'preferred_brand': null,
            },
          ],
        },
      );
      expect(
        input!.heavyVehicleRestriction,
        api.WorkPackageInputHeavyVehicleRestrictionEnum.YES,
      );
      expect(
        (api.standardSerializers.serializeWith(
              api.WorkPackageInput.serializer,
              input,
            )
            as Map)['heavy_vehicle_restriction'],
        'YES',
      );
    },
  );
  testWidgets('locked original and proposal switch at the 1024 px breakpoint', (
    tester,
  ) async {
    const original = <String, Object?>{
      'name': 'Foundation',
      'fulfillment_method': 'PICKUP',
      'payment_method': 'ONLINE',
      'lines': [
        {'name': 'Blocks', 'quantity': '10', 'unit_code': 'PC'},
      ],
    };
    for (final width in [1100.0, 900.0]) {
      tester.view.physicalSize = Size(width, 1200);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: WorkPackageAttachment(
                original: original,
                proposed: {
                  'lines': [
                    {'description': 'Proposed blocks', 'quantity': '8'},
                  ],
                },
                version: 1,
              ),
            ),
          ),
        ),
      );
      final left = tester.getRect(
            find.text('Locked Buyer original · version 1'),
          ),
          right = tester.getRect(find.text('Vendor proposal'));
      if (width >= 1024) {
        expect(right.left, greaterThan(left.right));
        expect(right.top, left.top);
      } else {
        expect(right.top, greaterThan(left.bottom));
      }
      expect(tester.takeException(), isNull);
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  testWidgets(
    'budget warning shows all three buckets without double subtraction',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProjectBudgetCard(
              budget: {
                'budget_centavos': 30000,
                'pending_centavos': 10000,
                'actual_centavos': 10000,
                'awaiting_recovery_centavos': 8000,
                'committed_centavos': 28000,
                'remaining_centavos': 2000,
                'warning': true,
                'utilization_percent': '93.33',
                'label': 'UNDER_BUDGET',
              },
            ),
          ),
        ),
      );
      expect(find.text('Remaining ₱20.00'), findsOneWidget);
      expect(
        find.textContaining('paid cancelled', findRichText: true),
        findsNothing,
      );
      expect(
        find.text('Paid cancelled amount awaiting recovery'),
        findsOneWidget,
      );
      expect(find.text('₱80.00'), findsOneWidget);
      expect(find.textContaining('93.33% utilized'), findsOneWidget);
    },
  );
}
