import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/buyer_overlays.dart';
import 'package:materyalph/design_system/components/ranking_explanation.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';

import 'item_procurement_fakes.dart';

Future<void> _openExplanation(
  WidgetTester tester,
  ListingCardView card, {
  double width = 390,
  double textScale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  addTearDown(() {
    tester.view.resetDevicePixelRatio();
    tester.view.resetPhysicalSize();
  });
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: BuyerTheme.light,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: true,
        ),
        child: child!,
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showBuyerBottomSheet<void>(
              context: context,
              builder: (context) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: RankingExplanation(card: card, position: 1),
              ),
            ),
            child: const Text('Why this ranking'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Why this ranking'));
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
    await (FontLoader('packages/lucide_icons_flutter/Lucide')..addFont(
          rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'),
        ))
        .load();
  });

  testWidgets('plain facts appear before the optional server score breakdown', (
    tester,
  ) async {
    final card = listingCard('roofing', price: 28550, distance: 4200);
    await _openExplanation(tester, card);

    expect(find.text('Why this Best Deal?'), findsOneWidget);
    expect(find.text('#1 in your Best Deal results'), findsOneWidget);
    expect(
      find.text('4.2 km from your selected location (straight-line distance).'),
      findsOneWidget,
    );
    expect(
      find.text('₱285.50 per piece. Compared with matching product options.'),
      findsOneWidget,
    );
    expect(find.text('In stock'), findsOneWidget);
    expect(
      find.text('New supplier — still building a track record.'),
      findsOneWidget,
    );
    expect(find.text('No product ratings yet.'), findsOneWidget);
    expect(find.textContaining('×'), findsNothing);
    expect(find.textContaining('Best Deal score:'), findsNothing);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        '../../../docs/design/evidence/best-deal-explanation/buyer-best-deal-390.png',
      ),
    );

    await tester.ensureVisible(find.text('View score details'));
    await tester.tap(find.text('View score details'));
    await tester.pumpAndSettle();
    expect(find.text('Best Deal score: 75.83 out of 100'), findsOneWidget);
    for (final component in card.components) {
      expect(find.text(component.basis), findsOneWidget);
      expect(
        find.text(
          '${component.label}: ${component.score} × ${component.weightPercent}% = ${component.weighted}',
        ),
        findsOneWidget,
      );
    }

    await tester.ensureVisible(find.byTooltip('Close explanation'));
    await tester.tap(find.byTooltip('Close explanation'));
    await tester.pumpAndSettle();
    expect(find.byType(RankingExplanation), findsNothing);
  });

  testWidgets('published ratings stay distinct from supplier performance', (
    tester,
  ) async {
    await _openExplanation(
      tester,
      listingCard(
        'steel',
        vendorScore: 'VPS 3.13',
        rating: '4.00',
        stock: 'LIMITED_STOCK',
        badges: const ['BEST_PRICE'],
        components: [
          for (final component in listingCard('base').components)
            if (component.key == 'product_rating')
              const RankingComponentView(
                key: 'product_rating',
                label: 'Product Rating',
                weightPercent: 10,
                score: '80.00',
                weighted: '8.00',
                basis: '4.00 of 5 from 11 ratings',
              )
            else
              component,
        ],
      ),
    );
    expect(find.text('Supplier performance'), findsOneWidget);
    expect(
      find.text("3.13 out of 5, based on the supplier's track record (VPS)."),
      findsOneWidget,
    );
    expect(find.text('Product rating'), findsOneWidget);
    expect(find.text('4.00 out of 5 from 11 ratings'), findsOneWidget);
    expect(find.text('Limited stock'), findsOneWidget);
    expect(
      find.textContaining('Lowest price among matching product options.'),
      findsOneWidget,
    );
    expect(find.textContaining('default score'), findsNothing);
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'missing comparison and unused factors at 320px, ${scale}x text',
      (tester) async {
        await _openExplanation(
          tester,
          listingCard(
            'new',
            name: 'Rerolled steel bar with a long product option name',
            normalizedUnitPrice: null,
            components: [
              for (final component in listingCard('base').components)
                if (component.key == 'price')
                  const RankingComponentView(
                    key: 'price',
                    label: 'Price',
                    weightPercent: 0,
                    score: '50.00',
                    weighted: '0.00',
                    basis: 'Not Yet Comparable — internal neutral score',
                  )
                else
                  component,
            ],
          ),
          width: 320,
          textScale: scale,
        );
        expect(
          find.textContaining('No matching prices to compare yet.'),
          findsOneWidget,
        );
        expect(
          find.text('Not used in your ranking preferences.'),
          findsOneWidget,
        );
        expect(find.textContaining('Lowest price'), findsNothing);
        expect(tester.takeException(), isNull);

        await tester.ensureVisible(find.text('View score details'));
        await tester.tap(find.text('View score details'));
        await tester.pumpAndSettle();
        expect(find.text('Price: 50.00 × 0% = 0.00'), findsOneWidget);
        await tester.ensureVisible(
          find.text('New — no product ratings yet (internal neutral score)'),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byTooltip('Close explanation'), findsOneWidget);
      },
    );
  }
}
