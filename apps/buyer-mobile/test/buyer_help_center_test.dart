import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/screens/buyer_account_screen.dart';
import 'package:materyalph/screens/buyer_help_center_screen.dart';
import 'package:materyalph/screens/buyer_profile_screen.dart';
import 'package:materyalph/widgets/legal_content.dart';

import 'buyer_account_test.dart' as fixtures;

Future<void> _pumpProfile(
  WidgetTester tester, {
  VoidCallback? orders,
  VoidCallback? refunds,
  VoidCallback? disputes,
}) async {
  await tester.binding.setSurfaceSize(const Size(390, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: BuyerTheme.light,
      home: BuyerProfileScreen(
        repository: fixtures.repository(verified: true),
        onSignedOut: () {},
        onSignOut: () async {},
        onOpenOrders: orders,
        onOpenCancellationsAndRefunds: refunds,
        onOpenDisputes: disputes,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// The page list, not the search field's own scrollable.
final _page = find
    .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
    .first;

Future<void> _pumpHelpCenter(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(theme: BuyerTheme.light, home: const BuyerHelpCenterScreen()),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Support lists Help Center and Terms only', (tester) async {
    await _pumpProfile(tester);
    expect(find.text('Help Center'), findsOneWidget);
    expect(find.text('Terms & Agreements'), findsOneWidget);
    expect(find.text('Reports & Privacy Requests'), findsNothing);
  });

  testWidgets('Terms & Agreements opens directly and Back returns to Profile', (
    tester,
  ) async {
    await _pumpProfile(tester);
    await tester.tap(find.text('Terms & Agreements'));
    await tester.pumpAndSettle();
    expect(find.byType(LegalContent), findsOneWidget);
    expect(find.byType(BuyerSettingsScreen), findsNothing);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerAccountScreen), findsNothing);
    expect(find.byType(BuyerSettingsScreen), findsNothing);
    expect(find.text('Sign Out'), findsOneWidget);
  });

  testWidgets('Get help with opens the topic answers, not the feature', (
    tester,
  ) async {
    final taps = <String>[];
    await _pumpProfile(
      tester,
      orders: () => taps.add('orders'),
      refunds: () => taps.add('refunds'),
      disputes: () => taps.add('disputes'),
    );
    await tester.tap(find.text('Help Center'));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerHelpCenterScreen), findsOneWidget);
    for (final topic in buyerHelpTopics) {
      expect(find.text(topic.title), findsOneWidget);
    }

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerHelpTopicScreen), findsOneWidget);
    expect(find.text('When is my order confirmed?'), findsOneWidget);
    expect(find.text('How do I pay for an online order?'), findsNothing);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Terms & Agreements'));
    await tester.pumpAndSettle();
    expect(find.text('Where can I read the Terms I accepted?'), findsOneWidget);
    expect(find.byType(LegalContent), findsNothing);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerHelpCenterScreen), findsOneWidget);
    expect(taps, isEmpty);
  });

  testWidgets('a topic page lists every answer and expands it', (tester) async {
    const topic = 'Cancellations & Refunds';
    await _pumpHelpCenter(tester);
    await tester.tap(find.text(topic));
    await tester.pumpAndSettle();
    final answers = buyerHelpTopics.singleWhere((t) => t.title == topic);
    for (final answer in answers.answers) {
      expect(find.text(answer.question), findsOneWidget);
    }
    await tester.tap(find.text('Where does my refund go?'));
    await tester.pumpAndSettle();
    expect(find.textContaining('original payment method'), findsOneWidget);
  });

  testWidgets('search filters answers across topics with a clear state', (
    tester,
  ) async {
    await _pumpHelpCenter(tester);
    await tester.enterText(find.byType(TextField), 'refund');
    await tester.pumpAndSettle();
    final matches = buyerHelpTopics
        .expand((topic) => topic.answers)
        .where((answer) => answer.matches('refund'))
        .length;
    expect(find.text('$matches answers found'), findsOneWidget);
    expect(find.text('GET HELP WITH'), findsNothing);
    expect(find.text('How do I track my order?'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzqx');
    await tester.pumpAndSettle();
    expect(find.text('No answers found'), findsOneWidget);
    await tester.tap(find.text('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('No answers found'), findsNothing);
    expect(find.text('GET HELP WITH'), findsOneWidget);
  });

  testWidgets('Help Center and a topic fit 320px with enlarged text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(() {
      tester.platformDispatcher.clearTextScaleFactorTestValue();
      return tester.binding.setSurfaceSize(null);
    });
    await _pumpHelpCenter(tester);
    await tester.scrollUntilVisible(
      find.text('Still need help?'),
      300,
      scrollable: _page,
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: BuyerHelpTopicScreen(topic: buyerHelpTopics[3]),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Still need help?'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.takeException(), isNull);
  });
}
