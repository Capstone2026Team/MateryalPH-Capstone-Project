import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/buyer_overlays.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/map_home_screen.dart';

Future<void> _openFilters(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double scale = 1,
  DiscoveryFilters filters = const DiscoveryFilters(directoryMinRating: 3),
  ValueChanged<DiscoveryFilters?>? onApplied,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  await tester.binding.setSurfaceSize(size);
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(() {
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    return tester.binding.setSurfaceSize(null);
  });
  await tester.pumpWidget(
    MaterialApp(
      theme: BuyerTheme.light,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              final result = await showBuyerBottomSheet<DiscoveryFilters>(
                context: context,
                builder: (_) => RepaintBoundary(
                  key: const ValueKey('filter-sheet-preview'),
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: DiscoveryFilterSheet(
                      filters: filters,
                      categories: const [
                        CategoryOption('cement', 'Cement and Concrete'),
                      ],
                    ),
                  ),
                ),
              );
              onApplied?.call(result);
            },
            child: const Text('Open filters'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open filters'));
  await tester.pumpAndSettle();
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
  });
  setUp(() => WidgetController.hitTestWarningShouldBeFatal = true);
  tearDown(() => WidgetController.hitTestWarningShouldBeFatal = false);

  testWidgets(
    'Favorites stand alone; Verified and Directory controls stay under their own tier toggle',
    (tester) async {
      await _openFilters(tester);
      final favorites = find.byKey(
        const ValueKey('favorite-supplier-filters'),
      );
      final verified = find.byKey(const ValueKey('verified-supplier-filters'));
      final directory = find.byKey(
        const ValueKey('directory-supplier-filters'),
      );
      expect(
        find.descendant(
          of: favorites,
          matching: find.text('Favorite Suppliers only'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: verified,
          matching: find.text('Favorite Suppliers only'),
        ),
        findsNothing,
      );
      expect(
        tester.getTopLeft(find.text('Favorite Suppliers only')).dy,
        lessThan(tester.getTopLeft(find.text('Show Verified Vendors')).dy),
      );
      for (final label in [
        'Show Verified Vendors',
        'Supplier type',
        'Material category',
      ]) {
        expect(
          find.descendant(of: verified, matching: find.text(label)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: directory, matching: find.text(label)),
          findsNothing,
        );
      }
      expect(
        find.descendant(
          of: directory,
          matching: find.text('Minimum Google rating'),
        ),
        findsOneWidget,
      );
      expect(
        tester.getTopLeft(find.text('Material category')).dy,
        lessThan(tester.getTopLeft(find.text('Show Directory Suppliers')).dy),
      );
      expect(
        tester.getTopLeft(find.text('Show Directory Suppliers')).dy,
        lessThan(tester.getTopLeft(find.text('Minimum Google rating')).dy),
      );
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'Reset clears the grouped fields and Apply returns the cleared values',
    (tester) async {
      DiscoveryFilters? result;
      await _openFilters(
        tester,
        filters: const DiscoveryFilters(
          favoritesOnly: true,
          supplierType: 'OTHER',
          categoryId: 'cement',
          directoryMinRating: 4,
          directoryMaxDistanceKm: 3,
        ),
        onApplied: (value) => result = value,
      );
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      expect(find.text('Any supplier type'), findsOneWidget);
      expect(find.text('Any category'), findsOneWidget);
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(result?.activeCount, 0);
      expect(result?.supplierType, isNull);
      expect(result?.categoryId, isNull);
      expect(result?.directoryMinRating, isNull);
      expect(result?.includeVerified, isTrue);
      expect(result?.includeDirectory, isTrue);
    },
  );

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
  ]) {
    testWidgets(
      'grouped filters scroll with reachable actions at $size and 2x text',
      (tester) async {
        await _openFilters(tester, size: size, scale: 2);
        final apply = find.widgetWithText(FilledButton, 'Apply');
        final before = tester.getRect(apply);
        expect(before.bottom, lessThanOrEqualTo(size.height));
        expect(before.height, greaterThanOrEqualTo(44));
        await tester.scrollUntilVisible(
          find.text('Minimum Google rating'),
          160,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        expect(tester.getRect(apply), before);
        expect(tester.takeException(), isNull);
        await tester.tap(apply);
        await tester.pumpAndSettle();
      },
    );
  }

  if (const bool.fromEnvironment('CAPTURE_DISCOVERY_FILTERS')) {
    testWidgets('capture organized filter sheet', (tester) async {
      await _openFilters(tester);
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const ValueKey('filter-sheet-preview')),
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File('../../.tmp/supplier-browse-preview/filters.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
    });
  }

  testWidgets(
    'Directory filters retain rating and remove the legacy distance restriction',
    (tester) async {
      DiscoveryFilters? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  result = await showModalBottomSheet<DiscoveryFilters>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const DiscoveryFilterSheet(
                      filters: DiscoveryFilters(directoryMaxDistanceKm: 3),
                      categories: [],
                    ),
                  );
                },
                child: const Text('Open filters'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open filters'));
      await tester.pumpAndSettle();
      final rating = find.widgetWithText(ChoiceChip, '4.5+');
      await tester.ensureVisible(rating);
      await tester.tap(rating);
      await tester.pump();
      expect(find.text('Directory distance'), findsNothing);
      expect(find.text('Any within radius'), findsNothing);
      await tester.ensureVisible(find.text('Apply'));
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(result?.directoryMinRating, 4.5);
      expect(result?.directoryMaxDistanceKm, isNull);
      expect(result?.activeCount, 1);
      expect(result?.tierSpecific, isFalse);
    },
  );

  testWidgets('Favorites only keeps Directory Suppliers and their rating', (
    tester,
  ) async {
    const filters = DiscoveryFilters(favoritesOnly: true);
    expect(filters.tierSpecific, isFalse);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DiscoveryFilterSheet(filters: filters, categories: []),
        ),
      ),
    );
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '4.5+'))
          .onSelected,
      isNotNull,
    );
    expect(find.textContaining('Directory Suppliers are hidden'), findsNothing);
  });

  testWidgets(
    'Verified-only filters disable Directory chips with an explanation',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DiscoveryFilterSheet(
              filters: DiscoveryFilters(supplierType: 'OTHER'),
              categories: [],
            ),
          ),
        ),
      );
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '4.5+'))
            .onSelected,
        isNull,
      );
      expect(find.text('Directory distance'), findsNothing);
      await tester.scrollUntilVisible(
        find.textContaining('Directory Suppliers are hidden'),
        200,
      );
      expect(
        find.textContaining('Directory Suppliers are hidden'),
        findsOneWidget,
      );
    },
  );
}
