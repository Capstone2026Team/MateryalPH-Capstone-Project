import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/trust/buyer_ratings_section.dart';
import 'package:materyalph/features/trust/trust_models.dart';
import 'trust_fakes.dart';

void main() {
  testWidgets(
    'compact unpublished rating never invents a score and retries failures',
    (tester) async {
      final repository = FakeReviewsRepository()
        ..failure = Exception('Unavailable');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BuyerRatingsSection(repository: repository, compact: true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('0.00'), findsNothing);
      repository.failure = null;
      await tester.tap(
        find.byTooltip('Could not load Buyer rating. Tap to retry.'),
      );
      await tester.pumpAndSettle();
      expect(find.text('—'), findsOneWidget);
      expect(find.text('0.00'), findsNothing);
      expect(
        find.bySemanticsLabel(RegExp('Building your rating')),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'Profile rating displays a published CCS and reveals ratings from the actual store',
    (tester) async {
      final repository = FakeReviewsRepository()
        ..received = BuyerReceivedRatingsView(
          summary: const BuyerRatingSummaryView(count: 5, score: 4.25),
          total: 1,
          items: [
            BuyerReceivedRatingView(
              id: 'sample',
              storeName: 'Sample Supply',
              orderReference: 'ORD-SAMPLE',
              ratings: const ReviewRatingsView(
                inquirySeriousness: 4,
                communicationQuality: 5,
                paymentReliability: 4,
              ),
              submittedAt: DateTime.utc(2026, 11, 4, 18),
              comment: 'Clear communication throughout the order.',
            ),
          ],
        );
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: BuyerRatingsSection(repository: repository),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('4.25 / 5'), findsOneWidget);
      expect(
        find.text('5 eligible ratings in the last 90 days.'),
        findsOneWidget,
      );
      await tester.tap(find.text('View ratings from stores'));
      await tester.pumpAndSettle();
      expect(find.text('Sample Supply'), findsOneWidget);
      expect(find.textContaining('Nov 5, 2026'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Inquiry Seriousness: 4 of 5'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Communication Quality: 5 of 5'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Payment Reliability: 4 of 5'),
        findsOneWidget,
      );
      expect(
        find.text('Clear communication throughout the order.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'unpublished scores show progress and an empty history, never a fabricated zero',
    (tester) async {
      final repository = FakeReviewsRepository();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BuyerRatingsSection(repository: repository)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Building your rating'), findsOneWidget);
      expect(
        find.text(
          'Your score appears after 5 eligible completed transactions.',
        ),
        findsOneWidget,
      );
      expect(find.text('0.00 / 5'), findsNothing);
      await tester.tap(find.text('View ratings from stores'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('No published ratings from stores yet.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'failed rating requests have a working retry independent of the rest of Profile',
    (tester) async {
      final repository = FakeReviewsRepository()
        ..failure = Exception('Sample offline failure');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BuyerRatingsSection(repository: repository)),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Could not load your ratings. Please retry.'),
        findsOneWidget,
      );
      repository.failure = null;
      await tester.tap(find.text('Retry ratings'));
      await tester.pumpAndSettle();
      expect(find.text('Building your rating'), findsOneWidget);
    },
  );

  testWidgets('rating summary reflows at narrow width and large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(() {
      tester.platformDispatcher.clearTextScaleFactorTestValue();
      return tester.binding.setSurfaceSize(null);
    });
    final repository = FakeReviewsRepository()
      ..received = BuyerReceivedRatingsView(
        summary: const BuyerRatingSummaryView(count: 5, score: 4),
        total: 1,
        items: [
          BuyerReceivedRatingView(
            id: 'sample',
            storeName: 'Sample Supply',
            orderReference: 'ORD-SAMPLE',
            ratings: const ReviewRatingsView(
              inquirySeriousness: 4,
              communicationQuality: 5,
              paymentReliability: 4,
            ),
            submittedAt: DateTime.utc(2026, 11, 5),
          ),
        ],
      );
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: BuyerRatingsSection(repository: repository),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Your Buyer rating'), findsOneWidget);
    await tester.ensureVisible(find.text('View ratings from stores'));
    await tester.tap(find.text('View ratings from stores'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
