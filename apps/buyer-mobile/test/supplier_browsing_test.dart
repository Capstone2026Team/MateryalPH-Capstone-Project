import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/supplier_browsing.dart';
import 'package:materyalph/features/map_discovery/supplier_panels.dart';

import 'map_discovery_fakes.dart';

SupplierResultView _store(
  String id,
  String name, {
  bool verified = false,
  bool favorite = false,
  bool newVendor = false,
  int distance = 1000,
  String? rating,
}) => SupplierResultView(
  resultId: id,
  name: name,
  rank: 1,
  tier: verified ? SupplierTier.verified : SupplierTier.directory,
  point: const GeoPoint(14.6, 121),
  distanceMeters: distance,
  scoreKind: verified
      ? (newVendor ? ScoreKind.newVendor : ScoreKind.vps)
      : ScoreKind.directory,
  scoreText: verified
      ? (newVendor ? 'New Vendor' : 'VPS $rating')
      : 'Directory',
  scoreValue: verified ? rating : null,
  googleRating: verified ? null : rating,
  googleRatingCount: verified || rating == null ? null : 12,
  isFavorite: favorite,
);

final _stores = [
  _store(
    'v1',
    'Manila Building Supply',
    verified: true,
    favorite: true,
    rating: '4.2',
    distance: 1800,
  ),
  _store('v2', 'Panda Hardware', verified: true, rating: '4.8', distance: 900),
  _store(
    'v3',
    'New Manila Hardware',
    verified: true,
    newVendor: true,
    rating: '5.0',
    distance: 400,
  ),
  _store('d1', 'Panda Construction Supply', rating: '4.7', distance: 690),
  _store('d2', 'R Hidalgo Hardware', rating: '3.0', distance: 465),
  _store('d3', 'P. Casal Construction Supply', distance: 214),
];

List<String> _ids(List<SupplierResultView> items) =>
    items.map((i) => i.resultId).toList();

class _Panel extends StatefulWidget {
  const _Panel(this.controller);
  final DiscoveryController controller;
  @override
  State<_Panel> createState() => _PanelState();
}

class _PanelState extends State<_Panel> {
  final search = TextEditingController();
  var view = SupplierListView.verified;
  var sort = SupplierListSort.nearest;
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) => SupplierListPanel(
      controller: widget.controller,
      view: view,
      sort: sort,
      searchController: search,
      onQueryChanged: (_) => setState(() {}),
      onViewChanged: (value) => setState(() => view = value),
      onSortChanged: (value) => setState(() => sort = value),
      onExpand: () {},
      onChangeLocation: () {},
      onAdjustFilters: () {},
    ),
  );
}

Future<(DiscoveryController, FakeDiscoveryRepository)> _pump(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double scale = 1,
}) async {
  await tester.binding.setSurfaceSize(size);
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(() {
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    return tester.binding.setSurfaceSize(null);
  });
  final repo = FakeDiscoveryRepository(page: resultPage(_stores));
  final controller = DiscoveryController(repository: repo);
  await controller.initialize();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      theme: BuyerTheme.light,
      home: Scaffold(
        body: RepaintBoundary(
          key: const ValueKey('supplier-preview'),
          child: Material(color: Colors.white, child: _Panel(controller)),
        ),
      ),
    ),
  );
  await tester.pump();
  return (controller, repo);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'))).load();
    await (FontLoader('packages/lucide_icons_flutter/Lucide')..addFont(
          rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'),
        ))
        .load();
  });
  setUp(() => WidgetController.hitTestWarningShouldBeFatal = true);
  tearDown(() => WidgetController.hitTestWarningShouldBeFatal = false);

  for (final scenario in [
    ('Directory toggle off', const DiscoveryFilters(includeDirectory: false)),
    ('supplier type active', const DiscoveryFilters(supplierType: 'OTHER')),
    ('category active', const DiscoveryFilters(categoryId: 'cement')),
  ]) {
    testWidgets(
      '${scenario.$1} hides the Directory section and recovers the selected view',
      (tester) async {
        final (controller, repo) = await _pump(tester);
        await tester.tap(find.byKey(const ValueKey('supplier-view-directory')));
        await tester.pump();
        await tester.enterText(
          find.byKey(const ValueKey('supplier-name-search')),
          'Panda',
        );
        await tester.pump();
        repo.page = resultPage(
          _stores.where((store) => store.isVerified).toList(),
          directoryStatus: scenario.$2.tierSpecific ? 'FILTERED_OUT' : 'HIDDEN',
        );
        await controller.applyFilters(scenario.$2);
        await tester.pump();

        expect(
          find.byKey(const ValueKey('supplier-view-directory')),
          findsNothing,
        );
        expect(find.textContaining('0 Directory'), findsNothing);
        expect(
          tester
              .widget<ChoiceChip>(
                find.byKey(const ValueKey('supplier-view-verified')),
              )
              .selected,
          isTrue,
        );
        expect(find.text('Panda Hardware'), findsOneWidget);
        expect(find.text('Panda Construction Supply'), findsNothing);
        expect(
          find.byKey(const ValueKey('supplier-view-favorites')),
          findsOneWidget,
        );
        expect(
          tester
              .widget<TextField>(
                find.byKey(const ValueKey('supplier-name-search')),
              )
              .controller!
              .text,
          'Panda',
        );

        repo.page = resultPage(_stores);
        await controller.applyFilters(const DiscoveryFilters());
        await tester.pump();
        expect(
          find.byKey(const ValueKey('supplier-view-directory')),
          findsOneWidget,
        );
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  testWidgets('Favorites only keeps both supplier tier sections available', (
    tester,
  ) async {
    final (controller, repo) = await _pump(tester);
    repo.page = resultPage(_stores.where((store) => store.isFavorite).toList());
    await controller.applyFilters(const DiscoveryFilters(favoritesOnly: true));
    await tester.pump();
    for (final view in SupplierListView.values) {
      expect(
        find.byKey(ValueKey('supplier-view-${view.name}')),
        findsOneWidget,
      );
    }
    await tester.pumpWidget(const SizedBox());
  });

  test(
    'store-name search is case-insensitive, handles spaces and applies to each tier',
    () {
      expect(
        _ids(
          browseSuppliers(
            _stores,
            view: SupplierListView.directory,
            sort: SupplierListSort.nearest,
            query: '  SUPPLY  panda ',
          ),
        ),
        ['d1'],
      );
      expect(
        _ids(
          browseSuppliers(
            _stores,
            view: SupplierListView.verified,
            sort: SupplierListSort.nearest,
            query: 'PANDA',
          ),
        ),
        ['v2'],
      );
      expect(
        _ids(
          browseSuppliers(
            _stores,
            view: SupplierListView.favorites,
            sort: SupplierListSort.nearest,
          ),
        ),
        ['v1'],
      );
    },
  );

  test(
    'Google rating sorts keep unrated suppliers last in both directions',
    () {
      expect(
        _ids(
          browseSuppliers(
            _stores,
            view: SupplierListView.directory,
            sort: SupplierListSort.highestRating,
          ),
        ),
        ['d1', 'd2', 'd3'],
      );
      expect(
        _ids(
          browseSuppliers(
            _stores,
            view: SupplierListView.directory,
            sort: SupplierListSort.lowestRating,
          ),
        ),
        ['d2', 'd1', 'd3'],
      );
    },
  );

  test(
    'Verified rating sorts use published VPS and never New Vendor neutral values',
    () {
      expect(
        _ids(
          browseSuppliers(
            _stores,
            view: SupplierListView.verified,
            sort: SupplierListSort.highestRating,
          ),
        ),
        ['v2', 'v1', 'v3'],
      );
      expect(
        _ids(
          browseSuppliers(
            _stores,
            view: SupplierListView.verified,
            sort: SupplierListSort.lowestRating,
          ),
        ),
        ['v1', 'v2', 'v3'],
      );
    },
  );

  test('distance sorts are reversible and do not mutate server ordering', () {
    expect(
      _ids(
        browseSuppliers(
          _stores,
          view: SupplierListView.directory,
          sort: SupplierListSort.nearest,
        ),
      ),
      ['d3', 'd2', 'd1'],
    );
    expect(
      _ids(
        browseSuppliers(
          _stores,
          view: SupplierListView.directory,
          sort: SupplierListSort.farthest,
        ),
      ),
      ['d1', 'd2', 'd3'],
    );
    expect(_ids(_stores), ['v1', 'v2', 'v3', 'd1', 'd2', 'd3']);
  });

  test(
    'rating ties use nearest distance and stable id; invalid scores stay last',
    () {
      final rows = [
        _store('b', 'B', rating: '4.5', distance: 300),
        _store('a', 'A', rating: '4.5', distance: 300),
        _store('c', 'C', rating: '4.5', distance: 100),
        _store('x', 'Invalid', rating: 'NaN', distance: 1),
      ];
      expect(
        _ids(
          browseSuppliers(
            rows,
            view: SupplierListView.directory,
            sort: SupplierListSort.highestRating,
          ),
        ),
        ['c', 'a', 'b', 'x'],
      );
    },
  );

  testWidgets(
    'search survives tab switching, clear restores results and there is no All tab',
    (tester) async {
      await _pump(tester);
      expect(find.widgetWithText(ChoiceChip, 'All'), findsNothing);
      await tester.enterText(
        find.byKey(const ValueKey('supplier-name-search')),
        'Panda',
      );
      await tester.pump();
      expect(find.text('Panda Hardware'), findsOneWidget);
      expect(find.text('Manila Building Supply'), findsNothing);
      await tester.tap(find.byKey(const ValueKey('supplier-view-directory')));
      await tester.pump();
      expect(find.text('Panda Construction Supply'), findsOneWidget);
      expect(find.text('Panda Hardware'), findsNothing);
      await tester.tap(find.byTooltip('Clear store search'));
      await tester.pump();
      expect(find.text('R Hidalgo Hardware'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'sorting keeps name search through automatic result replacement',
    (tester) async {
      final (controller, repo) = await _pump(tester);
      await tester.tap(find.byKey(const ValueKey('supplier-view-directory')));
      await tester.pump();
      await tester.enterText(
        find.byKey(const ValueKey('supplier-name-search')),
        'Supply',
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('supplier-sort-rating')));
      await tester.pumpAndSettle();
      expect(
        find.bySemanticsLabel('Google rating: high to low'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('VPS: high to low'), findsNothing);
      repo.page = resultPage([
        ..._stores,
        _store('d4', 'New Supply Store', rating: '4.9', distance: 800),
      ]);
      await controller.revalidate();
      await tester.pump();
      expect(
        find.bySemanticsLabel('Google rating: high to low'),
        findsOneWidget,
      );
      expect(
        tester.getTopLeft(find.text('New Supply Store')).dy,
        lessThan(tester.getTopLeft(find.text('Panda Construction Supply')).dy),
      );
      expect(find.text('R Hidalgo Hardware'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'inline sort tabs toggle both directions and expose the active order',
    (tester) async {
      await _pump(tester);
      final distance = find.byKey(const ValueKey('supplier-sort-distance'));
      final rating = find.byKey(const ValueKey('supplier-sort-rating'));
      expect(
        tester
            .getSemantics(distance)
            .getSemanticsData()
            .hasAction(ui.SemanticsAction.tap),
        isTrue,
      );
      expect(tester.getSize(distance).height, greaterThanOrEqualTo(44));
      expect(tester.getSize(rating).height, greaterThanOrEqualTo(44));
      expect(find.bySemanticsLabel('Nearest first'), findsOneWidget);
      await tester.tap(distance);
      await tester.pump();
      expect(find.bySemanticsLabel('Farthest first'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Manila Building Supply')).dy,
        lessThan(tester.getTopLeft(find.text('Panda Hardware')).dy),
      );
      await tester.tap(rating);
      await tester.pump();
      expect(find.bySemanticsLabel('VPS: high to low'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Panda Hardware')).dy,
        lessThan(tester.getTopLeft(find.text('Manila Building Supply')).dy),
      );
      await tester.tap(rating);
      await tester.pump();
      expect(find.bySemanticsLabel('VPS: low to high'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Manila Building Supply')).dy,
        lessThan(tester.getTopLeft(find.text('Panda Hardware')).dy),
      );
      await tester.tap(distance);
      await tester.pump();
      expect(find.bySemanticsLabel('Nearest first'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('a name with no matches has a clear-search recovery action', (
    tester,
  ) async {
    await _pump(tester);
    await tester.enterText(
      find.byKey(const ValueKey('supplier-name-search')),
      'not listed',
    );
    await tester.pump();
    expect(find.text('No matching stores'), findsOneWidget);
    await tester.ensureVisible(find.text('Clear search'));
    await tester.tap(find.text('Clear search'));
    await tester.pump();
    expect(find.text('Panda Hardware'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
  ]) {
    testWidgets(
      'supplier controls and Directory rows reflow at $size and 2x text',
      (tester) async {
        await _pump(tester, size: size, scale: 2);
        await tester.ensureVisible(
          find.byKey(const ValueKey('supplier-view-directory')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('supplier-view-directory')));
        await tester.pump();
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  if (const bool.fromEnvironment('CAPTURE_SUPPLIER_BROWSE')) {
    testWidgets('capture Directory list preview for visual review', (
      tester,
    ) async {
      await _pump(tester);
      await tester.tap(find.byKey(const ValueKey('supplier-view-directory')));
      await tester.pumpAndSettle();
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const ValueKey('supplier-preview')),
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File('../../.tmp/supplier-browse-preview/directory.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
      await tester.pumpWidget(const SizedBox());
    });
  }
}
