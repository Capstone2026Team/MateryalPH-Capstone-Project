import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/projects/projects_screen.dart';

import 'typed_project_fixtures.dart';

void main() {
  final cases = [
    (
      name: 'Work Package completed cost',
      budget: 3000000,
      pending: 0,
      actual: 1340505,
      recovery: 0,
    ),
    (
      name: 'Project completed cost',
      budget: 95000000,
      pending: 0,
      actual: 1340505,
      recovery: 0,
    ),
    (
      name: 'all three expense categories',
      budget: 100000,
      pending: 20000,
      actual: 30000,
      recovery: 10000,
    ),
    (
      name: 'fully committed budget',
      budget: 60000,
      pending: 20000,
      actual: 30000,
      recovery: 10000,
    ),
    (
      name: 'over budget',
      budget: 40000,
      pending: 20000,
      actual: 30000,
      recovery: 10000,
    ),
    (name: 'empty budget', budget: 0, pending: 0, actual: 0, recovery: 0),
  ];

  for (final scenario in cases) {
    testWidgets('${scenario.name} paints proportional expense segments', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final committed = scenario.pending + scenario.actual + scenario.recovery;
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: ProjectBudgetCard(
              budget: typedBudget({
                'budget_centavos': scenario.budget,
                'pending_centavos': scenario.pending,
                'actual_centavos': scenario.actual,
                'awaiting_recovery_centavos': scenario.recovery,
                'committed_centavos': committed,
                'remaining_centavos': scenario.budget - committed,
              }),
            ),
          ),
        ),
      );

      final track = find.descendant(
        of: find.byType(ProjectBudgetCard),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.constraints?.maxHeight == 10 &&
              widget.color == BuyerTheme.border,
        ),
      );
      expect(track, findsOneWidget);
      final trackRect = tester.getRect(track);
      final scale = scenario.budget > committed ? scenario.budget : committed;
      var left = trackRect.left;
      for (final bucket in [
        (scenario.pending, Color.lerp(BuyerTheme.action, Colors.white, 0.55)!),
        (scenario.actual, BuyerTheme.action),
        (scenario.recovery, BuyerTheme.ink),
      ]) {
        final segment = find.descendant(
          of: track,
          matching: find.byWidgetPredicate(
            (widget) => widget is ColoredBox && widget.color == bucket.$2,
          ),
        );
        if (bucket.$1 == 0) {
          expect(segment, findsNothing);
          continue;
        }
        expect(segment, findsOneWidget);
        final rect = tester.getRect(segment);
        expect(
          rect.height,
          trackRect.height,
          reason: 'Expense color must fill the visible bar height',
        );
        expect(rect.top, trackRect.top);
        expect(rect.left, closeTo(left, 0.01));
        expect(rect.width, closeTo(trackRect.width * bucket.$1 / scale, 0.01));
        left = rect.right;
      }
      expect(tester.takeException(), isNull);
    });
  }
}
