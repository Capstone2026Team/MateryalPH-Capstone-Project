import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph/features/projects/vendor_selection_screen.dart';
import 'package:materyalph/features/projects/vendor_selection_widgets.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import 'vendor_selection_test.dart'
    show candidate, estimate, links, package, packageId;

const cheap = '01995000-0000-7000-8000-0000000000c1';
const dear = '01995000-0000-7000-8000-0000000000c2';

/// Serves the list the way the server orders it: Price cheapest first unless
/// `direction=DESC`, every other ordering as the default.
ProjectsRepository repository(List<RequestOptions> requests) =>
    ProjectsRepository(
      client: api.MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              requests.add(options);
              if (!options.uri.path.endsWith('/estimates')) {
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
              final sort = options.uri.queryParameters['sort'] ?? 'BEST_MATCH';
              final direction = options.uri.queryParameters['direction'];
              final cheapFirst = sort == 'PRICE' && direction != 'DESC';
              final items = [
                candidate(cheap, 'Cheap Store', total: 1000000),
                candidate(dear, 'Dear Store', total: 2000000),
              ];
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'data': {
                      'estimate': estimate,
                      'items': cheapFirst ? items : items.reversed.toList(),
                      'page': 1,
                      'has_more': false,
                      'total': 2,
                      'unfiltered_total': 2,
                      'sort': sort,
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

Future<List<RequestOptions>> pumpScreen(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final requests = <RequestOptions>[];
  await tester.pumpWidget(
    MaterialApp(
      theme: BuyerTheme.light,
      home: VendorSelectionScreen(
        repository: repository(requests),
        package: package(legacy: true),
        mapBuilder: (context, props) => const ColoredBox(color: Colors.white),
        links: links(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return requests;
}

Map<String, String> lastList(List<RequestOptions> requests) => requests
    .lastWhere((r) => r.method == 'GET' && r.uri.path.endsWith('/estimates'))
    .uri
    .queryParameters;

Future<void> tapTab(WidgetTester tester, String label) async {
  final tab = find.text(label);
  await tester.ensureVisible(tab);
  await tester.pumpAndSettle();
  await tester.tap(tab);
  await tester.pumpAndSettle();
}

/// The direction arrows in the tab row: Budget fit, Rating and Price only.
Finder arrows(IconData icon) => find.byIcon(icon);

/// The Vendor shown first; the list builds cards lazily.
String firstStore(WidgetTester tester) =>
    tester
            .widget<VendorResultCard>(find.byType(VendorResultCard).first)
            .candidate['store_name']!
        as String;

void main() {
  testWidgets('Best match has no arrow; the other three tabs have one each', (
    tester,
  ) async {
    await pumpScreen(tester);
    expect(
      find.descendant(
        of: find.bySemanticsLabel('Best match'),
        matching: find.byType(Icon),
      ),
      findsNothing,
    );
    // Budget fit and Rating open high to low, Price low to high.
    expect(arrows(LucideIcons.arrowDown), findsNWidgets(2));
    expect(arrows(LucideIcons.arrowUp), findsOneWidget);
  });

  testWidgets(
    'Price opens cheapest first and a second tap flips the order and the arrow',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final requests = await pumpScreen(tester);
      // Best match is selected first: the server is asked for no direction.
      expect(lastList(requests)['sort'], 'BEST_MATCH');
      expect(lastList(requests).containsKey('direction'), isFalse);

      await tapTab(tester, 'Price');
      expect(lastList(requests)['sort'], 'PRICE');
      expect(lastList(requests)['direction'], 'ASC');
      expect(
        find.bySemanticsLabel('Sort by Price, low to high'),
        findsOneWidget,
      );
      expect(firstStore(tester), 'Cheap Store');
      expect(arrows(LucideIcons.arrowUp), findsOneWidget);

      await tapTab(tester, 'Price');
      expect(lastList(requests)['direction'], 'DESC');
      expect(
        find.bySemanticsLabel('Sort by Price, high to low'),
        findsOneWidget,
      );
      expect(firstStore(tester), 'Dear Store');
      // The arrow flipped with the order: every tab now points down.
      expect(arrows(LucideIcons.arrowUp), findsNothing);
      expect(arrows(LucideIcons.arrowDown), findsNWidgets(3));

      await tapTab(tester, 'Price');
      expect(lastList(requests)['direction'], 'ASC');
      semantics.dispose();
    },
  );

  testWidgets('switching tabs resets the new tab to its own default', (
    tester,
  ) async {
    final requests = await pumpScreen(tester);
    await tapTab(tester, 'Price');
    await tapTab(tester, 'Price');
    expect(lastList(requests)['direction'], 'DESC');

    await tapTab(tester, 'Rating');
    expect(lastList(requests)['sort'], 'RATING');
    expect(lastList(requests)['direction'], 'DESC');
    await tapTab(tester, 'Rating');
    expect(lastList(requests)['direction'], 'ASC');

    // Coming back to Price starts it cheapest first again, not where it was left.
    await tapTab(tester, 'Price');
    expect(lastList(requests)['direction'], 'ASC');
    await tapTab(tester, 'Budget fit');
    expect(lastList(requests)['direction'], 'DESC');

    // Best match drops the direction; tapping it again asks for nothing more.
    await tapTab(tester, 'Best match');
    expect(lastList(requests)['sort'], 'BEST_MATCH');
    expect(lastList(requests).containsKey('direction'), isFalse);
    final calls = requests.length;
    await tapTab(tester, 'Best match');
    expect(requests.length, calls);
  });

  testWidgets('a filter keeps the selected sort and direction', (tester) async {
    final requests = await pumpScreen(tester);
    await tapTab(tester, 'Price');
    await tapTab(tester, 'Price');
    await tester.ensureVisible(find.text('Preferred sellers'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preferred sellers'));
    await tester.pumpAndSettle();
    expect(lastList(requests)['sort'], 'PRICE');
    expect(lastList(requests)['direction'], 'DESC');
    expect(lastList(requests)['favorites_only'], 'true');
  });

  testWidgets('only the selected tab shows an active arrow', (tester) async {
    await pumpScreen(tester);
    Color colorOf(IconData icon, int index) =>
        tester.widget<Icon>(arrows(icon).at(index)).color!;
    // Down arrows are Budget fit then Rating; the up arrow is Price.
    await tapTab(tester, 'Price');
    expect(colorOf(LucideIcons.arrowUp, 0), BuyerTheme.action);
    expect(colorOf(LucideIcons.arrowDown, 0).a, lessThan(0.6));
    expect(colorOf(LucideIcons.arrowDown, 1).a, lessThan(0.6));
    await tapTab(tester, 'Rating');
    expect(colorOf(LucideIcons.arrowDown, 1), BuyerTheme.action);
    expect(colorOf(LucideIcons.arrowUp, 0).a, lessThan(0.6));
  });

  testWidgets('each arrow tab keeps a 44 px target', (tester) async {
    await pumpScreen(tester);
    for (final label in ['Best match', 'Budget fit', 'Rating', 'Price']) {
      final tab = find.ancestor(
        of: find.text(label),
        matching: find.byType(InkWell),
      );
      final size = tester.getSize(tab.first);
      expect(size.height, greaterThanOrEqualTo(44), reason: label);
      expect(size.width, greaterThanOrEqualTo(44), reason: label);
    }
  });

  testWidgets('a long list returns to the top when it is re-sorted', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1100, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final requests = <RequestOptions>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: VendorSelectionScreen(
          repository: repository(requests),
          package: package(legacy: true),
          mapBuilder: (context, props) => const ColoredBox(color: Colors.white),
          links: links(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final list = find.byType(ListView);
    final scroll = tester.state<ScrollableState>(
      find.descendant(of: list, matching: find.byType(Scrollable)).first,
    );
    // The test font is wider than the real one, so bring Price into the row first.
    await tester.ensureVisible(find.text('Price'));
    // Scrolled a little, so the tabs are still on screen.
    scroll.position.jumpTo(120);
    await tester.pump();
    expect(scroll.position.pixels, 120);
    await tester.tap(find.text('Price'));
    await tester.pumpAndSettle();
    expect(scroll.position.pixels, 0);
  });

  test('labels and server direction', () {
    expect(vendorSortLabel('Price', false), 'Sort by Price, low to high');
    expect(vendorSortLabel('Rating', true), 'Sort by Rating, high to low');
    expect(vendorSortDirection(true), 'DESC');
    expect(vendorSortDirection(false), 'ASC');
    expect(vendorSortDescending.containsKey('BEST_MATCH'), isFalse);
    expect(packageId, isNotEmpty);
  });
}
