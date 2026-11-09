import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/request_notice.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';

void main() {
  for (final width in [320.0, 390.0, 768.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('notice fits $width px at ${scale}x text with explicit retry', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(Size(width, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        var retries = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: BuyerTheme.light,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: Scaffold(
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  BuyerRequestNotice(
                    kind: DiscoveryFailureKind.offline,
                    message:
                        'You appear to be offline. Check your connection and retry.',
                    detail:
                        'Showing suppliers from 8:28 PM; driving times are hidden until you refresh.',
                    onRetry: () => retries++,
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(retries, 0);
        expect(find.text("You're offline"), findsOneWidget);
        final retry = find.widgetWithText(TextButton, 'Retry');
        await tester.ensureVisible(retry);
        await tester.pumpAndSettle();
        expect(tester.getSize(retry).height, greaterThanOrEqualTo(44));
        await tester.tap(retry);
        expect(retries, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('timeout, denied access and server failure stay distinct', (
    tester,
  ) async {
    for (final (kind, title) in [
      (DiscoveryFailureKind.timeout, 'Request timed out'),
      (DiscoveryFailureKind.forbidden, 'Access denied'),
      (DiscoveryFailureKind.provider, 'Request unavailable'),
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: BuyerRequestNotice(
              kind: kind,
              message: 'Specific safe failure message.',
              onRetry: null,
            ),
          ),
        ),
      );
      expect(find.text(title), findsOneWidget);
      expect(find.text("You're offline"), findsNothing);
      expect(find.text('Specific safe failure message.'), findsOneWidget);
      expect(
        tester.widget<TextButton>(find.byType(TextButton)).onPressed,
        isNull,
      );
    }
  });
}
