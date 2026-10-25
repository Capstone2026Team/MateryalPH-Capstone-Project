import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/supplier_route_tile.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/supplier_map.dart';
import 'package:materyalph/features/projects/project_arrangement_screen.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph/features/projects/vendor_selection_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import 'typed_project_fixtures.dart';
import 'vendor_selection_test.dart' as fixtures;

const _version = '01995000-0000-7000-8000-0000000000e2';
String _id(String suffix) => '01995000-0000-7000-8000-0000000000$suffix';

Map<String, Object?> _vendor(int n) => {
  'vendor_id': _id('f$n'),
  'candidate_id': _id('c$n'),
  'store_name': ['BuildMart', 'JM Steel', 'Concrete Supply'][n - 1],
  'latitude': 14.6 + n / 100,
  'longitude': 121.0 + n / 100,
  'distance_meters': n * 1000,
  'score_label': 'New Vendor',
  'fulfillment_method': 'DELIVERY',
  'items': [
    {'line_id': _id('b$n')},
  ],
};

Map<String, Object?> _group(int n) => {
  'id': _id('a$n'),
  'source_candidate_id': _id('c1'),
  'version': 1,
  'work_package_version_id': _version,
  'vendors': n == 1 ? [_vendor(1), _vendor(2)] : [_vendor(3)],
  'vendor_count': n == 1 ? 2 : 1,
  'coverage': {'lines_total': 2, 'lines_fulfilled': 2, 'lines_remaining': 0},
  'materials_centavos': 100000,
  'delivery_centavos': 20000,
  'total_centavos': 120000,
  'budget_label': 'UNDER_BUDGET',
  'fingerprint': 'fixture-$n',
  'issues': n == 1 ? ['Review delivery access'] : <String>[],
  'submitted': false,
  'stale': false,
  'previous_vendors': <Object?>[],
  'fms': <String, Object?>{},
};

class _RoutesHarness {
  final requests = <RequestOptions>[];
  final pending = <String, (RequestOptions, RequestInterceptorHandler)>{};
  SupplierMapProps? map;

  late final repository = ProjectsRepository(
    client: api.MateryalphApiClient(
      dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
      interceptors: [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            if (options.uri.path.endsWith('/route')) {
              pending[options.uri.pathSegments[options.uri.pathSegments.length -
                  2]] = (
                options,
                handler,
              );
              return;
            }
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': {
                    'estimate': fixtures.estimate,
                    'items': [_group(1), _group(2)],
                    'page': 1,
                    'has_more': false,
                    'total': 2,
                    'unfiltered_total': 2,
                    'sort': options.uri.queryParameters['sort'] ?? 'BEST_MATCH',
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

  Future<void> open(
    WidgetTester tester, {
    Size size = const Size(1100, 1200),
    double scale = 1,
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
            disableAnimations: true,
          ),
          child: child!,
        ),
        home: VendorSelectionScreen(
          repository: repository,
          package: typedPackage(fixtures.package()),
          links: fixtures.links(),
          mapBuilder: (context, props) {
            map = props;
            return const ColoredBox(color: Colors.white);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  void resolve(
    int n, {
    bool fail = false,
    String? version,
    String? candidate,
    String? polyline,
  }) {
    final (options, handler) = pending.remove(_id('c$n'))!;
    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: fail ? 503 : 200,
        data: {
          'data': fail
              ? null
              : {
                  'candidate_id': candidate ?? _id('c$n'),
                  'version_id': version ?? _version,
                  'origin': 'PROJECT_SITE',
                  'distance_meters': n * 4200,
                  'duration_seconds': n * 720,
                  // Two nearby points; no client-side distance or ETA estimation.
                  'encoded_polyline': polyline ?? '_ibxA_`oqVgEgE',
                  'duration_basis': 'TRAFFIC_AWARE',
                  'computed_at': '2026-10-25T00:00:00Z',
                },
          'meta': <String, Object?>{},
          'errors': fail
              ? [
                  {
                    'code': 'ROUTE_UNAVAILABLE',
                    'message': 'Route provider unavailable.',
                  },
                ]
              : <Object?>[],
        },
      ),
    );
  }

  Future<void> select(WidgetTester tester, int group) async {
    await tester.scrollUntilVisible(
      find.byKey(ValueKey(_id('a$group'))),
      250,
      scrollable: find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .first,
    );
    await tester.pumpAndSettle();
    tester
        .widgetList<ProjectArrangementCard>(find.byType(ProjectArrangementCard))
        .firstWhere((card) => card.option.id == _id('a$group'))
        .onSelect();
  }
}

void main() {
  testWidgets(
    'real generated arrangement collections render with and without issues',
    (tester) async {
      final harness = _RoutesHarness();
      await harness.open(tester);
      expect(find.byType(ProjectArrangementCard), findsWidgets);
      expect(
        find.text(
          'Review specifications or delivery details before submitting.',
        ),
        findsOneWidget,
      );
      await harness.select(tester, 2);
      expect(find.text('One Vendor for all materials'), findsOneWidget);
      await tester.pumpAndSettle();
      harness.resolve(3);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a selected group loads every route and pin/list selection reuses each result',
    (tester) async {
      final harness = _RoutesHarness();
      await harness.open(tester);
      await harness.select(tester, 1);
      await tester.pumpAndSettle();
      expect(harness.pending.keys, unorderedEquals([_id('c1'), _id('c2')]));
      expect(harness.map!.items.map((v) => v.resultId), [_id('f1'), _id('f2')]);
      expect(harness.map!.highlightedIds, {_id('f1'), _id('f2')});
      // Routes open inside the selected card, not above the list.
      expect(
        find.descendant(
          of: find.byType(ProjectArrangementCard),
          matching: find.byType(SupplierRouteTile),
        ),
        findsNWidgets(2),
      );
      expect(find.text('Calculating road route…'), findsNWidgets(2));
      harness.resolve(2);
      harness.resolve(1);
      await tester.pumpAndSettle();
      expect(
        harness.map!.routePaths.keys,
        unorderedEquals([_id('f1'), _id('f2')]),
      );
      expect(harness.map!.routePath, same(harness.map!.routePaths[_id('f1')]));
      expect(find.text('4.2 km · Est. 12 min drive'), findsOneWidget);
      expect(find.text('8.4 km · Est. 24 min drive'), findsOneWidget);
      harness.map!.onSelect(_id('f2'));
      await tester.pumpAndSettle();
      expect(harness.map!.selectedId, _id('f2'));
      expect(harness.map!.routePath, same(harness.map!.routePaths[_id('f2')]));
      await tester.tap(find.byKey(ValueKey('vendor-route:${_id('f1')}')));
      await tester.pumpAndSettle();
      expect(harness.map!.selectedId, _id('f1'));
      expect(
        harness.requests.where((r) => r.uri.path.endsWith('/route')),
        hasLength(2),
      );
      await tester.tap(find.text('Hide routes'));
      await tester.pumpAndSettle();
      expect(harness.map!.selectedId, isNull);
      expect(harness.map!.routePaths, isEmpty);
      expect(harness.map!.items, hasLength(3));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'one unavailable route can retry without losing another Vendor route',
    (tester) async {
      final harness = _RoutesHarness();
      await harness.open(tester);
      await harness.select(tester, 1);
      await tester.pumpAndSettle();
      harness.resolve(1);
      harness.resolve(2, fail: true);
      await tester.pumpAndSettle();
      // A transient provider 503 is retried once before the Buyer sees it.
      expect(find.text('Travel time unavailable'), findsNothing);
      expect(harness.pending.keys, [_id('c2')]);
      harness.resolve(2, fail: true);
      await tester.pumpAndSettle();
      expect(find.text('Travel time unavailable'), findsOneWidget);
      expect(harness.map!.routePaths.keys, [_id('f1')]);
      await tester.tap(find.text('Retry route'));
      await tester.pumpAndSettle();
      expect(harness.pending.keys, [_id('c2')]);
      expect(harness.map!.routePaths.keys, [_id('f1')]);
      harness.resolve(2);
      await tester.pumpAndSettle();
      expect(harness.map!.routePaths, hasLength(2));
      expect(find.text('Travel time unavailable'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('late results cannot replace a newly selected quotation group', (
    tester,
  ) async {
    final harness = _RoutesHarness();
    await harness.open(tester);
    await harness.select(tester, 1);
    await tester.pumpAndSettle();
    await harness.select(tester, 2);
    await tester.pumpAndSettle();
    harness.resolve(3);
    await tester.pumpAndSettle();
    harness.resolve(1);
    harness.resolve(2);
    await tester.pumpAndSettle();
    expect(harness.map!.selectedId, _id('f3'));
    expect(harness.map!.routePaths.keys, [_id('f3')]);
    expect(harness.map!.items.map((v) => v.resultId), [_id('f3')]);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'mismatched and incomplete provider results never show a route or ETA',
    (tester) async {
      final harness = _RoutesHarness();
      await harness.open(tester);
      await harness.select(tester, 1);
      await tester.pumpAndSettle();
      harness.resolve(1, version: _id('e9'));
      harness.resolve(2, polyline: '');
      await tester.pumpAndSettle();
      expect(harness.map!.routePaths, isEmpty);
      expect(find.text('Travel time unavailable'), findsNWidgets(2));
      expect(find.textContaining('Est. 12 min'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'compact card shows the rank pill, opens FMS from its badge and focuses a tapped Vendor',
    (tester) async {
      final focused = <String>[];
      final option = api.standardSerializers.deserializeWith(
        api.ProjectArrangement.serializer,
        {
          ..._group(1),
          'fms': {'score': '87.07', 'components': {}, 'weights': {}},
        },
      )!;
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProjectArrangementCard(
                option: option,
                rankingPosition: 1,
                selected: false,
                onSelect: () {},
                onReview: () {},
                onVendor: focused.add,
              ),
            ),
          ),
        ),
      );
      expect(find.text('TOP 1 — Best Match for You'), findsOneWidget);
      expect(find.text('Quotation group · 2 vendors'), findsOneWidget);
      expect(find.text('2/2 materials'), findsOneWidget);
      expect(find.text('1 material · 1.0 km · Site delivery'), findsOneWidget);
      await tester.tap(find.text('JM Steel'));
      expect(focused, [_id('f2')]);
      await tester.tap(find.text('FMS 87.07'));
      await tester.pumpAndSettle();
      expect(find.text('Why this ranking'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the Routes action keeps its label on one line on a phone', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final option = api.standardSerializers.deserializeWith(
      api.ProjectArrangement.serializer,
      _group(1),
    )!;
    for (final hidden in [true, false]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ProjectArrangementCard(
                option: option,
                rankingPosition: 1,
                selected: !hidden,
                onSelect: () {},
                onReview: () {},
                onVendor: (_) {},
                routes: hidden ? null : const SizedBox(),
                onHideRoutes: () {},
              ),
            ),
          ),
        ),
      );
      final label = find.text(hidden ? 'Routes' : 'Hide routes');
      // One line, never clipped: it stacks under View quotation instead.
      final paragraph = tester.renderObject<RenderParagraph>(label);
      expect(paragraph.didExceedMaxLines, isFalse);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'narrow screen with large text keeps the selected group and route list usable',
    (tester) async {
      final harness = _RoutesHarness();
      await harness.open(tester, size: const Size(320, 900), scale: 2);
      await harness.select(tester, 1);
      await tester.pumpAndSettle();
      harness.resolve(1);
      harness.resolve(2);
      await tester.pumpAndSettle();
      expect(find.byType(SupplierRouteTile), findsNWidgets(2));
      expect(harness.map!.routePaths, hasLength(2));
      expect(tester.takeException(), isNull);
    },
  );
}
