import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/async_state.dart';
import 'package:materyalph/design_system/components/procurement_components.dart'
    show StateKind, StateMessage, StatePage;
import 'package:materyalph/design_system/theme.dart';

Widget host(Widget child, {bool reduced = false, double scale = 1}) =>
    MaterialApp(
      theme: BuyerTheme.light,
      builder: (context, page) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: reduced,
          textScaler: TextScaler.linear(scale),
        ),
        child: page!,
      ),
      home: Scaffold(body: child),
    );

void main() {
  testWidgets(
    'reduced motion keeps loading visible without continuous animation',
    (tester) async {
      await tester.pumpWidget(
        host(
          const Column(
            children: [
              BuyerLoadingState(label: 'Loading orders…'),
              BuyerLoadingProgress(semanticsLabel: 'Updating orders…'),
            ],
          ),
          reduced: true,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Loading orders…'), findsOneWidget);
      expect(find.bySemanticsLabel('Loading orders…'), findsOneWidget);
      expect(
        tester
            .widget<CircularProgressIndicator>(
              find.byType(CircularProgressIndicator),
            )
            .value,
        0.75,
      );
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        0.5,
      );
      expect(find.text('No orders'), findsNothing);
    },
  );

  testWidgets(
    'offline retry stays readable at 320px and large text without retrying automatically',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var retries = 0;
      await tester.pumpWidget(
        host(
          StatePage(
            child: StateMessage(
              kind: StateKind.offline,
              title: "You're offline",
              message: 'Reconnect to load your orders.',
              actionLabel: 'Try again',
              onAction: () => retries++,
            ),
          ),
          scale: 2,
        ),
      );
      await tester.pumpAndSettle();
      expect(retries, 0);
      expect(find.byType(BuyerRequestState), findsOneWidget);
      expect(find.byType(Image), findsNothing);
      await tester.ensureVisible(find.text('Try again'));
      await tester.tap(find.text('Try again'));
      expect(retries, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('permission and timeout messages keep their original meaning', (
    tester,
  ) async {
    for (final kind in [StateKind.error, StateKind.forbidden]) {
      await tester.pumpWidget(
        host(
          StateMessage(
            kind: kind,
            title: 'Request unavailable',
            message: kind == StateKind.forbidden
                ? 'Access denied.'
                : 'The request timed out.',
          ),
        ),
      );
      expect(find.text("You're offline"), findsNothing);
      expect(
        find.text(
          kind == StateKind.forbidden
              ? 'Access denied.'
              : 'The request timed out.',
        ),
        findsOneWidget,
      );
    }
  });
}
