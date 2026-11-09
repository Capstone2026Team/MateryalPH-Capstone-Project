import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/request_notice.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/device_location.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/supplier_panels.dart';
import 'package:materyalph/features/map_discovery/supplier_browsing.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph/features/projects/projects_screen.dart';
import 'package:materyalph/screens/buyer_profile_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import 'buyer_account_test.dart' as account;
import 'map_discovery_fakes.dart';
import 'projects_authoring_test.dart' as projects;

void main() {
  testWidgets('Map notice keeps saved suppliers, freshness and hidden ETAs', (
    tester,
  ) async {
    final repository = FakeDiscoveryRepository();
    final controller = DiscoveryController(repository: repository);
    final search = TextEditingController(text: 'Sampaloc');
    var locationChanges = 0;
    await controller.initialize();
    await controller.select('v-1');
    repository.searchFailure = const DiscoveryFailure(
      DiscoveryFailureKind.offline,
      'You appear to be offline. Check your connection and retry.',
    );
    await controller.refresh();
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: Scaffold(
          body: ListenableBuilder(
            listenable: controller,
            builder: (context, _) => SupplierListPanel(
              controller: controller,
              view: SupplierListView.verified,
              sort: SupplierListSort.nearest,
              searchController: search,
              onQueryChanged: (_) {},
              onSortChanged: (_) {},
              onViewChanged: (_) {},
              onExpand: () {},
              onChangeLocation: () => locationChanges++,
              onAdjustFilters: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BuyerRequestNotice), findsOneWidget);
    expect(find.text("You're offline"), findsOneWidget);
    expect(find.textContaining('Showing suppliers from'), findsOneWidget);
    expect(find.textContaining('driving times are hidden'), findsOneWidget);
    expect(controller.route, isNull);
    expect(find.text('Sampaloc Lumber Hardware'), findsWidgets);
    repository.searchFailure = null;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerRequestNotice), findsNothing);
    expect(search.text, 'Sampaloc');
    expect(controller.resultsStale, isFalse);
    repository.searchFailure = const DiscoveryFailure(
      DiscoveryFailureKind.offline,
      'You appear to be offline. Check your connection and retry.',
    );
    await controller.selectRadius(10);
    await tester.pumpAndSettle();
    expect(find.byType(BuyerRequestNotice), findsOneWidget);
    expect(find.textContaining('Showing suppliers from'), findsNothing);
    await tester.ensureVisible(find.text('Change location'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Change location'));
    expect(locationChanges, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
    search.dispose();
  });

  testWidgets('Projects refresh keeps its last page and retry recovers', (
    tester,
  ) async {
    var offline = true;
    var loads = 0;
    final client = api.MateryalphApiClient(
      dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
      interceptors: [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            loads++;
            if (offline) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.connectionError,
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
                    'items': [projects.projectFixture()],
                    'page': 1,
                    'has_more': false,
                  },
                  'meta': <String, Object?>{},
                  'errors': <Object?>[],
                },
              ),
            );
          },
        ),
      ],
    );
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: ProjectsScreen(
          repository: ProjectsRepository(
            client: client,
            onSessionExpired: () async =>
                fail('Offline must retain the session'),
          ),
          discovery: FakeDiscoveryRepository(),
          deviceLocation: FakeDeviceLocation(
            const DeviceLocationResult(DeviceLocationStatus.denied),
          ),
          mapBuilder: RecordingMap().build,
          openConversation: (_, _) {},
          openOrder: (_, _) {},
          openStore: (_, _) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BuyerRequestNotice), findsOneWidget);
    expect(find.text("You're offline"), findsOneWidget);
    offline = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Renovation'), findsOneWidget);
    offline = true;
    await tester.pump(const Duration(seconds: 45));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerRequestNotice), findsOneWidget);
    expect(find.text("You're offline"), findsOneWidget);
    expect(find.text('Renovation'), findsOneWidget);
    final beforeRetry = loads;
    offline = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(loads, beforeRetry + 1);
    expect(find.byType(BuyerRequestNotice), findsNothing);
    expect(find.text('Renovation'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'Profile uses the same notice and retry reloads account details',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var unavailable = true;
      var loads = 0;
      var signedOut = false;
      final repository = account.repository();
      repository.apiClient.dio.interceptors.insert(
        0,
        InterceptorsWrapper(
          onRequest: (options, handler) {
            loads++;
            if (unavailable) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.connectionError,
                ),
              );
            } else {
              handler.next(options);
            }
          },
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: BuyerProfileScreen(
            repository: repository,
            onSignedOut: () => signedOut = true,
            onSignOut: () async {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BuyerRequestNotice), findsOneWidget);
      expect(find.textContaining('MateryalPH is unavailable'), findsOneWidget);
      expect(signedOut, isFalse);
      expect(loads, 1);
      unavailable = false;
      await tester.ensureVisible(find.text('Retry'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.byType(BuyerRequestNotice), findsNothing);
      expect(find.text('Buyer fixture'), findsOneWidget);
      expect(signedOut, isFalse);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
