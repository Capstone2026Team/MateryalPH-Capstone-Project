import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/screens/ranking_preferences_hub_screen.dart';

Widget _app(Widget home, {double scale = 1}) => MaterialApp(
  theme: BuyerTheme.light,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
  home: home,
);

void main() {
  testWidgets('Item-Based and Project-Based rows open their own editors', (
    tester,
  ) async {
    final taps = <String>[];
    await tester.pumpWidget(
      _app(
        RankingPreferencesHubScreen(
          onOpenItemBased: () => taps.add('item'),
          onOpenProjectBased: () => taps.add('project'),
        ),
      ),
    );
    await tester.tap(find.text('Item-Based ranking'));
    await tester.tap(find.text('Project-Based ranking'));
    expect(taps, ['item', 'project']);
  });

  testWidgets('an unavailable editor says so instead of failing silently', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(RankingPreferencesHubScreen(onOpenItemBased: () {})),
    );
    expect(find.text('Not available right now.'), findsOneWidget);
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('lays out at 320px with text scale $scale', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _app(
          RankingPreferencesHubScreen(
            onOpenItemBased: () {},
            onOpenProjectBased: () {},
          ),
          scale: scale,
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
