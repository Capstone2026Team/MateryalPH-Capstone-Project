import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/ranking_influence_dashboard.dart';
import 'package:materyalph/design_system/components/ranking_preferences_editor.dart';
import 'package:materyalph/design_system/ranking_weights.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/item_procurement/ranking_preferences_screen.dart';
import 'package:materyalph/features/projects/project_ranking_preferences_screen.dart';

import 'item_procurement_fakes.dart';
import 'projects_authoring_test.dart' as project_fixtures;

const _projectFactors = [
  ('material_match', 'Material match', 'More of your materials fulfilled.'),
  ('budget_fit', 'Budget fit', 'Offers within your budget.'),
  ('distance', 'Distance', 'Vendors closer to the site.'),
  ('vps', 'Vendor Performance (VPS)', 'Earned Vendor performance.'),
];
const _itemDefaults = {
  'distance': 30,
  'price': 25,
  'vps': 20,
  'stock': 15,
  'product_rating': 10,
};

Widget _app(Widget child, {double scale = 1}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: BuyerTheme.light,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
  home: child,
);

void main() {
  setUpAll(() async {
    for (final font in [
      ('Inter', 'assets/fonts/Inter-Variable.ttf'),
      ('MaterialIcons', 'fonts/MaterialIcons-Regular.otf'),
      (
        'packages/lucide_icons_flutter/Lucide',
        'packages/lucide_icons_flutter/assets/lucide.ttf',
      ),
    ]) {
      await (FontLoader(font.$1)..addFont(rootBundle.load(font.$2))).load();
    }
  });

  test(
    'influence previews normalize both factor sets without changing raw weights',
    () {
      for (final raw in [
        {
          'distance': 80,
          'price': 60,
          'vps': 70,
          'stock': 90,
          'product_rating': 50,
        },
        {'material_match': 80, 'budget_fit': 50, 'distance': 40, 'vps': 30},
      ]) {
        final before = {...raw};
        final preview = rankingInfluencePercentages(raw);
        expect(preview.values.reduce((a, b) => a + b), closeTo(100, 0.000001));
        expect(raw, before);
        final total = raw.values.reduce((a, b) => a + b);
        for (final key in raw.keys) {
          expect(preview[key], closeTo(raw[key]! / total * 100, 0.000001));
        }
        expect(
          rankingInfluencePercentages({
            for (final key in raw.keys) key: 0,
          }).values,
          everyElement(0),
        );
        expect(
          rankingInfluencePercentages({
            for (final key in raw.keys) key: key == raw.keys.first ? 1 : 0,
          })[raw.keys.first],
          100,
        );
      }
    },
  );

  for (final project in [false, true]) {
    final defaults = project ? project_fixtures.defaults : _itemDefaults;
    final factors = project
        ? _projectFactors
        : RankingPreferencesScreen.factors;
    final target = project ? 'budget_fit' : 'price';
    final targetLabel = project ? 'Budget fit' : 'Price';
    final type = project ? 'Project' : 'Item';

    testWidgets(
      '$type live influence follows independent sliders, saving and reset',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        var raw = {...defaults};
        var version = 0;
        var loads = 0;
        var saves = 0;
        var resets = 0;
        var personalized = false;
        RankingPreferenceSnapshot snapshot() => RankingPreferenceSnapshot(
          weights: raw,
          defaults: defaults,
          personalized: personalized,
          version: version,
        );
        await tester.pumpWidget(
          _app(
            RankingPreferencesEditor(
              title: '$type ranking',
              description: 'Saved ranking preferences.',
              resetMessage: 'Restore platform weights.',
              factors: factors,
              load: () async {
                loads++;
                return snapshot();
              },
              save: (weights, expected) async {
                expect(expected, version);
                raw = {...weights};
                version++;
                saves++;
                personalized = true;
                return snapshot();
              },
              reset: (expected) async {
                expect(expected, version);
                raw = {...defaults};
                version++;
                resets++;
                personalized = false;
                return snapshot();
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        final originalColor = tester
            .widget<LinearProgressIndicator>(
              find.byKey(ValueKey('ranking-influence-bar-$target')),
            )
            .color;
        final slider = find.byKey(ValueKey('ranking-weight-$target'));
        await tester.scrollUntilVisible(slider, 150);
        tester.widget<Slider>(slider).onChanged!(80);
        await tester.pump();
        expect(
          [loads, saves, resets],
          [1, 0, 0],
          reason: 'Slider movement is local only.',
        );
        expect(raw, defaults);
        await tester.scrollUntilVisible(
          find.byKey(const ValueKey('ranking-influence-dashboard')),
          -200,
        );
        expect(
          tester
              .widget<Text>(
                find.byKey(const ValueKey('ranking-leading-factor')),
              )
              .data,
          targetLabel,
        );
        expect(
          tester
              .widget<Text>(
                find.byKey(ValueKey('ranking-influence-percent-$target')),
              )
              .data,
          '51.6%',
        );
        final bar = tester.widget<LinearProgressIndicator>(
          find.byKey(ValueKey('ranking-influence-bar-$target')),
        );
        expect(bar.value, closeTo(80 / 155, 0.000001));
        expect(
          bar.color,
          originalColor,
          reason: 'A factor keeps its color when its rank changes.',
        );
        expect(
          tester
              .getTopLeft(find.byKey(ValueKey('ranking-influence-row-$target')))
              .dy,
          lessThan(
            tester
                .getTopLeft(
                  find.byKey(
                    ValueKey('ranking-influence-row-${defaults.keys.first}'),
                  ),
                )
                .dy,
          ),
        );
        await tester.tap(find.text('Save preferences'));
        await tester.pumpAndSettle();
        expect(raw, {...defaults, target: 80});
        expect(saves, 1);
        await tester.scrollUntilVisible(
          find.byTooltip('Reset to Default'),
          160,
        );
        await tester.tap(find.byTooltip('Reset to Default'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Reset to Default'));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.byKey(const ValueKey('ranking-influence-dashboard')),
          -200,
        );
        expect(raw, defaults);
        expect(resets, 1);
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byKey(ValueKey('ranking-influence-bar-$target')),
              )
              .value,
          0.25,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      '$type influence explains ties, disabled factors and an all-zero draft',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          for (final values in [
            {for (final factor in factors) factor.$1: 10},
            {
              for (var i = 0; i < factors.length; i++)
                factors[i].$1: i < 2 ? 80 : 10,
            },
            {
              for (final factor in factors)
                factor.$1: factor.$1 == target ? 1 : 0,
            },
            {for (final factor in factors) factor.$1: 0},
          ]) {
            await tester.pumpWidget(
              _app(
                Scaffold(
                  body: SingleChildScrollView(
                    child: RankingInfluenceDashboard(
                      weights: values,
                      factors: factors,
                    ),
                  ),
                ),
              ),
            );
            await tester.pump();
            final total = values.values.reduce((a, b) => a + b);
            final active = values.values.where((v) => v > 0).length;
            final partialTie = values[factors.first.$1] == 80;
            expect(
              tester
                  .widget<Text>(
                    find.byKey(const ValueKey('ranking-leading-factor')),
                  )
                  .data,
              total == 0
                  ? 'No active factors'
                  : active == 1
                  ? targetLabel
                  : partialTie
                  ? '${factors[0].$2} & ${factors[1].$2}'
                  : 'Equal influence',
            );
            if (partialTie) {
              expect(
                find.text('Your most influential factors'),
                findsOneWidget,
              );
              final percent = (values[factors.first.$1]! / total * 100)
                  .toStringAsFixed(1);
              expect(
                find.bySemanticsLabel(
                  '${factors.first.$2}, $percent percent of ranking influence',
                ),
                findsOneWidget,
              );
            }
            for (final factor in factors) {
              final value = tester
                  .widget<LinearProgressIndicator>(
                    find.byKey(ValueKey('ranking-influence-bar-${factor.$1}')),
                  )
                  .value!;
              expect(value.isFinite, isTrue);
              expect(
                value,
                closeTo(total == 0 ? 0 : values[factor.$1]! / total, 0.000001),
              );
            }
          }
          expect(tester.takeException(), isNull);
        } finally {
          semantics.dispose();
        }
      },
    );

    for (final viewport in [(320.0, 2.0), (390.0, 1.0), (1024.0, 1.0)]) {
      testWidgets(
        '$type ranking influence reflows at ${viewport.$1}px and ${viewport.$2}x text',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(viewport.$1, 844));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final screen = project
              ? ProjectRankingPreferencesScreen(
                  repository: project_fixtures.repository(
                    (options, handler) =>
                        project_fixtures.respond(options, handler, {
                          'weights': defaults,
                          'default_weights': defaults,
                          'personalized': false,
                          'version': 0,
                          'defaults_version': 0,
                          'algorithm_version': 'fms.normalized-weighted-sum.v1',
                        }),
                  ),
                )
              : RankingPreferencesScreen(
                  repository: FakeProcurementRepository(),
                );
          await tester.pumpWidget(_app(screen, scale: viewport.$2));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          if (viewport.$1 == 390) {
            await expectLater(
              find.byType(MaterialApp),
              matchesGoldenFile(
                project
                    ? '../../../docs/design/evidence/ranking-influence/buyer-project-ranking-390.png'
                    : '../../../docs/design/evidence/ranking-influence/buyer-item-ranking-390.png',
              ),
            );
          }
          await tester.scrollUntilVisible(
            find.byKey(ValueKey('ranking-weight-${defaults.keys.last}')),
            200,
          );
          expect(tester.takeException(), isNull);
          expect(find.text('Save preferences').hitTestable(), findsOneWidget);
        },
      );
    }
  }
}
