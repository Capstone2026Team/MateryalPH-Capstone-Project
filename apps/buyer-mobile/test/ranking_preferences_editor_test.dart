import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/ranking_preferences_editor.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';

void main() {
  for (final defaults in [
    {'distance': 30, 'price': 25, 'vps': 20, 'stock': 15, 'product_rating': 10},
    {'material_match': 40, 'budget_fit': 25, 'distance': 20, 'vps': 15},
  ]) {
    final type = defaults.containsKey('price') ? 'Item' : 'Project';
    testWidgets(
      '$type rejects zero, saves raw weights and restores on reopen',
      (tester) async {
        var weights = {...defaults};
        var version = 0;
        var saves = 0;
        var changes = 0;
        var failSave = false;
        RankingPreferenceSnapshot snapshot() => RankingPreferenceSnapshot(
          weights: {...weights},
          defaults: defaults,
          personalized: version > 0,
          version: version,
        );
        Widget editor() => MaterialApp(
          theme: BuyerTheme.light,
          home: RankingPreferencesEditor(
            title: '$type ranking',
            description: 'Choose relative importance.',
            resetMessage: 'Restore defaults.',
            factors: [
              for (final key in defaults.keys) (key, key, 'About $key'),
            ],
            load: () async => snapshot(),
            save: (raw, expectedVersion) async {
              expect(expectedVersion, version);
              saves++;
              if (failSave) {
                throw const DiscoveryFailure(
                  DiscoveryFailureKind.offline,
                  'You are offline. Please retry.',
                );
              }
              weights = {...raw};
              version++;
              return snapshot();
            },
            reset: (_) async => snapshot(),
            onChanged: () => changes++,
          ),
        );
        FilledButton saveButton() => tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Save preferences'),
        );
        await tester.pumpWidget(editor());
        await tester.pumpAndSettle();
        // Scroll each lazily built row into view as on a small phone.
        for (final key in defaults.keys) {
          final finder = find.byKey(ValueKey('ranking-weight-$key'));
          await tester.scrollUntilVisible(finder, 120);
          tester.widget<Slider>(finder).onChanged!(0);
          await tester.pump();
        }
        expect(saveButton().onPressed, isNull);
        expect(
          find.text(
            'Enable at least one criterion by setting its weight above zero.',
          ),
          findsOneWidget,
        );
        expect(saves, 0);
        final last = defaults.keys.last;
        tester
            .widget<Slider>(find.byKey(ValueKey('ranking-weight-$last')))
            .onChanged!(73);
        await tester.pump();
        expect(saveButton().onPressed, isNotNull);
        failSave = true;
        await tester.tap(find.text('Save preferences'));
        await tester.pumpAndSettle();
        expect(changes, 0);
        expect(weights, defaults);
        expect(saveButton().onPressed, isNotNull);
        failSave = false;
        await tester.tap(find.text('Save preferences'));
        await tester.pumpAndSettle();
        expect(weights, {
          for (final key in defaults.keys) key: key == last ? 73 : 0,
        });
        expect(changes, 1);
        expect(saves, 2);
        expect(find.text('Ranking preferences saved.'), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(editor());
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('ranking-weight-$last')),
          120,
        );
        expect(
          tester
              .widget<Slider>(find.byKey(ValueKey('ranking-weight-$last')))
              .value,
          73,
        );
        expect(saveButton().onPressed, isNull);
      },
    );
  }
}
